

path1 = "M:\\Labbe\\Vincent Poupart\\Cell_shape"
path2 = "M:\\Labbe\\Mohamed Réda Zellag\\Data\\SPINDLE\\UM793_UM792_Control"
#path3 = "/home/vincent/Documents/wrl"

filelist1 = ListFiles(path1)
filelist2 = ListFiles(path2)
filelist3 = ListFiles(path3)
wrlfiles = sort(WrlfileList(filelist2))

DTC = FetchDTC(filelist1)
DPaxis = FetchDPaxis(filelist1)
CellShape_df_final = FetchImarisStats(filelist1)
filtered_df = FilteringCellShape(CellShape_df_final)
Celloutput = sort(CreateCelloutput(filelist2))
Celloutput, WRLmanquants = NormalVector2Celloutput3!(Celloutput, wrlfiles)


#ZipFiles = ZipfileList(filelist2, "rachis surface")
#WriteZippedWrlFiles(ZipFiles)

# = CSV.read("Celloutput.csv", DataFrame)

#Scoring = ClickStepsMitosis(Celloutput)
#scoring_df = ScoringDict2DataFrame(Scoring)
#CSV.write(joinpath(path2, "scoring_df.csv"), scoring_df)
scoring_df = CSV.read(joinpath(path2, "scoring_df.csv"), DataFrame)
SaveCelloutputdf(Celloutput)
scoring_df_add_matlab = CSV.read("M:\\Labbe\\Vincent Poupart\\Cell_shape\\scoring_df_add_matlab.csv", DataFrame)


SpindleOrientationJulia = Vector{Union{Missing,Float64}}(undef, nrow(scoring_df_add_matlab))
for i in 1:nrow(scoring_df_add_matlab)
    anaphaseonset = scoring_df_add_matlab[i, :AnaphaseOnset]
    if anaphaseonset !== NaN
        anaphaseonset = convert(Int64, anaphaseonset)
        cell = scoring_df_add_matlab[i, :Cell]
        println(cell)
        gonad = RemoveExt(cell, " Cell")
        indx = findfirst(x -> x == anaphaseonset, Celloutput[cell][!, :FRAME])
        if indx >= 1 
            SpinOri = Celloutput[cell][indx, :AngleSpindleRachis]
            SpindleOrientationJulia[i] = SpinOri
        end
    end
end


scoring_df_add_matlab[!, :SpindleOrientationJuliaSphereCorrect] = SpindleOrientationJulia
CSV.write("scoring_df_add_matlab.csv", scoring_df_add_matlab)

function CreateInterphaseCellsDF(filtered_df)
    InterphaseCellsDF = DataFrame()
    Gonad = []
    TrackID = []
    Type = []
    Time = []
    Duration = []
    CellPositionX = []
    CellPositionY = []
    CellPositionZ = []
    CellEllipsoidAxisCX = []
    CellEllipsoidAxisCY = []
    CellEllipsoidAxisCZ = []
    MeanDistanceDTC = []
    MeanCellVolume = []
    MeanOrientationCtoDP = []
    MeanProlateIndex = []

    for i in 1:nrow(filtered_df)
        Gonad = push!(Gonad, filtered_df[i, :Gonad])
        TrackID = push!(TrackID, filtered_df[i,:TrackID])
        Type = push!(Type, filtered_df[i, :Type])
        Time = push!(Time, filtered_df[i, :Time][1]) 
        Duration = push!(Duration, filtered_df[i, :Duration])
        CellPositionX = push!(CellPositionX, filtered_df[i, :CellPositionX][1])
        CellPositionY = push!(CellPositionY, filtered_df[i, :CellPositionY][1])
        CellPositionZ = push!(CellPositionZ, filtered_df[i, :CellPositionZ][1])
        CellEllipsoidAxisCX = push!(CellEllipsoidAxisCX, filtered_df[i, :CellEllipsoidAxisCX][1])
        CellEllipsoidAxisCY = push!(CellEllipsoidAxisCY, filtered_df[i, :CellEllipsoidAxisCY][1])
        CellEllipsoidAxisCZ = push!(CellEllipsoidAxisCZ, filtered_df[i, :CellEllipsoidAxisCZ][1])
        MeanDistanceDTC = push!(MeanDistanceDTC, filtered_df[i, :MeanDistanceDTC])
        MeanCellVolume = push!(MeanCellVolume, filtered_df[i, :MeanCellVolume])
        MeanOrientationCtoDP = push!(MeanOrientationCtoDP, filtered_df[i, :MeanOrientationCtoDP])
        MeanProlateIndex = push!(MeanProlateIndex , filtered_df[i, :MeanProlateIndex])
    end

    InterphaseCellsDF[!, :Gonad] = Gonad
    InterphaseCellsDF[!, :TrackID ] = TrackID 
    InterphaseCellsDF[!, :Type] = Type
    InterphaseCellsDF[!, :Time] = Time
    InterphaseCellsDF[!, :Duration] = Duration 
    InterphaseCellsDF[!, :CellPositionX] = CellPositionX
    InterphaseCellsDF[!, :CellPositionY] = CellPositionY
    InterphaseCellsDF[!, :CellPositionZ] = CellPositionZ
    InterphaseCellsDF[!, :CellEllipsoidAxisCX] = CellEllipsoidAxisCX
    InterphaseCellsDF[!, :CellEllipsoidAxisCY] = CellEllipsoidAxisCY
    InterphaseCellsDF[!, :CellEllipsoidAxisCZ] = CellEllipsoidAxisCZ
    InterphaseCellsDF[!, :MeanDistanceDTC] = MeanDistanceDTC
    InterphaseCellsDF[!, :MeanCellVolume] = MeanCellVolume
    InterphaseCellsDF[!, :MeanOrientationCtoDP] = MeanOrientationCtoDP
    InterphaseCellsDF[!, :MeanProlateIndex] = MeanProlateIndex 
   
    return InterphaseCellsDF
end

InterphaseCellsDF = CreateInterphaseCellsDF(filtered_df)
CSV.write("/run/user/1000/gvfs/smb-share:server=serv04-iric.iric.umontreal.ca,share=labo/Labbe/Vincent Poupart/Cell_shape/InterphaseCellsDF.csv", InterphaseCellsDF)