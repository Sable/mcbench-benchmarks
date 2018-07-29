function [y, details] = radau2a( fex, dfex, idxDynamicEquations, ...
                                       idxDynamicPoints, yold, deltat, config, yest )
%radau2a Implementation of the radauIIa rungekutta method for differential
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
%         - config.radaus  Stage of the radau tableau. Default 1.
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
%DATE     15.01.2012
%
%COPYRIGHT 2012
%LICENCE   Published under the MathWorks licence.

if (~exist('config','var'))
    [y, details] = rungekutta( fex, dfex, idxDynamicEquations, ...
                                       idxDynamicPoints, yold, deltat );
else
    if (isfield(config, 'radaus'))
        if (config.radaus == 1)
            config.c = 1;
            config.A = 1;
            config.b = 1;
        elseif (config.radaus == 2)
            config.c = [1/3; 1];
            config.A = [[5/12, -1/12];
                       [3/4, 1/4]];
            config.b = [3/4; 1/4];
        elseif (config.radaus == 3)
            config.c = [(4-sqrt(6))/10; (4+sqrt(6))/10; 1];
            config.A = [[(88-7*sqrt(6))/360,     (296-169*sqrt(6))/1800, (-2+3*sqrt(6))/225];
                       [(296+169*sqrt(6))/1800, (88+7*sqrt(6))/360,     (-2-3*sqrt(6))/225];
                       [(16-sqrt(6))/36, (16+sqrt(6))/36, 1/9]];
            config.b = [(16-sqrt(6))/36; (16+sqrt(6))/36; 1/9];
        else
           error('radau2a:StageNotFound', ['The desired Radau IIA stage s=' num2str(config.radaus) ' is not implemented.']); 
        end
    else
        error('radau2a:VariableNotFound', 'No Radau IIA stage given, please add a value for config.radaus.'); 
    end
    [y, details] = rungekuttadae( fex, dfex, idxDynamicEquations, ...
                                       idxDynamicPoints, yold, deltat, config ); 
end

end

