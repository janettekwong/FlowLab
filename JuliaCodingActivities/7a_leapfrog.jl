# Julia Basics
# FLOW Lab LTRAD Program
# Author: Janette Wong
# Date: 17 Jan 2025
# Leapfrogging Vorticies



# Define variables: gamma and initial positions of vorticies, initialize array, using LinearAlgebra
using LinearAlgebra
using Plots
Gamma = [0, 0, 1] # Gamma needs to be negative for vorticies 1 and 4
D = 1
TimeStep = 0.01

# Initialize Position Arrays
P1 = [0,-D/2, 0]
P2 = [0, D/2, 0]
P3 = [D, D/2, 0]
P4 = [D, -D/2, 0]

# Initialize Velocity Arrays
V1 = [0,0,0]
V2 = [0,0,0]
V3 = [0,0,0]
V4 = [0,0,0]

"""
velocity(Gamma,r)

Function for velocity vector at a given distance away from a vortex.
"""

function velocity(Gamma,r)
    v = cross(Gamma,r)/(2*pi*(norm(r))^2)
    return v
end




"""
get_distance(P1,P2)

Gives distance from Point 2 to Point 1.
"""

function get_distance(P1,P2)
    return P2.-P1
end




"""
get_velocities()

Outputs the velocities for the next timestep.
"""
function get_velocities(P1,P2,P3,P4)
    ## Compute Distances
    # Compute distances from other points to Point 1
    r1_2 = get_distance(P1,P2)
    r1_3 = get_distance(P1,P3)
    r1_4 = get_distance(P1,P4)

    # Compute distances from other points to Point 2
    r2_1 = get_distance(P2,P1)
    r2_3 = get_distance(P2,P3)
    r2_4 = get_distance(P2,P4)

    # Compute distances from other points to Point 3
    r3_1 = get_distance(P3,P1)
    r3_2 = get_distance(P3,P2)
    r3_4 = get_distance(P3,P4)

    # Compute distances from other points to Point 4
    r4_1 = get_distance(P4,P1)
    r4_2 = get_distance(P4,P2)
    r4_3 = get_distance(P4,P3)

    ## Compute Velocities
    # Compute the velocity vectors from the vortex at Point 1
    v1_2 = velocity(-Gamma,r1_2)
    v1_3 = velocity(-Gamma,r1_3)
    v1_4 = velocity(-Gamma,r1_4)
    
    # Compute the velocity vectors from the vortex at Point 2
    v2_1 = velocity(Gamma,r2_1)
    v2_3 = velocity(Gamma,r2_3)
    v2_4 = velocity(Gamma,r2_4)

    # Compute the velocity vectors from the vortex at Point 3
    v3_1 = velocity(Gamma,r3_1)
    v3_2 = velocity(Gamma,r3_2)
    v3_4 = velocity(Gamma,r3_4)

    # Compute the velocity vectors from the vortex at Point 4
    v4_1 = velocity(-Gamma,r4_1)
    v4_2 = velocity(-Gamma,r4_2)
    v4_3 = velocity(-Gamma,r4_3)

    # Add Velocities
    V1 = v2_1 + v3_1 + v4_1
    V2 = v1_2 + v3_2 + v4_2
    V3 = v1_3 + v2_3 + v4_3
    V4 = v1_4 + v2_4 + v3_4

    return V1, V2, V3, V4
end




"""
make_position_arrays(P1,P2,P3,P4,t_final,dt)

Takes initial positions and outputs the final position arrays for each point, given the time range and dt.
"""
function make_position_arrays(P1, P2, P3, P4, t_final, dt)
    num_steps = Int(t_final / dt)
    
    # Initialize position matrices
    p1 = zeros(Float64, num_steps, 3)
    p2 = zeros(Float64, num_steps, 3)
    p3 = zeros(Float64, num_steps, 3)
    p4 = zeros(Float64, num_steps, 3)

    # Set initial positions
    p1[1, :] .= P1
    p2[1, :] .= P2
    p3[1, :] .= P3
    p4[1, :] .= P4

    for t in 2:num_steps
        V1, V2, V3, V4 = get_velocities(P1, P2, P3, P4)
        P1 = P1 .+ V1 .* dt
        P2 = P2 .+ V2 .* dt
        P3 = P3 .+ V3 .* dt
        P4 = P4 .+ V4 .* dt
        
        p1[t, :] .= P1
        p2[t, :] .= P2
        p3[t, :] .= P3
        p4[t, :] .= P4
    end

    return p1, p2, p3, p4
end


## RUN CODE ##
t_final = 40
dt = 0.01
time = 0:dt:t_final
# Create Position Arrays
p1,p2,p3,p4 = make_position_arrays(P1,P2,P3,P4,t_final,dt)

# Plot 
plot!(p1[:,1], p1[:,2], line = (2, :red), legend = false)
plot!(p2[:,1], p2[:,2], line = (2, :red), legend = false)
plot!(p3[:,1], p3[:,2], line = (2, :blue), legend = false)
plot!(p4[:,1], p4[:,2], line = (2, :blue), legend = false)

savefig("leapfrog_plot.png")
