% Dasslc test problem
% requires files: dydt.m

% global debug level
%   0 : no output
%   1 : write output values only
%  10 : write all results from m-files
% 100 : confirm exit from each m-file with <RETURN>

global DEBUG;
DEBUG  = 1;

t0  = 0.0;        % initial value for independent variable
tf  = 1.0;        % final value for independent variable
y0  = [3 6 5]';   % initial state variables
rtol= 1e-4;       % relative tolerance
atol= 1e-4;       % absolute tolerance
rpar=[4 6];       % optional arguments passed to residual and jacobian functions

tspan=[t0,tf];
[t,y,yp,outp]=dasslc('dydt',tspan,y0,rpar,rtol,atol);

if ( DEBUG > 0 )
  if ( outp >= 0 )
    disp(sprintf('Integration completed successfully, %d points',length(t)));
    
    % result vector contains t in row 1, y(k) in row k
    for i = 1:size(y,1)
      buf = sprintf('% .2e ',y(i,:));
      disp(sprintf('pt %3d: t=% .2e y = %s',i,t(i),buf));
    end
    plot(t,y);
  else
    disp(sprintf('Integration failed: result flag = %d',outp));
  end
end
