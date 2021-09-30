% % % Idea for identifying a target release
% % 


% read in excel file with reservoir characteristics
pathname='.\res\'; %this is a path to my copy of the data
filename1 = 'SampleDamData';
ST = readtable([pathname filename1]);

% Create vector of reservoir filenames
fnames = {'AndijanCA_10day'; 'BullLakeUSA_01day'; 'CanyonFerryUSA_01day';...
    'ChardaraCA_10day'; 'CharvakCA_10day'; 'KayrakkumCA_10day'; 'NurekCA_10day';...
    'SeminoeUSA_01day'; 'ToktogulCA_10day'; 'TuyenQuangVN_01day';...
    'TyuyamuyunCA_10day'};

filename=fnames{5}; %this is the name of a data file
T = readtable([pathname filename]);

% Define OBSERVED values
Q = T.outflow; % outflow, m3/s
S = T.storage; % m3
month = T.month;


% Create idx vector where 1 indicates wet season and 2 indicates dry
idx = dryseasonidx(ST.ds_s(5), ST.ds_e(5), month);
% select dry season storage and flows
dry = find(idx == 2); % location of dry season
Sdry = S(dry); Qdry = Q(dry); % selection
% same thing for wet
wet = find(idx ==1);
Swet = S(wet); Qwet = Q(wet);

% Define bands of 50 up to 800
band1wet = find(Qwet <= 50);
band1dry = find(Qdry <= 50);

freq_bands = zeros(2, 800/50);
freq_bands(1,1) = numel(band1wet); % wet in first column
freq_bands(1,2) = numel(band1dry); % dry in second column

figure('DefaultAxesFontSize',11)
scatter(Sdry,Qdry,'MarkerEdgeColor', [0.9290 0.6940 0.1250])
hold on
scatter(Swet,Qwet,'MarkerEdgeColor',[0.4660 0.6740 0.1880])
xlim([min(S), max(S)])


for i = 1:((800/50)-1)
    band = find(Qwet >= 50*i & Qwet <= 50*i+50) % wet season
    freq_bands(1,i+1) = numel(band); % wet season
    
    band = find(Qdry >= 50*i & Qdry <= 50*i+50) % dry season
    freq_bands(2, i+1)=numel(band); % dry season
    
    yline(50*i)
    text(max(S) + 50000000, 50*i + 25,num2str(freq_bands(1,i+1))) % wet
    text(max(S) + 140000000, 50*i + 25,num2str(freq_bands(2,i+1))) % Dry
end



% % % % Define bands of 50 up to 800
% % % band1 = find(Q <= 50);
% % % freq_bands = zeros(1, 800/50);
% % % freq_bands(1) = numel(band1);
% % % 
% % % 
% % % for i = 1:((800/50)-1)
% % %     band = find(Q >= 50*i & Q <= 50*i+50)
% % %     freq_bands(i+1) = numel(band)
% % %     yline(50*i)
% % %     text(max(S)+ 100000000, 50*i + 25,num2str(freq_bands(i+1)))
% % % end
% % % 


xlabel('Storage (m^3)')
ylabel('Flow (m^3/s)')
title('Andijan, Uzbekistan')
legend('Dry Season', 'Wet Season','location','southoutside')



