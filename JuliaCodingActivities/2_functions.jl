# Julia Functions
# FLOW Lab LTRAD Program
# Author: Janette Wong
# Date: 1 Jan 2025
# Activity 1 to learn functions in Julia




"""
thicknessfunction(x,m)

Function for airfoil thickness along the chord.

Thickness is given by max thickness, m, and distance along the airfoil, x.

"""
function thicknessfunction(x,m)
    t = 10*m*(0.2969*x^(1/2) - 0.1260*x - 0.3537*x^2 + 0.2843*x^3 -0.1015*x^4)
    return t
end

# Define variables
x = 0:0.1:1
t = Float64[]
m = 0.10

println("Thickness")
for value in x
    thick = thicknessfunction(value, m)
    push!(t, thick)
    println("x: $value, t: $thick")
end

### for loop in 3 lines of code
println()
println("Thickness Table")
for x in 0:0.1:1
    println("$x, $(round(thicknessfunction(x,0.10), digits=5))")
end

println()
println("Thickness Table with while loop")
let x = 0
    while x <= 1
        println("$x, $(round(thicknessfunction(x,0.10), digits=5))")
        x += 0.1
    end
end
