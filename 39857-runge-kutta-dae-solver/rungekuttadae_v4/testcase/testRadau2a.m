function testRungeKutta()
%testRungeKutta Tests the Radau II A method on a simple pendulum problem
% with index 2.
%
%DATE   15.01.2013
%AUTHOR Stefan Schießl

    M = 5; 
        
    task.deltat = 0.05;
    task.idxDynamicEquations = 1:4;
    task.fex = @pendulumF;
    task.dfex = @pendulumDF;
    task.dynPoints = 1;
    
    yinit = zeros(M,1);
    yinit(3,1:1) = -1; 
    yinit(2,1:1) = 1; 

    rkcfg.useStabilizerDeltat = 1;
    rkcfg.tolabs   = 1e-12;    % runge kutta iteration - absolute tolerance
    rkcfg.tolrel   = 0;        % runge kutta iteration - relative tolerance
    rkcfg.maxit    = 100;      % runge kutta iteration - max. number of iterations
    rkcfg.printConsole = 1;
        
    t0 = 0;
    t1 = 4;
    
    disp('Radau IIa s=1');
    rkcfg.radaus = 1;
    run(t0, t1, yinit, task, rkcfg);
    
    disp('Radau IIa s=2');
    rkcfg.radaus = 2;
    run(t0, t1, yinit, task, rkcfg);

end

function run(t0, t1, yinit, task, rkcfg)
%run Calculate the numerical solution of the given problem from 
% time t0 to t1 with the given initial values.
    yold = yinit;
    i = 1;
    deltat = task.deltat;
    for t=t0:deltat:(t1-deltat)
        y = radau2a(task.fex, task.dfex, ...
                          task.idxDynamicEquations, task.dynPoints, ...
                          yold, deltat, rkcfg);
        tnew = t + deltat;
        yold = y;   
        figure(1)
        plot([0 y(1,:)], [0 y(2,:)]);
        axis([-1 1 -1 1]);
        title(['t=' num2str(tnew) ' s=' num2str(i)]);
        pause(0.1);
        i = i+1;
    end
end