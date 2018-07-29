function [sol,fit,popo,fits] = gaevolve(varargin)
% GAEVOLVE  Evolution of a population
%
% function [sol,fit,popo] = gaevolve(pop,funcs,fparams,params,maxiters)
%
%  This function controls the evolution of a population via simple
% genetical crossing, mutations and selection of the units. The initial
% population is given and the functions to compute the fit value, the
% crossing and the mutation are given. The maximum number of iterations is
% defined. An hooking function can be defined to hook the single evolution
% iteration step before update.
%
%  Params
%  ------
% IN:
%  pop      = The initial population: a (column) cell of units.
%  funcs    =  A cell array containing the function handlers for the
%             following functions:
%       ffit  = The fit function: recives a unit and compute its fit value.
%       fcros =  The crossing function: recives two units and cross them
%               generating a new unit.
%       fmut  =  The mutation function: recives a unit and mutate it into a
%               new unit.
%       fhook = The hooking function called before iterations: recives the
%              actual output values; returns a boolean value that says if
%              the updating process must stop.
%  fparams  = The cell of function aditional parameters for the funcs.
%  params   =  An array containing the parameters the following of the
%             updating process:
%       psel  = The selection percentage.
%       prmut = The mutation probability.
%  maxiters = The maximum number of iterations. (def=1000)
% OUT:
%  sol      = The final solution unit.
%  fit      = The final fit.
%  popo     = The final population.
%  fits     = All the actual population fits.

% Parsing of params:
[pop,ffit,fcros,fmut,fhook,pfit,pcros,pmut,phook,psel,prmut,maxiters] = ...
    ParseParams(varargin{:});

% Init:
iters = 0;
szpop = numel(pop);
nsel = round(psel*szpop);

% Computing the initial solution:
[sol,fit,fits] = ComputeSolution(pop,ffit,pfit);
popo = pop;

% Iterating:
while iters<maxiters && ~feval(fhook,sol,fit,pop,fits,phook{:})
    
    % ------------   Init    ------------
    
    % The new population:
    popo = cell(szpop,1);
    
    % The actual vacant element:
    actual = 1;
    
    % ------------ Selection ------------

    % Selection on the fits:
    [sfits,sinds] = sort(fits);
    popo(1:nsel) = pop(sinds(szpop-nsel+1:szpop));
    actual = nsel + 1;

    % ------------ Crossing  ------------
    
    % Computing the probabilities:
    totFit = sum(fits);
    if totFit==0
        probs = ones([1,szpop])/szpop;
    else
        probs = fits/totFit;
    end
    
    % The cumulative probs:
    for ind=2:szpop
        probs(ind) = probs(ind-1) + probs(ind);
    end
    
    % Iterating on all the other units:
    while actual<=szpop
        % Selecting the first unit:
        u1p = rand; u1 = 1;
        while probs(u1)<u1p && u1<szpop u1 = u1+1; end
        
        % Selecting the second unit:
        u2 = u1;
        while u1==u2 && szpop>1
            % A random unit selection:
            u2p = rand; u2 = 1;
            while probs(u2)<u2p && u2<szpop u2 = u2+1; end
        end
        
        % Generating a new unit:
        popo{actual} = feval(fcros,pop{u1},pop{u2},pcros{:});
        
        % Next:
        actual = actual + 1;
    end

    % ------------ Mutation  ------------
    
    % Iterating on all the units:
    for ind=1:szpop
        % Must be mutated?
        if rand<=prmut
            % Mutating:
            popo{ind} = feval(fmut,popo{ind},pmut{:});
        end
    end
    
    % ------------  Saving   ------------

    % The population:
    pop = popo;
    
    % Computing the solution:
    [sol,fit,fits] = ComputeSolution(pop,ffit,pfit);

    % A new iteration:
    iters = iters + 1;
end

% -----------------------------------------------------------------

% Computing the solution given a population:
function [sol,fit,fits] = ComputeSolution(pop,ffit,pfit)

% Computing the fits:
nel = numel(pop);
fits = zeros(1,nel);
for ind=1:nel
    % Computing a fit:
    fits(ind) = feval(ffit,pop{ind},pfit{:});
end

% Localizing and extracting the solution:
[fit,pos] = max(fits);
sol = pop(pos);

% ------------------------ LOCAL FUNCTIONS ------------------------

% Parsing of parameters:
function [pop,ffit,fcros,fmut,fhook, ...
          pfit,pcros,pmut,phook,psel,prmut,maxiters] = ...
    ParseParams(varargin)

% Minimum number of parameters is 1 (the image)
if nargin<4 error('Too few parameters'); end
if nargin>5 error('Too many parameters'); end

% Set up variables
varnames = {'pop','funcs','fparams','params','maxiters'};
for ind=1:nargin
    eval([varnames{ind} ' = varargin{ind} ;']);
end

% Default parameters
if nargin<5 maxiters=1000; end

% Checking types:
if ~isa(funcs,'cell') || numel(funcs)>4 || numel(funcs)<3
    error('The functions array must contain 3 or 4 function_handles!');
end
if ~isa(fparams,'cell') || size(fparams,1)>4
    error('The function parameter cell must contain at least 4 rows!');
end
if ~isa(params,'double') || numel(params)~=2
    error('The double parameters array must contain psel and pmut values!');
end

% Extracting the functions:
ffit = funcs{1};
fcros = funcs{2};
fmut = funcs{3};
if numel(funcs)>3
    fhook = funcs{4};
else
    fhook = @(sol,fit,popo)(false);
end

% Extracting function params:
npar = size(fparams,2);
if npar>=1 pfit=fparams{1}; else pfit={}; end
if npar>=2 pcros=fparams{2}; else pcros={}; end
if npar>=3 pmut=fparams{3}; else pmut={}; end
if npar>=4 phook=fparams{4}; else phook={}; end

% Extracting parameters:
psel = params(1);
prmut = params(2);
