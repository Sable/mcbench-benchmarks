function [popsize] = galtonwatson(nmbgen, initsize, p) 
% GALTONWATSON generates a trajectory of a Galton-Watson branching process 
% with offspring distribution p=(p0, p1,...,pn), starting with initsize
% individuals at time 0. 
%
%  [popsize] = galtonwatson(nmbgen, initsize, p) 
% 
%  Inputs: nmbgen - number of generations 
%	   initsize - initial size of the population
%          p - vector of offspring probabilities (p0, ..., pn). They should 
%          sum up to 1.  
% 
%  Outputs: popsize - the successive size of the population

% Authors: R.Gaigalas, I.Kaj
% v1.2 04-Oct-02

if (nargin==0)
   nmbgen=100;
   initsize=40;
   p=[1/2 0 1/2];
end

  % check arguments
  if (sum(p) ~= 1)
    error('Probabilities does not sum up to 1');
  end

% p=[0.3 0.4 0.2 0.1];   % Examples of offspring probabilitites
% p=[1/2 0 1/2];

popsize=zeros(1,nmbgen);

popsize(1)=initsize;

k=1;
while k<=nmbgen
 popsize(k+1)=offspring(popsize(k),p);
 k=k+1;
end
 
stairs((0:nmbgen),popsize)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nu=offspring(k,p)

z=[cumsum(p)];
n=length(p);        % nmb of possible offspring
offmu=dot(0:n-1,p); % offspring mean
u1=sort(rand(1,k));

 for j=1:n 
 u(j)=length(find(u1<z(j)));
 end 

u=diff([0 u]);
nu=u*(0:n-1)';

