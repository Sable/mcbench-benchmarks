%solve_Kepler_for_E
%
%Inputs:  Mean Anomaly (must be in radians)
%         eccentricity
%         tolerance (example, 0.05; default tolerance is 1 * 10^-8
%
%Outputs: Eccentric Anomaly (in radians)
%
%This function solves Kepler's Equation for Eccentric Anomaly, given Mean
%Anomaly and eccentricity of an orbit.  It outputs a value of E between 0
%and 2*pi.  It utilizes a fixed-point iterative method to reach the 
%solution.  Kepler's equation looks like this:
%
%              Me = E - e sin(E)
%             
%This program automatically formats the output such that E is between
%0 and 2*pi
%
%Email problems, comments, or suggestions to:  John.Shelton@colorado.edu

function [E] = solve_Kepler_for_E(Me, e, tol)

%Check for proper inputs.  Apply default tolerance if applicable.
if nargin == 2
    %using default value
    tol = 10^-9;
elseif nargin > 3
    error('Too many inputs.')
elseif nargin < 2
    error('Too few inputs.')
end

breakflag = 0;

E1 = Me;
while breakflag == 0
    %Fixed-point iterative version of Kepler's Equation
    E = Me + e*sin(E1);
    
    %Break loop if tolerance is achieved
    if abs(E - E1) < tol
        breakflag = 1;
    end
    
    E1 = E;
end

%Format the answer so that it is between 0 and 2*pi
while E > (2*pi)
    E = E - 2*pi;
end
while E < 0
    E = E + 2*pi;
end
