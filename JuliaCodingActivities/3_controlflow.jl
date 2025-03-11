# Julia Basics
# FLOW Lab LTRAD Program
# Author: Janette Wong
# Date: 1 Jan 2025
# Activity 2 to learn control flow

# Use ? and : to make a ternary expression
x = 1
x > 2 ? "Yes, x is big" : "No, x is small"

x > 2 ? x^2 : x

# AND (&&) and OR  (||)
isodd(13) && @warn("That's odd")

if x == 1
    println("x is one")
elseif x == 2
    println("x is two")
else
    println("idk")
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

# Define variables
c = 0.02
p = 0.40

# for loop for camber table
println()
println("Camber Table with For Loop")
for x in 0:0.1:1
    println("$x, $(round(camber(0.02,0.40,x), digits=5))")
end


# while loop for camber table
println()
println("Camber Table with While Loop")
let x = 0
    while x <= 1
        println("$x, $(round(camber(0.02,0.40,x), digits=5))")
        x += 0.1
    end
end
# does this need to be a line shorter? I have 6 lines not 5