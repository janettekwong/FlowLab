using Xfoil, Plots, Printf
pyplot()

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

# plot the airfoil geometry
scatter(x, y, label="", framestyle=:none, aspect_ratio=1.0, show=true)

# repanel using XFOIL's `PANE` command
xr, yr = Xfoil.pane()

# plot the refined airfoil geometry
scatter(xr, yr, label="", framestyle=:none, aspect_ratio=1.0, show=true)

# set operating conditions
alpha = -9:1:14 # range of angle of attacks, in degrees
re = 1e5 # 1e5 # Reynolds number
mach = 0.0

# set step size
h = 1e-6

# initialize outputs
n_a = length(alpha)
c_l = zeros(n_a)
c_d = zeros(n_a)
c_dp = zeros(n_a)
c_m = zeros(n_a)
converged = zeros(Bool, n_a)

# determine airfoil coefficients across a range of angle of attacks
for i = 1:n_a
    c_l[i], c_d[i], c_dp[i], c_m[i], converged[i] = Xfoil.solve_alpha(alpha[i], re; iter=100, reinit=true)
end

### ----- Plotting Coefficients normal -------------
# # print results
# println("Angle\t\tCl\t\tCd\t\tCm\t\tConverged")
# for i = 1:n_a
#     @printf("%8f\t%8f\t%8f\t%8f\t%d\n",alpha[i],c_l[i],c_d[i],c_m[i],converged[i])
# end

# # plot results
# plot(alpha, c_l, label="", xlabel="Angle of Attack (degrees)", ylabel="Lift Coefficient", show=true)
# plot(alpha, c_d, label="", xlabel="Angle of Attack (degrees)", ylabel="Drag Coefficient",
#     overwrite_figure=false, show=true)
# plot(alpha, c_m, label="", xlabel="Angle of Attack (degrees)", ylabel="Moment Coefficient",
#     overwrite_figure=false, show=true)

# ---------------------------------------------------
# Additions for sensitivity analysis
c_l_a = zeros(n_a)
c_d_a = zeros(n_a)
c_dp_a = zeros(n_a)
c_m_a = zeros(n_a)

for i = 1:n_a
    c_l1, c_d1, c_dp1, c_m1, converged[i] = Xfoil.solve_alpha(alpha[i], re; mach, iter=100, reinit=true)
    c_l2, c_d2, c_dp2, c_m2, converged[i] = Xfoil.solve_alpha(alpha[i]+h, re; mach, iter=100, reinit=true)
    c_l_a[i] = (c_l2 - c_l1)/h * 180/pi
    c_d_a[i] = (c_d2 - c_d1)/h * 180/pi
    c_m_a[i] = (c_m2 - c_m1)/h * 180/pi
end

# # print results
# println("Angle\t\tdClda\t\tdCdda\t\tdCmda\t\tConverged")
# for i = 1:n_a
#   @printf("%8f\t%8f\t%8f\t%8f\t%d\n",alpha[i],c_l_a[i],c_d_a[i],c_m_a[i],converged[i])
# end

# -------------------------------------------------------
# Automated Angle of Attack Sweep

# println("Automated Angle of Attack Sweep Data")
# c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=100, zeroinit=false, printdata=true, reinit=true)

# Add experimental data
# alpha1 = [0, 4, 8, 12]
# cl = [0.261, 0.733, 1.139, 1.144]
# cdrag = [0.01197, 0.01483, 0.02418, 0.09473]
# cm = [-0.051, -0.055, -0.059, -0.029]

# Experimental Data from lift plot for NACA 0012 airfoil

# Define your data
data = [
    -17.371428571428567 -1.2571428571428571;
    -15.999999999999996 -1.3600000000000003;
    -15.999999999999996 -1.5542857142857143;
    -12.799999999999997 -1.3371428571428572;
    -9.828571428571422 -1.12;
    -8.228571428571428 -0.8799999999999999;
    -6.628571428571426 -0.6628571428571428;
    -5.028571428571425 -0.48;
    -2.74285714285714 -0.25142857142857133;
    -1.3714285714285666 -0.10285714285714276;
    0 0.02285714285714313;
    1.8285714285714363 0.21714285714285708;
    3.20000000000001 0.3885714285714288;
    5.257142857142853 0.5942857142857143;
    7.314285714285724 0.7771428571428571;
    8.228571428571428 0.9142857142857141;
    10.285714285714285 1.1428571428571428;
    12.114285714285721 1.302857142857143;
    13.714285714285715 1.4171428571428573;
    15.542857142857144 1.5657142857142858;
    16.457142857142863 1.44;
    17.142857142857153 1.3257142857142856;
    17.37142857142858 1.1657142857142855;
    17.828571428571436 1.028571428571429;
    19.200000000000003 0.9371428571428573;
    20.57142857142857 0.8799999999999999
]


# Split the data into aoa and c_lift
aoa = data[:, 1]
c_lift = data[:, 2]

plot(alpha, c_l, label="", xlabel="Angle of Attack (degrees)", ylabel="Lift Coefficient", show=true)
scatter!(aoa, c_lift, markersize=4, markercolor=:yellow, legend=false)
# scatter!(alpha1, cl, markersize=4, markercolor=:red, legend=false)
# plot(alpha, c_d, label="", xlabel="Angle of Attack (degrees)", ylabel="Drag Coefficient",
#     overwrite_figure=false, show=true)
# scatter!(alpha1, cdrag, markersize=4, markercolor=:red)
# plot(alpha, c_dp, label="", xlabel="Angle of Attack (degrees)", ylabel="Pressure Drag Coefficient",
#     overwrite_figure=false, show=true)
# plot(alpha, c_m, label="", xlabel="Angle of Attack (degrees)", ylabel="Moment Coefficient",
#     overwrite_figure=false, show=true)
# scatter!(alpha1, cm, markersize=4, markercolor=:red)


## Create family of curves for various Re




println("Finished tutorial, good job!")


