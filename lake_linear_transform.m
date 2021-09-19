function Op_param = lake_linear_transform(x,idx,s_max,delta)
%
% Op_param = op_piecewise_linear_transform(x,idx,s_max,Qtarget,delta)
%
% Takes set of decision variables 'x' and transform them into the
% parameters of the lake linear operating policy implemented in the
% function 'lake_linear'.
% x       - vector of decision variables  - vector (G*1,1)
% idx     - time series of indices to attribute different parameter sets
%           over time                     - vector (T,1)
% s_max   - maximum reservoir storage     - scalar
% delta   - scalar

% Op_param: time series of parameters of the operating policy - matrix (T,3)

% Modified from:
% Copyright (c) 2020, Francesca Pianosi
%  All rights reserved.
%
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.

T = length(idx) ; % number of time-steps in the simulation horizon
G = length(unique(idx)) ; % number of temporal groups within which the
% policy parameters are the same
% CHANGED THE 1 (USED TO BE 3)
x = reshape( x, 1, G )'; % (G,3)

% create the matrix of policy parameters:
Op_param = nan(T,3) ;

% fill in the first columns with the (time-varying) parameters
% optimised by the genetic algorithm
% First row, idx = 1, wet season
% Second row, idx = 2, dry season
for i=1:G % for each time group
    Op_param(idx==i,1) = x(i,1) ;
end


% fill in the other 2 columns with the (constant) parameters
% that are not varied by the nsga algorithm
% if idx == 1
%     Op_param(1,4) = Qtarget*delta; % wet season
% else
%     Op_param(2,4) = QtargetDRY*delta; % dry season
% end

Op_param(:,2) = s_max    ;
Op_param(:,3) = delta    ;