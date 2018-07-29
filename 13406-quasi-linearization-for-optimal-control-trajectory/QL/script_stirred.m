%------------------------------- getting ready ----------------------------
clc
clear all
close all
%--------------------------------------------------------------------------

global A E
tol  = 0.001;
max  = 20;
init = 0;
xn   = init*ones(2,78);          % estimation for initial trejctory for states
pn   = init*ones(2,78);          % estimation for initial trejctory for co-states
check = [0.01:0.01:0.78];

for loop = 1:max
    xh1 = [0 0 1 0];             % initial conditions for homogeneous solution1
    xh2 = [0 0 0 1];             % initial conditions for homogeneous solution2
    xp0 = [0.05 0 0 0];          % initial conditions for particular  solution0
    a = 0;
    b = 0.01;
    for I=1:78
        t       = [xn(:,I)' pn(:,I)'];
        pointer = 100*loop+I
        clc
        A  = calculate_matrix(t);     
        x1 = [-2*(t(1)+0.25)+(t(2)+0.5)*exp(25*t(1)/(t(1)+2))-(t(1)+0.25)^2*t(3)/0.2    0.5-t(2)-(t(2)+0.5)*exp(25*t(1)/(t(1)+2))];
        x2 = [-2*t(1)+2*t(3)-t(3)*(t(2)+0.5)*(50/(t(1)+2)^2)*exp(25*t(1)/(t(1)+2))+t(3)^2*(t(1)+0.25)/0.2+t(4)*(t(2)+0.5)*(50/(t(1)+2)^2)*exp(25*t(1)/(t(1)+2)) -2*t(2)-t(3)*exp(25*t(1)/(t(1)+2))+t(4)*(1+exp(25*t(1)/(t(1)+2)))]; 
        e1 = [x1 x2]';
        e2 = A*t';
        E  = e1 - e2;
        
        clear t1 c
        x0  = [xp0 xh1 xh2]';
        [t1,c]  = ode45('stirred_model', [a b], x0);

        L       = length(t1);
        X1p(I)  = c(L,1);
        X2p(I)  = c(L,2);
        P1p(I)  = c(L,3);
        P2p(I)  = c(L,4);
        xp0     = [X1p(I) X2p(I) P1p(I) P2p(I)];
        
        X11h(I) = c(L,5);
        X12h(I) = c(L,6);
        P11h(I) = c(L,7);
        P12h(I) = c(L,8);
        xh1     = [X11h(I) X12h(I) P11h(I) P12h(I)];        
        
        X21h(I) = c(L,9 );
        X22h(I) = c(L,10);
        P21h(I) = c(L,11);
        P22h(I) = c(L,12);
        xh2     = [X21h(I) X22h(I) P21h(I) P22h(I)];        

         
        % simulation time for next interval of integrtion
        a = b;
        b = b + 0.01;
        
    end
    
    % calculting constant to satisfy boudary condition
    B1  = [0 0]'-[P1p(78) P2p(78)]';
    ph1 = [P11h(78) P12h(78)]';
    ph2 = [P21h(78) P22h(78)]';
    A1  = [ph1 ph2];
    const = A1\B1;
    
    % calculation of states and costates
    state   = [X1p;X2p] + [const(1)*X11h;const(1)*X12h]+[const(2)*X21h;const(2)*X22h];
    costate = [P1p;P2p] + [const(1)*P11h;const(1)*P12h]+[const(2)*P21h;const(2)*P22h];
    test = terminate(state,xn,costate,pn);
    fprintf('Terminate Check = %f\n',test);
    const
    pause
    clc
    if test < tol
        break
    end

    xn = state;
    pn = costate;
    
end

plot(check,state,'-');
title('Optimal Trejctory');
grid on
%--------------------------------------------------------------------------
for j = 1:78
   u(j)    = 0.5*costate(1,j)*(state(1,j)+0.25);
   intg(j) = state(1,j)^2+state(2,j)^2+0.1*u(j)^2;
end
figure
plot(check,u);
title('U^*');
grid on
J = integrate(check,intg);
fprintf('Optimal Cost = %f\n',J);