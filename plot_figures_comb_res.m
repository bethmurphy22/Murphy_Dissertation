function [nsecal,kgecal,maecal,nseval,kgeval, maeval,rescal,resval] = plot_figures_comb_res( S3, Qsim3, Q3, k, idx3, operating_rule, portion)

% Create plot to visualize the simulation and calculate the goodness of fit
% measures for the calibration and validation period

% function [] = plot_figures_comb_res( S, Qsim, Q, S1, Qsim1, Q1, k, idx, idx1, operating_rule)
%
% *** NOTE ****: Qsim must be set equal to spill+ release
    % Qsim = Qreg + Qspill
    % Needs to be done before inputted into this equation
    % *** but when k = 4 (Chardara), Qsim set equal to Qreg only
    
% % S = OBSERVED storage time series (ALL DATA)
% % Qsim = simulated releases (ALL DATA)
% % Q = observed releases (ALL DATA)
    
% % S = OBSERVED storage time series (calibration)
% % Qsim = simulated releases (calibration)
% % Q = observed releases (calibration)
% % S1 = OBSERVED storage time series (validation)
% % Qsim1 = simulated releases (validation)
% % Q1 = observed releases (validation)


% k specifies the reservoir
% idx is used to distinguish between wet and dry season residuals (ALL
% DATA)
% operating_rule specifies rule
% portion used to distinguish between calibration and validation period


% specify reservoir names
legend_str = {'Andijan, Uzbekistan';'Bull Lake, USA';'Canyon Ferry, USA';...
    'Chardara, Kazakstan'; 'Charvak, Uzbekistan';'Kayrakkum, Tajikistan';...
    'Nurek, Tajikistan';'Seminoe, USA';'Toktogul, Kyrgysztan';...
    'Tuyen Quang, Vietnam';'Tyuyamuyun, Turkmenistan'};

% Location of validation period start (in reference to S,Q,Qsim,idx variables)
index = round(numel(S3)*portion);
% Location of validation period start (in reference to # days, numeric
% x-axis
timeseries = [10; 1; 1; 10; 10;10; 10; 1; 10; 1; 10]; % 1-day or 10-day intervals for each res. 

int = timeseries(k);
index_xval = index * int;

T = numel(S3)*int; % index * number of days in time series interval


figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])
lw = 1.2; % line width

% calculate goodness of fit measures
% Calibration Period
Qsimcal = Qsim3(1:index);
Qcal = Q3(1:index);


nsecal = NSE(Qsimcal',Qcal'); nse = round(nsecal,2); % NSE, rounded for graph title
kgecal = KGE(Qsimcal',Qcal'); % kge
maecal = MAE(Qsimcal',Qcal'); % mae

% Validation Period
Qsimval = Qsim3(index:end);
Qval = Q3(index:end);

nseval = NSE(Qsimval',Qval'); nse1 = round(nseval,2); % NSE, rounded for graph title
kgeval = KGE(Qsimval',Qval'); % kge
maeval = MAE(Qsimval',Qval'); % mae


%% plot simulated and observed outflows for calibration period and validation  period together

subplot(9,9,[1:8, 10:17, 19:26, 28:35]); hold on; box on;
ax1 = gca;
numel(1:int:T)
numel(Q3)
h = shade(1:int:T, Qsim3)
hold on
pl = plot(1:int:T, Q3     ,'LineWidth',lw,'color',[18, 9, 133]/255)
xline(index_xval,'LineWidth',1)

% label the calibration and validation sections of graph
t = text(0.01, 0.935, 'Calibration', 'units', 'normalized')
t1 = text(0.61, 0.935, 'Validation', 'units', 'normalized')

t.BackgroundColor = 'w';
t1.BackgroundColor = 'w';


% specify title including reservoir name and goodness of fit measures
title(append(legend_str{k}, ': ', operating_rule))
subtitle({['Calibration NSE = ' num2str(nse)], ['Validation NSE = ' num2str(nse1)]})
% legend([pl, h(2)],{'Observed Outflow','Simulated Release + Spill'},'Location', 'eastoutside')
ylabel('Flow (m^3/s)')
xlabel('Time (Days)')
xlim([1 T])

% Legend in subplot to the right
% subplot(9,8,[15,23])
subplot(9,9,[18,27])
dummyx = 3:4; dummyy = 3:4;
h1 = shade(dummyx,dummyy)
hold on
pl1 = plot(dummyx,dummyy, 'LineWidth',lw,'color',[18, 9, 133]/255)
if k == 4
    wl = plot(NaN(10,1), 'w')
end
xlim([T+1 T+2])
axis off
if k == 4
    l = legend([pl1, h1(2),wl],{'Observed Outflow', 'Simulated Release','(Without Spill)'},'Position',[0.88 0.67 0.05 0.05])
%     'Location','west') %'Calibration/Validation Divide','Location','bestoutside'set(gca,'XLim',[1,T])
else
     l = legend([pl1, h1(2)],{'Observed Outflow', 'Simulated Release + Spill'},'Position',[0.88 0.67 0.05 0.05])
     % 'Location','west') %'Calibration/Validation Divide','Location','bestoutside'set(gca,'XLim',[1,T])
end

set(l,'FontSize',10);
%% Use idx to determine dry season and wet season residuals
% idx = 1 for wet season
% idx = 2 for dry season

% select idx values corresponding to validation and calibration period
idxcal = idx3(1:index);
idxval = idx3(index:end);

Scal = S3(1:index)
Sval = S3(index:end)

check = numel(idxval) == numel(Sval);
if check ~= 1; error('validation idx does not have same number elements as validation period'); end

% calibration season idices
dryseasoncal = idxcal == 2; % index for dry season
wetseasoncal = idxcal == 1; % index for wet season

% validation season indices
dryseasonval = idxval == 2; % index for dry season
wetseasonval = idxval == 1; % index for wet season

%% Now calculate and plot calibration residuals
rescal = Qcal - Qsimcal; % res(1:index);
resval = Qval - Qsimval; % res(index:end);

% Calibration residuals
subplot(9,9,[46:49,55:58,64:67,73:76]); hold on; box on;
ax3 = gca;

scatter(Scal(dryseasoncal), rescal(dryseasoncal),'MarkerEdgeColor', [0.9290 0.6940 0.1250],'LineWidth', 0.7);
hold on
% yline(mean(res(dryseasoncal)),'color', [189, 134, 2]/255,'LineWidth', 1.4)
scatter(Scal(wetseasoncal), rescal(wetseasoncal), 'MarkerEdgeColor', [0.4660 0.6740 0.1880],'LineWidth', 0.7);
% yline(mean(res(wetseasoncal)), 'color', [83, 120, 35]/255,'LineWidth', 1.4)

title('Calibration Residuals')
ylabel('Residual (m^3/s)')
xlabel('Observed Storage (m^3)')

% legend('Dry Season', 'Wet Season')

%% Now calculate and plot validation residuals
subplot(9,9,[50:53,59:62,68:71,77:80]);  hold on; box on;

ax4 = gca;

scatter(Sval(dryseasonval), resval(dryseasonval),'MarkerEdgeColor', [0.9290 0.6940 0.1250],'LineWidth', 0.7);
hold on
% yline(mean(res1(dryseasonval)), 'color', [189, 134, 2]/255,'LineWidth', 1.4)
scatter(Sval(wetseasonval),resval(wetseasonval),'MarkerEdgeColor', [0.4660 0.6740 0.1880],'LineWidth', 0.7);
% yline(mean(res1(wetseasonval)), 'color', [83, 120, 35]/255,'LineWidth', 1.4)

title('Validation Residuals')
xlabel('Observed Storage (m^3)')

% legend('Dry Season', 'Wet Season')

% Dummy subplot for dry and wet season legend
% subplot(9,9,[59,68])
subplot(9,9,[63, 72])
scatter(dummyx,dummyy,'MarkerEdgeColor', [0.9290 0.6940 0.1250],'LineWidth', 0.7);
hold on
% yline(1, 'color', [189, 134, 2]/255,'LineWidth', 1.4)
scatter(dummyx,dummyy,'MarkerEdgeColor', [0.4660 0.6740 0.1880],'LineWidth', 0.7);
% yline(1, 'color', [83, 120, 35]/255,'LineWidth', 1.4)
axis off
xlim([T T+1])
ylim([3 4])

l = legend('Dry Season', 'Wet Season','Location','west')
set(l,'FontSize',10);

%% Title for whole plot
sgtitle(' ') 

linkaxes([ax3, ax4], 'y')
linkaxes([ax3, ax4], 'x')
set(ax4,'Yticklabel',[]) 
pos = get(ax4, 'Position');
pos(1) = pos(1) + 0.005;
set(ax4, 'Position', pos)

pos = get(ax3, 'Position');
pos(1) = pos(1) - 0.005;
set(ax3, 'Position', pos)

% ax4.FontSize = 8;
% ax3.FontSize = 8;



