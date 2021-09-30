% Storage

% read in excel file with reservoir characteristics
pathname='.\res\'; %this is a path to my copy of the data
filename1 = 'SampleDamData';
ST = readtable([pathname filename1]);

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

tr = ST.Qtarget;
% [300; 30; 100; 800; 350; 600; 550; 70; 250; 650; 1000]


% Create loop to plot FDC for each reservoir in a subplot
figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 0.70]) %,'outerposition',[0 0 1 1]
for k = 1:numel(fnames);
    filename=fnames{k}; %this is the name of a data file
    T = readtable([pathname filename]);
    
    loc_label = legend_str{k}; % location label

    % Define OBSERVED values
    Q = T.outflow; % outflow, m3/s
    S = T.storage; % m3
    month = T.month;
    
    % LOOK AT ONLY CALIBRATION DATA
    portion = 0.60;
    idx = round(numel(Q)*portion);
    Q = Q(1:idx);
    S = S(1:idx);
    month = month(1:idx);

    % Create idx vector where 1 indicates wet season and 2 indicates dry
    idx = dryseasonidx(ST.ds_s(k), ST.ds_e(k), month);
    % select dry season storage and flows
    dry = find(idx == 2); % location of dry season
    Sdry = S(dry); Qdry = Q(dry); % selection
    % same thing for wet
    wet = find(idx ==1);
    Swet = S(wet); Qwet = Q(wet);

    
    % plot discharge vs. storage
    subplot(3,4,k)
    scatter(Sdry,Qdry,'MarkerEdgeColor', [0.9290 0.6940 0.1250])
    hold on
    scatter(Swet,Qwet,'MarkerEdgeColor',[0.4660 0.6740 0.1880])
    yline(tr(k))
%     legend('Wet Season', 'Dry Season')
% 
%     xlabel('Storage')
%     ylabel('Outflow (m^3/s)')
    title(loc_label)
    
    if k == 1
        ylabel('Outflow (m^3/s)')
    elseif k == 5
        ylabel('Outflow (m^3/s)')
    elseif k == 9
        ylabel('Outflow (m^3/s)')
        xlabel('Storage')
    elseif k == 10
         xlabel('Storage')
    elseif k == 11
         xlabel('Storage')
    elseif k == 8
         xlabel('Storage')
    end
end

subplot(3,4,12)

scatter(3,0,'MarkerEdgeColor', [224, 161, 4]/255)
hold on
scatter(3,0,'MarkerEdgeColor',[73, 117, 13]/255)
xline(3)
xlim([0 1])
axis off
l = legend('Dry Season','Wet Season','Identified Target Release','Location','northwest')

set(l,'FontSize',10);