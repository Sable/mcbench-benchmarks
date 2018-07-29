function f = crowding_distance(x,problem)
% This function calculates the crowding distance

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

[N,M] = size(x);
switch problem
    case 1
        M = 2;
        V = 6;
    case 2
        M = 3;
        V = 12;
end

% Crowding distance for each front
for i = 1 : length(F(front).f)
    y(i,:) = x(F(front).f(i),:);
end
for i = 1 : M
    [sorted(i).individual,sorted(i).index] = sort(y(:,V + i));
    distance(sorted(i).index(1)).individual = Inf;
    distance(sorted(i).index(length(sorted(i).index))).individual = Inf;
end

[num,len] = size(y);
% Initialize all the distance of individuals as zero.
for i = 1 : M
    for j = 2 : num - 1
        distance(j).individual = 0;
    end
    objective(i).range = ...
                sorted(i).individual(length(sorted(i).individual)) - ...
                sorted(i).individual(1);
        % Maximum and minimum objectives value for the ith objective
end 
% Caluclate the crowding distance for front one.
for i = 1 : M
    for j = 2 : num - 1
        distance(j).individual = distance(j).individual + ...
            (sorted(i).individual(j + 1) - sorted(i).individual(j - 1))/...
            objective(i).range;
        y(sorted(i).index(j),M + V + 2) = distance(j).individual;
    end
end
