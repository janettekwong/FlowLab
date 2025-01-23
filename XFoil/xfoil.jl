using Xfoil, Plots, Printf
pyplot()

# read airfoil coordinates from a file
x, y = open("naca2412.dat", "r") do f
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
re = 1e5 # Reynolds number
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

# print results
println("Angle\t\tdClda\t\tdCdda\t\tdCmda\t\tConverged")
for i = 1:n_a
  @printf("%8f\t%8f\t%8f\t%8f\t%d\n",alpha[i],c_l_a[i],c_d_a[i],c_m_a[i],converged[i])
end

# -------------------------------------------------------
# Automated Angle of Attack Sweep

println("Automated Angle of Attack Sweep Data")
c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=100, zeroinit=false, printdata=true, reinit=true)



println("Finished, good job!")