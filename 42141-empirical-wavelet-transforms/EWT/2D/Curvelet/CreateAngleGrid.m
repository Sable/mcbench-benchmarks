function [theta,radius] = CreateAngleGrid(W,H)

%=======================================================================
% function [theta,radius] = CreateAngleGrid(W,H)
% 
% This function creates matrices containing the following information for
% each pixel (assuming that the position (0,0) is at the center of the
% image.
%
% Inputs:
%   -W: image width
%   -H: image height
%
% Outputs:
%   -theta : angles in [-pi,pi]
%   -radius: distance from the center
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%=======================================================================

theta=zeros(H+1,W+1);
radius=zeros(H+1,W+1);

middleh=round(H/2)+1;
middlew=round(W/2)+1;

for i=1:W+1
    for j=1:H+1
        ri=(i-middlew)*pi/round(W/2);
        rj=(j-middleh)*pi/round(H/2);
        radius(j,i)=sqrt(ri^2+rj^2);
        if (ri==0) && (rj==0)
            theta(j,i)=0;
        else
            rt=rj/ri;
            theta(j,i)=atan(rt);
        end
        if ri<0
           if rj<=0
               theta(j,i)=theta(j,i)-pi;
           else
               theta(j,i)=theta(j,i)+pi;
           end
           if theta(j,i)<-3*pi/4
               theta(j,i)=theta(j,i)+2*pi;
           end
        end
    end
end