function [history,exitflag,lambda] = runfmincon
% =========================================================================
% This function calls the optimization function fmincon
%
% Credits:
% Ricardo Fontes Portal
% IDMEC - Instituto Superior Tecnico - Universidade Técnica de Lisboa
% ricardo.portal(at)dem(.)ist(.)utl(.)pt
%
% April 2009 original version
% March 2013 updated version
% =========================================================================
%% Start
global xlb xub x0;
% Set up shared variables with OUTFUN
history.x = [];
history.fval = [];
history.iter = 0;
history.cviol = 0;
history.fcalls =0;
%% Start with the default options
options = optimset;
options = optimset(options,'Display','none',... 'off',... 'iter',... 'notify',... 'final',...
    'Algorithm','interior-point',...'Trust-Region-Reflective',... 'interior-point',...'Active-Set',... 'interior-point',...
    'SubproblemAlgorithm' ,'cg',... (ldl-factorization,cg,lu-eig-factorization,cg-lu)
    'AlwaysHonorConstraints','bounds',...'none',... 
    'MaxIter',100,...
    'MaxFunEvals',1000,...
    'OutputFcn', @Outfun,...
    'PlotFcns' ,{@plotfval @plotconstrviolation},... @optimplotx @optimplotfunccount  @optimplotstepsize @optimplotfirstorderopt
    'DerivativeCheck','off',...
    'Diagnostics','off',...
    'GradObj','on',...      % if on -> consider user obj function gradient
    'GradConstr','off',...  % if on -> consider user contraints function gradient
    'FinDiffType','forward',... 'central',...
    'Hessian','bfgs',... 'lbfgs',...
    'TolX',1e-6,...1e-10,...         % default 1e-10
    'TolCon',0.003,...1e-6,...      % default 1e-06
    'TolFun',1e-6); % 1e-6);         % default 1e-06
%% Run FMINCON
% perform optimization
[x,fval,exitflag,output,lambda]=fmincon(@objfun,x0,[],[],[],[],xlb,xub,@constraints,options);
%% Output Function
    function stop = Outfun(x,optimValues,state)
        stop = false;
        switch state
            case 'init'
                hold on;
            case 'iter'
                % Concatenate current point and objective function
                % value with history.x must be a row vector.
                history.fval = [history.fval; optimValues.fval];
                history.x = [history.x; x];
            case 'done'
                disp(' ');
                %toc % returns the elapsed time
                history.iter = optimValues.iteration;
                history.cviol = optimValues.constrviolation;
                history.fcalls = optimValues.funccount;
                
            otherwise
        end
    end
end
