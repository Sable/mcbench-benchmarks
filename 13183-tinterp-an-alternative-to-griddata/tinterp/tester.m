function tester

% Tester for tinterp, comparing tinterp and griddata on the "peaks"
% example.
%
% This tester compares the accuracy of the linear and quadratic methods in
% tinterp with the cubic method in griddata. 
%
% The comparison is run for a series of different scattered data sets. Sets
% with 100 - 500 points are used and at each level 5 different random sets
% are used and the average results taken.
%
% Overall you should see that the quadratic method in tinterp is superior
% to the cubic method in griddata. The linear methods in tinterp and
% griddata are identical.
%
% NOTE: Random data sets are used! The results will be slightly different
% each time you call tester!
%
% Example:
%
%   tester;     % Runs the tester

% This example is only one of many scattered data interpolation benchmarks
% that could be used. I don't pretend it's exhaustive. If you have some other 
% test cases that contradict/support these results, let me know:
%
%   d_engwirda@hotmail.com
%
% Darren Engwirda - 2006.


close all, clc


% Cartesian grid to interpolate onto
n      = 50;                    % Number of points
x      = linspace(-3,3,n);
y      = linspace(-3,3,n);
[x,y]  = meshgrid(x,y);         % xy matrices
fe     = peaks(x,y);            % Exact solution

% Number of points in scattered dataset
num = 100:100:500;

for j = 1:length(num)
    
    % Average over a few random scattered datasets
    elin  = 0;
    equad = 0;
    ecub  = 0;
    N     = 5;
    for k = 1:N
        
        % Scattered data
        p = 6*(rand(num(j),2)-0.5);     % xy vector
        t = delaunayn(p);               % Triangulation
        f = peaks(p(:,1),p(:,2));       % Exact solution at vertices
        
        % Interpolate onto Cartesian grid
        flin  = tinterp(p,t,f,x,y,'linear');            % Linear interpolation via tinterp
        fquad = tinterp(p,t,f,x,y,'quadratic');         % Quadratic interpolation via tinterp
        fcub  = griddata(p(:,1),p(:,2),f,x,y,'cubic');  % Cubic interpolation via griddata
        
        % Deal with points outside the convexhull (this doesn't influence accuracy...)
        i        = isnan(fquad);
        fquad(i) = fe(i);
        flin(i)  = fe(i);
        fcub(i)  = fe(i);
        
        % Evaluate error per gridpoint
        elin  = elin + sum(sum(abs(fe-flin)))/n^2;
        equad = equad + sum(sum(abs(fe-fquad)))/n^2;
        ecub  = ecub + sum(sum(abs(fe-fcub)))/n^2;
        
    end
    
    eL(j) = elin;
    eQ(j) = equad;
    eC(j) = ecub;
    
end

figure, trimesh(t,p(:,1),p(:,2),f), title('Exact solution on scattered data')

figure, mesh(x,y,fe), title('Exact solution on Cartesian mesh')

figure, mesh(x,y,fquad), title('Quadratic interpolation on Cartesian mesh')

figure, mesh(x,y,fcub), title('Cubic interpolation on Cartesian mesh')

figure, loglog(num,eL,'b',num,eQ,'r',num,eC,'k'), grid on

legend('Linear (tinterp)','Quadratic (tinterp)','Cubic (griddata)')

title('Interpolation accuracy')
xlabel('Number of points in scattered data set')
ylabel('Error per grid point')