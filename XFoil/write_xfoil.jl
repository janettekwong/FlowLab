using Xfoil, Printf, DelimitedFiles
# pyplot()

function process_files(list_of_files, alpha, re)
    # Initialize an empty array to store all data
    all_data = Float64[]

    for file in list_of_files
        # Construct the full path to the file
        localpath = @__DIR__
        filepath = joinpath(localpath, file)

        # Extract the file name without the extension
        file_label = splitext(basename(file))[1]
        file_label = replace(file_label, r"naca(\d+)" => s -> "NACA " * match(r"\d+", s).match)

        # Extract the thickness from the filename
        camber = parse(Float64, string(file_label[6]))
        thickness = parse(Float64, file_label[end-1:end])

        # Declare variables as local
        local x, y
        # read airfoil coordinates from a file
        x, y = open(filepath, "r") do f
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
        Xfoil.set_coordinates(x, y)

        # Declare variables as local
        local c_l, c_d, c_dp, c_m, converged
        c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=100, zeroinit=false, printdata=false, reinit=true)
        
        # Combine the data into a matrix and add the thickness column
        data = hcat(alpha, c_l, c_d, c_dp, c_m, converged, fill(camber, length(alpha)), fill(thickness, length(alpha)))

        # Append the data to the all_data array
        if isempty(all_data)
            all_data = data
        else
            all_data = vcat(all_data, data)
        end
    end

    return all_data
end

function main()
    localpath = @__DIR__
    cd(localpath)

    flat_files = ["naca0009.dat", "naca0012.dat", "naca0015.dat", "naca0018.dat"]
    all_files = ["naca0012.dat", "naca0015.dat", "naca0018.dat", "naca2412.dat", "naca2415.dat", "naca2418.dat", "naca4412.dat", "naca4415.dat", "naca4418.dat"]
    camber_files = ["naca0012.dat", "naca2412.dat", "naca4412.dat"]
    one_file = ["naca2412.dat"]
    alpha = -5:2:15 # range of angle of attacks, in degrees
    re = 1e5

    # Process the list of files and get the combined data
    combined_data = process_files(flat_files, alpha, re)

    # Write the combined data to a file
    writedlm("xfoil_results_combined.csv", combined_data, ',')

    # Plot the data
    # plot(alpha, combined_data[:, 2], xlabel="Angle of Attack", ylabel="Coefficient of Drag", linewidth=2, legend=:topleft, label="XFoil")
    # scatter!(alpha, combined_data[:, 2], label="XFoil Data", color=:red, markersize=8, legend=:topleft)

    println("Finished script, good job!")
end

# main()