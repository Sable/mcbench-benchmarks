function [ transitionMatrix columnStates ] = getTransitionMatrix(markovChain,Norder)
%%
% function getTransitionMatrix constructs the transition matrix of
% a markov chain, given the markovChain and the order,
% i.e., an integer greater or equal to 1.
%
% Inputs:
%    markovChain : the markov chain, in integers.
%    Norder : the order to be analyzed. 
% Ouptuts: 
%    transition matrix: the state-transition matrix (TM), where each value represents
%                       the number of occurrence for a sequence of states, which is the 
%                       previous state (column of TM) followed by the current state (row of TM).
%                       (See references for more info.)
%    columnStates: the sequence for the previous state(column of TM).
%%
% %Example 1:
% %outputs the 1st order transition matrix of the below markov chain.
% markovChain = [1 6 1 6 4 4 4 3 1 2 2 3 4 5 4 5 2 6 2 6 2]; Norder = 1;
% [ transitionMatrix columnStates ] = getTransitionMatrix(markovChain,Norder);
%
%%
% %Example 2:
% %plots the 2nd order transition matrix of a random markov chain with 4 states
% getTransitionMatrix;
%
%%
% ref: http://en.wikipedia.org/wiki/Markov_chain
%      http://stackoverflow.com/questions/11072206/constructing-a-multi-order-markov-chain-transition-matrix-in-matlab
%      
% $ version 1   $ by Pangyu Teng $ 25JUN2012 $ created $ 
% $ version 1.1 $ by Pangyu Teng $ 26Jun2012 $ updated, multi-order support
%

if nargin < 2,
    display(sprintf('2 inputs required (getTransitionMatrix.m)\nusing example data... '));
    %return;        
    markovChain = round(3*rand([1,1000])+1);
    Norder = 2;
end

if Norder < 1,
    display('Norder has to be >1 (getTransitionMatrix.m)');
    return;
end

if numel(markovChain) <= Norder
    display('Need more data for the 1st input. (getTransitionMatrix.m)');
    return;
end

%make markovChain a column
if size(markovChain,1) > 1;
    markovChain = markovChain';
end

%number of states
Nstates = max(markovChain);

if Norder == 1,
    
    %get transition matrix
    transitionMatrix = full(sparse(markovChain(1:end-1),markovChain(2:end),1,Nstates^Norder,Nstates));
    columnStates = cellstr(regexprep(num2str(1:Nstates),'[^\w'']','')');
    
else

    %get Norder-contiguous sequences of the markov chain
    ngrams = [];
    for i = 0:Norder-1
        ngrams = [ngrams, circshift(markovChain,[0 -1*(i)])'];
    end
    ngrams = cellstr(num2str( ngrams));
    ngrams = ngrams(1:end-Norder);

    
    %create  all combinations of Norder-contiguous sequences
    [x{1:Norder}] = ndgrid(1:Nstates);

    %format x to cell
    evalStr = ['xCell = cellstr(num2str(['];
    for i = 1:Norder
        evalStr = [evalStr 'x{' num2str(i) '}(:) '];            
    end
    evalStr = [evalStr ']));'];
    eval(evalStr);

    %map ngrams to numbers
    [gn,trashToo,g]=unique([xCell;ngrams]);
    s1 = g(Nstates^Norder+1:end);

    %states following the ngrams
    s2 = markovChain(Norder+1:end);

    %reordered xCell.
    columnStates = gn(1:Nstates^Norder);    
    
    %get transition matrix
    transitionMatrix = full( sparse(s1,s2,1,Nstates^Norder,Nstates) );

end

if nargout < 1

    %plot the transition matrix
    imagesc(transitionMatrix);
    str= 'Transition Matrix of the Markov Chain:\n';
    str=[str sprintf('%d',markovChain) '...'];
    title(sprintf(str));    
    
    %replace tickLabels with states.
    set(gca,'YTick',1:numel(columnStates));
    set(gca,'YTickLabel',columnStates);
    set(gca,'XTick',1:Nstates);
    set(gca,'XTickLabel',1:Nstates);
    
end