function [] = plot_sim_with_obs( s, S, s_max, I, Q, Qreg, Qspill, k, portion, op_name)

% WILL PLOT ALL DATA, so prior to this we should call resizeinputs.m with
% datatype specified as 'all'

% Utilizes Filled area plot by Javier Montalt Tordera (2021)
%(https://www.mathworks.com/matlabcentral/fileexchange/69652-filled-area-plot), 
% MATLAB Central File Exchange. Retrieved August 19, 2021.

% Ending plot should show:
    % Reservoir name in title
    % simulated and observed outflow 
    % simulated spills
    % simulated and observed storage
    % vertical line differentiating calibration and validation period
% *Don't show env_min or evaporation since assumed 0


% s       = time series of SIMULATED storage                           - vector (N,1)
% S       = time series of OBSERVED storage

% s_min   = minimum observed storage - scalar
% s_max   = maximum storage reported in GRaND (at which spills occur)            - scalar

% I       = time series of OBSERVED reservoir inflows                 - vector (N,1)


% Qreg    = time series of SIMULATED regulated release                 - vector (N,1)
% Qspill  = time series of SIMULATED release through spillways         - vector (N,1)
% Q = OBSERVED releases (would include spills)

% k designates the number reservoir we are plotting

% portion used to plot vertical line that separates calibration from
% validation data

% op_name specifies policy for title

% specify reservoir names for title
legend_str = {'Andijan, Uzbekistan';'Bull Lake, USA';'Canyon Ferry, USA';...
    'Chardara, Kazakstan'; 'Charvak, Uzbekistan';'Kayrakkum, Tajikistan';...
    'Nurek, Tajikistan';'Seminoe, USA';'Toktogul, Kyrgysztan';...
    'Tuyen Quang, Vietnam';'Tyuyamuyun, Turkmenistan'};

timeseries = [10; 1; 1; 10; 10;10; 10; 1; 10; 1; 10]; % 1-day or 10-day intervals


T = length(I)*timeseries(k) ; % Number of Days
int = timeseries(k);
index = round(numel(I)*portion)*int;

lw = 1.2;


% COLOR OPTIONS
    % 186, 7, 141 - magenta
    % 51, 242, 41 - bright neon-ish green
    % 18, 9, 133 - very dark blue
    % 171,217,233 - light blue
    % 44,123,182 - medium blue
    % 138, 243, 255- turqoise blue
    % 127, 217, 227 - slightly darker turquoise blue
    % 168, 137, 50 - weird orangey brown
    % 193, 94, 255 - bright purple
    % 95, 166, 217 - darkish grey blue


figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])
% plot inflow/outflow/simualted release and spill:
subplot(6,6,[1:5,7:11,13:17,19:23]); hold on; box on
h1 = shade(1:int:T, Qreg, 'FillAlpha',0.1)
plot(1:int:T, Qreg, 'LineWidth', 0.85, 'color', [158, 195, 219]/255) % overwrite the outline color of the shade
%, 'FillColor', [95, 166, 217]/255
plot(1:int:T, I      ,'LineWidth', lw, 'color',[215,25,28]/255)
plot(1:int:T, Q      ,'LineWidth', 1.4, 'color',[18, 9, 133]/255)
% % shade(1:int:T, Qreg, 1:int:T, Qspill)
h2 = shade(1:int:T, Qspill, 'k', 'FillColor', [25, 122, 191]/255,'FillAlpha',0.7)
xl = xline(index,'LineWidth',1)

ylim([0 inf])

set(gca,'XLim',[1,T])
set(gca,'Xticklabel',[]) 
ylabel('Flow (m^3/s)')

ax1 = gca;

% label the calibration and validation sections of graph
t = text(0.01, 0.96, 'Calibration', 'units', 'normalized')
t1 = text(0.61, 0.96, 'Validation', 'units', 'normalized')

t.BackgroundColor = 'w';
t1.BackgroundColor = 'w';


title(append(legend_str{k}, ': ', op_name))


% Legend in subplot to the right
subplot(6,6,[12,18])
dummyx = 3:4; dummyy = 3:4;
h1 = shade(dummyx,dummyy, 'FillAlpha',0.1)
hold on
pl1 = plot(dummyx,dummyy, 'LineWidth',lw, 'color',[215,25,28]/255)
pl2 = plot(dummyx,dummyy,'LineWidth', 1.4, 'color',[18, 9, 133]/255)
h2 = shade(dummyx,dummyy, 'k', 'FillColor', [25, 122, 191]/255,'FillAlpha',0.7)
xlim([T+1 T+2])
axis off

l = legend([pl1, pl2, h1(2), h2(2)],{'Observed Inflow', 'Observed Outflow', 'Simulated Release', 'Simulated Spill'},'Location','west') %'Calibration/Validation Divide','Location','bestoutside'set(gca,'XLim',[1,T])
set(l,'FontSize',10);

% plot storage:
% % subplot(4,4,[13:16]); hold on; box on
subplot(6,6,[25:29,31:35]); hold on; box on
pl1 = plot(1:int:T,S, 'k', 'LineWidth', 1.5)
h = shade(1:int:T,s(1:numel(I)),'-k','FillColor','black')
pl2 = plot(s_max*ones(T,1),':k','LineWidth',1)

xl = xline(index,'LineWidth',1)

y2 = s_max + 0.1*s_max;

set(gca,'XLim',[1,T])
set(gca,'YLim', [0,y2])
ylabel('Storage (m^3)')
xlabel('Time (Days)')

ax2 = gca;

% Legend in subplot to the right
subplot(6,6,[30,36])
pl3 = plot(dummyx,dummyy, 'k', 'LineWidth', 1.5)
hold on
h = shade(dummyx,dummyy,'-k','FillColor','black')
pl4 = plot(dummyx,dummyy,':k', 'LineWidth',1 )
xlim([T+1 T+2])
axis off
l = legend([pl3, h(2),pl4],{'Observed Storage', 'Simulated Storage', 'Maximum Storage'},'Location','west')
set(l,'FontSize',10);
% link axes
linkaxes([ax1, ax2], 'x')



