% File to compare simulation results of the three operating policies 
% to the results of Coerver and Hanasaki

% load in reservoir data
pathname='.\res\'; %this is a path to my copy of the data
filename = 'All_Performance_Measures';
T = readtable([pathname filename]);

%% Compare calibration and validation
% NSE, KGE, MAE
xlab = {'Andijan','Bull Lake','Canyon Ferry',...
    'Chardara', 'Charvak','Kayrakkum',...
    'Nurek','Seminoe','Toktogul',...
    'Tuyen Quang','Tyuyamuyun'}

NSE = [T.Lin_val_NSE, T.Piece_val_NSE, T.Piece_OPT_val_NSE];
KGE = [T.Lin_val_KGE, T.Piece_val_KGE, T.Piece_OPT_val_KGE];
MAE = [T.Lin_val_MAE, T.Piece_val_MAE, T.Piece_OPT_val_MAE];

lakelinerrors_NSE = [T.Lin_val_NSE - 0.10*T.Lin_val_NSE, T.Lin_val_NSE + 0.10*T.Lin_val_NSE];
lakelinerrors_KGE = [T.Lin_val_KGE - 0.10*T.Lin_val_KGE, T.Lin_val_KGE + 0.10*T.Lin_val_KGE];
lakelinerrors_MAE = [T.Lin_val_MAE - 0.10*T.Lin_val_MAE, T.Lin_val_MAE + 0.10*T.Lin_val_MAE];



figure('DefaultAxesFontSize',11)
subplot(3,10,[1:3,11:13,21:23])
x = 1:11;
b = barh(x,NSE,0.85)

b(3).FaceColor = [85, 6, 150]/255; % Dark purple
b(2).FaceColor = [134, 98, 163]/255; % Med purple
b(1).FaceColor = [197, 178, 212]/255; %[212, 193, 227]/255; % Light Purple


set(gca,'yticklabel',xlab);
set(gca,'YDir','reverse');
xlabel('Validation NSE')
ylabel('Reservoir')

subplot(3,10,[4:6,14:16,24:26])
b = barh(x,KGE,0.85)
set(gca,'yticklabel',[]);
set(gca,'YDir','reverse');
xlabel('Validation KGE')

b(3).FaceColor = [85, 6, 150]/255; % Dark purple
b(2).FaceColor = [134, 98, 163]/255; % Med purple
b(1).FaceColor = [197, 178, 212]/255; %[212, 193, 227]/255; % Light Purple


subplot(3,10,[7:9,17:19,27:29])
b = barh(x,MAE,0.85)
set(gca,'yticklabel',[]);
set(gca,'YDir','reverse');
xlabel('Validation MAE')

b(3).FaceColor = [85, 6, 150]/255; % Dark purple
b(2).FaceColor = [134, 98, 163]/255; % Med purple
b(1).FaceColor = [197, 178, 212]/255; %[212, 193, 227]/255; % Light Purple



% % % legend dummy subplot
subplot(3,10,20)
b = barh(1,[1;2;3],0.85);
hold on
plot(1:2,1:2,'w')
xlim([5 10])
ylim([0 1])
axis off


b(3).FaceColor = [85, 6, 150]/255; % Dark purple
b(2).FaceColor = [134, 98, 163]/255; % Med purple
b(1).FaceColor = [197, 178, 212]/255; %[212, 193, 227]/255; % Light Purple

% b(1).BaseLine = 'off';
b(1).BaseLine.Color = 'none';
b(2).BaseLine.Color = 'none';
b(3).BaseLine.Color = 'none';


l = legend('Linear', 'Piecewise', 'Piecewise', '(w/ Optimized Qtarget)', 'Location', 'eastoutside')
set(l,'FontSize',10);
%% Bar chart comparing all validation NSE values
% Lake lin results
% lakelin = [0.76; 0.56; 0.48; 0.44; 0.71; 0.57; 0.76; 0.37; 0.02; 0.44; 0.86]';
lakelin = [0.76; 0.56; 0.52; 0.44; 0.71; 0.57; 0.65; 0.37; 0.02; 0.44; 0.86]';

% Piecewise results
% piecewise = [0.83; 0.56; -0.15; 0.39; 0.72; 0.49; 0.71; 0.37; 0.14; 0.42; 0.86]';
piecewise  = [0.81; 0.56; 0.52; 0.39; 0.73; 0.53; 0.58; 0.38; 0.12; 0.41; 0.85]';

% Piecewise OptQ results
% piecewiseoptQ = [0.83; 0.56; 0.45; 0.26; 0.69; 0.33; 0.76; -0.35; 0.20; 0.37; 0.86]';
piecewiseoptQ = [0.84; 0.47; 0.51; 0.27; 0.68; 0.42; 0.57; -0.35; 0.03; 0.33; 0.86]';

% Hanasaki
hanasaki = [0.51; 0.11; 0.22; NaN; 0.7; 0.52; NaN; NaN; 0.02; 0.83; NaN]';
% Coerver
coerver = [0.69; 0.46; 0.8; -0.49; 0.92; 0.45; 0.78; 0.4; 0.33; 0.5; 0.95]';

% combine
values = [lakelin; piecewise; piecewiseoptQ; hanasaki; coerver];


figure('DefaultAxesFontSize',11)
values = [lakelin; piecewise; piecewiseoptQ; hanasaki; coerver];
% values = [coerver; hanasaki; piecewiseoptQ; piecewise; lakelin];
x = 1:11;
b = barh(x,values,0.85)
hold on



lakelinerrors_NSE = [lakelin - 0.10*lakelin, lakelin + 0.10*lakelin];
piecewiseerrors_NSE = [piecewise - 0.10*piecewise, piecewise + 0.10*piecewise];
piecewiseoptQerrors_NSE = [piecewiseoptQ - 0.10*piecewiseoptQ, piecewiseoptQ + 0.10*piecewiseoptQ];
hanasakierrors_NSE = [hanasaki - 0.10*hanasaki, hanasaki+0.10*hanasaki];
coervererrors_NSE = [coerver - 0.10*coerver, coerver + 0.10*coerver];

% % errors = [lakelinerrors_NSE; piecewiseerrors_NSE; piecewiseoptQerrors_NSE; hanasakierrors_NSE; coervererrors_NSE];
% % 
% % % Finding the number of groups and the number of bars in each group
% % ngroups = size(values, 1);
% % nbars = size(values, 2);
% % % Calculating the width for each bar group
% % groupwidth = min(0.8, nbars/(nbars + 1.5));
% % % Set the position of each error bar in the centre of the main bar
% % % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
% % for i = 1:nbars
% %     % Calculate center of each bar
% %     x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
% %     errorbar(values(:,i),x, errors(:,i),'horizontal','k', 'linestyle', 'none');
% % end




% er = errorbar(x,lakelin,err_low_lakelinerrors_NSE,err_high_lakelinerrors_NSE,'horizontal');   



b(3).FaceColor = [85, 6, 150]/255; % Dark purple
b(2).FaceColor = [134, 98, 163]/255; % Med purple

b(1).FaceColor = [197, 178, 212]/255; %[212, 193, 227]/255; % Light Purple

b(5).FaceColor = [240, 105, 26]/255; % Dark Orange
b(4).FaceColor = [235, 169, 131]/255;% Light Orange


set(gca,'yticklabel',xlab);
set(gca,'YDir','reverse');
xlabel('Validation NSE')
ylabel('Reservoir')
% legend([b(5), b(4), b(3), b(2), b(1)], 'Linear', 'Piecewise', 'Piecewise w/ Optimized Qtarget', 'Hanasaki et al. (2006)', 'Coerver et al. (2018)','Location', 'eastoutside')
l = legend('Linear', 'Piecewise', 'Piecewise (w/ Optimized Qtarget)', 'Hanasaki Algorithm',  'Coerver Method','Location', 'eastoutside')
set(l,'FontSize',10);



