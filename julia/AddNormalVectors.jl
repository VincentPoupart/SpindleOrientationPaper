function NormalVector2CellShape!(filtered_df::DataFrame, wrlfilelist::Vector{String})
    wrlbasenamelist = RemoveExt.(basename.(wrlfilelist), ".")
    XNormal = Vector{Vector{Union{Float64,Missing}}}(undef, nrow(filtered_df))
    YNormal = Vector{Vector{Union{Float64,Missing}}}(undef, nrow(filtered_df))
    ZNormal = Vector{Vector{Union{Float64,Missing}}}(undef, nrow(filtered_df))
    AngleNormalLongAxis = Vector{Vector{Union{Float64,Missing}}}(undef, nrow(filtered_df))

    coordIndices_temporary = Dict{Int64,Vector{SubArray{Int64,1,Vector{Int64},Tuple{UnitRange{Int64}},true}}}()
    points_temporary = Dict{Int64,Vector{SubArray{Union{Nothing,Float64},1,Vector{Union{Nothing,Float64}},Tuple{UnitRange{Int64}},true}}}()
    Normals_temporary = Dict{Int64,Vector{Vector{Float64}}}()
    Areas_temporary = Dict{Int64,Vector{Float64}}()
    Centroids_temporary = Dict{Int64,Vector{Vector{Float64}}}()
    number_of_nodes = []
    number_of_nodes2 = []
    number_of_nodes3 = []
    number_of_nodes4 = []
    for i in 1:nrow(filtered_df)
        gonad = filtered_df[i, :Gonad]
        if i == 1 || gonad !== filtered_df[i-1, :Gonad]
            foo = gonad .== wrlbasenamelist
            wrl = unique(wrlfilelist[foo])
            io = open(wrl[1], "r")
            PointsStart, PointsEnd = process_wrl_files(io, "point")
            io = open(wrl[1], "r")
            CoordsIndicesStart, CoordsIndicesEnd = process_wrl_files(io, "coordIndex")
            io = open(wrl[1], "r")
            foo = readlines(io)
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
                    coordIndices_node = foo[CoordsIndicesStart[y, 2]:CoordsIndicesEnd[y, 2]]
                    coordIndices_node = process_line_i!(coordIndices_node)
                    coordIndices_temporary[y] = coordIndices_node
                    points_node = foo[PointsStart[y, 2]:PointsEnd[y, 2]]
                    points_node = process_line_ii!(points_node)
                    points_node = collect(Iterators.partition(points_node, 3))
                    points_temporary[y] = points_node
                end
                Normals_temporary, Centroids_temporary, Areas_temporary = calculate_normals_and_centroids(points_temporary, coordIndices_temporary, number_of_nodes)
            end
            println("gonad ", gonad, " is done")
            close(io)
        end
        NormalsX = Vector{Union{Float64,Missing}}(undef, length(filtered_df[i, :Time]))
        NormalsY = Vector{Union{Float64,Missing}}(undef, length(filtered_df[i, :Time]))
        NormalsZ = Vector{Union{Float64,Missing}}(undef, length(filtered_df[i, :Time]))
        Angles = Vector{Union{Float64,Missing}}(undef, length(filtered_df[i, :Time]))
        if number_of_nodes == number_of_nodes2 && number_of_nodes3 == number_of_nodes4 && number_of_nodes == number_of_nodes3
            for j in 1:length(filtered_df[i, :Time])
                Frame = filtered_df[i, :Time][j]
                if haskey(Centroids_temporary, Frame)
                    spindle_mid_point = [filtered_df[i, :CellPositionX][j] filtered_df[i, :CellPositionY][j] filtered_df[i, :CellPositionZ][j]]
                    cent = Centroids_temporary[Frame]
                    d = Vector{Float64}(undef, 0)
                    for k in eachindex(cent)
                        push!(d, Distance3D(cent[k], spindle_mid_point))
                    end
                    Ioo = sortperm(d)
                    Sorted_Normals = Normals_temporary[Frame][Ioo]
                    Sorted_Areas = Areas_temporary[Frame][Ioo]
                    Sorted_CoordIndices = coordIndices_temporary[Frame][Ioo]
                    CumSumArea = cumsum(Sorted_Areas)
                    IndexArea = findfirst(x -> x >= 50.0, CumSumArea)
                    longaxis = [filtered_df[i, :CellEllipsoidAxisCX][j] filtered_df[i, :CellEllipsoidAxisCY][j] filtered_df[i, :CellEllipsoidAxisCZ][j]]
                    normal = sum(Sorted_Normals[1:IndexArea])
                    NormalsX[j] = normal[1]
                    NormalsY[j] = normal[2]
                    NormalsZ[j] = normal[3]
                    Angles[j] = CalculerAngle(normal, longaxis)
                end
            end
        end
        XNormal[i] = NormalsX
        YNormal[i] = NormalsY
        ZNormal[i] = NormalsZ
        AngleNormalLongAxis[i] = Angles
        println("i = ", i)
    end
    filtered_df[!, :XNormal] = XNormal
    filtered_df[!, :YNormal] = YNormal
    filtered_df[!, :ZNormal] = ZNormal
    filtered_df[!, :AngleNormalLongAxis] = AngleNormalLongAxis
    return filtered_df
end

function NormalVector2Celloutput!(Celloutput::Dict{String,DataFrame}, wrlfilelist::Vector{String})
    Celloutput = sort(Celloutput)
    wrlbasenamelist = RemoveExt.(basename.(wrlfilelist), ".")
    coordIndices_temporary = Dict{Int64,Vector{SubArray{Int64,1,Vector{Int64},Tuple{UnitRange{Int64}},true}}}()
    points_temporary = Dict{Int64,Vector{SubArray{Union{Nothing,Float64},1,Vector{Union{Nothing,Float64}},Tuple{UnitRange{Int64}},true}}}()
    Normals_temporary = Dict{Int64,Vector{Vector{Float64}}}()
    Areas_temporary = Dict{Int64,Vector{Float64}}()
    Centroids_temporary = Dict{Int64,Vector{Vector{Float64}}}()
    number_of_nodes = []
    number_of_nodes2 = []
    number_of_nodes3 = []
    number_of_nodes4 = []
    k = sort(collect(keys(Celloutput)))
    for i in eachindex(k)
        foo = []
        foo2 = []
        gonad = RemoveExt(k[i], " Cell")
        if i == 1 || gonad !== RemoveExt(k[i-1], " Cell")
            foo = gonad .== wrlbasenamelist
            if sum(foo) > 0
                wrl = unique(wrlfilelist[foo])
                number_of_nodes, number_of_nodes2, number_of_nodes3, number_of_nodes4, Normals_temporary, Centroids_temporary, Areas_temporary = ParseWRL(wrl)
            end
            println("gonad ", gonad, " is done")
        end
        NormalsX = Vector{Union{Float64,Missing}}(undef, length(Celloutput[k[i]][!, :FRAME]))
        NormalsY = Vector{Union{Float64,Missing}}(undef, length(Celloutput[k[i]][!, :FRAME]))
        NormalsZ = Vector{Union{Float64,Missing}}(undef, length(Celloutput[k[i]][!, :FRAME]))
        Angles = Vector{Union{Float64,Missing}}(undef, length(Celloutput[k[i]][!, :FRAME]))
        if number_of_nodes == number_of_nodes2 && number_of_nodes3 == number_of_nodes4 && number_of_nodes == number_of_nodes3
            for j in 1:nrow(Celloutput[k[i]])
                Frame = Celloutput[k[i]][j, :FRAME]
                if haskey(Centroids_temporary, Frame)
                    spindle_mid_point = Celloutput[k[i]][j, :Spindle_Midpoint]
                    cent = Centroids_temporary[Frame]
                    d = Vector{Float64}(undef, 0)
                    for m in eachindex(cent)
                        push!(d, Distance3D(cent[m], spindle_mid_point))
                    end
                    Ioo = sortperm(d)
                    Sorted_Normals = Normals_temporary[Frame][Ioo]
                    Sorted_Areas = Areas_temporary[Frame][Ioo]
                    CumSumArea = cumsum(Sorted_Areas)
                    IndexArea = findfirst(x -> x >= 50.0, CumSumArea)
                    #longaxis = [filtered_df[i, :CellEllipsoidAxisCX][j] filtered_df[i, :CellEllipsoidAxisCY][j] filtered_df[i, :CellEllipsoidAxisCZ][j]]
                    spindle = [Celloutput[k[i]][j, :POSITION_X] - Celloutput[k[i]][j, :POSITION_X_1] Celloutput[k[i]][j, :POSITION_Y] - Celloutput[k[i]][j, :POSITION_Y_1] Celloutput[k[i]][j, :POSITION_Z] - Celloutput[k[i]][j, :POSITION_Z_1]]
                    normal = sum(Sorted_Normals[1:IndexArea])
                    NormalsX[j] = normal[1]
                    NormalsY[j] = normal[2]
                    NormalsZ[j] = normal[3]
                    #Angles[j] = CalculerAngle(normal, longaxis)
                    Angles[j] = CalculerAngle(normal, spindle)
                end
            end
        end
        Celloutput[k[i]][!, :XNormal] = NormalsX
        Celloutput[k[i]][!, :YNormal] = NormalsY
        Celloutput[k[i]][!, :ZNormal] = NormalsZ
        #filtered_df[!, :AngleNormalLongAxis] = AngleNormalLongAxis
        Celloutput[k[i]][!, :AngleSpindleRachis] = Angles
        println("i = ", i)
    end
    return Celloutput
end

function NormalVector2Celloutput2!(Celloutput, wrlfilelist)
    Celloutput = sort(Celloutput)
    k = sort(collect(keys(Celloutput)))
    wrlbasenamelist = RemoveExt.(basename.(wrlfilelist), ".")
    GonadWRL = nothing
    IndexedFaceSets = nothing
    WRLmanquant = Vector{String}()
    for i in eachindex(k)
        foo = []
        GonadCelloutput = RemoveExt(k[i], " Cell")
        foo = GonadCelloutput .== wrlbasenamelist
        if hasproperty(Celloutput[k[i]], :AngleSpindleRachis) == false && GonadCelloutput !== "r_2022_03_26_UM792-1001"
            if isnothing(IndexedFaceSets) || i == 1 || GonadCelloutput !== RemoveExt(k[i-1], " Cell")
                IndexedFaceSets = nothing
                GonadWRL = nothing
                println("sum of foo = ", sum(foo))
                if sum(foo) == 0
                    push!(WRLmanquant, GonadCelloutput)
                elseif sum(foo) > 0
                    wrl = unique(wrlfilelist[foo])
                    GonadWRL = RemoveExt.(basename.(wrl[1]), ".")
                    IndexedFaceSets = ExtractDataVRML(wrl[1])
                    println("gonad ", GonadCelloutput, " is done")
                end
            end
            if GonadCelloutput == GonadWRL
                Celloutput[k[i]] = AddAngles(Celloutput[k[i]], IndexedFaceSets)
            end
        end
        println("cell $i is done")
    end
    return Celloutput, unique(WRLmanquant)
end


function AddAngles(fazer::DataFrame, IndexedFaceSets)
    NormalsX = Vector{Union{Float64,Missing}}(undef, length(fazer[!, :FRAME]))
    NormalsY = Vector{Union{Float64,Missing}}(undef, length(fazer[!, :FRAME]))
    NormalsZ = Vector{Union{Float64,Missing}}(undef, length(fazer[!, :FRAME]))
    Angles = Vector{Union{Float64,Missing}}(undef, length(fazer[!, :FRAME]))
    for j in 1:nrow(fazer)
        Frame = fazer[j, :FRAME]
        if Frame <= length(IndexedFaceSets)
            spindle_mid_point = fazer[j, :Spindle_Midpoint]
            cent = IndexedFaceSets[Frame]["centroids"]
            d = Vector{Float64}(undef, 0)
            for m in eachindex(cent)
                push!(d, Distance3D(cent[m], spindle_mid_point))
            end
            Ioo = sortperm(d)
            Sorted_Normals = IndexedFaceSets[Frame]["normals"][Ioo]
            Sorted_Areas = IndexedFaceSets[Frame]["areas"][Ioo]
            CumSumArea = cumsum(Sorted_Areas)
            IndexArea = findfirst(x -> x >= 50.0, CumSumArea)
            if IndexArea !== nothing && d[Ioo][IndexArea] <= 8
                spindle = [fazer[j, :POSITION_X] - fazer[j, :POSITION_X_1] fazer[j, :POSITION_Y] - fazer[j, :POSITION_Y_1] fazer[j, :POSITION_Z] - fazer[j, :POSITION_Z_1]]
                normal = sum(Sorted_Normals[1:IndexArea])
                NormalsX[j] = normal[1]
                NormalsY[j] = normal[2]
                NormalsZ[j] = normal[3]
                Angles[j] = CalculerAngle(normal, spindle)
            end
        end
    end
    fazer[!, :XNormal] = NormalsX
    fazer[!, :YNormal] = NormalsY
    fazer[!, :ZNormal] = NormalsZ
    fazer[!, :AngleSpindleRachis] = Angles
    return fazer
end

function NormalVector2Celloutput3!(Celloutput, wrlfilelist)
    Celloutput = sort(Celloutput)
    k = sort(collect(keys(Celloutput)))
    wrlbasenamelist = RemoveExt.(basename.(wrlfilelist), ".")
    GonadWRL = nothing
    IndexedFaceSets = nothing
    WRLmanquant = Vector{String}()
    for i in eachindex(k)
        foo = []
        GonadCelloutput = RemoveExt(k[i], " Cell")
        foo = GonadCelloutput .== wrlbasenamelist
        if hasproperty(Celloutput[k[i]], :AngleSpindleRachis) == false # && GonadCelloutput !== "r_2022_03_26_UM792-1001"
            if isnothing(IndexedFaceSets) || i == 1 || GonadCelloutput !== RemoveExt(k[i-1], " Cell")
                IndexedFaceSets = nothing
                GonadWRL = nothing
                println("sum of foo = ", sum(foo))
                if sum(foo) == 0
                    push!(WRLmanquant, GonadCelloutput)
                elseif sum(foo) > 0
                    wrl = unique(wrlfilelist[foo])
                    GonadWRL = RemoveExt.(basename.(wrl[1]), ".")
                    IndexedFaceSets = ExtractDataVRML(wrl[1])
                    println("gonad ", GonadCelloutput, " is done")
                end
            end
            if GonadCelloutput == GonadWRL
                Celloutput[k[i]] = AddAngles2(Celloutput[k[i]], IndexedFaceSets)
            end
        end
        println("cell $i is done")
    end
    return Celloutput, unique(WRLmanquant)
end

function AddAngles2(fazer::DataFrame, IndexedFaceSets)
    fazer[!, :XNormal] = Vector{Union{Float64,Missing}}(undef, length(fazer[!, :FRAME]))
    fazer[!, :YNormal] = Vector{Union{Float64,Missing}}(undef, length(fazer[!, :FRAME]))
    fazer[!, :ZNormal] = Vector{Union{Float64,Missing}}(undef, length(fazer[!, :FRAME]))
    Angles = Vector{Union{Float64,Missing}}(undef, length(fazer[!, :FRAME]))
    for j in 1:nrow(fazer)
        Frame = fazer[j, :FRAME]
        if Frame <= length(IndexedFaceSets)
            spindle_mid_point = fazer[j, :Spindle_Midpoint]
            cent = IndexedFaceSets[Frame]["centroids"]
            d = Vector{Float64}(undef, 0)
            for m in eachindex(cent)
                push!(d, Distance3D(cent[m], spindle_mid_point))
            end
            Ioo = sortperm(d)
            Sorted_Normals = IndexedFaceSets[Frame]["normals"][Ioo]
            Sorted_Areas = IndexedFaceSets[Frame]["areas"][Ioo]
            CumSumArea = cumsum(Sorted_Areas)
            distance = 1
            area = 0
            IndexDistance = 0
            if last(CumSumArea) > 100        
                while area < 50
                    IndexDistance = findfirst(x -> x >= distance, d[Ioo])
                    area = CumSumArea[IndexDistance]
                    distance += 0.1
                end
                println("area = ", area)
                if IndexDistance !== nothing && d[Ioo][IndexDistance] <= 8
                    spindle = [fazer[j, :POSITION_X] - fazer[j, :POSITION_X_1] fazer[j, :POSITION_Y] - fazer[j, :POSITION_Y_1] fazer[j, :POSITION_Z] - fazer[j, :POSITION_Z_1]]
                    normal = sum(Sorted_Normals[1:IndexDistance])
                    fazer[j, :XNormal] = normal[1]
                    fazer[j, :YNormal] = normal[2]
                    fazer[j, :ZNormal] = normal[3]
                    Angles[j] = CalculerAngle(normal, spindle)
                end
            end
        end
    end
    fazer[!, :AngleSpindleRachis] = Angles
    return fazer
end

