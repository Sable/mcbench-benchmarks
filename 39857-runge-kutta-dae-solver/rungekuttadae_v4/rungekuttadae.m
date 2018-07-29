function [y, details] = rungekuttadae( fex, dfex, idxDynamicEquations, ...
                                       idxDynamicPoints, yold, deltat, config, yest )
%rungekutta Implementation of a general rungekutta method for differential
% algebraic equations. 
% The input y has size(y)=[M,N] where M is the amount of equations
% and N is the amount of points in the dicretization.
% The righthand-side with the respective derivative 
% is needed and the indices of the dynamic and algebraic equations.
% Every point / variable that is not specifically declared dynamic will
% be treated as an algebraic one.
% The differential algebraic system has the following structure:
%      dt/du = f(u,v)  
%          0 = g(u,v)  where u are the dynamic equations and 
%                      v the algebraic ones.
%
%INPUT: fhandle  fex          Right hand side of the DAE system.
%       fhandle  dfex         Jacobian of the right hand side.
%       vector   idxDynamicEquations  Indices of the equations that are
%                                     dynamic (ergo contain dy/dt). All
%                                     remaining equations are considered
%                                     algebraic.%                                     
%       vector   idxDynamicPoints  Indices of the points that are
%                                  calculated dynamically. All other
%                                  points are regarded as points with only
%                                  algebraic equations.
%       matrix   yold     Solution for the time t.
%       double   deltat   Time discretization length.
%       struct   config   Configuration of the algorithm. Every config
%                         value is optional.
%         - config.A        Butcher tableau. Default 1.
%         - config.b        "
%         - config.tolabs   Absolute tolerance of the newton algorithm.
%                           Default 1e-8.
%         - config.tolrel   Relative tolerance of the newton algorithm.
%                           Default 1e-12.
%         - config.maxit    Maximum allowed iterations of the newton
%                           algoritm.
%                           Default 100.
%         - config.useStabilizerDeltat  The algebraic equations are 
%                                       multiplied by deltat to stabilize
%                                       the newton convergence.
%                                       Default 0.
%         - config.printConsole  > 0 = Console output enabled,
%                                the higher the value the more detailed
%                                the output.
%       matrix   yest     Estimated solution for time t+deltat.
%
%OUTPUT: matrix   y       Solution for the time t+deltat.
%        struct   details Detailed information on the solution.
%             - details.res      Residuum of the solution.
%             - details.iter     Number of newton iterations.
%             - details.message  Formatted output of the details.
%             - details.stifflyAccurate  1 if a stiffly accurate method was
%                                        used, otherwise 0.
%
%AUTHOR:  Stefan Schießl
%DATE     07.08.2012
%
%COPYRIGHT 2013
%LICENCE   Published under the MathWorks licence.
if (~exist('yest','var'))
   yest = yold; 
end

%% Argument handling
if (~exist('config','var'))
    % Default is implicit euler
    config.c = 1;
    config.A = 1;
    config.b = 1;
    config.tolabs = 1e-8;
    config.tolrel = 1e-12;
    config.maxit = 100;
    config.printConsole = 1;
else
    if (~isfield(config, 'A') || ...
        ~isfield(config, 'b'))
        error('rungekutta:call', ...
              'The config argument needs to contain the fields A, b.');       
    end
	if (~isfield(config, 'tolabs'))
        config.tolabs = 1e-8;
	end
    if (~isfield(config, 'tolabs'))
        config.tolrel = 1e-12;
    end
    if (~isfield(config, 'tolabs'))
        config.maxit = 100;
    end
    if (~isfield(config, 'printConsole'))
        config.printConsole = 1;
    end
    if (~isfield(config, 'useStabilizerDeltat'))
        config.useStabilizerDeltat = 0;
    end
end

%% Construct internal parameter struct for the calculation
para.countEquations = size(yold,1); % M
para.countPoints = size(yold,2);    % N
para.countEquationsTimesPoints = para.countEquations*para.countPoints;
para.deltat = deltat;
para.fex = fex;
para.dfex = dfex;
%para.c = config.c;
para.A = config.A;
para.b = config.b;
para.useStabilizerDeltat = config.useStabilizerDeltat;

para.idxAlgebraicEquations = 1:para.countEquations;
para.idxAlgebraicEquations = ...
    para.idxAlgebraicEquations(~ismember(para.idxAlgebraicEquations, idxDynamicEquations));
para.idxDynamicEquations = idxDynamicEquations;
para.dynPoints = idxDynamicPoints;

% Flat index structure, indicates which variable is dynamic or algebraic.
% (length(iD)+length(iA)=M*N)
[iD, iA] = getIdxFlatY( para );
para.idxFlatDynamic = iD;
para.idxFlatAlgebraic = iA;

%% Which level s is being used?
s = length(para.b);
para.s = s;

% If level s>1 more variables are needed.
% e.g. yoldrk = [yold; yold; yold];
%               <-------s=3------>
yoldrk = (ones(s,1)*yold(:)')';
yoldrk = yoldrk(:);

yestrk = (ones(s,1)*yest(:)')';
yestrk = yestrk(:);

%% Newton Algorithm
tolabs = config.tolabs;
tolrel = config.tolrel;
maxit = config.maxit;

[y, details] = newton(@(y, yold2) rkFun(y, yoldrk, para), ...
                      @(y) rkDFun(y, para), ...
                      yestrk, yoldrk, tolabs, tolrel, maxit, 0 );
if (config.printConsole > 0)
    fprintf(details.message);
end
                  
%% Update step
% The solution of the newton are only the ki and li for the next step.
cE = para.countEquations;
cP = para.countPoints;

% Stiffly accurate method?
A = config.A;
b = config.b;
if (min(b == A(end,:)') == 1)
    methodMessage = 'stiffly accurate method found, direct update.\n';
    if (config.printConsole > 1)
        fprintf(methodMessage);
    end
    details.stifflyAccurate = 1;
    % Shortcut update (for stiff accurate)
    y = reshape(y((s-1)*cE*cP+1:s*cE*cP), cE, cP);
else
    methodMessage = 'normal method found, update formula used.\n';
    if (config.printConsole > 1)
        fprintf(methodMessage);
    end
    details.stifflyAccurate = 0;
    % Update according to the Runge Kutta scheme.
    fex = getFex(y,para);

    % l1 = preAMatrix(iA,1), l2 = preAMatrix(iA,2), ...
    preAMatrix = reshape(y, cE*cP, s);
    preAMatrix = preAMatrix(iA,:) - yoldrk(iA)*ones(1,s);

    ynew = zeros(cE*cP,1);
    if (~isempty(iD))
        ynew(iD) = yoldrk(iD) + fex(:,iD)'*b*deltat;
    end
    ynew(iA) = yoldrk(iA) + (preAMatrix*(inv(A)'*b));

    % The output with the same dimension as the input, not a ugly flat vector.
    y = reshape(ynew, cE, cP);
end
details.message = [details.message methodMessage];

end

