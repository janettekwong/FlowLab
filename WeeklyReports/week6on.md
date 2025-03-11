# Wednesday, Feb 12
Today I learned how to set up Xfoil and the surrogate. I want to grab the data in xfoil.jl and make a big dataset. I will use writedlmx(array, filename) to get a file out. Then I'll use neuralfoil in python to create the surrogate.

# Thursday, Feb 13
Today I fixed project 1. I added the error plots and read over it again. I also got the drag surrogate plot up.

# Friday, Feb 14
Meeting Notes:
- Get the 3dplots from thickness vs alpha to Cl, then add camber and make manifold plot
- Run XF, NF, and KRG in one file
- Fix Project 1 (especiallly the drag P after Adam gives feedback)

I need to learn how to get pxlight and do xfoil in python. I have the drag surrogate plot but I need to choose the right number of alpha points and the range to do it over.

# Tuesday, Feb 18
Today I completed all the 2d plots creating surrogate models for lift, drag and moment just off of angle of attack. I tried to use juliacall to call write_xfoil.jl directly into surrogate.py so I can change which airfoils I'm comparing simultaneously but it's a bit stuck. I did add camber and thickness to the data.

Next time I'm going to try to get it all connected. I'll start by running surrogate.py and reading the error codes.

# Wednesday, Feb 19
Today I finished incorporating write_xfoil.jl into surrogate.py. I can plot it in 2d but I'm having problems moving it to 3d

# Friday, Feb 21
Got the 3d plots for camber.

# Monday, Feb 24
Meeting notes: 
- Get thickness plots.
- Start learning Neural foil.
- Make pros and cons list for Kriging vs Neuralfoil
    - how well does it interpolate?
    - extrapolate?
    - what is the source material - why?
    - where does it break?
        - does kriging have a smoother alpha than Xfoil after stall?
        - c0 continuous: no jump discontinuity
        - c1 continuous: no sharp turns, first derivative is continuous
        - cn continuous: no derivatives are discontinuous

        - check to see if the curves are c1 continuous. Then an gradient based optimizer will work.
        - check this visually to see if there are any sharp turns

        - is NeuralFoil c1 continuous?

![Image 1](C:/Users/wongj_rl8z6/ME595R/NeuralFoilFigures/Lift_camber_3d)

# Tuesday, Feb 25
Meeting, look into what optimization you want to do

# Thursday, Feb 27
Tried adding more customization by using get_aero_from_coords.
It's working worse but idk if it's because I used AI to generate the coordinates.

# Friday, Feb 28
Used previous julia functions and translated them to python in order to confirm coordinates.
Still works bad with NeuralFoil.
Conclusion, NeuralFoil has a big weakness with coordinate entry. However it did fine with the dat file.

Things to look into next:
What if you just converted the dat file to coordinates? Would it still be bad? 
    If so, its a problem with the function.
    If not, then it's probably a problem with how I make my coordinates.

What about the kriging model? How would it do if I input coordinates? Better than NeuralFoil?

# Saturday, March 1
Plotted error for different model sizes with the coordinates method of NeuralFoil. None of them seem good enough when compared to the .dat files or "naca####". 
Need to compare kriging model.

# Thursday, March 6
Trying kulfan parameters instead. Almost to plotting a custom one.
Meeting with Adam:
    - find weaknesses in NF
    - make a small dataset and run kriging on it as a neural network and compare it to neuralfoil
    - fix the coordinate function

