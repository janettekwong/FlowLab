# Julia Basics
# FLOW Lab LTRAD Program
# Author: Janette Wong
# Date: 10 Jan 2025
# Activity 5 to learn plotting


using Plots
"""
thicknessfunction(x,m)

Function for airfoil thickness along the chord.

Thickness is given by max thickness, m, and distance along the airfoil, x.

"""
function thicknessfunction(x,m)
    t = 10*m*(0.2969*x^(1/2) - 0.1260*x - 0.3537*x^2 + 0.2843*x^3 -0.1015*x^4)
    return t
end




"""
camber(c,p,x)

Function for airfoil camber along the chord.

Where c is the value of maximum camber (% chord), and p is the position of max camber (units of chord/10), and x is position along unit length chord

"""
function camber(c,p,x)
    if x <= p
        zbar = c*(2*p*x - x^2)/p^2
    else
        zbar = c*(1 - 2*p + 2*p*x - x^2)/(1 - p)^2
    end
    return zbar
end




"""
coor(c,p,t,x)

Function for upper and lower z coordinate of airfoil.

Where c is max camber, p is max camber position, t is max thickness, and x is an array of values from 0 to 1.

"""
function coor(c1::Int,p1::Int,t1::Int,x)
    # Convert variables to correct magnitudes
    c = c1/100
    t = t1/100
    p = p1/10

    # Solve for upper and lower coordinates in array form
    zu = Float64[]
    zl = Float64[]
    for i in x
        zbar = camber(c,p,i)
        thick = thicknessfunction.(i,t)
        println("zbar ($i): $zbar")
        println("thick ($i): $thick")
        # Solve for upper and lower coordinates
        upper_coor = zbar + thick/2
        lower_coor = zbar - thick/2
        push!(zu,upper_coor)
        push!(zl,(lower_coor))
    end
    return zu, zl
end

xs = range(0, stop=1, step=0.01)

# Calculate 0008, 0012, 2412, 4412, 2424 coords
zu0008, zl0008 = coor(0,0,08,xs)
zu0012, zl0012 = coor(0,0,12,xs)
zu2412, zl2412 = coor(2,4,12,xs)
zu4412, zl4412 = coor(4,4,12,xs)
zu2424, zl2424 = coor(2,4,24,xs)

plot(xlabel="Length", ylabel="Height", legend = true, grid = false, xlims = (-0.1, 1.1), ylims = (-0.15, 0.25), xticks = [0, 1], yticks = [-0.15, 0, 0.25])
plot!(legend = (0.9, 0.9), legend_background_color = :transparent, fg_legend= :transparent)
plot!(xs, zu0008, line = (2, :blue, :solid), label = "NACA 0008")
plot!(xs, zl0008, line = (2, :blue, :solid), label = "")

plot!(xs, zu0012, line = (2, :green, :dash), label = "NACA 0012")
plot!(xs, zl0012, line = (2, :green, :dash), label = "")

plot!(xs, zu2412, line = (2, :red, :dot), label = "NACA 2412")
plot!(xs, zl2412, line = (2, :red, :dot), label = "")

plot!(xs, zu4412, line = (2, :purple, :dashdot), label = "NACA 4412")
plot!(xs, zl4412, line = (2, :purple, :dashdot), label = "")

plot!(xs, zu2424, line = (2, :orange, :dash), label = "NACA 2424")
plot!(xs, zl2424, line = (2, :orange, :dash), label = "")

savefig("NACA_profiles.pdf")