function [I, S, Q, env_min, e, Qtarget, month, idx, s_max, s_min, s0, delta,QtargetDRY] = resizeinputs(portion, k, datatype)

% portion is the fraction of data being used for calibration 
% k is the number corresponding to the reservoir being simulated
% datatype specifies if data is being sized for:
    % 'calibration' (first portion of data)
    % 'validation' (the remaining data)
    % 'all' (entire dataset)
    
% defines all of the reservoir characteristic variables (s_max, s_min, s0, delta)
% and defines variables needed in Workflow 2 that have to match the size of
% the calibration length

% create ordered list of reservoir files
fnames = {'AndijanCA_10day'; 'BullLakeUSA_01day'; 'CanyonFerryUSA_01day';...
    'ChardaraCA_10day'; 'CharvakCA_10day'; 'KayrakkumCA_10day'; 'NurekCA_10day';...
    'SeminoeUSA_01day'; 'ToktogulCA_10day'; 'TuyenQuangVN_01day';...
    'TyuyamuyunCA_10day'};

% load in reservoir data
pathname='.\res\'; %this is a path to my copy of the data
filename = fnames{k}; % k will specify which reservoir data to load
T = readtable([pathname filename]);

% load in the sample dam data with all reservoir characteristics
filename1 = 'SampleDamData';
ST = readtable([pathname filename1]); % kth row will refer to the reservoir

% Define initial variables
I = T.inflow;
S = T.storage;
Q = T.outflow;

month = T.month;

% define characteristics that are not vectors
s_max = ST.Smax(k); % from GRAND (or another source if GRAND was incorrect)
delta = ST.delta(k); % sec/period

s_min = 0; % Assumed, but replace with other value if info is known
s0 = S(1); % set initial storage equal to the initial observed storage

% Define the index to specify vector length
index = round(numel(I)*portion);

% Define variables based on data type
if strcmp(datatype,'calibration') == 1
    I = I(1:index);
    S = S(1:index);
    Q = Q(1:index);
    month = month(1:index);
elseif strcmp(datatype,'validation') == 1
    I = I(index:end);
    S = S(index:end);
    Q = Q(index:end);
    month = month(index:end);
elseif strcmp(datatype, 'all') == 1
    I = I(1:end);
    S = S(1:end);
    Q = Q(1:end);
    month = month(1:end);
else
    error('Must specify calibration, validation or all for third input');
end

idx = dryseasonidx(ST.ds_s(k), ST.ds_e(k), month); % identify if data is in dry or wet season

env_min = zeros(length(I),1); % m3/s, ASSUMPTION
e = zeros(length(I),1); % evaporation m/s, ASSUMPTION

% k pulls the target flow corresponding to the selected reservoir
Qtarget = ST.Qtarget(k);   %(ST.Qtarget(k))*ones(length(I),1);

QtargetDRY = ST.QtargetDRY(k); % if specified
    
    
    