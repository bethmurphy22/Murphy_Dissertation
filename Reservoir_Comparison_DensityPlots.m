% This script aims to create a probability density curve for ALL GRaND
% Reservoirs and to plot the 11 sample reservoirs as lines over it
% Manually zoom in on the different subplots so the sample res. are more
% visible 
% Make sure everything not shown (due to zooming in) has a probability
% approximately equal to zero, and make note of maximum value on figure
% Make note of cumulative density function percentage to quantify the
% variability captured by the sample reservoirs

% read in the Coerver GRAND Data 
pathname='.\res\'; %this is a path to my copy of the data
filename='GRAND_Data'; %this is the name of a data file
T = readtable([pathname filename]);

% read in all GRAND Data
filename= 'GRAND_Data_ALL';
T1 = readtable([pathname filename]);

% Decide variables of interest
    % DAM_HGT      Column 19
    % AREA_SKM     Column 23
    % mcmcap       Column 28
    % DIS_AVG_LS   Column 33
    % DOR_PC       Column 34
    % ELEV_MASL    Column 35
    % CATCH_SKM    Column 36

int = [19 23 28 33 34 35 36]; % Create index for variables of interest
% Create tables with only variables of interest
T1 = T1(:,int); % ALL GRAND DATA
T = T(:,int); % COERVER DATA

labels = {'Dam Height';'Surface Area';'Maximum Capacity';...
    'Average Discharge'; 'Degree of Regulation'; 'Elevation';...
    'Draining Catchment Area'};

labels_x = {'Height (m)'; 'Area (km^2)'; 'Volume (mil. m^3)';...
    'Discharge (L/s)'; 'DOR (%)'; 'Elevation (m.a.s.l)'; 'Area (km^2)'}

zoomrange = [400, 1500, 7*10^4, 3*10^6, 1000, 3000, 8*10^5];

figure('DefaultAxesFontSize',11)
for k = 1:numel(int)
    subplot(2,4,k)
    var = T1.(k); % kth column, ALL GRAND Data
    var1 = T.(k); % kth column, COERVER sample Data
    
    var = var(var >= 0); % Get rid of any non-values (-99)
    var1 = var1(var1 >= 0); % Get rid of any negative values (-99)
    
    lab = labels{k}; % specify what variable it is
    lab_x = labels_x{k}; % x label
    
    [f,xi] = ksdensity(var); % probability density of ALL reservoirs
    plot(xi,f,'k','LineWidth',1.5) % plot probability density
    hold on
  
    for i = 1:numel(var1) % loop through the Coerver data points
        xline(var1(i))
        hold on
    end
    
    % Add red lines showing the minimum and maximum sample dam data
    minvar1 = min(var1); maxvar1 = max(var1);
    xline(minvar1,'r','LineWidth',1.2)
    xline(maxvar1, 'r','LineWidth',1.2)
    
    % Calculate key information about distribution
    % Display maximum value since extent will be zoomed in and won't show
    % it
    maxvar = round(max(var)); % maximum value in GRAND set
    if maxvar > 5000
        maxvar = sprintf('%0.2e',maxvar)
    end
    % Display the percent which the sample data falls into
    [f1,xi1] = ksdensity(var,'Function', 'cdf'); 
    [ d, ix ] = min( abs( xi1-min(var1)) );
    [ d1, ix1 ] = min( abs( xi-max(var1)) );
    per = f1(ix1)-f1(ix);
    per = round(per*100,2);
    
    title(lab)
    subtitle({['Max Value = ' num2str(maxvar)], ['Percent = ' num2str(per)]})
    
    xlabel(lab_x)
    ylabel('Frequency')
    
    
    % set the graphs to zoom into the range I want...
    % Find where the probability density function = 0 for a long time....
    set(gca,'XLim',[0, zoomrange(k)])
    
end

subplot(2,4,8)
plot(0,0,'k','LineWidth',1.5)
hold on
plot(0,0,'k')
plot(0,0, 'r', 'LineWidth',1.2)
axis off
l = legend('Density Plot for GRaND Reservoirs','Sample Reservoirs','Min. and Max. Value for Sample Reservoirs',...
    'Location','northwest')
  
set(l,'FontSize',10);