% This script aims to compare the usage of Coerver Reservoirs to
% the usage of all reservoirs in the GRAND database
% Written by Bethany Murphy on July 20, 2021

% read in the Coerver GRAND Data 
pathname='.\res\'; %this is a path to my copy of the data
filename='GRAND_Data'; %this is the name of a data file
T = readtable([pathname filename]);

% read in all GRAND Data
filename= 'GRAND_Data_ALL';
T1 = readtable([pathname filename]);

x = {'Hydroelectricity';'Irrigation';'Flood Control'; ...
    'Navigation';'Recreation';'Fisheries';'Water supply';'Other'};



% preallocate vector
numALL = zeros(numel(x),1); % All GRaND 
numDAMS = zeros(numel(x),1); % COERVER DAMS

for i = 1:numel(x)
    y = strcmp(T1.MAIN_USE,x(i));
    z = sum(y);
    numALL(i) = z;
    
    y1 = strcmp(T.MAIN_USE,x(i));
    z1 = sum(y1);
    numDAMS(i) = z1;
end
    

vals = [log(numALL) log(numDAMS)]; % log scale to see

b = bar(vals);

% Display main usages in pie chart
figure
subplot(1,2,1)
idx = find(numALL==0); % find zero values
x1 = x; x1{idx} = ' '; % index by non-zero values

pie(numALL,x1)
title('All GRaND Dams')

subplot(1,2,2)
idx = find(numDAMS==0); % find zero values
x2 = x; 
for i = 1:numel(idx)
    k = idx(i)
    x2{k} = ' '; % index by non-zero values
end

pie(numDAMS,x2)
title('Sample Dams')

sgtitle('Comparison of Main Uses')

% number of dams with __ Number of secondary uses 
% 0 secondary uses, 1, 2... 7
GRAND_sec = [4864;1356;658;338;75;28;1;1];
sample_sec = [0; 7; 2; 1; 1; 0; 0; 0];

labels = {'0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'} ;


figure
subplot(1,2,1)

pie(GRAND_sec,labels)
title('All GRaND Dams')


subplot(1,2,2)

idx = find(sample_sec==0); % find zero values
labels1 = labels;
for i = 1:numel(idx)
    g = idx(i)
    labels1{g} = ' '; % index by non-zero values
end


pie(sample_sec,labels1)
title('Sample Dams')

sgtitle('Comparison of Secondary Uses')
    

%% Plot showing info about main and secondary uses
figure
subplot(2,2,1)
explode = zeros(numel(numALL),1);
explode(4) = 1; explode(6) = 1;
pie(numALL,explode,x1)
title('Main Uses: All GRaND Dams', ' ')

subplot(2,2,2)
pie(numDAMS,x2)
title('Main Uses: Sample Dams', ' ')

subplot(2,2,3)

% explode(5:7) = 1;
five_seven = GRAND_sec(6) + GRAND_sec(7) + GRAND_sec(8);
GRAND_sec1 = GRAND_sec;
GRAND_sec1(6) = five_seven;

explode = zeros(6,1);
explode(6) = 1;


labels2 = {'0'; '1'; '2'; '3'; ' 4'; '5-7   '} ;
pie(GRAND_sec1(1:6),explode, labels2)

% pie(GRAND_sec,explode,labels)
title('Number of Secondary Uses: All GRaND Dams', ' ')

labels3 = {' '; '1'; '2'; '3'; '4'; ' '} ;
subplot(2,2,4)
pie(sample_sec(1:6),labels3)
title('Number of Secondary Uses: Sample Dams', ' ')