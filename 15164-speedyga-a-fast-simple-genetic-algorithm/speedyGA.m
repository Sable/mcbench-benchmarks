% SpeedyGA is a vectorized implementation of a Simple Genetic Algorithm in Matlab
% Version 1.3
% Copyright (C) 2007, 2008, 2009  Keki Burjorjee
% Created and tested under Matlab 7 (R14). 

%  Licensed under the Apache License, Version 2.0 (the "License"); you may
%  not use this file except in compliance with the License. You may obtain 
%  a copy of the License at  
%
%  http://www.apache.org/licenses/LICENSE-2.0 
%
%  Unless required by applicable law or agreed to in writing, software 
%  distributed under the License is distributed on an "AS IS" BASIS, 
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
%  See the License for the specific language governing permissions and 
%  limitations under the License. 

%  Acknowledgement of the author (Keki Burjorjee) is requested, but not required, 
%  in any publication that presents results obtained by using this script 

%  Without Sigma Scaling, Stochastic Universal Sampling, and the generation of mask 
%  repositories, SpeedyGA faithfully implements the specification of a simple genetic 
%  algorithm given on pages 10,11 of M. Mitchell's book An Introduction to
%  Genetic Algorithms, MIT Press, 1996). Selection is fitness
%  proportionate.
 
len=640                    % The length of the genomes  
popSize=500;               % The size of the population (must be an even number)
maxGens=1000;              % The maximum number of generations allowed in a run
probCrossover=1;           % The probability of crossing over. 
probMutation=0.003;        % The mutation probability (per bit)
sigmaScalingFlag=1;        % Sigma Scaling is described on pg 168 of M. Mitchell's
                           % GA book. It often improves GA performance.
sigmaScalingCoeff=1;       % Higher values => less fitness pressure 

SUSFlag=1;                 % 1 => Use Stochastic Universal Sampling (pg 168 of 
                           %      M. Mitchell's GA book)
                           % 0 => Do not use Stochastic Universal Sampling
                           %      Stochastic Universal Sampling almost always
                           %      improves performance

crossoverType=2;           % 0 => no crossover
                           % 1 => 1pt crossover
                           % 2 => uniform crossover

visualizationFlag=1;       % 0 => don't visualize bit frequencies
                           % 1 => visualize bit frequencies

verboseFlag=1;             % 1 => display details of each generation
                           % 0 => run quietly

useMaskRepositoriesFlag=1; % 1 => draw uniform crossover and mutation masks from 
                           %      a pregenerated repository of randomly generated bits. 
                           %      Significantly improves the speed of the code with
                           %      no apparent changes in the behavior of
                           %      the SGA
                           % 0 => generate uniform crossover and mutation
                           %      masks on the fly. Slower. 
                           

    


% crossover masks to use if crossoverType==0.
mutationOnlycrossmasks=false(popSize,len);

% pre-generate two “repositories” of random binary digits from which the  
% the masks used in mutation and uniform crossover will be picked. 
% maskReposFactor determines the size of these repositories.

maskReposFactor=5;
uniformCrossmaskRepos=rand(popSize/2,(len+1)*maskReposFactor)<0.5;
mutmaskRepos=rand(popSize,(len+1)*maskReposFactor)<probMutation;

% preallocate vectors for recording the average and maximum fitness in each
% generation
avgFitnessHist=zeros(1,maxGens+1);
maxFitnessHist=zeros(1,maxGens+1);

    
eliteIndiv=[];
eliteFitness=-realmax;


% the population is a popSize by len matrix of randomly generated boolean
% values
pop=rand(popSize,len)<.5;

for gen=0:maxGens

    % evaluate the fitness of the population. The vector of fitness values 
    % returned  must be of dimensions 1 x popSize.
    fitnessVals=oneMax(pop);
     
    [maxFitnessHist(1,gen+1),maxIndex]=max(fitnessVals);    
    avgFitnessHist(1,gen+1)=mean(fitnessVals);
    if eliteFitness<maxFitnessHist(gen+1)
        eliteFitness=maxFitnessHist(gen+1);
        eliteIndiv=pop(maxIndex,:);
    end    
    
    % display the generation number, the average Fitness of the population,
    % and the maximum fitness of any individual in the population
    if verboseFlag
        display(['gen=' num2str(gen,'%.3d') '   avgFitness=' ...
            num2str(avgFitnessHist(1,gen+1),'%3.3f') '   maxFitness=' ...
            num2str(maxFitnessHist(1,gen+1),'%3.3f')]);
    end
    % Conditionally perform bit-frequency visualization
    if visualizationFlag
        figure(1)
        set (gcf, 'color', 'w');
        hold off
        bitFreqs=sum(pop)/popSize;
        plot(1:len,bitFreqs, '.');
        axis([0 len 0 1]);
        title(['Generation = ' num2str(gen) ', Average Fitness = ' sprintf('%0.3f', avgFitnessHist(1,gen+1))]);
        ylabel('Frequency of the Bit 1');
        xlabel('Locus');
        drawnow;
    end    

    % Conditionally perform sigma scaling 
    if sigmaScalingFlag
        sigma=std(fitnessVals);
        if sigma~=0;
            fitnessVals=1+(fitnessVals-mean(fitnessVals))/...
            (sigmaScalingCoeff*sigma);
            fitnessVals(fitnessVals<=0)=0;
        else
            fitnessVals=ones(popSize,1);
        end
    end        
    
    
    % Normalize the fitness values and then create an array with the 
    % cumulative normalized fitness values (the last value in this array
    % will be 1)
    cumNormFitnessVals=cumsum(fitnessVals/sum(fitnessVals));

    % Use fitness proportional selection with Stochastic Universal or Roulette
    % Wheel Sampling to determine the indices of the parents 
    % of all crossover operations
    if SUSFlag
        markers=rand(1,1)+[1:popSize]/popSize;
        markers(markers>1)=markers(markers>1)-1;
    else
        markers=rand(1,popSize);
    end
    [temp parentIndices]=histc(markers,[0 cumNormFitnessVals]);
    parentIndices=parentIndices(randperm(popSize));    

    % deterimine the first parents of each mating pair
    firstParents=pop(parentIndices(1:popSize/2),:);
    % determine the second parents of each mating pair
    secondParents=pop(parentIndices(popSize/2+1:end),:);
    
    % create crossover masks
    if crossoverType==0
        masks=mutationOnlycrossmasks;
    elseif crossoverType==1
        masks=false(popSize/2, len);
        temp=ceil(rand(popSize/2,1)*(len-1));
        for i=1:popSize/2
            masks(i,1:temp(i))=true;
        end
    else
        if useMaskRepositoriesFlag
            temp=floor(rand*len*(maskReposFactor-1));
            masks=uniformCrossmaskRepos(:,temp+1:temp+len);
        else
            masks=rand(popSize/2, len)<.5;
        end
    end
    
    % determine which parent pairs to leave uncrossed
    reprodIndices=rand(popSize/2,1)<1-probCrossover;
    masks(reprodIndices,:)=false;
    
    % implement crossover
    firstKids=firstParents;
    firstKids(masks)=secondParents(masks);
    secondKids=secondParents;
    secondKids(masks)=firstParents(masks);
    pop=[firstKids; secondKids];
    
    % implement mutation
    if useMaskRepositoriesFlag
        temp=floor(rand*len*(maskReposFactor-1));
        masks=mutmaskRepos(:,temp+1:temp+len);
    else
        masks=rand(popSize, len)<probMutation;
    end
    pop=xor(pop,masks);    
end
if verboseFlag
    figure(2)
    %set(gcf,'Color','w');
    hold off
    plot([0:maxGens],avgFitnessHist,'k-');
    hold on
    plot([0:maxGens],maxFitnessHist,'c-');
    title('Maximum and Average Fitness')
    xlabel('Generation')
    ylabel('Fitness')
end

 
