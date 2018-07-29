    function [yM] = model(xm, a)
    %
    % Model (linear and nonlinear) definitions
    % for the function numerFminS() as a 'fun'
    %
    % Linear (dataLRM.txt):
    %yM = zeros(2,1);
    %yM=a(1)*xm+a(2);
    % Second degree polynomial (dataNRM.txt):
    yM = zeros(3,1);
    yM=a(1)*xm.^2+a(2)*xm+a(3);
    % Power exponet (dataERM.txt):        
    %yM = zeros(2,1);
    %yM=a(1)*xm.^a(2);    