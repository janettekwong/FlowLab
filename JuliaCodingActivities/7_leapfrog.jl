# Julia Basics
# FLOW Lab LTRAD Program
# Author: Janette Wong
# Date: 13 Jan 2025
# Leapfrogging Vorticies

### Pseudocode

# Define variables: gamma and initial positions of vorticies, initialize array, using LinearAlgebra
using LinearAlgebra
Gamma = [0, 0, 1] # Gamma needs to be negative for vorticies 1 and 4
D = 1
TimeStep = 0.01
PositionArray = [[0,-D/2, 0], [0,D/2,0], [D,D/2,0], [D,-D/2,0]]
VelocityArray = [[0,0,0], [0,0,0], [0,0,0], [0,0,0]]

# Use function to calculate velocity vector at a radius r away. Gamma and r are inputs
"""
velocity(Gamma,r)

Function for velocity vector at a given radius away from a vortex.
"""

function velocity(Gamma,r)
    v = cross(Gamma,r)/(2*pi*(norm(r))^2)
    return v
end

# test velocity function
# r = [0, -D/2, 0]
# v = velocity(Gamma,r)
# println(v) 


# find a way to get the radii between each vortex from the array
r1_2 = [PositionArray[1][1] - PositionArray[2][1], PositionArray[1][2] - PositionArray[2][2], 0]
r1_3 = [PositionArray[1][1] - PositionArray[3][1], PositionArray[1][2] - PositionArray[3][2], 0]
r1_4 = [PositionArray[1][1] - PositionArray[4][1], PositionArray[1][2] - PositionArray[4][2], 0]

r2_1 = [PositionArray[2][1] - PositionArray[1][1], PositionArray[2][2] - PositionArray[1][2], 0]
r2_3 = [PositionArray[2][1] - PositionArray[3][1], PositionArray[2][2] - PositionArray[3][2], 0]
r2_4 = [PositionArray[2][1] - PositionArray[4][1], PositionArray[2][2] - PositionArray[4][2], 0]

r3_1 = [PositionArray[3][1] - PositionArray[1][1], PositionArray[3][2] - PositionArray[1][2], 0]
r3_2 = [PositionArray[3][1] - PositionArray[2][1], PositionArray[3][2] - PositionArray[2][2], 0]
r3_4 = [PositionArray[3][1] - PositionArray[4][1], PositionArray[3][2] - PositionArray[4][2], 0]

r4_1 = [PositionArray[4][1] - PositionArray[1][1], PositionArray[4][2] - PositionArray[1][2], 0]
r4_2 = [PositionArray[4][1] - PositionArray[2][1], PositionArray[4][2] - PositionArray[2][2], 0]
r4_3 = [PositionArray[4][1] - PositionArray[3][1], PositionArray[4][2] - PositionArray[3][2], 0]

function get_distance(P1,P2)
    return P2.-P1
end

### TRY AGAIN
#take in 3 radii vectors (the three that are impacting 1 point) to a function
# use the function velocity() to make them into velocity vectors
# then add them together to make one velocity vector
# return the velocity vector
function combinevelocity(r1,r2,r3) # input radii from other points to point of interest
    v1 = velocity(Gamma, r1)
    v2 = velocity(Gamma, r2)
    v3 = velocity(Gamma, r3)
    vnext = v1+v2+v3
    println(v1, v2, v3)
    return vnext
end

v1 = combinevelocity(r1_2,r1_3,r1_4)
v2 = combinevelocity(r2_1,r2_3,r2_4)
v3 = combinevelocity(r3_1,r3_2,r3_4)
v4 = combinevelocity(r4_1,r4_2,r4_3)
println(v1)
println(v2)
println(v3)
println(v4)

# make another function that will take in a velocity vector and mulitply it by a timestep
function toposition(v1,v2,v3,v4,ts)
    P = [v1*ts,v2*ts,v3*ts,v4*ts]
    return P
end
P = toposition(v1,v2,v3,v4,TimeStep)
println(P)
push!(PositionArray,P)
println(PositionArray)
# return a new position vector

# push the new positon vector in the spot it belongs



# Combine the effects of all the vorticies on each other (combine velocity vectors...)

# Multiply by a timestep to get next position for each vortex, putting it into an array

# Plot the array with time [0,12] as x and the 4 vorticies as the y's
