function u = lake_linear( s, x)
%
% u = lake_linear( s, x )
%
% linear operating policy
%
% s = storage value (volume)
% u = regulated release (volume/time)
% x = vector of 3 policy paramaters
%       x(1): slope of first linear piece (radiant)
%       x(2): maximum storage (volume)
%       x(3): length of the simulation time-step (time)
% Note: 
% x(1) must vary in (0,pi/2)
% x(3) is used to convert 'u' into flow units (volume/time)

% Modified from:
%  Copyright (c) 2020, Francesca Pianosi
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

% % Recover policy parameters:
ms    = x(2) ; % max storage
delta = x(3) ; % timestep

% Check paramter values are feasible:
if x(1) <=0    ; error('First component of input ''x'' (1st slope angle) must be positive'); end 
if x(1) >=pi/2 ; error('First component of input ''x'' (1st slope angle) must be smaller than pi/2'); end 

% calculate outflow according to policy:
% Si = [ 0 ms]' ;
% Ui = [ 0 ms*tan(x(1)) ]' ;
u = s*tan(x(1))/delta;

