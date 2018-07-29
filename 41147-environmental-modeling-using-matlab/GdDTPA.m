function GdDTPA
% GdDTPA reaction advection steady state      
%    using MATLAB fzero for solution of implicit equation                    
%
%   $Ekkehard Holzbecher  $Date: 2006/05/03 $
%--------------------------------------------------------------------------
xdata = [0.22 0.42 0.84 1.66 3.33 5 10 15 20 25 30];
ydata = [54.7 54.3 54.2 54.0 52.8 52.4 51.0 49.9 48.7 47.6 46.2];
cin = 55; 
aeta = 4304; 
beta = 5937;
for i=1:size(xdata,2)
    yfunc(i) = fzero (@GD,cin,odeset,cin,beta,aeta,xdata(i));
end
plot (xdata,ydata,'o',xdata,yfunc);
xlabel ('distance [m]'); ylabel ('Gd concentration [ng/ml]');

function y = GD(c,cin,beta,aeta,x)
y = x+(c+2*beta*log(c)-beta*beta/c-cin-2*beta*log(cin)+beta*beta/cin)/aeta;