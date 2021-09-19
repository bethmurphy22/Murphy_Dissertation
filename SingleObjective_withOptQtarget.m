%% Set up
% Testing the Piecewise Linear Operating Policy (w/ optimized Qtarget)
% Optimizing policy paramaters using NSE as an objective to be maximized
% USING A SINGLE-OBJECTIVE OPTIMIZATION - genetic algorithm in MATLAB

% Create vector of reservoir names for titles and to loop through
legend_str = {'Andijan, Uzbekistan';'Bull Lake, USA';'Canyon Ferry, USA';...
    'Chardara, Kazakstan'; 'Charvak, Uzbekistan';'Kayrakkum, Tajikistan';...
    'Nurek, Tajikistan';'Seminoe, USA';'Toktogul, Kyrgysztan';...
    'Tuyen Quang, Vietnam';'Tyuyamuyun, Turkmenistan'};

figname_str = {'Andijan'; 'Bull'; 'Canyon'; 'Chardara'; 'Charvak'; 'Kayrakkum';...
    'Nurek'; 'Seminoe'; 'Toktogul'; 'Tuyen'; 'Tyuyamuyun'};

% Define portion of data for calibration 
portion = 0.60; % Coerver et al. used 60% of the data

% specify operating rule
operating_rule = 'op_piecewise_linear';% name of operating policy function
op_name = 'Piecewise Linear Operating Policy (w/ Optimized Qtarget)'; % for graph titles

% Create variables where information of interest will be stored
% 1st column = validation, 2nd Column = calibration
nse = zeros(11,2); % Nash-Sutcliffe Efficiency
kge = zeros(11,2); % Kling Gupta Efficiency
mae = zeros(11,2); % Mean Absolute Error

zval = zeros(11,1); % # of points hidden in the visualized operating policy

wetparams = zeros(11,6); % optimized wet season policy paramaters
dryparams = zeros(11,6); % optimized dry season policy paramaters
Qtarg = zeros(11,2); % optimized Qtarget

dryparamCHECK = zeros(11,6);
wetparamCHECK = zeros(11,6);


loop = 8; % specify the reservoir being simulated (1:11 if all)

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
    
    % set-up for genetic algorithm
    % set upper and lower bounds on design variables x
        % x(1) - slope of the first linear piece (radiant)
        % x(2) - storage at which second linear piece begins (volume)
        % x(3) - slope of the second linear piece (radiant)
        % x(4) - target release (volume)
        % Parameters vary by two seasons (G = 2), wet and dry
        % x  = [    x1w;   x2w;   x3w ;  x4w;   x1d;   x2d;    x3d; x4d ] ;
     
    Qtarg_min = quantile(Q,0.25); % 25 percent of data belows this
    Qtarg_max = quantile(Q, 0.75); % 75 percent below, 25 percent above
        
    lb  = [    eps;  0;    eps; Qtarg_min*delta;    eps;  0;    eps; min(Q)*delta ] ; % lower bounds
    ub  = [ pi/2.1; s_max; pi/2.1;  Qtarg_max*delta; pi/2.1; s_max; pi/2.1;  max(Q)*delta] ; % upper bounds
    
    % set fitness function and number of variables
    FITNESSFCN = @(x)evaluate_objective_single(x,sys_param);
    NVARS = numel(lb); 
    it = 5;  % specified number of iterations, can be changed
    
    % Set options to see plots of stopping criteria and solutions
    opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});
    
    % preallocate y and fval vectors based on # iterations
    y_pos = zeros(it, NVARS);
    fval_pos = zeros(1,it);
    
    % Run optimization multiple times and select only the best to plot
    for j = 1:it
        [y_pos(j,:),fval_pos(j),exitFlag,Output] = ga(FITNESSFCN,NVARS,[],[],[],[],lb,ub,[],opts);
    end
    
    % store and find index of *MINIMUM* solution because NSE is negative
    [fval, solutionidx] = min(fval_pos);
    % select corresponding paramaters 
    y = y_pos(solutionidx, :);
    
    
    % Store wet and dry parameters to visualize operating policy later
    wetparams(k,:) = [ y(1:4),s_max,delta]; % wet 
    dryparams(k,:) = [ y(5:8),s_max,delta]; % dry
    
    % transform variables for simulation, according to wet and dry season
    Op_param_cho = op_piecewise_linear_transform_optQ(y,idx,s_max,delta) ;
    
    
    % Simulate the operating policy
    [ s, Qreg, Qspill, E, SA ] = reservoir_simulation( I, e, env_min, s0, s_min, s_max, operating_rule, Op_param_cho, delta ) ;
    
    wetp = wetparams(k,:); % wet 
    dryp = dryparams(k,:); % dry
    
    Qtarg(k,1) = wetp(4)/delta; % wet
    Qtarg(k,2) = dryp(4)/delta; % dry
    
    % Repeat for ALL DATA
    % Redefine variables for the WHOLE period
    datatype = 'all';
    [I3, S3, Q3, env_min3, e3, Qtarget3, month3, idx3, s_max3, s_min3, s03, delta3] = resizeinputs(portion, k, datatype);
    s03 = s0;
    
    % repeat parameters for each and re-run simulation
    Op_param_cho3 = op_piecewise_linear_transform_optQ(y,idx3,s_max3,delta3);
    [ s3, Qreg3, Qspill3, ~, ~ ] = reservoir_simulation( I3, e3, env_min3, s03, s_min3, s_max3, operating_rule, Op_param_cho3, delta3 ) ;
    
    % FIND SEMINOE EXTRA HIGH FLOW
%     if k == 8
%         val= find(Qreg3 > 2000);
%         Qreg3(val) = 200; % manually set to lower value
%     end
    
    % ADD SPILLS TO REGULATED FLOWS FOR CALIBRATION AND VALIDATION PERIOD
    % For calculation of NSE
    if k == 4 % do nothing for Chardara b/c reported outflows do not include spills
        Qsim3 = Qreg3;
    else 
        Qsim3 = Qreg3 + Qspill3; % validation
    end
    
    [nsecal,kgecal,maecal,nseval,kgeval, maeval] = plot_figures_comb_res( S3, Qsim3, Q3, k, idx3, op_name, portion)
%     figurename = append('./graphs/',figname_str{k}, 'Q_OPT_PIECEWISE_sim_res', '.png'); % figure name and path
%     saveas(gca,figurename)
    
    
    % CALCULATIONS FOR THE CALIBRATION PERIOD and validation period
    nse(k,1) = nsecal; % nse calibration
    kge(k,1) = kgecal; % kge calibration
    mae(k,1) = maecal; % mae calibration
    
    nse(k,2) = nseval; % nse validation
    kge(k,2) = kgeval; % kge validation
    mae(k,2) = maeval; % mae validation
    
    % PLOT
    plot_sim_with_obs( s3, S3, s_max3, I3, Q3, Qreg3, Qspill3, k, portion,op_name)
%     figurename = append('./graphs/',figname_str{k}, 'Q_OPT_PIECEWISE_sim_flows_store', '.png'); % figure name and path
%     saveas(gca,figurename)
    
    % Visualize operating policy along with simulated releases
    z = vis_op_policy(s_max3, wetp, dryp, operating_rule, op_name, k, s3, Qreg3, idx3, I3, delta3, Qspill3)
%     figurename = append('./graphs/',figname_str{k}, 'Q_OPT_PIECEWISE_policy', '.png'); % figure name and path
%     saveas(gca,figurename)
    
    zval(k,1) = z;
    
    % store all relevant data into this one spot
    alldata = [wetparams, dryparams, Qtarg, nse, kge, mae,zval];
    
    % check that paramaters passed to simulator are some in vis_op_policy
    % Find a dry parameter row 
    dryrow = find(idx3 == 2, 1);
    wetrow = find(idx3 == 1, 1);
    
    dryparamCHECK(k,:) = Op_param_cho(dryrow,:) - dryp;
    wetparamCHECK(k,:) = Op_param_cho(wetrow,:) - wetp;

end

