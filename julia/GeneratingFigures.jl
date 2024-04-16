using CairoMakie

f1 = Figure(resolution = (1200, 900))
ax1 = Axis(f1[1,1], title = "Cell Volume according to time (raw) n = $(nrow(CellShape_df_final))", xlabel = "Frame", ylabel = "Cell Volume(µm³)", limits = (nothing, nothing, 0, 400))
for i in 1:nrow(CellShape_df_final)
    lines!(ax1, CellShape_df_final[i, :Time], CellShape_df_final[i, :CellVolume])
end
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Cell_Volume_per_time (unfiltered data).png", f1, px_per_unit = 2) 
display(f1)

f2 = Figure(resolution = (1200, 900))
ax2 = Axis(f2[1,1], title = "Cell Volume according to time(filtered) n = $(nrow(filtered_df))", xlabel = "Frame", ylabel = "Cell Volume(µm³)",limits = (nothing, nothing, 0, 400))
for i in 1:nrow(filtered_df)
    lines!(ax2, filtered_df[i, :Time], filtered_df[i, :CellVolume])
end
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Cell_Volume_per_time (filtered data).png", f2, px_per_unit = 2) 
display(f2)

filtered_df_big = filter(row -> row[:CellSize] == "Big", filtered_df)
filtered_df_small = filter(row -> row[:CellSize] == "Small", filtered_df)

f3 = Figure(resolution = (1200, 900))
ax3 = Axis(f3[1,1], title = "Cumulative distribution long axis orientation to the DP axis n = $(nrow(filtered_df))", xlabel = "Orientation (degrees)", ylabel = "fraction")
ecdfplot!(ax3,filtered_df[!, :MeanOrientationCtoDP])
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Cumulative distribution Orientation long axis to DP axis (filtered data).png", f3, px_per_unit = 2) 
display(f3)

f4 = Figure(resolution = (1200, 900))
ax4 = Axis(f4[1,1], title = "Cumulative distribution long axis orientation to the DP axis n small = $(nrow(filtered_df_small)) n big = $(nrow(filtered_df_big))", xlabel = "Orientation (degrees)", ylabel = "fraction")
ecdfplot!(ax4,filtered_df_big[!, :MeanOrientationCtoDP])
ecdfplot!(ax4,filtered_df_small[!, :MeanOrientationCtoDP])
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Cumulative distribution Orientation long axis to DP axis small vs big (filtered data).png", f4, px_per_unit = 2) 
display(f4)



f5 = Figure(resolution = (1200, 900))
ax5 = Axis(f5[1,1], title = "Mean Cell Volume n  = $(nrow(CellShape_df_final))", ylabel = "Mean Cell Volume(µm³)")
rainclouds!(ax5, CellShape_df_final[!, :Type], CellShape_df_final[!, :MeanCellVolume])
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Mean Cell Volume (raw).png", f5, px_per_unit = 2) 
display(f5)

f6 = Figure(resolution = (1200, 900))
ax6 = Axis(f6[1,1], title = "Cell Volume Slope n  = $(nrow(CellShape_df_final))", ylabel = "Cell Volume Slope(µm³/ Frame)")
rainclouds!(ax6, CellShape_df_final[!, :Type], CellShape_df_final[!, :CellVolumeSlope])
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Cell Volume Slope(raw).png", f6, px_per_unit = 2) 
display(f6)

f7 = Figure(resolution = (1200, 900))
ax7 = Axis(f7[1,1], title = "Cell Volume Slope n  = $(nrow(CellShape_df_final))", ylabel = "Cell Volume Slope(µm³/ Frame)", limits = (nothing, nothing, -25, 25))
rainclouds!(ax7, CellShape_df_final[!, :Type], CellShape_df_final[!, :CellVolumeSlope])
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Cell Volume Slope zoomed(raw).png", f7, px_per_unit = 2) 
display(f7)

f8 = Figure(resolution = (1200, 900))
ax8 = Axis(f8[1,1], title = "Cell track length n  = $(nrow(CellShape_df_final))", ylabel = "Cell track length (Frames)", limits = (nothing, nothing, 0, 100))
rainclouds!(ax8, CellShape_df_final[!, :Type], CellShape_df_final[!, :Duration])
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Track lengths (raw).png", f8, px_per_unit = 2) 
display(f8)

f8 = Figure(resolution = (1200, 900))
ax8 = Axis(f8[1,1], title = "Cell track length n  = $(nrow(CellShape_df_final))", ylabel = "Cell track length (Frames)", limits = (nothing, nothing, 0, 100))
rainclouds!(ax8, CellShape_df_final[!, :Type], CellShape_df_final[!, :Duration])
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Track lengths (raw).png", f8, px_per_unit = 2) 
display(f8)

f9 = Figure(resolution = (1200, 900))
ax9 = Axis(f9[1,1], title = "Volume Variance n  = $(nrow(CellShape_df_final))", ylabel = "Volume Variance", limits = (nothing, nothing, -200, 4000))
rainclouds!(ax9, CellShape_df_final[!, :Type], CellShape_df_final[!, :VarianceCellVolume])
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Volume variance (raw).png", f9, px_per_unit = 2) 
display(f9)

filter!(:VarianceOrientationCtoDP => x -> !(ismissing(x) || isnothing(x) || isnan(x)), CellShape_df_final)
f10 = Figure(resolution = (1200, 900))
ax10 = Axis(f10[1,1], title = "Orientation Variance n  = $(nrow(CellShape_df_final))", ylabel = "Orientation Variance")
rainclouds!(ax10, CellShape_df_final[!, :Type], CellShape_df_final[!, :VarianceOrientationCtoDP])
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Orientation variance (raw).png", f10, px_per_unit = 2) 
display(f10)

f11 = Figure(resolution = (1200, 900))
ax11 = Axis(f11[1,1], title = "Cell long axis orientation to DP axis according to time (raw) n = $(nrow(CellShape_df_final))", xlabel = "Frame", ylabel = "Cell Orientation (degrees)", limits = (nothing, nothing, 0, 100))
for i in 1:nrow(CellShape_df_final)
    lines!(ax11, CellShape_df_final[i, :Time], CellShape_df_final[i, :OrientationCtoDP])
end
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Cell_Orientation_per_time (unfiltered data).png", f11, px_per_unit = 2) 
display(f11)

f12 = Figure(resolution = (1200, 900))
ax12 = Axis(f12[1,1], title = "Cell long axis orientation to DP axis according to time (filtered) n = $(nrow(filtered_df))", xlabel = "Frame", ylabel = "Cell Orientation (degrees)", limits = (nothing, nothing, 0, 100))
for i in 1:nrow(filtered_df)
    lines!(ax12, filtered_df[i, :Time], filtered_df[i, :OrientationCtoDP])
end
save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Cell_Orientation_per_time (filtered data).png", f12, px_per_unit = 2) 
display(f12)

f13 = Figure(resolution = (1200, 900))
ax13 = Axis(f13[1,1], title = "Cell long axis orientation to DP axis  (raw) n = $(nrow(CellShape_df_final))", xlabel = "Orientation long axis to DP axis (degress)", ylabel = "fraction")
ecdfplot!(ax13, CellShape_df_final[!, :MeanOrientationCtoDP])

save("/Users/vincentpoupart/Documents/Julia/Cell_Shape/Figures/Cell_Orientation_cumulative(raw).png", f13, px_per_unit = 2) 
display(f13)