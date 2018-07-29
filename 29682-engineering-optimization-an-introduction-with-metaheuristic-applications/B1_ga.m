% -----------------------------------------------------------------  %
% Matlab Programs included the Appendix B in the book:               %
%  Xin-She Yang, Engineering Optimization: An Introduction           %
%                with Metaheuristic Applications                     %
%  Published by John Wiley & Sons, USA, July 2010                    %
%  ISBN: 978-0-470-58246-6,   Hardcover, 347 pages                   %
% -----------------------------------------------------------------  %
% Citation detail:                                                   %
% X.-S. Yang, Engineering Optimization: An Introduction with         %
% Metaheuristic Application, Wiley, USA, (2010).                     %
%                                                                    % 
% http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html % 
% http://eu.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html  %
% -----------------------------------------------------------------  %
% ===== ftp://  ===== ftp://   ===== ftp:// =======================  %
% Matlab files ftp site at Wiley                                     %
% ftp://ftp.wiley.com/public/sci_tech_med/engineering_optimization   %
% ----------------------------------------------------------------   %

% Genetic Algorithm (Simple Demo) Matlab/Octave Program              %
% Written by X S Yang (Cambridge University) 2008                    % 
% This is a simple demo, there are more efficient packages available %
% both commercial and/or open source. For actual applications,       %
% more sophicated implementation is needed. So search the web to     % 
% to find a suitable package concerning genetic algorithms           %

% Usage: B1_ga   or  B1_ga(`x*exp(-x)');
function [bestsol, bestfun, count]=B1_ga(funstr)
global solnew sol pop popnew fitness fitold f range;
if nargin<1,
  % Easom Function with fmax=1 at x=pi
  funstr='-cos(x)*exp(-(x-3.1415926)^2)';
end
range=[-10 10];       % Range/Domain
% Converting to an inline function
f=vectorize(inline(funstr));
% Generating the initil population
rand('state',0');     % Reset the random generator
popsize=20;           % Population size
MaxGen=100;           % Max number of generations
count=0;              % counter
nsite=2;              % number of mutation sites
pc=0.95;              % Crossover probability
pm=0.05;              % Mutation probability
nsbit=16;             % String length (bits)
% Generating initial population
popnew=init_gen(popsize,nsbit);
fitness=zeros(1,popsize);    % fitness array
% Display the shape of the function
x=range(1):0.1:range(2); plot(x,f(x));
% Initialize solution <- initial population
for i=1:popsize,
   solnew(i)=bintodec(popnew(i,:));
end
% Start the evolution loop
for i=1:MaxGen,
   % Record as the history
   fitold=fitness; pop=popnew; sol=solnew;
 for j=1:popsize,
   % Crossover pair
   ii=floor(popsize*rand)+1; jj=floor(popsize*rand)+1;
   % Cross over
   if pc>rand,
      [popnew(ii,:),popnew(jj,:)]=...
                    crossover(pop(ii,:),pop(jj,:));
   % Evaluate the new pairs
   count=count+2;
   evolve(ii); evolve(jj);
   end
   % Mutation at n sites
   if pm>rand,
    kk=floor(popsize*rand)+1;   count=count+1;
    popnew(kk,:)=mutate(pop(kk,:),nsite);
    evolve(kk);
   end
 end  % end for j
   % Record the current best
   bestfun(i)=max(fitness);
   bestsol(i)=mean(sol(bestfun(i)==fitness));
end
% Display results
subplot(2,1,1); plot(bestsol); title('Best estimates');
subplot(2,1,2); plot(bestfun); title('Fitness');
% ------------- All sub functions ----------
% generation of initial population
function pop=init_gen(np,nsbit)
% String length=nsbit+1 with pop(:,1) for the Sign
pop=rand(np,nsbit+1)>0.5;
% Evolving the new generation
function evolve(j)
global solnew popnew fitness fitold pop sol f;
   solnew(j)=bintodec(popnew(j,:));
   fitness(j)=f(solnew(j));
   if fitness(j)>fitold(j),
      pop(j,:)=popnew(j,:);
      sol(j)=solnew(j);
   end
% Convert a binary string into a decimal number
function [dec]=bintodec(bin)
global range;
% Length of the string without sign
nn=length(bin)-1;
num=bin(2:end);   % get the binary
% Sign=+1 if bin(1)=0; Sign=-1 if bin(1)=1.
Sign=1-2*bin(1);
dec=0;
% floating point.decimal place in the binary
dp=floor(log2(max(abs(range))));
for i=1:nn,
   dec=dec+num(i)*2^(dp-i);
end
dec=dec*Sign;
% Crossover operator
function [c,d]=crossover(a,b)
nn=length(a)-1;
% generating random crossover point
cpoint=floor(nn*rand)+1;
c=[a(1:cpoint) b(cpoint+1:end)];
d=[b(1:cpoint) a(cpoint+1:end)];
% Mutatation operator
function anew=mutate(a,nsite)
nn=length(a); anew=a;
for i=1:nsite,
   j=floor(rand*nn)+1;
   anew(j)=mod(a(j)+1,2);
end