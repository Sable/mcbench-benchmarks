%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL

%%This function plan a trajectory passing in N 
%% points using N-1 3th order polynomial:
%% the user must choose: intial,final and intermediate points
%% timePoints is a matrix [2,N] where first row is the time,second row
%% is the position points
%% the velocities this time are computed as a linear interpolation between
%% the position points
%% Output: a matrix [N-1,4] whose columns are the polynomail coefficients

function [TJ]=trajectory3VelComputed(timePoints)
N=length(timePoints);

if(N<2)
fprintf('Error: you defined only 1 point');
return;
end
TJ=[];

for k=1:N-1
    tk=timePoints(1,k);
    tk1=timePoints(1,k+1);
    qk=timePoints(2,k);
    qk1=timePoints(2,k+1);
    if(k==1)
        velk=0;
    else
        velk=(qk-timePoints(2,k-1))/(tk-timePoints(1,k-1));    
    end
    
    if(k==N-1)
        velk1=0;
    else
       velk1=( timePoints(2,k+1)- timePoints(2,k))/(timePoints(1,k+1)-timePoints(1,k));       
    end

    if(sign(velk)~=sign(velk1))
        velk=0;
        velk1=0;
    else
        velk=0;
        velk1=(velk+velk1)/2;
        
    end
 
    coeffs=pol3interpol(tk,tk1,qk,qk1,velk,velk1);
    TJ=[TJ;coeffs'];
end


end