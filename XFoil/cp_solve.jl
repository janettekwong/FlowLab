using DelimitedFiles
using Plots
using Xfoil
using Interpolations
using Statistics

# Set the backend to PyPlot for interactive plotting in a separate window
pyplot()

file = "naca0018.dat"

dat_file1 = "c:/Users/wongj_rl8z6/FlowLab/XFoil/naca0018lift.dat" # lift
dat_file2 = "c:/Users/wongj_rl8z6/FlowLab/XFoil/naca0018drag.dat" # drag

# Read the comma-delimited file into an array
pub_lift_data = readdlm(dat_file1, ',')

# Separate the data into x and y components
x_data = pub_lift_data[:, 1]
y_data = pub_lift_data[:, 2]

# read airfoil coordinates from a file
x_naca, y_naca = open(file, "r") do f
    x_naca = Float64[]
    y_naca = Float64[]
    for line in eachline(f)
        entries = split(chomp(line))
        push!(x_naca, parse(Float64, entries[1]))
        push!(y_naca, parse(Float64, entries[2]))
    end
    x_naca, y_naca
end

# set operating conditions
alpha = -21:1:20
re = 1e5

# Initialize arrays to store results
c_l = Float64[]
c_d = Float64[]
c_dp = Float64[]
c_m = Float64[]
converged = Bool[]

# Solve for each angle of attack
for a in alpha
    cl, cd, cdp, cm, conv = Xfoil.solve_alpha(a, re, iter=100)
    push!(c_l, cl)
    push!(c_d, cd)
    push!(c_dp, cdp)
    push!(c_m, cm)
    push!(converged, conv)
end

# Plot the data
plot(alpha, c_d, xlabel="Angle of Attack", ylabel="Coefficient of Drag", linewidth=2, legend=:topleft, label="XFoil")
scatter!(x_data, y_data, label="Published Data", color=:green, markersize=8, legend=:topleft)

# Interpolate the XFoil data to match the x_data points
interp_c_d = interpolate((alpha,), c_d, Gridded(Linear()))
c_d_interp = [interp_c_d(x) for x in x_data]

# Calculate the error
errors = c_d_interp .- y_data

# Calculate RMSE
rmse = sqrt(mean(errors .^ 2))
println("Root Mean Square Error (RMSE): ", rmse)

# Plot the error as a bar plot
bar(x_data, errors, xlabel="Angle of Attack", ylabel="Error", label="Error", color=:, legend=false, ylim=(-0.5, 0.5))

# Save the plot to the Downloads folder
# savefig("C:/Users/wongj_rl8z6/Downloads/lift_error_plot.png")

# Display the plot in an interactive window
gui()

println("Finished script, good job!")