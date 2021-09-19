%% Set up
% Testing the Piecewise Linear Operating Policy
% Optimizing policy paramaters using NSE as an objective to be maximized
% USING A SINGLE-OBJECTIVE OPTIMIZATION - genetic algorithm in MATLAB

% Create vector of reservoir names for titles and to loop through
legend_str = {'Andijan, Uzbekistan';'Bull Lake, USA';'Canyon Ferry, USA';...
    'Chardara, Kazakstan'; 'Charvak, Uzbekistan';'Kayrakkum, Tajikistan';...
    'Nurek, Tajikistan';'Seminoe, USA';'Toktogul, Kyrgysztan';...
    'Tuyen Quang, Vietnam';'Tyuyamuyun, Turkmenistan'};

% Create vector of names for saved figure filenames
figname_str = {'Andijan'; 'Bull'; 'Canyon'; 'Chardara'; 'Charvak'; 'Kayrakkum';...
    'Nurek'; 'Seminoe'; 'Toktogul'; 'Tuyen'; 'Tyuyamuyun'};

% Define portion of data for calibration 
portion = 0.60; % Coerver et al. used 60% of the data

% specify operating rule
operating_rule = 'op_piecewise_linear'; % name of operating policy function
op_name = 'Piecewise Linear Operating Policy'; % for graph titles

% Create variables where information of interest will be stored
% 1st column = validation, 2nd Column = calibration
nse = zeros(11,2); % Nash-Sutcliffe Efficiency
kge = zeros(11,2); % Kling Gupta Efficiency
mae = zeros(11,2); % Mean Absolute Error

zval = zeros(11,1); % # of points hidden in the visualized operating policy

wetparams = zeros(11,6); % optimized wet season policy paramaters
dryparams = zeros(11,6); % optimized dry season policy paramaters


dryparamCHECK = zeros(11,6); 
wetparamCHECK = zeros(11,6);

loop = 5; % specify the reservoir being simulated (1:11 if all)

for k = loop    %% Calibration
    % define datatype so we call the correct portion of data
    datatype = 'calibration'; 
    
    % Define OBSERVED values
    [I, S, Q, env_min, e, Qtarget, month, idx, s_max, s_min, s0, delta] = resizeinputs(portion, k, datatype);
    
  
    %% Run optimisation
    % Save all input data and parameters in a data struct that will be passed
    % over to the optimiser:
    sys_param.e       = e ;
    sys_param.I       = I ;
    sys_param.env_min = env_min ;
    sys_param.Qtarget = Qtarget ;
    sys_param.idx     = idx     ;
    sys_param.s0      = s0      ;
    sys_param.s_min   = s_min   ;
    sys_param.s_max   = s_max   ;
    sys_param.delta   = delta   ;
    sys_param.operating_rule = operating_rule;
    sys_param.option = 0 ; % this is a parameter to activate a specific
    sys_param.k = k;
    
    % ADD observed Q so NSE can be calculated
    sys_param.Q       = Q ;
    
    % Dry season Qtarget if applicable
% % % %     sys_param.QtargetDRY = QtargetDRY;
    
    % set-up for genetic algorithm
    % set upper and lower bounds on design variables x
        % x(1) - slope of the first linear piece (radiant)
        % x(2) - storage at which second linear piece begins (volume)
        % x(3) - slope of the second linear piece (radiant)
        % Parameters vary by two seasons (G = 2), wet and dry
        % x  = [    x1w;   x2w;   x3w ;    x1d;   x2d;    x3d ] ;
        
    lb  = [    eps;  0;    eps;   eps;  0;    eps ] ; % lower bounds
    ub  = [ pi/2.1; s_max; pi/2.1; pi/2.1; s_max; pi/2.1] ; % upper bounds

    
    % set fitness function, number of variables, number of iterations
    FITNESSFCN = @(x)evaluate_objective_single(x,sys_param);
    NVARS = numel(lb); 
    it = 5; % specified number of iterations, can be changed
    
    % Set options to see plots of stopping criteria and solutions
    opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});

    % preallocate y and fval vectors based on # iterations
    y_pos = zeros(it, NVARS);
    fval_pos = zeros(1,it);
    
    % Run optimization multiple times and select only the best to plot
    for j = 1:it
        [y_pos(j,:),fval_pos(j),exitFlag,Output] = ga(FITNESSFCN,NVARS,[],[],[],[],lb,ub,[],opts);
    end
    
    % store and find index of *MINIMUM* solution since NSE is negative
    [fval, solutionidx] = min(fval_pos);
    % select corresponding paramaters 
    y = y_pos(solutionidx, :);
    
    
    % Store wet and dry parameters to visualize operating policy later
% % %     wetparams(k,:) = [ y(1:3),delta*Qtarget,s_max,delta]; % wet 
% % %     dryparams(k,:) = [ y(4:6),delta*QtargetDRY,s_max,delta]; % dry
    wetparams(k,:) = [ y(1:3),delta*Qtarget(1),s_max,delta]; % wet 
    dryparams(k,:) = [ y(4:6),delta*Qtarget(1),s_max,delta]; % dry
    
    % Visualize operating policy and simulated releases
    wetp = wetparams(k,:); % wet 
    dryp = dryparams(k,:); % dry

    % transform variables for simulation, according to wet and dry season
% % %     Op_param_cho = op_piecewise_linear_transform(y,idx,s_max,Qtarget,delta,QtargetDRY) ;
    Op_param_cho = op_piecewise_linear_transform(y,idx,s_max,Qtarget,delta) ;
    
    % Simulate the operating policy
    [ s, Qreg, Qspill, E, SA ] = reservoir_simulation( I, e, env_min, s0, s_min, s_max, operating_rule, Op_param_cho, delta ) ;

    %% Repeat for ALL DATA 
    % Redefine variables for the WHOLE period
    datatype = 'all';
    [I3, S3, Q3, env_min3, e3, Qtarget3, month3, idx3, s_max3, s_min3, s03, delta3] = resizeinputs(portion, k, datatype);
    
    % repeat parameters for each and re-run simulation
    Op_param_cho3 =  op_piecewise_linear_transform(y,idx3,s_max3,Qtarget3,delta3) ;  
% % %     Op_param_cho3 =  op_piecewise_linear_transform(y,idx3,s_max3,Qtarget3,delta3,QtargetDRY3) ;  
    [ s3, Qreg3, Qspill3, ~, ~ ] = reservoir_simulation( I3, e3, env_min3, s03, s_min3, s_max3, operating_rule, Op_param_cho3, delta3) ;
    
    % ADD SPILLS TO REGULATED FLOWS FOR CALIBRATION AND VALIDATION PERIOD
    % For calculation of NSE/other goodness of fit measures
    if k == 4 % do nothing for Chardara b/c reported outflows do not include spills
        Qsim3 = Qreg3;
    else 
        Qsim3 = Qreg3 + Qspill3; % validation
    end
    
    [nsecal,kgecal,maecal,nseval,kgeval, maeval] = plot_figures_comb_res( S3, Qsim3, Q3, k, idx3, op_name, portion)
% %     figurename = append('./graphs/',figname_str{k}, '_PIECEWISE_sim_res', '.png'); % figure name and path
% %     saveas(gca,figurename)
    
    % CALCULATIONS FOR THE CALIBRATION PERIOD and validation period
    nse(k,1) = nsecal; % nse calibration
    kge(k,1) = kgecal; % kge calibration
    mae(k,1) = maecal; % mae calibration
    
    nse(k,2) = nseval; % nse validation
    kge(k,2) = kgeval; % kge validation
    mae(k,2) = maeval; % mae validation
    
    % Visualize results of simulation along with observed inflow, release
    % and storage
    plot_sim_with_obs( s3, S3, s_max3, I3, Q3, Qreg3, Qspill3, k, portion, op_name)
% %     figurename = append('./graphs/',figname_str{k}, '_PIECEWISE_sim_flows_store', '.png'); % figure name and path
% %     saveas(gca,figurename)
    
    % Visualize operating policy along with simulated releases
    z = vis_op_policy(s_max3, wetp, dryp, operating_rule, op_name, k, s3, Qreg3, idx3, I3, delta3, Qspill3)
% % %     figurename = append('./graphs/',figname_str{k}, '_PIECEWISE_policy', '.png'); % figure name and path
% % %     saveas(gca,figurename)
% % %     
    zval(k,1) = z;
        
    % store all relevant data into this one spot
    alldata = [wetparams, dryparams, nse, kge, mae, zval];
    
    % check that paramaters passed to simulator are some in vis_op_policy
    % Find a dry parameter row 
    dryrow = find(idx3 == 2, 1);
    wetrow = find(idx3 == 1, 1);
    
    % should be all zeros
    dryparamCHECK(k,:) = Op_param_cho(dryrow,:) - dryp;
    wetparamCHECK(k,:) = Op_param_cho(wetrow,:) - wetp;
    
end


