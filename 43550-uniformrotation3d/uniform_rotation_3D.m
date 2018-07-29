function rotated=uniform_rotation_3D(v)
% This function perform a unformly random rotation 3D.
% It is clear that in 2 dimensions that this means the 
% rotation angle is uniformly distributed between (0, 2pi).
% However, it is NOT correct and does NOT carry over to 
% higher dimensions. 
%
% More information see Le?n, Carlos A.; Mass?, Jean-Claude; 
% Rivest, Louis-Paul (February 2006), "A statistical model 
% for random rotations", Journal of Multivariate Analysis 97 
% (2): 412?430, doi:10.1016/j.jmva.2005.03.009, ISSN 0047-259X

% Arguments (input):
%   v - 3*1 vector needs to be rotated
%
%
% arguments (output):
%   rotated - 3*1 vector after unformly random rotation
%
% 
% References: J. Arvo (1992), Fast Random Rotation Matrices
%
% Author: Yaming Wang. ETH Zurich.
% email: yaming.wang@sed.ethz.ch
% Release: 1.00
% Release data: 18.09.2012

rot_1=2*pi*rand(1);
matrix_1=[cos(rot_1),sin(rot_1),0;...
    -sin(rot_1),cos(rot_1),0;...
    0,0,1];

rot_2a=2*pi*rand(1);
rot_2b=rand(1);

Householder_v=[cos(rot_2a)*sqrt(rot_2b)
    sin(rot_2a)*sqrt(rot_2b)
    sqrt(1-rot_2b)];

% Householder matrix
matrix_2=eye(3)-2*Householder_v*Householder_v';

rotated=-matrix_2*matrix_1*v;

fprintf(1,'rotation finished.\n');


% ====================================================
%      end of function
% ====================================================