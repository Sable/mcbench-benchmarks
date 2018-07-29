%% Genetic Algorithms
% Genetic algorithms are usefull optimization tools that allows to explore
% intrinsic properties of a predefined type of units. Genetic algorithms
% allows to explore the solution space of a problem randomly following the
% paths that are more promising than others. In a lot of real applications
% the GAs can be used to reach solutions that are difficult to reach using
% other optimization techniques.
% This tool is not a complete toolbox on genetic algorithms but helps to
% implement them without doing all from scratch. This toolbox allows to
% specify the fundamental operators (cross-over and mutation) and to
% specify the fitness function and a stop-critirion function so that the
% tool can get an initial population and generate new populations evolving
% it.

%% Example: a simple genetic problem:
% A classical problem for the genetic algorithms, described in the
% literature is the following: find the 32 bit number with the maximum
% number of 1s in its binary representation. Here the problem is really
% simple, no computataion must be done to discover the answer, but a
% genetic algorithm can be used to discover this value and to test this
% tool. Each unit of the population is a number, the genoma is the bit
% string that represents each integer value. The mutation operator simply
% mutates randomly the bits in the values. The crossover operator selects
% random positions and mixes two values cutting the left side of the first
% string of bits and the second side of the other. The fitness function
% counts the number of ones in the binary representation of the value.
% Here a population of 20 units is randomply generated ad the evolution is
% runned with 0.2 as selection probability, 0.05 as mutation probability
% adn with 1000 as maximum number of generations.

% Params:
szpop = 20;
funcs = {@SNumOnes,@SCrossBits,@SMutateBit,@SDisp};
probsel = 0.2;
probmut = 0.05;

% The population:
pop = num2cell(floor(rand([szpop,1])*65536*65536));

% The evolution:
[sol,fit,popo] = gaevolve(pop,funcs,{},[probsel,probmut]);

%% Stop criteria
% The stopping criteria is defined with a function that recives the actual
% state of the genetic algorithm: the actual solution, the actual (maximal)
% fitness, the actual population with all the fitness. This function
% returns a boolean that says if the execution must be interrupted or not.
% This functino is called after a fitness calculation and untits sorting so
% can be usefull to display the actual solution, or to save the actual
% state, or to log infos or to do other things with a semi-final state.
% Here the stopping criteria is that all the bits are 1 so the fitness is
% 32.
% 
% % Hook function:
% function stop = Disp(sol,fit,pop,fits)
% 
% % Display the number of bits:
% disp(sprintf('Actual max bits: %d',fit));
% 
% % Returning:
% stop = fit==32;

%% Fitness function
% This function is the fitness function that allows to compute the wellness
% of a solution. This function recives a unit and have to return a
% numerical value that defines the wellness. In this case the number of
% ones in the binary representation of the bits is returned.
% 
% % The fitting fuction:
% function fit = SNumOnes(num)
% 
% % Iterating on the 32bit number:
% fit = sum(dec2bin(num)=='1');

%% Mutation operator
% The mutation operator allows to generate new units that have a new
% variation in the genotipe, so this function takes a single unit, mutates
% it and return the new unit. In this case the mutation operator selects
% randomly a bit and changes its value.
% 
% % The mutation function:
% function nnum = SMutateBit(num)
% 
% % Selecting a position:
% pos = ceil(rand*32);
% 
% % Flipping that bit:
% change = bitset(0,pos);
% nnum = bitxor(num,change);

%% Cross over
% The cross over operator mixes two units randomply hoping that the best of
% the two units remains in the new one and that the worst is lost. This
% function recives a pair of units and returns the new generated one. In
% this case a random position is selected and the new unit is generated
% with the left bits of the first unit and the right bits of the second
% one.
% 
% % The crossing function:
% function nnum = SCrossBits(num1,num2)
% 
% % Selecting a position:
% pos = ceil(rand*32);
% 
% % The output:
% nnum = 0;
% 
% % Setting the first bits:
% for ind=1:pos
%     if bitget(num1,ind)==1
%         nnum = bitset(nnum,ind);
%     end
% end
% 
% % Setting the other bits:
% for ind=pos+1:32
%     if bitget(num2,ind)==1
%         nnum = bitset(nnum,ind);
%     end
% end
