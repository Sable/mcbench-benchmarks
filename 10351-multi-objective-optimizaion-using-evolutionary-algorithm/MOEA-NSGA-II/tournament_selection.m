function f = selection_individuals(chromosome,pool_size,tour_size)

% function selection_individuals(chromosome,pool_size,tour_size) is the
% selection policy for selecting the individuals for the mating pool. The
% selection is based on tournament selection. Argument 'chromosome' is the
% current generation population from which the individuals are selected to 
% form a mating pool of size 'pool_size' after performing tournament 
% selection, with size of the tournament being 'tour_size'. By varying the 
% tournament size the selection pressure can be adjusted. 

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

[pop,variables] = size(chromosome);
rank = variables - 1;
distance = variables;

for i = 1 : pool_size
    for j = 1 : tour_size
        candidate(j) = round(pop*rand(1));
        if candidate(j) == 0
            candidate(j) = 1;
        end
        if j > 1
            while ~isempty(find(candidate(1 : j - 1) == candidate(j)))
                candidate(j) = round(pop*rand(1));
                if candidate(j) == 0
                    candidate(j) = 1;
                end
            end
        end
    end
    for j = 1 : tour_size
        c_obj_rank(j) = chromosome(candidate(j),rank);
        c_obj_distance(j) = chromosome(candidate(j),distance);
    end
    min_candidate = ...
        find(c_obj_rank == min(c_obj_rank));
    if length(min_candidate) ~= 1
        max_candidate = ...
        find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
        if length(max_candidate) ~= 1
            max_candidate = max_candidate(1);
        end
        f(i,:) = chromosome(candidate(min_candidate(max_candidate)),:);
    else
        f(i,:) = chromosome(candidate(min_candidate(1)),:);
    end
end
