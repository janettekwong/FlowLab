import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from smt.surrogate_models import KRG
from juliacall import Main as jl


def read_data(file_path):
    data = pd.read_csv(
        file_path, names=["alpha", "c_l", "c_d", "c_dp", "c_m", "converged"]
    )
    print(data.head())
    return data


def create_surrogate(xt, yt):
    # sm = KRG(theta0=[1e-2])
    sm = KRG()
    sm.set_training_values(xt, yt)
    sm.train()
    return sm


def plot_surrogate(
    sm, alpha_min, alpha_max, camber_min, camber_max, xlabel="x", ylabel="y"
):
    num = 100
    alpha_range = np.linspace(alpha_min, alpha_max, num)
    camber_range = np.linspace(camber_min, camber_max, num)
    alpha_grid, camber_grid = np.meshgrid(alpha_range, camber_range)
    xt_grid = np.column_stack([alpha_grid.ravel(), camber_grid.ravel()])
    yt_grid = sm.predict_values(xt_grid).reshape(alpha_grid.shape)

    fig = plt.figure()
    ax = fig.add_subplot(111, projection="3d")
    ax.plot_surface(alpha_grid, camber_grid, yt_grid, cmap="viridis")

    ax.set_xlabel(xlabel)
    ax.set_ylabel("Camber")
    ax.set_zlabel(ylabel)
    plt.show()


if __name__ == "__main__":
    # Load the Julia file
    jl.include("c:/Users/wongj_rl8z6/FlowLab/XFoil/write_xfoil.jl")

    # Call the process_files function
    list_of_files = [
        "naca0012.dat",
        "naca2412.dat",
        "naca4412.dat",
    ]  # ["naca0009.dat", "naca0012.dat", "naca0015.dat", "naca0018.dat"]
    alpha = list(range(-5, 16, 2))  # range of angle of attacks, in degrees
    re = 1e5

    # Convert Python list to Julia array
    julia_list_of_files = jl.convert(jl.Array, list_of_files)
    julia_alpha = jl.convert(jl.Array, [float(a) for a in alpha])

    # Call the function
    combined_data = jl.process_files(julia_list_of_files, julia_alpha, re)

    # Convert the combined data to a DataFrame with explicit column names
    columns = ["alpha", "c_l", "c_d", "c_dp", "c_m", "converged", "camber", "thickness"]
    data = pd.DataFrame(combined_data, columns=columns)
    print(data.head())

    focus = "lift"  # "lift", "drag", or "moment"

    if focus == "lift":
        xt = data[["alpha", "camber"]].values
        print("xt: ", xt)
        print("xt shape: ", xt.shape)
        yt = data["c_l"].values
        xt = np.array(xt)
        yt = np.array(yt)
        label = "Lift Coefficient"
    elif focus == "drag":
        xt = data[["alpha", "camber"]].values
        yt = data["c_d"].values
        label = "Drag Coefficient"
    elif focus == "moment":
        xt = data[["alpha", "camber"]].values
        yt = data["c_m"].values
        label = "Moment Coefficient"

    alpha_min = min(alpha)
    alpha_max = max(alpha)
    camber_min = data["camber"].min()
    camber_max = data["camber"].max()

    sm = create_surrogate(xt, yt)
    plot_surrogate(
        sm,
        alpha_min=alpha_min,
        alpha_max=alpha_max,
        camber_min=camber_min,
        camber_max=camber_max,
        xlabel="Angle of Attack (degrees)",
        ylabel=label,
    )
