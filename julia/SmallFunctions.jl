using DataFrames
using CSV
using DataFramesMeta
using StatsBase
using GLM
using LinearAlgebra
using Statistics
using ZipFile
using CairoMakie
using GLMakie
using DataFramesMeta
using Base.Threads
using IterTools
using Logging
import Base: strip
using BenchmarkTools
using Base.Threads


function ListFiles(path::String)
    filelist = Vector{String}(undef, 0)
    for (root, dirs, files) in walkdir(path)
        for file in files
            push!(filelist, joinpath(root, file))
        end
    end
    return filelist
end

function CorrectAngles!(A)
    if A > 90
        A = 180 - A
    end
    return (A)
end

function CalculerAngle(A, B)
    C = (acos(dot(A, B) / (norm(A) * norm(B)))) * 180 / pi
    C = CorrectAngles!(C)
    return (C)
end

function Distance3D(A, B)
    distance = sqrt((A[1] - B[1])^2 + (A[2] - B[2])^2 + (A[3] - B[3])^2)
    return (distance)
end

function RemoveExt(filename::String, ext::String)
    index = findlast(ext, filename)
    return filename[1:index[1]-1]
end

function WriteZippedWrlFiles(ZipFileList::Vector{String})
    for i in eachindex(ZipFileList)
        println(i)
        ZippedFolder = ZipFileList[i]
        println(ZippedFolder)
        r = ZipFile.Reader(ZippedFolder)
        idx = only(findall(x -> contains(x.name, ".wrl"), r.files))
        wrlfile = read(r.files[idx], String)
        write(joinpath(dirname(ZipFileList[i]), "r_$(basename(dirname(ZipFileList[i]))).wrl"), wrlfile)
    end
end

function TxtfileList(filelist::Vector{String})
    return filter(x -> endswith(x, ".txt") && !(occursin("coords", x) || occursin("cellIDs", x) || occursin("Values", x) || occursin("console", x)), filelist)
end

function WrlfileList(filelist::Vector{String})
    return unique(filter(x -> endswith(x, ".wrl"), filelist))
end

function ZipfileList(filelist::Vector{String}, ends::String)
    return filter(x -> endswith(x, "$(ends).zip"), filelist)
end

function FetchDPaxis(filelist::Vector{String})
    DPaxis = Dict()
    for i in eachindex(filelist)
        if contains(filelist2[i], "_DPaxis.csv")
            movie = RemoveExt(basename(filelist[i]), "_DPaxis.csv")
            df = DataFrame(CSV.File(filelist[i]))
            select!(df, [:x1, :x2, :y1, :y2, :z1, :z2])
            df.X .= df[!, :x1] .- df[!, :x2]
            df.Y .= df[!, :y1] .- df[!, :y2]
            df.Z .= df[!, :z1] .- df[!, :z2]
            DPaxis[movie] = df
        end
    end
    return DPaxis
end

function FetchDTC(filelist::Vector{String})
    DTC = Dict()
    for i in eachindex(filelist)
        if contains(filelist[i], "_DTC.csv")
            movie = RemoveExt(basename(filelist[i]), "_DTC.csv")
            df = DataFrame(CSV.File(filelist[i]))
            select!(df, [:x1, :y1, :z1])
            DTC[movie] = df
        end
    end
    return DTC
end

function ReadTracks(txtfilepath::String)
    df = dropmissing(CSV.read(txtfilepath, DataFrame))
    filter!(:Label => !contains("ID"), df)
    filter!(:Label => contains("Cent"), df)
    return df
end

function process_line_i!(A)
    A = string(A)
    A = replace(A, "-1" => " ") # remove the signal between faces coordinates
    A = split(A, " ")
    A = chop.(A, head=0, tail=1)#remove comas
    A = filter!(x -> x !== nothing, tryparse.(Int64, A)) .+ 1 #Julia starts at 1, not 0
    A = collect(Iterators.partition(A, 3))
    return (A)
end

function process_line_ii!(A)
    A = string(A)
    A = replace(A, "/" => " ")
    A = replace(A, "\\" => " ")
    A = replace(A, "," => " ")
    A = split(A, " ")
    A = filter!(x -> x !== nothing, tryparse.(Float64, A))
    return (A)
end

function process_wrl_files(A, D)
    Node_Count = 0
    B = Array{Int64}(undef, 0, 2)
    C = Array{Int64}(undef, 0, 2)
    for (y, line) in enumerate(eachline(A))
        if contains(line, D)
            Node_Count += 1
            fazer = [Node_Count y]
            B = vcat(B, fazer)
        elseif contains(line, "]") && Node_Count >= 1 && y - B[end, 2] > 20
            if size(C) == (0, 2)
                fazer = [Node_Count y]
                C = vcat(C, fazer)
            elseif y - C[end, 2] > 20 && C[end, 1] != Node_Count
                fazer = [Node_Count y]
                C = vcat(C, fazer)
            end
        end
    end
    return (B, C)
end


######## Fetch DPaxis
function FetchDPaxis(filelist::Vector{String})
    DPaxis = Dict()
    for i in eachindex(filelist)
        if contains(filelist[i], "_DPaxis.csv")
            gonad = RemoveExt(basename(filelist[i]), "_DPaxis.csv")
            df = DataFrame(CSV.File(filelist[i]))
            select!(df, [:x1, :x2, :y1, :y2, :z1, :z2])
            df.X .= df[!, :x1] .- df[!, :x2]
            df.Y .= df[!, :y1] .- df[!, :y2]
            df.Z .= df[!, :z1] .- df[!, :z2]
            DPaxis[gonad] = df
        end
    end
    return DPaxis
end

######## Fetch DTC Position
function FetchDTC(filelist::Vector{String})
    DTC = Dict()
    for i in eachindex(filelist)
        if contains(filelist[i], "DTC.csv")
            gonad = RemoveExt(basename(filelist[i]), "_DTC.csv")
            df = DataFrame(CSV.File(filelist[i]))
            select!(df, [:x1, :y1, :z1])
            DTC[gonad] = df
        end
    end
    return DTC
end

#########filtering Cell Shape DF
function FilteringCellShape(CellShape_df_final::DataFrame)
    filtered_df = copy(CellShape_df_final)
    filtered_df = filter(row ->
            row[:MeanCellVolume] > 75
                && row[:MeanCellVolume] < 250
                && row[:CellVolumeSlope] < 0.25
                && row[:CellVolumeSlope] > -0.25
                && row[:Duration] > 10
                && row[:VarianceCellVolume] < 50
                #&& row[:VarianceOrientationCtoDP] < 100
                && row[:MeanDistanceDTC] < 100, filtered_df)
    dropmissing!(filtered_df)
    return filtered_df
end

function calculate_normals_and_centroids(A, B, C)
    temporary_normals = Dict{Int64,Vector{Vector{Float64}}}()
    temporary_centroids = Dict{Int64,Vector{Vector{Float64}}}()
    temporary_areas = Dict{Int64,Vector{Float64}}()
    for x in 1:C
        centroids = Vector{Vector{Float64}}()
        normals = Vector{Vector{Float64}}()
        areas = Vector{Float64}()
        for y in 1:length(B[x])
            V1 = A[x][B[x][y][1]]
            V2 = A[x][B[x][y][2]]
            V3 = A[x][B[x][y][3]]
            VA = V2 - V1
            VB = V3 - V1
            normal = cross(VA, VB) / 2
            push!(normals, normal)
            centroid = [mean([V1[1], V2[1], V3[1]]), mean([V1[2], V2[2], V3[2]]), mean([V1[3], V2[3], V3[3]])]
            push!(centroids, centroid)
            area = 0.5(norm(cross(VA, VB)))
            push!(areas, area)
        end
        #Some Comment
        temporary_normals[x] = normals
        temporary_centroids[x] = centroids
        temporary_areas[x] = areas
    end
    return (temporary_normals, temporary_centroids, temporary_areas)
end

function CreateCelloutput(filelist::Vector{String})
    txtfilelist = TxtfileList(filelist)
    Celloutput = Dict{String,DataFrame}()
    unique_tracks = Dict()
    for x in eachindex(txtfilelist)
        txtfile = txtfilelist[x]
        movie = RemoveExt(basename(txtfile), ".txt")
        df = ReadTracks(txtfile)
        unique_tracks[x] = sort(unique(df[!, :Label]))
        #number_of_cells = length(unique_tracks[x]) / 2
        for y in 1:2:length(unique_tracks[x])
            #n = findfirst("a", unique_tracks[x][y])
            cell = unique_tracks[x][y][1:end-1]
            cell2 = cell[6:end]
            Cellule = string(movie, " Cell_", "$cell2")
            cella = string(cell, "a")
            cellb = string(cell, "b")
            cent_a = filter(:Label => isequal(cella), df)
            cent_b = filter(:Label => isequal(cellb), df)
            Celloutput["$Cellule"] = innerjoin(cent_a, cent_b, on=:FRAME, makeunique=true)
            spindle_mid_point = Vector{Matrix{Float64}}()
            spindle_lengths = Vector{Float64}()
            for z in 1:length(Celloutput["$Cellule"][!, :FRAME])
                push!(spindle_mid_point, [((Celloutput["$Cellule"][z, :POSITION_X] + Celloutput["$Cellule"][z, :POSITION_X_1]) / 2) ((Celloutput["$Cellule"][z, :POSITION_Y] + Celloutput["$Cellule"][z, :POSITION_Y_1]) / 2) ((Celloutput["$Cellule"][z, :POSITION_Z] + Celloutput["$Cellule"][z, :POSITION_Z_1]) / 2)])
                Celloutput["$Cellule"][z, :FRAME] = Celloutput["$Cellule"][z, :FRAME] + 1
                cent_a = [Celloutput["$Cellule"][z, :POSITION_X] Celloutput["$Cellule"][z, :POSITION_Y] Celloutput["$Cellule"][z, :POSITION_Z]]
                cent_b = [Celloutput["$Cellule"][z, :POSITION_X_1] Celloutput["$Cellule"][z, :POSITION_Y_1] Celloutput["$Cellule"][z, :POSITION_Z_1]]
                spindle_length = Distance3D(cent_a, cent_b)
                push!(spindle_lengths, spindle_length)
            end
            Celloutput["$Cellule"][!, :Spindle_Midpoint] = spindle_mid_point
            Celloutput["$Cellule"][!, :Spindle_Length] = spindle_lengths
        end
    end
    return Celloutput
end

findnearest(A::AbstractArray, t) = findmin(abs.(A .- t))[2]

function ScoringDict2DataFrame(Scoring)
    Scoring = sort(Scoring)
    k = collect(keys(Scoring))
    scoring_df = DataFrame()
    Cell = Vector{Union{String,Missing}}(undef, length(Scoring))
    NEBD = Vector{Float64}(undef, length(Scoring))
    StartCongression = Vector{Float64}(undef, length(Scoring))
    AnaphaseOnset = Vector{Float64}(undef, length(Scoring))
    for i in eachindex(k)
        Cell[i] = k[i]
        NEBD[i] = Scoring[k[i]][1, :NEBD]
        StartCongression[i] = Scoring[k[i]][1, :StartCongression]
        AnaphaseOnset[i] = Scoring[k[i]][1, :AnaphaseOnset]
    end
    scoring_df[!, :Cell] = Cell
    scoring_df[!, :NEBD] = NEBD
    scoring_df[!, :StartCongression] = StartCongression
    scoring_df[!, :AnaphaseOnset] = AnaphaseOnset
    return scoring_df
end

function http_download(url, dest)
    HTTP.open(:GET, url) do http
        open(dest, "w") do file
            write(file, http)
        end
    end
end

function ParseWRL(wrl::String)
    io = open(wrl[1], "r")
    CoordsIndicesStart, CoordsIndicesEnd = process_wrl_files(io, "coordIndex")
    io = open(wrl[1], "r")
    foo2 = readlines(io)
    io = open(wrl[1], "r")
    PointsStart, PointsEnd = process_wrl_files(io, "point")
    number_of_nodes = length(CoordsIndicesStart[:, 1])
    number_of_nodes2 = length(CoordsIndicesEnd[:, 1])
    number_of_nodes3 = length(PointsStart[:, 1])
    number_of_nodes4 = length(PointsEnd[:, 1])
    coordIndices_temporary = Dict{Int64,Vector{SubArray{Int64,1,Vector{Int64},Tuple{UnitRange{Int64}},true}}}()
    points_temporary = Dict{Int64,Vector{SubArray{Union{Nothing,Float64},1,Vector{Union{Nothing,Float64}},Tuple{UnitRange{Int64}},true}}}()
    Normals_temporary = Dict{Int64,Vector{Vector{Float64}}}()
    Areas_temporary = Dict{Int64,Vector{Float64}}()
    Centroids_temporary = Dict{Int64,Vector{Vector{Float64}}}()
    if number_of_nodes == number_of_nodes2 && number_of_nodes3 == number_of_nodes4 && number_of_nodes == number_of_nodes3
        for y in 1:number_of_nodes
            coordIndices_node = foo2[CoordsIndicesStart[y, 2]:CoordsIndicesEnd[y, 2]]
            coordIndices_node = process_line_i!(coordIndices_node)
            coordIndices_temporary[y] = coordIndices_node
            points_node = foo2[PointsStart[y, 2]:PointsEnd[y, 2]]
            points_node = process_line_ii!(points_node)
            points_node = collect(Iterators.partition(points_node, 3))
            points_temporary[y] = points_node
        end
        Normals_temporary, Centroids_temporary, Areas_temporary = calculate_normals_and_centroids(points_temporary, coordIndices_temporary, number_of_nodes)
    end
    close(io)
    return number_of_nodes, number_of_nodes2, number_of_nodes3, number_of_nodes4, Normals_temporary, Centroids_temporary, Areas_temporary
end

function SaveCelloutputdf(Celloutput)
    Celloutput = sort(Celloutput)
    k = sort(collect(keys(Celloutput)))
    Celloutputdf = DataFrame()
    for i in eachindex(k)
        df = Celloutput[k[i]]
        IndexCell = findfirst(" Cell", k[i])
        CelluleNumber = k[i][IndexCell[1]+1:end]
        println(CelluleNumber)
        GonadName = k[i][1:IndexCell[1]]
        cell = fill(CelluleNumber, (size(Celloutput[k[i]])[1]))
        gonad = fill(GonadName, (size(Celloutput[k[i]])[1]))
        df[!, :cell] = cell
        df[!, :gonad] = gonad
        if hasproperty(df, :AngleSpindleRachis) == false
            AngleSpindleRachis = fill(missing, (size(Celloutput[k[i]])[1]))
            df[!, :AngleSpindleRachis] = AngleSpindleRachis
        end
        if hasproperty(df, :XNormal) == false
            XNormal = fill(missing, (size(Celloutput[k[i]])[1]))
            YNormal = fill(missing, (size(Celloutput[k[i]])[1]))
            ZNormal = fill(missing, (size(Celloutput[k[i]])[1]))
            df[!, :XNormal] = XNormal 
            df[!, :YNormal] = YNormal
            df[!, :ZNormal] = ZNormal 
        end
        Celloutputdf = vcat(Celloutputdf, df)
    end
    CSV.write("Celloutput.csv", Celloutputdf)
end