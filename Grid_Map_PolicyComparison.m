% File to compare simulation results of the three operating policies 
% to the results of Coerver and Hanasaki

% load in reservoir data
pathname='.\res\'; %this is a path to my copy of the data
filename = 'All_Performance_Measures';
T = readtable([pathname filename]);

% Create vector of reservoir names for titles
legend_str = {'Andijan, Uzbekistan';'Bull Lake, USA';'Canyon Ferry, USA';...
    'Chardara, Kazakstan'; 'Charvak, Uzbekistan';'Kayrakkum, Tajikistan';...
    'Nurek, Tajikistan';'Seminoe, USA';'Toktogul, Kyrgysztan';...
    'Tuyen Quang, Vietnam';'Tyuyamuyun, Turkmenistan'};


%% Comparing NSE for all
% Linear results
lakelin = T.Lin_val_NSE;
% Piecewise results
piecewise  = T.Piece_val_NSE;
% Piecewise OptQ results
piecewiseoptQ = T.Piece_OPT_val_NSE;
% Hanasaki
hanasaki = [0.51; 0.11; 0.22; NaN; 0.7; 0.52; NaN; NaN; 0.02; 0.83; NaN];
% Coerver
coerver = [0.69; 0.46; 0.8; -0.49; 0.92; 0.45; 0.78; 0.4; 0.33; 0.5; 0.95];

% Each column is a different policy, each row is a reservoir
values = [lakelin, piecewise, piecewiseoptQ, hanasaki, coerver];


figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])

percent_diff = zeros(5,5);
for i = 1:11
    resdata = values(i,:); % select only that reservoir's data
    
    % Calculate percentage difference between each paramater
    for k = 1:5
        for j = 1:5
        percent_diff(k,j) = (resdata(k) - resdata(j))/abs(resdata(k));
        end
    end
% % %     
    % set extraneous values to NaN.. 3, when multiplied by 100 -->300
    nullval = 2.99;
    percent_diff(:,1) = nullval;
    percent_diff(2:5,2) = nullval;
    percent_diff(3:5,3) = nullval;
    percent_diff(4:5,4) = nullval;
    percent_diff(5,5) = nullval;
    
    % Set color map 
    % Range will be set: -50 to 300 (but only interested in seeing up to
    % 50)
    % 10 colors for the -50 t0 50 range, with a band of 0.1 for each color
    % specify that the middle will be white for anything +- 0.10
    % Reds for the negatives, blues for the positives
    cmap_1 = [[156, 0, 0]/255; ...   % dark red
        [173, 42, 42]/255; ...       % red
        [204, 100, 100]/255; ...       % medium red
        [245, 179, 179]/255; ... % light red
        1, 1, 1; ...   % White for 5 
        1, 1, 1; ...       % White for 6
        [203, 220, 245]/255; ...       % light blue
        [104, 152, 222]/255; ...       % blue
        [44, 108, 201]/255; ...       % medium blue
        [0, 63, 156]/255]           % dark blue

    cmap = [[156, 0, 0]/255; ...   % dark red
        [173, 42, 42]/255; ...       % red
        [204, 100, 100]/255; ...       % medium red
        [245, 179, 179]/255; ... % light red
        1, 1, 1; ...   % White for 5 
        1, 1, 1; ...       % White for 6
        [203, 220, 245]/255; ...       % light blue
        [104, 152, 222]/255; ...       % blue
        [44, 108, 201]/255; ...       % medium blue
        [0, 63, 156]/255;...          % dark blue 40 - 50
        
        [0, 63, 156]/255;...          % dark blue 50 - 60
        [0, 63, 156]/255;...          % dark blue 60 - 70
        [0, 63, 156]/255;...          % dark blue 70 - 80
        [0, 63, 156]/255;...          % dark blue 80 - 90
        [0, 63, 156]/255;...          % dark blue 90 - 100
        [0, 63, 156]/255;...          % dark blue 100 - 110
        [0, 63, 156]/255;...          % dark blue 110 - 120
        [0, 63, 156]/255;...          % dark blue 120 - 130
        [0, 63, 156]/255;...          % dark blue 130 - 140
        [0, 63, 156]/255;...          % dark blue 140 - 150
        [0, 63, 156]/255;...          % dark blue 150 - 160
        [0, 63, 156]/255;...          % dark blue 160 - 170
        [0, 63, 156]/255;...          % dark blue 170 - 180
        [0, 63, 156]/255;...          % dark blue 180 - 190
        [0, 63, 156]/255;...          % dark blue 190 - 200
        [0, 63, 156]/255;...          % dark blue 200 - 210
        [0, 63, 156]/255;...          % dark blue 210- 220
        [0, 63, 156]/255;...          % dark blue 220 - 230
        [0, 63, 156]/255;...          % dark blue 230 - 240
        [0, 63, 156]/255;...          % dark blue 240 - 250
        [0, 63, 156]/255;...          % dark blue 250 - 260
        [0, 63, 156]/255;...          % dark blue 260 - 270
        [0, 63, 156]/255;...          % dark blue 270 - 280
        [0, 63, 156]/255;...          % dark blue 280 - 290 
        
        [191, 191, 191]/255]          % GREY FOR NULL, set to 299
    
   
    subplot(3,4,i)
    
    % These reservoirs don't have Hanasaki Data
    if i == 4  || i == 7  || i == 8  || i == 11
        % Remove Hanasaki Column and Row
        percent_diff(:,4) = [];
        percent_diff(4,:) = [];
        
        percent_diff = percent_diff*100;
        
        % plot
        imshow(percent_diff)
        axis on
        hold on
        
        set(gca,'XTickLabel',{'1','2','3', '5'}) % skip 4 b/c no Hanasaki
        set(gca, 'XTick',1:4)
        set(gca, 'YTick',1:4)
        set(gca,'YTickLabel',{'1','2','3', '5'}) % skip 4 b/c no Hanasaki
        title(legend_str{i});
        
    else % reservoir has policy data for all 5 
        
        percent_diff = percent_diff*100;
        
        % plot
        imshow(percent_diff)
        axis on
        hold on

        set(gca,'XTickLabel',{'1','2','3', '4', '5'})
        set(gca, 'XTick',1:5)
        set(gca, 'YTick',1:5)
        title(legend_str{i});
    end
    
    % add lines to distinguish each grid
    for j = 1:5
        xline(j+0.5)
        yline(j+0.5)
    end
    
    % set color axis limits -0.5 to 0.5
    % anything more extreme will take on the most extreme color in the bar
    % ex: a value of -2 will be shaded the same as -0.5
%     caxis([-50,50])
    
    caxis([-50,300])
    
    % set colormap to previously defined color ranges
    colormap(cmap);
    
    hold off
    
%     % display colorbar
%     colorbar
end

% plot the guide to the policies in the remaining subplot
subplot(3,4,12)
axis off
% str = {'1. Linear','2. Piecewise','3. Piecewise (w/ Optimized Qtarget)','4. Hanasaki et al. (2006)', '5. Coerver et al. (2018)'};
% text(0.01,0.75,str)

% str = {'Colors represent the NSE percent','change calculated by: '}
str = {'Colors represent the NSE','percent change calculated by: '}

text(-0.18,0.75,str)

caxis([-50,300])
colormap(cmap);
colorbar('westoutside')

%% Comparing KGE
% Linear results
lakelin = T.Lin_val_KGE;
% Piecewise results
piecewise  = T.Piece_val_KGE;
% Piecewise OptQ results
piecewiseoptQ = T.Piece_OPT_val_KGE;

% Each column is a different policy, each row is a reservoir
values = [lakelin, piecewise, piecewiseoptQ];

figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])
percent_diff = zeros(3,3);
for i = 1:11
    resdata = values(i,:); % select only that reservoir's data
    
    % Calculate percentage difference between each paramater
    for k = 1:3
        for j = 1:3
        percent_diff(k,j) = (resdata(k) - resdata(j))/abs(resdata(k));
        end
    end
    
    % set extraneous values to NaN.. 3, when multiplied by 100 -->300
    percent_diff(:,1) = nullval;
    percent_diff(2:3,2) = nullval;
    percent_diff(3,3) = nullval;
    
    percent_diff = percent_diff*100;
    
    subplot(3,4,i)
    
    % plot
    imshow(percent_diff)
    axis on
    hold on
    
    set(gca,'XTickLabel',{'1','2','3'})
    set(gca, 'XTick',1:3)
    set(gca, 'YTick',1:3)
    title(legend_str{i});
   
    % add lines to distinguish each grid
    for j = 1:3
        xline(j+0.5)
        yline(j+0.5)
    end
    
    % set color axis limits -0.5 to 0.5
    % anything more extreme will take on the most extreme color in the bar
    % ex: a value of -2 will be shaded the same as -0.5
    caxis([-50,300])
    
    % set colormap to previously defined color ranges
    colormap(cmap);
end

% plot the guide to the policies in the remaining subplot
subplot(3,4,12)
axis off
% str = {'1. Linear','2. Piecewise','3. Piecewise (w/ Optimized Qtarget)'};
% str = {'Colors represent the KGE percent','change calculated by: '}
str = {'Colors represent the KGE','percent change calculated by: '}
% text(0.01,0.75,str)

text(-0.18,0.80,str)

caxis([-50,300])
colormap(cmap);
colorbar('westoutside')


%% Comparing MAE
% Linear results
lakelin = T.Lin_val_MAE;
% Piecewise results
piecewise  = T.Piece_val_MAE;
% Piecewise OptQ results
piecewiseoptQ = T.Piece_OPT_val_MAE;

% Each column is a different policy, each row is a reservoir
values = [lakelin, piecewise, piecewiseoptQ];

figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])
percent_diff = zeros(3,3);
for i = 1:11
    resdata = values(i,:); % select only that reservoir's data
    
    % Calculate percentage difference between each paramater
    for k = 1:3
        for j = 1:3
        percent_diff(k,j) = (resdata(k) - resdata(j))/abs(resdata(k));
        end
    end
    
    % set extraneous values to NaN.. 3, when multiplied by 100 -->300
    percent_diff(:,1) = nullval;
    percent_diff(2:3,2) = nullval;
    percent_diff(3,3) = nullval;
    
    percent_diff = percent_diff*100;
    

    
    subplot(3,4,i)
    
    % plot
    imshow(percent_diff)
    axis on
    hold on
    
    set(gca,'XTickLabel',{'1','2','3'})
    set(gca, 'XTick',1:3)
    set(gca, 'YTick',1:3)
    title(legend_str{i});
   
    % add lines to distinguish each grid
    for j = 1:3
        xline(j+0.5)
        yline(j+0.5)
    end
    
    % set color axis limits -0.5 to 0.5
    % anything more extreme will take on the most extreme color in the bar
    % ex: a value of -2 will be shaded the same as -0.5
    caxis([-50,300])
    
    % set colormap to previously defined color ranges
    colormap(cmap);
end

% plot the guide to the policies in the remaining subplot
subplot(3,4,12)
axis off
% str = {'1. Linear','2. Piecewise','3. Piecewise (w/ Optimized Qtarget)'};
% text(0.01,0.75,str)
% str = {'Colors represent the MAE percent','change calculated by: '}
str = {'Colors represent the MAE','percent change calculated by: '}

text(-0.18,0.80,str)
caxis([-50,300])
colormap(cmap);
colorbar('westoutside')


%% Comparing NSE
% Linear results
lakelin = T.Lin_val_NSE;
% Piecewise results
piecewise  = T.Piece_val_NSE;
% Piecewise OptQ results
piecewiseoptQ = T.Piece_OPT_val_NSE;

% Each column is a different policy, each row is a reservoir
values = [lakelin, piecewise, piecewiseoptQ];

figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])
percent_diff = zeros(3,3);
for i = 1:11
    resdata = values(i,:); % select only that reservoir's data
    
    % Calculate percentage difference between each paramater
    for k = 1:3
        for j = 1:3
        percent_diff(k,j) = (resdata(k) - resdata(j))/abs(resdata(k));
        end
    end
    
    % set extraneous values to NaN.. 3, when multiplied by 100 -->300
    percent_diff(:,1) = nullval;
    percent_diff(2:3,2) = nullval;
    percent_diff(3,3) = nullval;
    
    percent_diff = percent_diff*100;
    
    
    subplot(3,4,i)
    
    % plot
    imshow(percent_diff)
    axis on
    hold on
    
    set(gca,'XTickLabel',{'1','2','3'})
    set(gca, 'XTick',1:3)
    set(gca, 'YTick',1:3)
    title(legend_str{i});
   
    % add lines to distinguish each grid
    for j = 1:3
        xline(j+0.5)
        yline(j+0.5)
    end
    
    % set color axis limits -0.5 to 0.5
    % anything more extreme will take on the most extreme color in the bar
    % ex: a value of -2 will be shaded the same as -0.5
    caxis([-50,300])
    
    % set colormap to previously defined color ranges
    colormap(cmap);
end

% plot the guide to the policies in the remaining subplot
subplot(3,4,12)
axis off
% str = {'1. Linear','2. Piecewise','3. Piecewise (w/ Optimized Qtarget)'};
% text(0.01,0.75,str)
str = {'Colors represent the NSE','percent change calculated by: '}

text(-0.18,0.80,str)
caxis([-50,300])
colormap(cmap);
colorbar('westoutside')

%% Make grey grid for 

percent_diff = 0.08*ones(5,5);
% set extraneous values to NaN.. 3, when multiplied by 100 -->300
nullval = 2.99;
percent_diff(:,1) = nullval;
percent_diff(2:5,2) = nullval;
percent_diff(3:5,3) = nullval;
percent_diff(4:5,4) = nullval;
percent_diff(5,5) = nullval;

percent_diff = percent_diff*100;

figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])
imshow(percent_diff,'InitialMagnification', 2000);
hold on
% add lines to distinguish each grid
for j = 1:5
    xline(j+0.5)
    yline(j+0.5)
end

caxis([-50,300])
colormap(cmap)


set(gca,'XTickLabel',{'1','2','3', '4', '5'})
set(gca, 'XTick',1:5)
set(gca, 'YTick',1:5)
