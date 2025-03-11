using Xfoil, Plots, Printf
pyplot()

localpath = @__DIR__
cd(localpath)

flat_files = ["naca0009.dat", "naca0012.dat", "naca0015.dat", "naca0018.dat"]
all_files = ["naca0012.dat", "naca0015.dat", "naca0018.dat", "naca2412.dat", "naca2415.dat", "naca2418.dat", "naca4412.dat", "naca4415.dat", "naca4418.dat"]
camber_files = ["naca0012.dat", "naca2412.dat", "naca4412.dat"]
one_file = ["naca2412.dat"]
alpha = -9:.5:20 # range of angle of attacks, in degrees
re = 1e5

## Create family of curves for various Re
plt_lift = plot(legend=false, xlabel="Angle of Attack (degrees)", ylabel="Lift Coefficient", ylim=(-1.0, 1.5))
plt_drag = plot(legend=false, xlabel="Angle of Attack (degrees)", ylabel="Drag Coefficient") #, ylim=(0, 0.3))
plt_moment = plot(legend=false, xlabel="Angle of Attack (degrees)", ylabel="Moment Coefficient", ylim=(-0.5, 0.5))

# Define line styles and colors
line_styles = [:solid] #, :dash, :dot] #, :dashdot]
colors = [:blue, :red, :green, :purple, :orange, :cyan, :magenta]

for (i, file) in enumerate(flat_files)
    # Construct the full path to the file
    filepath = joinpath(localpath, file)

    # Extract the file name without the extension
    file_label = splitext(basename(file))[1]
    file_label = replace(file_label, r"naca(\d+)" => s -> "NACA " * match(r"\d+", s).match)

    # Declare variables as local
    local x, y
    # read airfoil coordinates from a file
    x, y = open(filepath, "r") do f
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
    Xfoil.set_coordinates(x, y)

    # Declare variables as local
    local c_l, c_d, c_dp, c_m, converged
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=100, zeroinit=false, printdata=false, reinit=true)
    
    # Plot with different line styles and colors
    # plot!(plt_lift, alpha, c_l, label="$file_label", color=colors[i % length(colors) + 1], linestyle=line_styles[i % length(line_styles) + 1], linewidth=2, show=false)
    plot!(plt_drag, alpha, c_d, label="$file_label", color=colors[i % length(colors) + 1], linestyle=line_styles[i % length(line_styles) + 1], linewidth=2, show=false)
    # plot!(plt_moment, alpha, c_m, label="$file_label", color=colors[i % length(colors) + 1], linewidth=2, show=false)
end

# display(plt_lift)
display(plt_drag)
# display(plt_moment)

println("Finished script, good job!")