function kge_mean = KGE(y_sim,y_obs)
%
% Computes the weighted average of Kling-Gupta Efficiency (KGE) coefficient
% For normal and inverse flows --> a recommended metric for low flow
% indices --> Refer to Garcia et al. 2017
%
% 
% Y_sim = time series of modelled variable     - matrix (N,T)
%         (N>1 different time series can be evaluated at once)
% y_obs = time series of observed variable     - vector (1,T)
%
% kge   = vector of KGE coefficients           - vector (N,1)
%


[N,T] = size(y_sim) ;
[M,D] = size(y_obs) ;

if T~=D
    error('input y_sim and y_obs must have the same number of columns')
end
if M>1
    error('input y_obs must be a row vector')
end

% for regular flows
err1 = y_obs - mean(y_obs);
err2 = y_sim - mean(y_sim);

new = (err1.*err2)/(std(y_obs)*std(y_sim));

r = sum(new)/numel(y_obs);
alpha = std(y_sim)/std(y_obs);
beta = mean(y_sim)/mean(y_obs);

if alpha == NaN   ; error('Division of standard deviations is NaN'); end 
if beta == NaN   ; error('Division of means is NaN'); end 

kge_n = 1 - sqrt((r-1)^2 + (alpha-1)^2 + (beta-1)^2);


% redefine as inverses
y_sim = 1./y_sim;
y_obs = 1./y_obs;

% repeat kge calculation for inverse transformed flows
err1 = y_obs - mean(y_obs);
err2 = y_sim - mean(y_sim);

new = (err1.*err2)/(std(y_obs)*std(y_sim));

r = sum(new)/numel(y_obs);
alpha = std(y_sim)/std(y_obs);
beta = mean(y_sim)/mean(y_obs);

if alpha == NaN   ; error('Division of transformed standard deviations is NaN'); end 
if beta == NaN   ; error('Division of transformed means is NaN'); end 

kge_i = 1 - sqrt((r-1)^2 + (alpha-1)^2 + (beta-1)^2);

% mean of both kge estimates
kge_mean = (kge_n  + kge_i)/2;

