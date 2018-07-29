function knapsackGA
%% The knapsack problem
% The knapsack problem or rucksack problem is a problem in combinatorial optimization:
% Given a set of items, each with a weight and a value, determine the count of each
% item to include in a collection so that the total weight is less than or equal to a
% given limit and the total value is as large as possible. It derives its name from 
% the problem faced by someone who is constrained by a fixed-size knapsack and must 
% fill it with the most useful items.
% 
% The problem often arises in resource allocation with financial constraints. A
% similar problem also appears in combinatorics, complexity theory, cryptography and
% applied mathematics.
% 
% The decision problem form of the knapsack problem is the question "can a value of
% at least V be achieved without exceeding the weight W?"
%
% http://en.wikipedia.org/wiki/Knapsack_problem
% made by Hanan Kavitz    Mar 2012

%% Linear programing first
w=1:10;
sumOfAllItemsInSack=150;

options=optimset('Display','off','LargeScale','off');
[x,fval]=linprog(-w,w,sumOfAllItemsInSack,[],[],zeros(1,length(w)),[],...
    sumOfAllItemsInSack./(ones(1,length(w))*length(w)),options);
visalization(x',w)
% This is not bad but can we realy have floating point amount of items? Can
% we carry 5.2222 items of the first kind?

%% integer programing using Genetic Algorithm
% This is realy an integer variables kind of problem, we can carry 5 or 6
% items of the first kind but not 5.2222 items.
% integer programming using GA was introduced at R2010b
options=gaoptimset('Display','off','PlotFcns',@gaplotbestf,'Generation',Inf);
[x,fval,exitFlag]=ga(@(x)(-w*x'),length(w),w,sumOfAllItemsInSack,[],[],zeros(1,length(w)),...
    [],[],1:10,options);

visalization(x,w)

function visalization(x,w)
figure
explode=ones(1,length(x));
pie(x,explode,{'1' '2' '3' '4' '5' '6' '7' '8' '9' '10'})
title(['The total weight is',num2str(x*w')])








