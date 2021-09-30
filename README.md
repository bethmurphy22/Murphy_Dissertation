# Murphy_Dissertation

% All .csv and .xlsx files were stored in a subfolder called res, so the pathname was always set to '.\res\' when loading data

% series of files to simulate a reservoir according to an optimized operating policy

Three operating policy functions developed
with corresponding functions that transform the variables
and are implemented in their own matlab workflow file

To elaborate:
- The lake_linear.m is the linear operating policy, which is transformed using lake_linear_transform
      - Both are implemented in SingleObjective_Lake_Linear workflow

- The op_piecewise_linear.m is the piecewise operating policy, which is transformed using op_piecewise_linear_transform
      - Both are implemented in SingleObjective_piecewise workflow

- op_piecewise_linear.m is also implemented into the SingleObjective_withOptQtarget workflow, but is transformed using op_piecewise_linear_transform_optQ

** Looking back on this, it would probably make more sense to consolidate the workflows into one file and implement cases for each 

% policy paramaters are optimized for a wet and dry season using MATLAB's genetic algorithm and NSE as an objective function

% Several functions included to plot results
plot_figures_comb_res --> observed and simulated outflow vs. time, and dry/wet season residuals vs. storage 
... also calculates the calibration and validation goodness of fit measures

plot_sim_with_obs --> observed and simulated flows vs. time, and observed and simulated storage vs. time

vis_op_policy --> simulated release vs. storage, visualizes operating policy for each season and shows calibration and dry season releases


