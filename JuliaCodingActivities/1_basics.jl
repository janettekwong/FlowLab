# Julia Basics
# FLOW Lab LTRAD Program
# Author: Janette Wong
# Date: 1 Jan 2025
# Activity to learn the basics of coding in Julia

println("Hello, world!")

#= Multiline comments
are written
like this. 
=#

# Basic Math 1 to 10
0.5 + 0.5
1 - 3
3 * 1
16 / 4
div(10,2)
2 * 3
5 \ 35
2 ^ 3
25 % 16
(2 * 4) + 2

bitstring(1234)

"2 + 3 = $(2 + 3)"

using Printf   # this is how you load (or import) a module
@printf "%d is less than %f\n" 4.5 5.3   # => 5 is less than 5.300000

println("b is my vector")
b = [3, 4, 5]

push!(b,6)
println("a is going to append on")
a = [12, 13, 14]
c = append!(b,a)
println("c gets popped!")
d = pop!(c)
println("Put c back together")
push!(c,d)
c

for animal in ["dog", "cat", "mouse"]
    println("$animal is a mammal.")
end

for (k, v) in Dict("dog" => "mammal", "goldfish" => "fish")
    println("$k is a $v")
end

function addstuff(x,y)
    x + y
end

addstuff(1,3)