using Xfoil, Plots, Printf
pyplot()

localpath = @__DIR__
cd(localpath)

file = "naca2412.dat"
# file = "naca0012.dat"

# read airfoil coordinates from a file
x, y = open(file, "r") do f
    x = Float64[]
    y = Float64[]
    for line in eachline(f)
        entries = split(chomp(line))
        push!(x, parse(Float64, entries[1]))
        push!(y, parse(Float64, entries[2]))
    end
    x, y
end

# load airfoil coordinates into XFOIL
Xfoil.set_coordinates(x,y)

alpha = 0:.5:30 # range of angle of attacks, in degrees

# determine airfoil coefficients across a range of angle of attacks
Reynolds = [1e5, 1e6, 1e7, 1e8, 1e9, 1e10]

# Create a color gradient
colors = cgrad(:blues, length(Reynolds))

## Create family of curves for various Re
plt_lift = plot(legend=:topleft, xlabel="Angle of Attack (degrees)", ylabel="Lift Coefficient", legendtitle="Reynolds Number", ylim=(0, 2.5))
plt_drag = plot(legend=:topleft, xlabel="Angle of Attack (degrees)", ylabel="Drag Coefficient", legendtitle="Reynolds Number", ylim=(0, 0.3))
plt_moment = plot(legend=:topleft, xlabel="Angle of Attack (degrees)", ylabel="Moment Coefficient", legendtitle="Reynolds Number", ylim=(-0.5, 0.5))

for (i, re) in enumerate(Reynolds)
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x_naca, y_naca, alpha, re, iter=100, zeroinit=false, printdata=false, reinit=true)
    re_label = @sprintf("%.1e", re)
    # plot!(plt_lift, alpha, c_l, label="$re_label", color=colors[i], show=false)
    plot!(plt_drag, alpha, c_d, label="Re $re_label", color=colors[i], show=false)
    # plot!(plt_moment, alpha, c_m, label="Re $re_label", color=colors[i], show=false)
end

# display(plt_lift)
display(plt_drag)
# display(plt_moment)

# plot(alpha, c_l, label="", xlabel="Angle of Attack (degrees)", ylabel="Lift Coefficient", show=true)
# plot(alpha, c_d, label="", xlabel="Angle of Attack (degrees)", ylabel="Drag Coefficient",
#     overwrite_figure=false, show=true)
# plot(alpha, c_dp, label="", xlabel="Angle of Attack (degrees)", ylabel="Pressure Drag Coefficient",
#     overwrite_figure=false, show=true)
# plot(alpha, c_m, label="", xlabel="Angle of Attack (degrees)", ylabel="Moment Coefficient",
#     overwrite_figure=false, show=true)






println("Finished script, good job!")


