function f = initialize_variables(N,problem)

% function f = initialize_variables(N,problem)
% N - Population size
% problem - takes integer values 1 and 2 where,
%           '1' for MOP1
%           '2' for MOP2
%
% This function initializes the population with N individuals and each
% individual having M decision variables based on the selected problem. 
% M = 6 for problem MOP1 and M = 12 for problem MOP2. The objective space
% for MOP1 is 2 dimensional while for MOP2 is 3 dimensional.

%
%  Copyright (c) 2009, Aravind Seshadri
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

% Both the MOP's has 0 to 1 as its range for all the decision variables. 
min = 0;
max = 1;
switch problem
    case 1
        M = 6;
        K = 8;
    case 2
        M = 12;
        K = 15;
end
for i = 1 : N
    % Initialize the decision variables
    for j = 1 : M
        f(i,j) = rand(1); % i.e f(i,j) = min + (max - min)*rand(1);
    end
    % Evaluate the objective function
    f(i,M + 1: K) = evaluate_objective(f(i,:),problem);
end
