% Solution of Fractional Optimal Control Problems using Rational
% Approximation
% [1] C. Tricaud and Y.Q. Chen: Solving Fractional Order Optimal Control
% Problems in RIOTS_95 - A General-Purpose Optimal Control Problem Solver,
% Proceedings of the 3rd IFAC Workshop on Fractional Differentiation and
% its Applications, Ankara, Turkey, 05 - 07 November, 2008.
% written by C. Tricaud. 11/20/2008
% Usage: Choose the category of problem you wish to solve using the
% "problem" variable and choose the order of the system's dynamics with
% "N". Please refer to [1] for additional information regrading the
% examples

clear all
global N A B C D problem

RIOTSPATH = 'C:\Documents and Settings\ECE\My Documents\MATLAB\';
addpath([RIOTSPATH 'RIOTS_FOCPOust;', ...
    RIOTSPATH 'RIOTS_FOCPOust\systems;', ...
    RIOTSPATH 'RIOTS_FOCPOust\f2c;', ...
    RIOTSPATH 'RIOTS_FOCPOust\drivers;'], '-begin');


problem = 2; % 1=LTI, 2=LTV, 3=Bang-Bang
alpha=0.9;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if problem == 1 % LTI Problem

    tgrid=0:0.01:1;
    w_L=1e-2;
    w_H=alpha*1e2;
    N=4;
    [A,B,C,D] = ssdata(ora_foc(-alpha,N,w_L,w_H));
    x0 = 1;
    x0 = x0*[1;zeros(length(C')-1,1)]/(C*[1;zeros(length(C')-1,1)]);
    u0 = zeros(1, length(tgrid));
    parameters = [alpha, w_L, w_H, N];
    [u_openloop_optimal,x_ol_optml,f] = riots(x0, u0, tgrid, [], [], parameters, [100, 0, 1], 4);
    figure(1)
    xlabel('t', 'FontSize', 17);
    ylabel('x(t)', 'FontSize', 17);
    set(gca, 'LineWidth', 1.5, 'FontSize', 15)
    plot(tgrid,C*x_ol_optml+D*u_openloop_optimal, 'LineWidth', 2, 'Color','black')
    hold on
    figure(2)
    xlabel('t', 'FontSize', 17);
    ylabel('u(t)', 'FontSize', 17);
    set(gca, 'LineWidth', 1.5, 'FontSize', 15)
    plot(tgrid,u_openloop_optimal, 'LineWidth', 2, 'Color','black')
    hold on

elseif problem == 2 % LTV Problem

    tgrid=0:0.01:1;
    w_L=1e-2;
    w_H=alpha*1e2;
    N=5;
    [A,B,C,D] = ssdata(ora_foc(-alpha,N,w_L,w_H));
    x0 = 1;
    x0 = x0*[1;zeros(length(C')-1,1)]/(C*[1;zeros(length(C')-1,1)]);
    u0 = zeros(1, length(tgrid));
    parameters = [alpha, w_L, w_H, N];
    [u_openloop_optimal,x_ol_optml,f] = riots(x0, u0, tgrid, [], [], parameters, [100, 0, 1], 4);
    figure(1)
    xlabel('t', 'FontSize', 17);
    ylabel('x(t)', 'FontSize', 17);
    set(gca, 'LineWidth', 1.5, 'FontSize', 15)
    plot(tgrid,C*x_ol_optml+D*u_openloop_optimal, 'LineWidth', 2, 'Color','black')
    hold on
    figure(2)
    xlabel('t', 'FontSize', 17);
    ylabel('u(t)', 'FontSize', 17);
    set(gca, 'LineWidth', 1.5, 'FontSize', 15)
    plot(tgrid,u_openloop_optimal, 'LineWidth', 2, 'Color','black')
    hold on

elseif problem ==3 % Bang-bang Problem

    tgrid=0:0.01:1;
    w_L=interp1([0.6,0.7,0.8,0.9,1],[1.5e-2,3e-2,4e-2,8e-2,1e-1],alpha);
    w_H=interp1([0.6,0.7,0.8,0.9,1],[4.5,6,10,10,10],alpha);
    N=1;
    [A,B,C,D] = ssdata(ora_foc(-alpha,N,w_L,w_H));
    init = interp1([0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1],[207 185 150 113 83 61 46 36 30],alpha);
    x0 = 0;
    x01 = x0*B;
    x02 = x0.*x01+1;
    x03 = x0.*x01;
    x04 = x0.*x01;
    x0 = [x01,x02,x03,x04];
    x0 = [x0;[0 1 0 0];[init 0 20 200]];
    u0 = zeros(1, length(tgrid));

    parameters = [alpha, w_L, w_H, N];

    [u_openloop_optimal,x_ol_optml,f] = riots(x0, u0, tgrid, -2, 1, parameters, [100, 0, 1], 4);

    Tf = x_ol_optml(end,1);

    figure(1)
    plot(tgrid.*Tf,[C*x_ol_optml(2:end-1,:)+D*u_openloop_optimal;x_ol_optml(1,:)], 'LineWidth', 2, 'Color','black')
    xlabel('t', 'FontSize', 17);
    ylabel('x(t)', 'FontSize', 17);
    set(gca, 'LineWidth', 1.5, 'FontSize', 15);
    figure(2)
    plot(tgrid.*Tf,u_openloop_optimal, 'LineWidth', 2, 'Color','black')
    xlabel('t', 'FontSize', 17);
    ylabel('u(t)', 'FontSize', 17);
    set(gca, 'LineWidth', 1.5, 'FontSize', 15);

end