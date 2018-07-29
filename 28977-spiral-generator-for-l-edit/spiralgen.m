function [outcommand] = spiralgen(n,initangle,endangle,a,b)
%--
%sean hatch - 10/7/10
%generates L-Edit command for drawing an Archimedean spiral using 
%L-edit's path tool.
%--
%n is number of points in path
%initangle is radians until path begins
%endangle is radians until path ends
%a,b: spiral parameters (in locator units!) (note: if your spiral looks
%"jagged" in L-edit because of rounding error, you need only change the
%value of the locator units!
clf

outcommand = 'path -!';
cpts = zeros(n,2);
%calculate spiral coordinates (in polar coordinates)
theta = linspace(initangle,endangle,n);
r = a + b.*theta;

%convert to cartesian and round values 
%(i think locator units must be integer values) 
cpts(:,1) = round(r.*cos(theta));
cpts(:,2) = round(r.*sin(theta));

%this will build the string that is to be copied into L-edit's comnand
%window.
for k = 1:n
        outcommand =[outcommand,' ',int2str(cpts(k,1)),' ',int2str(cpts(k,2))];
end

%plot r,theta values in blue and rounded cartesion values in red
polar(theta,r);
hold on
plot(cpts(:,1),cpts(:,2),'r');

end