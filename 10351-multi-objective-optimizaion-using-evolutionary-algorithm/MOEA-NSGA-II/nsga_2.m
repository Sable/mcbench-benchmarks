function nsga_2()
%% Main Function
% Main program to run the NSGA-II MOEA.
% Read the corresponding documentation to learn more about multiobjective
% optimization using evolutionary algorithms.
% initialize_variables has two arguments; First being the population size
% and the second the problem number. '1' corresponds to MOP1 and '2'
% corresponds to MOP2.

%% Initialize the variables
% Declare the variables and initialize their values
% pop - population
% gen - generations
% pro - problem number

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

pop = 200;
gen = 1000;
pro = 1;

switch pro
    case 1
        % M is the number of objectives.
        M = 2;
        % V is the number of decision variables. In this case it is
        % difficult to visualize the decision variables space while the
        % objective space is just two dimensional.
        V = 6;
    case 2
        M = 3;
        V = 12;
end

% Initialize the population
chromosome = initialize_variables(pop,pro);


%% Sort the initialized population
% Sort the population using non-domination-sort. This returns two columns
% for each individual which are the rank and the crowding distance
% corresponding to their position in the front they belong. 
chromosome = non_domination_sort_mod(chromosome,pro);

%% Start the evolution process

% The following are performed in each generation
% Select the parents
% Perfrom crossover and Mutation operator
% Perform Selection

for i = 1 : gen
    % Select the parents
    % Parents are selected for reproduction to generate offspring. The
    % original NSGA-II uses a binary tournament selection based on the
    % crowded-comparision operator. The arguments are 
    % pool - size of the mating pool. It is common to have this to be half the
    %        population size.
    % tour - Tournament size. Original NSGA-II uses a binary tournament
    %        selection, but to see the effect of tournament size this is kept
    %        arbitary, to be choosen by the user.
    pool = round(pop/2);
    tour = 2;
    parent_chromosome = tournament_selection(chromosome,pool,tour);

    % Perfrom crossover and Mutation operator
    % The original NSGA-II algorithm uses Simulated Binary Crossover (SBX) and
    % Polynomial crossover. Crossover probability pc = 0.9 and mutation
    % probability is pm = 1/n, where n is the number of decision variables.
    % Both real-coded GA and binary-coded GA are implemented in the original
    % algorithm, while in this program only the real-coded GA is considered.
    % The distribution indeices for crossover and mutation operators as mu = 20
    % and mum = 20 respectively.
    mu = 20;
    mum = 20;
    offspring_chromosome = genetic_operator(parent_chromosome,pro,mu,mum);

    % Intermediate population
    % Intermediate population is the combined population of parents and
    % offsprings of the current generation. The population size is almost 1 and
    % half times the initial population.
    [main_pop,temp] = size(chromosome);
    [offspring_pop,temp] = size(offspring_chromosome);
    intermediate_chromosome(1:main_pop,:) = chromosome;
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M+V) = ...
        offspring_chromosome;

    % Non-domination-sort of intermediate population
    % The intermediate population is sorted again based on non-domination sort
    % before the replacement operator is performed on the intermediate
    % population.
    intermediate_chromosome = ...
        non_domination_sort_mod(intermediate_chromosome,pro);
    % Perform Selection
    % Once the intermediate population is sorted only the best solution is
    % selected based on it rank and crowding distance. Each front is filled in
    % ascending order until the addition of population size is reached. The
    % last front is included in the population based on the individuals with
    % least crowding distance
    chromosome = replace_chromosome(intermediate_chromosome,pro,pop);
    if ~mod(i,10)
        fprintf('%d\n',i);
    end
end

%% Result
% Save the result in ASCII text format.
save solution.txt chromosome -ASCII

%% Visualize
% The following is used to visualize the result for the given problem.
switch pro
    case 1
        plot(chromosome(:,V + 1),chromosome(:,V + 2),'*');
        title('MOP1 using NSGA-II');
        xlabel('f(x_1)');
        ylabel('f(x_2)');
    case 2
        plot3(chromosome(:,V + 1),chromosome(:,V + 2),chromosome(:,V + 3),'*');
        title('MOP2 using NSGA-II');
        xlabel('f(x_1)');
        ylabel('f(x_2)');
        zlabel('f(x_3)');
end       
