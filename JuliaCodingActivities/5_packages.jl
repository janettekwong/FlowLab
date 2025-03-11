# Julia Basics
# FLOW Lab LTRAD Program
# Author: Janette Wong
# Date: 9 Jan 2025
# Activity 4 to learn packages

# using Pkg
# Pkg.add("CSV")
# Pkg.add("DataFrames")
using CSV
using DataFrames
df = CSV.read("C:\\Users\\wongj_rl8z6\\FlowLab\\JuliaCodingActivities\\E203.csv", DataFrame) #fix loading it in
println(df)

Pkg.add("LinearAlgebra")
using LinearAlgebra
A = [1 2 3; 4 5 6; 7 8 9]
B = [2 2 2; 2 2 2; 2 2 2]
A * B
C = [1 1 1; 1 1 1; 1 1 1]
# A / C
#LinearAlgebra.dot(A, B)

### Figure out division. Still doesn't work
# D = [2 3; 1 4]
# E = [1 2; 0 1]
# E / D

norm([3 4])
cross([1; 2; 3], [2; 3; 4])

# Pkg.add("Interpolations")
using Interpolations
xs = Float64[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
A = xs.^2

itp = interpolate((xs,), A, Gridded(Linear()))
# println(itp)
value_at_3_1 = itp(3.1)


# grad_itp = gradient(itp)
# println(grad_itp)
# grad_3_1 = grad_itp(3.1)

# Use FLOWMath
# Use DelimitedFiles
#look up how to use
pwd()