% Produce Flow Duration Curves for the Reservoirs
% Top loop produces FDCs and plots each reservoir's FDC on a separate
% subplot but in one figure
% Bottom loop plots a separate figure for each reservoir's FDC

% read a CSV time series data file for one site
pathname='.\res\'; %this is a path to my copy of the data

% Create vector of reservoir filenames
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
sec_uses = {'Irrigation'; 'Rec., Fisheries & Flood Con.'; ...
    'Irrigation, WS, Flood Con., Rec.'; 'Hydroelectricity'; 'Irrigation';...
    'Irrigation'; 'Hydroelectricity'; 'Hydroelectricity & Rec.'; ...
    'Irrigation'; 'Flood Con.'; 'Hydroelectricity & WS'};

% read in the Coerver GRAND Data (containing characteristics for each
% reservoir) --> BUT DOES NOT INCLUDE TYUYAMUYUN
pathname='.\res\'; %this is a path to my copy of the data
filename='GRAND_Data'; %this is the name of a data file
G = readtable([pathname filename]);

% Create vectors for main uses and maximum capacity(pull from GRAND)
main_uses = G.(49); % main use stored in 49th column
main_uses{11} = 'Irrigation'; % add Irrigation data for Tyuyamuyun reservoir
main_uses{4} = 'Irrigation'; % change blank data to Irrigation for Chardara


% Create loop to plot FDC for each reservoir in a subplot
figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])
for k = 1:numel(fnames)
    filename=fnames{k}; %this is the name of a data file
    T = readtable([pathname filename]);
    
    loc_label = legend_str{k}; % location label

    % Define OBSERVED values
    I = T.inflow; % inflow, m3/s
    Q = T.outflow; % outflow, m3/s

    % SORT Discharges high to low
    I = sort(I,'descend');
    Q = sort(Q,'descend');


    % Assign rank to each
    M = 1:numel(I);

    % Preallocate probability vector
    prob = zeros(numel(I),1);

    % Compute probability
    for i = 1:numel(I)
        per = M(i)/(numel(I)+1);
        prob(i,1) = 100*per;
    end

    lw = 1.5;

    % plot discharge vs. probability
    subplot(3,4,k)
    plot(prob,I,'LineWidth',lw,'color',[215,25,28]/255)
    hold on
    plot(prob,Q,'LineWidth',lw,'color',[18, 9, 133]/255)
%     xlabel('Exceedance Probability')

    if k == 1
        ylabel('Flow (m^3/s)')
    elseif k == 5
        ylabel('Flow (m^3/s)')
    elseif k == 9
        ylabel('Flow (m^3/s)')
        xlabel('Exceedance Probability')
    elseif k == 10
        xlabel('Exceedance Probability')
    elseif k == 11
        xlabel('Exceedance Probability')
    elseif k == 8
        xlabel('Exceedance Probability')
    end
    
    
    title(loc_label)
    % Include the uses in the subtitles
    subtitle({['Main Use = ' main_uses{k}], ['Sec. Use = ' sec_uses{k}]},'FontSize',10)
   
    set(gca,'XTick',[0:20:100])
   
end

subplot(3,4,12)
plot(0,0,'LineWidth',lw,'color',[215,25,28]/255)
hold on
plot(0,0,'LineWidth',lw,'color',[18, 9, 133]/255)
axis off
l = legend('Inflow','Outflow','Location','northwest')
set(l,'FontSize',10);



% Create loop to plot FDC for each reservoir in a subplot
% y-axis is logarithmic flow
figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])
for k = 1:numel(fnames)
    filename=fnames{k}; %this is the name of a data file
    T = readtable([pathname filename]);
    
    loc_label = legend_str{k}; % location label

    % Define OBSERVED values
    I = T.inflow; % inflow, m3/s
    Q = T.outflow; % outflow, m3/s
    
    
    % Make sure there are no negatives
    x = find(I >= 0);
    y = find(Q >= 0);
    
    if numel(x) ~= numel(I)
        I = I(x)
        Q = Q(x)
    end

    % SORT Discharges high to low
    I = sort(I,'descend');
    Q = sort(Q,'descend');


    % Assign rank to each
    M = 1:numel(I);

    % Preallocate probability vector
    prob = zeros(numel(I),1);

    % Compute probability
    for i = 1:numel(I)
        per = M(i)/(numel(I)+1);
        prob(i,1) = 100*per;
    end

    lw = 1.5;

    % plot discharge vs. probability
    subplot(3,4,k)
    plot(prob,log(I),'LineWidth',lw,'color',[215,25,28]/255)
    hold on
    plot(prob,log(Q),'LineWidth',lw,'color',[18, 9, 133]/255)
    
    if k == 1
        ylabel('Log(Flow) (m^3/s)')
    elseif k == 5
        ylabel('Log(Flow) (m^3/s)')
    elseif k == 9
        ylabel('Log(Flow) (m^3/s)')
        xlabel('Exceedance Probability')
    elseif k == 10
        xlabel('Exceedance Probability')
    elseif k == 11
        xlabel('Exceedance Probability')
    elseif k == 8
        xlabel('Exceedance Probability')
    end
    
    title(loc_label)
    % Include the uses in the subtitles
    subtitle({['Main Use = ' main_uses{k}], ['Sec. Use = ' sec_uses{k}]},'FontSize',10)
   
end

subplot(3,4,12)
plot(0,0,'LineWidth',lw,'color',[215,25,28]/255)
hold on
plot(0,0,'LineWidth',lw,'color',[18, 9, 133]/255)
axis off
l = legend('Inflow','Outflow','Location','northwest')
set(l,'FontSize',10);

%% Create loop to plot Storage Duration Curve for each reservoir in a subplot
figure
for k = 1:numel(fnames)
    filename=fnames{k}; %this is the name of a data file
    T = readtable([pathname filename]);
    
    loc_label = legend_str{k}; % location label

    % Define OBSERVED values
    S = T.storage;

    % SORT Discharges high to low
    S = sort(S,'descend');

    % Assign rank to each
    M = 1:numel(S);

    % Preallocate probability vector
    prob = zeros(numel(S),1);

    % Compute probability
    for i = 1:numel(S)
        per = M(i)/(numel(S)+1);
        prob(i,1) = 100*per;
    end

    lw = 1.5;

    % plot discharge vs. probability
    subplot(3,4,k)
    plot(prob,S,'k','LineWidth',lw)
%     xlabel('Exceedance Probability')

    if k == 1
        ylabel('Storage (m^3)')
    elseif k == 5
        ylabel('Storage (m^3)')
    elseif k == 9
        ylabel('Storage (m^3)')
        xlabel('Exceedance Probability')
    elseif k == 10
        xlabel('Exceedance Probability')
    elseif k == 11
        xlabel('Exceedance Probability')
    elseif k == 8
        xlabel('Exceedance Probability')
    end
    
    
    title(loc_label)
    % Include the uses in the subtitles
    subtitle({['Main Use = ' main_uses{k}], ['Sec. Use = ' sec_uses{k}]})
    set(gca,'XTick',[0:20:100])
   
end
% 
% subplot(3,4,12)
% plot(0,0,'LineWidth',lw,'color',[215,25,28]/255)
% hold on
% plot(0,0,'LineWidth',lw,'color',[18, 9, 133]/255)
% axis off
% legend('Inflow','Outflow','Location','northwest')


figure
for k = 1:numel(fnames)
    filename=fnames{k}; %this is the name of a data file
    T = readtable([pathname filename]);
    
    loc_label = legend_str{k}; % location label

    % Define OBSERVED values
    S = T.storage;

    % SORT Discharges high to low
    S = sort(S,'descend');

    % Assign rank to each
    M = 1:numel(S);

    % Preallocate probability vector
    prob = zeros(numel(S),1);

    % Compute probability
    for i = 1:numel(S)
        per = M(i)/(numel(S)+1);
        prob(i,1) = 100*per;
    end

    lw = 1.5;

    % plot discharge vs. probability
    subplot(3,4,k)
    plot(prob,log(S),'k','LineWidth',lw)
%     xlabel('Exceedance Probability')

    if k == 1
        ylabel('Log(Storage) (m^3)')
    elseif k == 5
        ylabel('Log(Storage) (m^3)')
    elseif k == 9
        ylabel('Log(Storage) (m^3)')
        xlabel('Exceedance Probability')
    elseif k == 10
        xlabel('Exceedance Probability')
    elseif k == 11
        xlabel('Exceedance Probability')
    elseif k == 8
        xlabel('Exceedance Probability')
    end
    
    
    title(loc_label)
    % Include the uses in the subtitles
    subtitle({['Main Use = ' main_uses{k}], ['Sec. Use = ' sec_uses{k}]})
    set(gca,'XTick',[0:20:100])
   
end