function [ hExtrude,hPlate1,hPlate2 ] = Extrude( x1,x2,h1,h2,dir,closed )
% global xx1
% global xx2
% global xx3

% This Function calculates and return n x 2 matrices of xx1, xx2 and xx3. these will be extruded from h1 to h2 in the 'dir' axis 
% 
%   Typical Call Extrude( x1,x2,h1,h2,'y' ):
% 
%   x1,x2: vectors of order n x 1 specifying the profile of the curve to be extruded.
%   h1,h2: starting and end value along a coordinate eg.-5,10
%   dir  : String to specify axis of extrution 'x' or 'y' or 'z' (Only along these axes...!)
% 
%   After this execution, surface(xx1,xx2,xx3) will give u the extruded surface
%   

n=length(x1);

if dir=='y'
    xx1=[x1 x1];
    xx2=[repmat(h1,n,1) repmat(h2,n,1)];
    xx3=[x2 x2];
elseif dir =='x'
    xx1=[repmat(h1,n,1) repmat(h2,n,1)];
    xx2=[x1 x1];
    xx3=[x2 x2];
else
    xx1=[x1 x1];
    xx2=[x2 x2];
    xx3=[repmat(h1,n,1) repmat(h2,n,1)];
end

hExtrude=surf(xx1,xx2,xx3,-4+xx3./max(max(xx3)));


if strcmp(closed,'closed')==1
    hold on
    hPlate1=fill3(xx1(:,1),xx2(:,1),xx3(:,1),'g');
    hPlate2=fill3(xx1(:,2),xx2(:,2),xx3(:,2),'g');
end