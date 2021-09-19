function [z] = vis_op_policy(s_max, wetp, dryp, operating_rule, op_name, k, s, Qreg, idx, I, delta, Qspill)

% s_max used to create storage paramater
% operating rule and wet/dry paramaters are used to fill in the function
% values
% k specifies the reservoir for title
% op_name for title

% % % s and Qreg are simulated storage and release for ALL data
% % % ** FUNCTION SHOULD BE CALLED AFTER SIMULATION IS REPEATED FOR ALL DATA*
% vis_op_policy( s_max, wetp, dryp, operating_rule, op_name, k, s, Qreg, idx)

% s and Qreg are simulated storage and release for calibration data
% s1 and Qreg1 are simulated storage and release for validation data
% idx and idx1 are wet and dry season identification for calibration and
% validation data respectively

% Calculate Qsim which includes regulated release and spill
Qsim = Qreg + Qspill;

% specify reservoir names
legend_str = {'Andijan, Uzbekistan';'Bull Lake, USA';'Canyon Ferry, USA';...
    'Chardara, Kazakstan'; 'Charvak, Uzbekistan';'Kayrakkum, Tajikistan';...
    'Nurek, Tajikistan';'Seminoe, USA';'Toktogul, Kyrgysztan';...
    'Tuyen Quang, Vietnam';'Tyuyamuyun, Turkmenistan'};

% new storage paramater where we account for the inflow 
% to plot against the simulated releases
snew = zeros(1, numel(I));

for i = 1:numel(snew)
    snew(i) = s(i) + I(i)*delta; 
end


% create visual for operating policy
s_test = [0:0.3*10^6:s_max]; %max(max(snew),s_max)
u_testw = zeros(1,numel(s_test));
u_testd = zeros(1,numel(s_test));

% simulate releases according to operating policy
for i=1:numel(s_test)
    u_testw(i) = feval(operating_rule,s_test(i),wetp) ; % (m3/s)
    u_testd(i) = feval(operating_rule,s_test(i),dryp) ; % (m3/s)
end

% Create scatter plot series of simulated storages and releases
dryseason = idx == 2; % index for dry season
wetseason = idx == 1; % index for wet season

sdry = snew(dryseason); Qregdry = Qreg(dryseason);
swet = snew(wetseason); Qregwet = Qreg(wetseason);


%% separate calibration and validation plot
separation = round(0.60*numel(Qreg));

% Calibration
snew_cal = snew(1:separation); 
Qsim_cal = Qsim(1:separation);
idx_cal = idx(1:separation);

% sort according to storage
[snew_cal, sort_idx] = sort(snew_cal);
% redefine Qsim and idx to be sorted in same way
Qsim_cal = Qsim_cal(sort_idx);
idx_cal = idx_cal(sort_idx);

% Validation
snew_val = snew(separation:end); 
Qsim_val = Qsim(separation:end);
idx_val = idx(separation:end);

% sort according to storage
[snew_val, sort_idx] = sort(snew_val);
% redefine Qsim and idx to be sorted in same way
Qsim_val = Qsim_val(sort_idx);
idx_val = idx_val(sort_idx);

%% Breakdown by dry and wet seasons
% In calibration period
dryseason_cal = idx_cal == 2; % index for dry season
wetseason_cal = idx_cal == 1; % index for wet season
% In validation period
dryseason_val = idx_val == 2; % index for dry season
wetseason_val = idx_val == 1; % index for wet season

% Calibration
snew_cal_dry = snew_cal(dryseason_cal); 
snew_cal_wet = snew_cal(wetseason_cal);

Qsim_cal_dry = Qsim_cal(dryseason_cal);
Qsim_cal_wet = Qsim_cal(wetseason_cal);

% Validation
snew_val_dry = snew_val(dryseason_val);
snew_val_wet = snew_val(wetseason_val);

Qsim_val_dry = Qsim_val(dryseason_val);
Qsim_val_wet = Qsim_val(wetseason_val);


%% Select points
% There are too many points to show all of them
z = round(numel(Qreg)/100); % interval for point selection


% select every other z available storage and simulated flow values
% Dry Season Calibration
snew_cal_dry1 = snew_cal_dry(1:z:end);
Qsim_cal_dry1 = Qsim_cal_dry(1:z:end);

% want to make sure that this captures the maximum storage value
if snew_cal_dry1(end) == snew_cal_dry(end) % check if it captures the max storage
else % if it doesn't, manually include it
    snew_cal_dry1 = [snew_cal_dry1, snew_cal_dry(end)];
    Qsim_cal_dry1 = [Qsim_cal_dry1; Qsim_cal_dry(end)];
end

% Wet Season Calibration
snew_cal_wet1 = snew_cal_wet(1:z:end);
Qsim_cal_wet1 = Qsim_cal_wet(1:z:end);

% want to make sure that this captures the maximum storage value
if snew_cal_wet1(end) == snew_cal_wet(end)
else
    snew_cal_wet1 = [snew_cal_wet1, snew_cal_wet(end)];
    Qsim_cal_wet1 = [Qsim_cal_wet1; Qsim_cal_wet(end)];
end

% Dry Season Validation
snew_val_dry1 = snew_val_dry(1:z:end);
Qsim_val_dry1 = Qsim_val_dry(1:z:end);

% want to make sure that this captures the maximum storage value
if snew_val_dry1(end) == snew_val_dry(end)
else
    snew_val_dry1 = [snew_val_dry1, snew_val_dry(end)];
    Qsim_val_dry1 = [Qsim_val_dry1; Qsim_val_dry(end)];
end

% Wet Season Validation
snew_val_wet1 = snew_val_wet(1:z:end);
Qsim_val_wet1 = Qsim_val_wet(1:z:end);

% want to make sure that this captures the maximum storage value
if snew_val_wet1(end) == snew_val_wet(end)
else
    snew_val_wet1 = [snew_val_wet1, snew_val_wet(end)];
    Qsim_val_wet1 = [Qsim_val_wet1; Qsim_val_wet(end)];
end


lw = 3;
sz = 70;
big = 70;

figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 0.70]) %,'outerposition',[0 0 1 1]
% Plot the policy
plot(s_test,u_testd,'LineWidth', lw,'color',[0.9290 0.6940 0.1250]); hold on; % policy
plot(s_test,u_testw,'LineWidth', lw,'color',[0.4660 0.6740 0.1880]); % wet policy


% Plot Calibration simulated releases
scatter(snew_cal_dry1, Qsim_cal_dry1,big,'h','filled','MarkerFaceColor',[250, 229, 177]/255,'MarkerEdgeColor','k','LineWidth', 0.7) % cal dry ,'MarkerEdgeColor', [0.9290 0.6940 0.1250]
hold on
scatter(snew_cal_wet1,Qsim_cal_wet1,big,'h','filled','MarkerFaceColor',[194, 214, 167]/255,'MarkerEdgeColor','k','LineWidth', 0.7) % cal wet

% Plot Validation Simulated releases
scatter(snew_val_dry1, Qsim_val_dry1,sz,'d','MarkerEdgeColor', [224, 161, 4]/255,'LineWidth', 1) % val dry
scatter(snew_val_wet1,Qsim_val_wet1,sz,'d','MarkerEdgeColor',[73, 117, 13]/255,'LineWidth', 1) % val wet
check = numel(snew_cal_dry1) + numel(snew_val_dry1) + numel(snew_cal_wet1) + numel(snew_val_wet1)


% Max storage
xline(s_max)
% scatter(snew(3865), 200,sz,'k', '*') % error

% plot limits
max_xval = max(s_max, max(snew));
max_xval = max_xval + 0.05*max_xval;


max_yval = max(Qsim);
if max_yval < 200;
    max_yval = max_yval + 0.5*max_yval;
else
    max_yval = max_yval + 0.05*max_yval;
end

xlim([0 max_xval])
ylim([0 max_yval])

l = legend('Dry Season Policy','Wet Season Policy','Dry Season Calibration Simulation', 'Wet Season Calibration Simulation'...
    , 'Dry Season Validation Simulation', 'Wet Season Validation Simulation',...
    'Maximum Storage', 'Manually Adjusted Release', 'Location', 'eastoutside')

set(l,'FontSize',10);

xlabel('Available Storage (m^3/s)'); ylabel('Flow (m^3/s)')
title(append(legend_str{k}, ': ', op_name))
% subtitle(['Every ' num2str(z) ' data values are displayed'])


