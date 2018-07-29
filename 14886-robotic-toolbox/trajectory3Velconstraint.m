%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%This function plan a trajectory passing in N 
%% points using N-1 3th order polynomial:
%% the user must choose: intial,final and intermediate points
%% timePoints is a matrix [3,N] where first row is the time,second row
%% is the position points, third row is the velocities
%% intermediate velocities (initial and final ones are imposed to be 0)
%% Output: a matrix [N-1,4] whose columns are the polynomail coefficients

function [TJ]=trajectory3Velconstraint(timePointsVels)
N=length(timePointsVels);

if(N<2)
fprintf('Error: you defined only 1 point');
return;
end
TJ=[];
%%set the initial and final velocities to 0
timePointsVels(3,1)=0;
timePointsVels(3,end)=0;
for k=1:N-1
    tk=timePointsVels(1,k);
    tk1=timePointsVels(1,k+1);
    qk=timePointsVels(2,k);
    qk1=timePointsVels(2,k+1);
    velk=timePointsVels(3,k);
    velk1=timePointsVels(3,k+1);
    coeffs=pol3interpol(tk,tk1,qk,qk1,velk,velk1);
    TJ=[TJ;coeffs'];
end


end