# Julia Basics
# FLOW Lab LTRAD Program
# Author: Janette Wong
# Date: 1 Jan 2025
# Activity 3 to learn arrays





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
zu1, zl1 = coor(2,4,12,range(0, stop=1, step=0.1))
zu2 = [1,2,3]
zl2 = [11,12,13]
println()
println("Table version")
solution_array = Array{Float64}(undef, length(x), 3)

for (xs, zu, zl) in zip(x,zu1,zl1)
    println("x: $xs, zu: $zu, zl: $zl")
end

println()
println("Array")
array1 = vcat(x',zu1',zl1')'
println(array1)

value1 = array1[1,2]
value2 = array1[5,3]
value3 = array1[1,1:3]
value4 = array1[1:3,2]
value5 = array1[:,2]
value6 = array1[1,:]

v1 = vcat(reverse(zl1),zu1)
v2 = vcat(reverse(x),x)