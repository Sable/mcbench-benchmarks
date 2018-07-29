function[Fullw]=fwhm(data)
% This function determines  full width at half 
% maximum of a peak if the input data  has two columns:
% Column 1 = x
% Column 2 = y
%Coded by Ebo Ewusi-Annan
%University of Florida 
%August 2012
x = data(:,1);
y= data(:,2);
maxy = max(y); 
f = find(y==maxy); 
cp = x(f);% ignore Matlabs suggestion to fix!!!
y1= y./maxy;
ydatawr(:,1) = y1;
ydatawr(:,2) = x;
newFit1=find(x>= cp);
newFit2=find(x < cp);
ydatawr2 = ydatawr(min(newFit1):max(newFit1),:);
ydatawr3 = ydatawr(min(newFit2):max(newFit2),:);
sp1 = spline(ydatawr2(:,1),ydatawr2(:,2),0.5);
sp2 = spline(ydatawr3(:,1),ydatawr3(:,2),0.5);
Fullw = sp1-sp2;
 end
