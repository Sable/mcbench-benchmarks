function [ht, rho, theta] = hough(IM, f, t, M, N)
% HOUGH Hough transform for detection lines in images.
% [HT,RHO,THETA] = HOUGH(IM,M,N). 
% From an image IM, computes the integration of the values
% of the image over all the lines. The origin of the coordinates is 
% in the middle of x axis (-250<=x<250, 0<=y<=1). The formula for the
% transform is rho = x*cos(theta) + y*sin(theta). Only the values of IM exceeding 5 % of the maximum 
%	are taken into account (to speed up the algorithm). 
%
%	IM    : image to be analyzed (size Xmax x Ymax).
%	M     : desired number of samples along the radial axis 
%					(default : Xmax).
%	N     : desired number of samples along the azimutal (angle) axis
%					(default : Ymax). 
%	HT    : output matrix (MxN matrix).
%	RHO   : sequence of samples along the radial axis.
%	THETA : sequence of samples along the azimutal axis.

if (nargin < 3 ),
 error('At least three parameters required');
end;
[Xmax,Ymax] = size(IM);

if (nargin == 3),
M = Xmax; N = Ymax;  
elseif (nargin == 4),
N=Ymax; 
end;

rhomax = sqrt(Xmax^2 + Ymax^2)/2;
deltar=rhomax/(M-1);
deltat=2*pi/N;

ht=zeros(M,N);
Max=max(max(IM)); 
for x = 0:Xmax-1,
    for y = 0:Ymax-1,
        if abs(IM(x+1,y+1))>Max/20,
            for theta = 0:deltat:(2*pi-deltat),
                 rho = x*cos(theta) + y*sin(theta); 
                if ((rho>=0)&&(rho<=rhomax)),
                    ht(round(rho/deltar)+1,round(theta/deltat)+1) =...
                        ht(round(rho/deltar)+1,round(theta/deltat)+1)+...
                        IM(x+1,y+1);
                end
            end
        end
    end
end
rho=0:deltar:rhomax;
theta=0:deltat:(2*pi-deltat);