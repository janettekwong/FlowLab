# FlowLab – Airfoil Simulation and Optimization (Winter 2025)

This repository documents my Winter 2025 research project exploring airfoil simulation, analysis, and optimization using both traditional and modern machine learning tools.

## Project Overview

This project began with learning the fundamentals of XFOIL, a classic tool for airfoil analysis, and progressed to experiments with Neural Foil, a neural network-based airfoil simulator. I implemented an airfoil optimization workflow using Neural Foil and ultimately explored developing my own predictive model using symbolic regression.

## Goals

- Gain hands-on experience with XFOIL for traditional airfoil analysis.
- Experiment with Neural Foil to test its capabilities and limitations.
- Develop an airfoil optimization pipeline using Neural Foil.
- Explore symbolic regression as a method for aerodynamic modeling.

## Key Learnings & Milestones

### 1. XFOIL Exploration
- Installed and ran XFOIL locally.
- Automated XFOIL simulations and parameter sweeps using Julia scripts.
- Parsed and visualized XFOIL output data in Julia.
- Learned to interpret XFOIL results and debug common issues.
- Built foundational knowledge of aerodynamic analysis and airfoil performance metrics.

### 2. Neural Foil Experiments
- Tested Neural Foil’s accuracy and speed compared to XFOIL.
- Explored the kinds of airfoils and parameter ranges where Neural Foil performs best (and where it struggles).
- Identified practical limitations and ideal use cases for Neural Foil in research workflows.

### 3. Airfoil Optimization Pipeline
- Created an automated optimization loop using Neural Foil as a fast surrogate model.
- Compared optimization results with those from traditional XFOIL-based approaches.
- Visualized and analyzed the tradeoffs between model speed and accuracy in the optimization context.

### 4. Symbolic Regression Modeling
- Attempted to fit my own model for airfoil performance using symbolic regression.
- Evaluated the strengths and weaknesses of symbolic regression compared to neural network models.
- Reflected on the interpretability and practical value of symbolic models in aerodynamic design.

## Technologies & Tools

- **Julia** – Main scripting language (automation, data processing, visualization)
- **XFOIL** – Traditional airfoil analysis tool
- **Neural Foil** – Machine learning-based airfoil simulator
- **PyTorch** – Deep learning framework used for model development

## References

- [XFOIL Documentation](https://web.mit.edu/drela/Public/web/xfoil/)
- [Peter Sharpe's Neural Foil page](https://github.com/peterdsharpe/NeuralFoil/tree/master)

## Acknowledgments

- Special thanks to my research mentor Adam Cardoza and my professor Dr. Andrew Ning.

---

Feel free to use or adapt any scripts and workflows from this repository for your own aerodynamic research!
