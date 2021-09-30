% This script visualizes the observed inflow, outflow and storage of each
% reservoir
% Purpose = data can be analyzed to conceptually understand the reservoir's
% operation (target releases and maximum storage)
% Written by Bethany Murphy July 19, 2021

% Set pathname for all reservoir data
pathname='.\res\'; %this is a path to my copy of the data

% Create vector of reservoir filenames ( to be looped through)
fnames = {'AndijanCA_10day'; 'BullLakeUSA_01day'; 'CanyonFerryUSA_01day';...
    'ChardaraCA_10day'; 'CharvakCA_10day'; 'KayrakkumCA_10day'; 'NurekCA_10day';...
    'SeminoeUSA_01day'; 'ToktogulCA_10day'; 'TuyenQuangVN_01day';...
    'TyuyamuyunCA_10day'};

% Create vector of reservoir names for titles
legend_str = {'Andijan, Uzbekistan';'Bull Lake, USA';'Canyon Ferry, USA';...
    'Chardara, Kazakstan'; 'Charvak, Uzbekistan';'Kayrakkum, Tajikistan';...
    'Nurek, Tajikistan';'Seminoe, USA';'Toktogul, Kyrgysztan';...
    'Tuyen Quang, Vietnam';'Tyuyamuyun, Turkmenistan'};

% create vector of secondary uses for each reservoir
sec_uses = {'Irrigation'; 'Recreation, Fisheries & Flood Control'; ...
    'Irrigation, Water Supply & Flood Control, Recreation'; 'Hydroelectricity'; 'Irrigation';...
    'Irrigation'; 'Hydroelectricity'; 'Hydroelectricity & Recreation'; ...
    'Irrigation'; 'Flood Control'; 'Hydroelectricity & Water Supply'};

% read in the Coerver GRAND Data (containing characteristics for each
% reservoir) --> BUT DOES NOT INCLUDE TYUYAMUYUN
pathname='.\res\'; %this is a path to my copy of the data
filename='GRAND_Data'; %this is the name of a data file
G = readtable([pathname filename]);

% Create vectors for main uses and maximum capacity(pull from GRAND)
main_uses = G.(49); % main use stored in 49th column
main_uses{11} = 'Irrigation'; % add data for Tyuyamuyun reservoir
main_uses{4} = 'Irrigation'; % add data for Chardara
s_max = G.mcmcap; % store maximum capacity
s_max(11) = 6700; % add blank data for Tyuyamuyun reservoir

% Visualize Target Release
filename='Test_Qtarget'; %this is the name of a data file
Test = readtable([pathname filename]);
Qtarg_spec = Test.(1);
QtargW_opt = Test.(2);
QtargD_opt = Test.(3);


% % loop through the reservoir files and plot the data
% for k = 1:numel(fnames)
%     filename=fnames{k}; %this is the name of a data file
%     T = readtable([pathname filename]); % read in data for each reservoir
%     
%     loc_label = legend_str{k}; % location label
% 
%     % Define OBSERVED values
%     I = T.inflow; % inflow, m3/s
%     Q = T.outflow; % outflow, m3/s
%     S = T.storage; % storage, m3
%     
%     % Create x ticks and time labels to customise the plot
%     yearidx = find(T.month == 1 & T.date == 1); % Find every January 1st --> may not work for 10 day series
%     xtick_time = yearidx; % Tick mark for every time the year starts
%     label_time = {T.year(xtick_time)} ;
% 
%     % Create figure
%     figure 
%     
%     % define linewidth
%     lw = 1;
% 
%     % Plot inflows and outflows
%     subplot(211)
%     ax1 = gca;
%     plot(I     ,'LineWidth',lw)
%     hold on
%     plot(Q      ,'LineWidth',lw)
%     ylabel('Flow (m^3/s)')
%     legend('Inflow','Outflow')
%     set(ax1,'XTick',xtick_time,'XTickLabel',label_time)
%    
%     % Title specifies reservoir name and location
%     title(['Observed Data for ' loc_label])
%    
%     % Include the uses in the subtitles
%     subtitle({['Main Use = ' main_uses{k}], ['Secondary Use = ' sec_uses{k}]})
% 
%     % Plot storage
%     subplot(212)
%     ax2 = gca;
%     plot(S,'k','LineWidth',lw)
%     
%     if s_max(k) == -99
%     else
%         yline(s_max(k)*10^6,'--','GraND Max Capacity')
%     end
% 
%     ylabel('Storage (m^3)')
%     set(ax2,'XTick',xtick_time,'XTickLabel',label_time)
% 
% 
%     linkaxes([ax1 ax2],'x') % so axes can zoom in together
% end


figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])
% loop through the reservoir files and plot the data
for k = 1:numel(fnames)
    filename=fnames{k}; %this is the name of a data file
    T = readtable([pathname filename]); % read in data for each reservoir
    
    loc_label = legend_str{k}; % location label

    % Define OBSERVED values
    I = T.inflow; % inflow, m3/s
    Q = T.outflow; % outflow, m3/s
    S = T.storage; % storage, m3
    
    % Create x ticks and time labels to customise the plot
    yearidx = find(T.month == 1 & T.date == 1); % Find every January 1st --> may not work for 10 day series
    xtick_time = yearidx; % Tick mark for every time the year starts
    
    xtick_time = xtick_time(1:2:end); % every other year
    label_time = {T.year(xtick_time)} ;

    % Specify subplot
    subplot(3,4,k) 
    
    % define linewidth
    lw = 1;

    % Plot inflows and outflows
    ax1 = gca;
    plot(I     ,'LineWidth',lw, 'color',[215,25,28]/255)
    hold on
    plot(Q      ,'LineWidth',lw, 'color',[18, 9, 133]/255)

%     ylabel('Flow (m^3/s)')
    set(ax1,'XTick',xtick_time,'XTickLabel',label_time)
    
    % plot the target releases
%     yline(Qtarg_spec(k),'-.k', 'LineWidth', lw)
%     yline(QtargW_opt(k),'-.b','LineWidth', lw) 
%     yline(QtargD_opt(k), '-.g','LineWidth', lw)
   
    % Title specifies reservoir name and location
    title(loc_label)
    xlim([0 numel(I)])
   
   
    if k == 1
        ylabel('Flow (m^3/s)')
    elseif k == 5
        ylabel('Flow (m^3/s)')
    elseif k == 9
        ylabel('Flow (m^3/s)')
%         xlabel('Exceedance Probability')
%     elseif k == 10
% %         xlabel('Exceedance Probability')
%     elseif k == 11
% %         xlabel('Exceedance Probability')
%     elseif k == 8
%         xlabel('Exceedance Probability')
    end
    
end

% k = 11;
% filename=fnames{k}; %this is the name of a data file
% T = readtable([pathname filename]); % read in data for each reservoir
% 
% loc_label = legend_str{k}; % location label
% 
% % Define OBSERVED values
% I = T.inflow; % inflow, m3/s
% Q = T.outflow; % outflow, m3/s
% S = T.storage; % storage, m3
% 
% % Create x ticks and time labels to customise the plot
% yearidx = find(T.month == 1 & T.date == 1); % Find every January 1st --> may not work for 10 day series
% xtick_time = yearidx; % Tick mark for every time the year starts
% 
% xtick_time = xtick_time(1:2:end); % every other year
% label_time = {T.year(xtick_time)} ;
% 
% % Specify subplot
% subplot(4,3,k)
% 
% % define linewidth
% lw = 1;
% 
% % Plot inflows and outflows
% ax1 = gca;
% plot(I     ,'LineWidth',lw, 'color',[215,25,28]/255)
% hold on
% plot(Q      ,'LineWidth',lw, 'color',[18, 9, 133]/255)
% 
% %     ylabel('Flow (m^3/s)')
% set(ax1,'XTick',xtick_time,'XTickLabel',label_time)
% 
% % plot the target releases
% %     yline(Qtarg_spec(k),'-.k', 'LineWidth', lw)
% %     yline(QtargW_opt(k),'-.b','LineWidth', lw)
% %     yline(QtargD_opt(k), '-.g','LineWidth', lw)
% 
% % Title specifies reservoir name and location
% title(loc_label)
% xlim([0 numel(I)])


subplot(3,4,12)
plot(0,0     ,'LineWidth',lw, 'color',[215,25,28]/255)
hold on
plot(0,0      ,'LineWidth',lw, 'color',[18, 9, 133]/255)
% yline(1,'-.k', 'LineWidth', lw)
% yline(2,'-.b','LineWidth', lw) 
% yline(3, '-.g','LineWidth', lw)
axis off
l = legend('Inflow','Outflow','Location','northwest')
set(l,'FontSize',10);
