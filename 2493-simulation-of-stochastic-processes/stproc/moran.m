function [A1nmb] = moran(initsize, popsize) 
% MORAN generates a trajectory of a Moran type process 
%  which gives the number of genes of allelic type A1 in a population 
%  of haploid individuals that can exist in either type A1 or type A2.
%  The population size is popsize and the initial number of type A1 
%  individuals os initsize.
%
%  [A1nmb] = galtonwatson(initsize, popsize) 
% 
%  Inputs: initsize - initial number of A1 genes
%          popsize - the total population size (preserved)
% 
%  Outputs: A1nmb - the successive number of type A1 genes in the population

% Authors: R.Gaigalas, I.Kaj
% v1.2 04-Oct-02

if (nargin==0)
  initsize=10;
  popsize=30;
end

A1nmb=zeros(1,popsize);
A1nmb(1)=initsize;

lambda = inline('(x-1).*(1-(x-1)./N)', 'x', 'N');
mu = inline('(x-1).*(1-(x-1)./N)', 'x', 'N');

x=initsize;
i=1;
while  (x>1 & x<popsize+1)
  if (lambda(x,popsize)/(lambda(x,popsize)+mu(x,popsize))>rand)
   x=x+1;
   A1nmb(i)=x;
  else
   x=x-1;
   A1nmb(i)=x;
  end;
  i=i+1;
end;
nmbsteps=length(A1nmb);
rate = lambda(A1nmb(1:nmbsteps-1),popsize) ...
        +mu(A1nmb(1:nmbsteps-1),popsize);  

jumptimes=cumsum(-log(rand(1,nmbsteps-1))./rate);
jumptimes=[0 jumptimes];
 
stairs(jumptimes,A1nmb);
axis([0 jumptimes(nmbsteps) 0 popsize+1]);

