function mae = MAE(y_sim,y_obs)
%
% Computes the Mean Absolute Error (MAE)
%
% mae = MAE(Y_sim,y_obs)
% 
% Y_sim = time series of modelled variable     - matrix (N,T)
%         (N>1 different time series can be evaluated at once)
% y_obs = time series of observed variable     - vector (1,T)
%
% mae   = vector of MAE coefficients           - vector (N,1)
%


[N,T] = size(y_sim) ;
[M,D] = size(y_obs) ;

if T~=D
    error('input y_sim and y_obs must have the same number of columns')
end
if M>1
    error('input y_obs must be a row vector')
end

Err  = abs(y_sim - y_obs);

mae = sum(Err)/numel(y_sim);