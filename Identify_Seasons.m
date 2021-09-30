% File to obtain dry and wet seasons

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


figure('DefaultAxesFontSize',11,'units','normalized','outerposition',[0 0 1 1])
for k = 1:numel(fnames)
    filename=fnames{k}
    T = readtable([pathname filename]);
    
    % load in reservoir data
    filename = fnames{k}; % k will specify which reservoir data to load
    T = readtable([pathname filename]);
    
    % load in the sample dam data with all reservoir characteristics
    filename1 = 'SampleDamData';
    ST = readtable([pathname filename1]); % kth row will refer to the reservoir

    ds_s = ST.ds_s(k);
    ds_e = ST.ds_e(k);
    
    
    loc_label = legend_str{k}; % location label

    % Define OBSERVED values
    I = T.inflow; % inflow, m3/s
    
    % LOOK AT ONLY CALIBRATION DATA
    portion = 0.60;
    idx = round(numel(I)*portion);
    I = I(1:idx);
    
    month = T.month(1:idx);

    % Get monthly mean
    for i = 1:12 % months
        x = find(month == i); % index for each month
        monthlyI = I(x); % flows for each month
        monthlymeans(i) = mean(monthlyI); % mean for each month
    end
    
    
    % Create x ticks and time labels to customise the plot
    x = 1:12;
    label_time = {' ';'Feb'; ' '; 'Apr';' '; 'Jun'; ' ';...
        'Aug'; ' '; 'Oct'; ' '; 'Dec'}
    
    sz = 24;
    
    subplot(3,4,k)
    hold on; box on;
    scatter(1:12,monthlymeans,sz,'filled','MarkerEdgeColor',[215,25,28]/255,'MarkerFaceColor',[215,25,28]/255)
%     ylabel('Mean Inflow (m^3/s)');
    title(loc_label)
    set(gca,'XTick',x,'XTickLabel',[])
    maxy = max(monthlymeans) + 0.3*max(monthlymeans);
    ylim([0, maxy]);
    xlim([1,12]);
    
    %% plot our wet and dry seasons
    lw = 4;
    
    yval_season = max(monthlymeans) + 0.20*max(monthlymeans);
    
    if ds_s > ds_e % if the beginning of the dry season is at a later month than the end
        ds_1 = (ds_s-0.5):0.5:12; % first part is start:12th month (December)
        ds_y = ones(numel(ds_1),1)*yval_season;
        plot(ds_1,ds_y,'LineWidth', lw,'color',[0.9290 0.6940 0.1250]); hold on; % dry policy
        
        ws = (ds_e + 0.5):0.5:(ds_s-0.5);
        ws_y = ones(numel(ws),1)*yval_season;
        plot(ws,ws_y,'LineWidth', lw,'color',[0.4660 0.6740 0.1880]);
        
        ds_2 = 1:0.5:(ds_e + 0.5); % second part is 1st month (january):end
        ds_y = ones(numel(ds_2),1)*yval_season;
        plot(ds_2,ds_y,'LineWidth', lw,'color',[0.9290 0.6940 0.1250]); hold on; % dry policy
        
        xline(ds_s - 0.5,'--')
        xline(ds_e + 0.5,'--')

    else % if numeric value of beginning of season is before end
        ds = (ds_s - 0.5):0.5:(ds_e + 0.5); % Season is start to end
        ds_y = ones(numel(ds),1)*yval_season;
        
        plot(ds,ds_y,'LineWidth', lw,'color',[0.9290 0.6940 0.1250]); hold on; % dry policy
        
        ws_1 = 1:0.5:(ds_s - 0.5);
        ws_y = ones(numel(ws_1),1)*yval_season;
        plot(ws_1,ws_y,'LineWidth', lw,'color',[0.4660 0.6740 0.1880]);
        
        ws_2 = (ds_e + 0.5):0.5:12;
        ws_y = ones(numel(ws_2),1)*yval_season;
        plot(ws_2,ws_y,'LineWidth', lw,'color',[0.4660 0.6740 0.1880]);
        
        xline(ds_s - 0.5,'--')
        xline(ds_e + 0.5,'--')
    end
    
set(gca,'XTickLabel',label_time)

%     ds_y = ones(numel(ds),1)*yval_season;
    
%     plot(ds,ds_y,'LineWidth', lw,'color',[0.9290 0.6940 0.1250]); hold on; % dry policy
%     plot(s_test,u_testw,'LineWidth', lw,'color',[0.4660 0.6740 0.1880]); % wet policy
    
    if k == 1
        ylabel('Mean Inflow (m^3/s)')
    elseif k == 5
        ylabel('Mean Inflow (m^3/s)')
    elseif k == 9
        ylabel('Mean Inflow (m^3/s)')
%         set(gca,'XTickLabel',label_time)
%     elseif k == 10
%         set(gca,'XTickLabel',label_time)
%     elseif k == 11
%         set(gca,'XTickLabel',label_time)
%     elseif k == 8
%         set(gca,'XTickLabel',label_time)
    end
end

subplot(3,4,12)
scatter(NaN,NaN,21,'filled','MarkerEdgeColor',[215,25,28]/255,'MarkerFaceColor',[215,25,28]/255)
hold on
plot(NaN,'LineWidth', lw, 'color',[0.9290 0.6940 0.1250]) % Dry
plot(NaN,'LineWidth', lw,'color',[0.4660 0.6740 0.1880]) % Wet
xline(1,'--')
xlim([2 3])
axis off
l = legend('Mean Inflow','Identified Dry Season','Identified Wet Season','Season Boundary',...
    'Location','northwest')
  
set(l,'FontSize',10);

% figure(2)
% for k = 1:numel(fnames)
%     filename=fnames{k}
%     T = readtable([pathname filename]);
%     
%     loc_label = legend_str{k}; % location label
%     
%     % Define OBSERVED values
%     I = T.inflow; % inflow, m3/s
%     
%     un_years = unique(T.year); % vector of all the years
%     
%     % preallocate vector
%     monthlymeans = zeros(numel(un_years),12);
%     
%     
%     for j = 1:numel(un_years) % index through each of the years
%         y = find(T.year == un_years(j)) % The location for all values in a year
%         
%         yearlyI = I(y); % All inflows for the jth year
%         months = T.month(y); % months in the jth year
%         
%         % Get monthly mean
%         for i = 1:12 % months
%             x = find(months == i); % index for each month
%             monthlyI = yearlyI(x); % flows for each month
%             
%             % store mean in row corresponding to year, column corresponding
%             % to month
%             monthlymeans(j,i) = mean(monthlyI); % mean for each month
%         end
%     end
%     
%     figure(2)
%     subplot(3,4,k)
%     for z = 1:numel(un_years)
%     scatter(1:12,monthlymeans(z,:),'filled')
%     hold on
%     end
%     title(loc_label)
% 
%     % Create x ticks and time labels to customise the plot
%     x = 2:2:12
%     label_time = {'Feb'; 'Apr'; 'Jun'; ...
%         'Aug'; 'Oct';  'Dec'}
%     
%     set(gca,'XTick',x,'XTickLabel',label_time)
%     
%     
%     figure(3)
%     subplot(3,4,k)
%     boxplot(monthlymeans)
%     hold on
%         if ds_s > ds_e % if the beginning of the dry season is at a later month than the end
%         ds_1 = ds_s:0.5:12; % first part is start:12th month (December)
%         ds_y = ones(numel(ds_1),1)*yval_season;
%         plot(ds_1,ds_y,'LineWidth', lw,'color',[0.9290 0.6940 0.1250]); hold on; % dry policy
%         
%         ws = ds_e:0.5:ds_s;
%         ws_y = ones(numel(ws),1)*yval_season;
%         plot(ws,ws_y,'LineWidth', lw,'color',[0.4660 0.6740 0.1880]);
%         
%         ds_2 = 1:0.5:ds_e; % second part is 1st month (january):end
%         ds_y = ones(numel(ds_2),1)*yval_season;
%         plot(ds_2,ds_y,'LineWidth', lw,'color',[0.9290 0.6940 0.1250]); hold on; % dry policy
%         
%         xline(ds_s - 0.5,'--')
%         xline(ds_e + 0.5,'--')
% 
%     else % if numeric value of beginning of season is before end
%         ds = ds_s:0.5:ds_e; % Season is start to end
%         ds_y = ones(numel(ds),1)*yval_season;
%         
%         plot(ds,ds_y,'LineWidth', lw,'color',[0.9290 0.6940 0.1250]); hold on; % dry policy
%         
%         ws_1 = 1:0.5:ds_s;
%         ws_y = ones(numel(ws_1),1)*yval_season;
%         plot(ws_1,ws_y,'LineWidth', lw,'color',[0.4660 0.6740 0.1880]);
%         
%         ws_2 = ds_e:0.5:12;
%         ws_y = ones(numel(ws_2),1)*yval_season;
%         plot(ws_2,ws_y,'LineWidth', lw,'color',[0.4660 0.6740 0.1880]);
%         
%         xline(ds_s + 0.5,'--')
%         xline(ds_e - 0.5,'--')
%     end
%     ylabel('Average Flow (m^3/s)')
%     set(gca,'XTick',x,'XTickLabel',label_time)
%     title(loc_label)
%     
% end




% % % figure
% % % for k = 1:numel(fnames)
% % %     filename=fnames{k}
% % %     T = readtable([pathname filename]);
% % %     
% % %     loc_label = legend_str{k}; % location label
% % %     
% % %     % Define OBSERVED values
% % %     I = T.inflow; % inflow, m3/s
% % %     
% % %     un_years = unique(T.year); % vector of all the years
% % %     
% % %     % preallocate vector
% % %     monthlymeans = zeros(numel(un_years),12);
% % %     
% % %     
% % %     for j = 1:numel(un_years) % index through each of the years
% % %         y = find(T.year == un_years(j)) % The location for all values in a year
% % %         
% % %         yearlyI = I(y); % All inflows for the jth year
% % %         months = T.month(y); % months in the jth year
% % %         
% % %         % Get monthly mean
% % %         for i = 1:12 % months
% % %             x = find(months == i); % index for each month
% % %             monthlyI = yearlyI(x); % flows for each month
% % %             
% % %             % store mean in row corresponding to year, column corresponding
% % %             % to month
% % %             monthlymeans(j,i) = mean(monthlyI); % mean for each month
% % %         end
% % %         
% % %         for i2 = 1:numel(monthlymeans)
% % %             store(i2) = monthlymeans(i2)
% % %         end
% % %     end
% % %     
% % %     subplot(3,4,k)
% % %     yearline = [12:12:numel(store)]
% % %     scatter(1:numel(store),store,'filled')
% % %     hold on
% % %     for z1 = 1:numel(yearline)
% % %         xline(yearline(z1))
% % %     end
% % %     
% % %     
% % % % %     for z = 1:numel(un_years)
% % % % % %         if un_years(z) == 2010
% % % % % %             scatter(1:12,monthlymeans(z,:),'d','filled')
% % % % % %         else
% % % % % %         scatter(1:12,monthlymeans(z,:),'filled')
% % % % % %         end
% % % % %     scatter(1:12,monthlymeans(z,:),'filled')
% % % % %     hold on
% % % % %     end
% % % % %     title(loc_label)
% % % % %     legend(num2str(un_years))
% % % 
% % %         % Create x ticks and time labels to customise the plot
% % %     x = 1:12:numel(store)
% % %     label_time = {num2str(un_years)}
% % %     
% % %     set(gca,'XTick',x,'XTickLabel',label_time)
% % % end
% % % preallocate vector
% % store = zeros(numel(un_years)*12,1);
% % 
% % for i2 = 1:numel(monthlymeans)
% %     store(i2) = monthlymeans(i2)
% % end

% % for z = 1:10
% %     scatter(1:12,monthlymeans(z,:),'filled')
% %     hold on
% % end
% % 
% % figure
% % yearline = [12:12:120]
% % scatter(1:120,store,'filled')
% % hold on
% % for z1 = 1:numel(yearline)
% %     xline(yearline(z1))
% % end


