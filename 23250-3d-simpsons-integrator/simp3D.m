function out = simp3D(func,a,b,c,d,e,f,NX,NY,NZ)

% © Whayne Padden and Charlie Macaskill 2008
% The University of Sydney, Sydney, Australia

% function out = simp3D('func',a,b,c,d,e,f,NX,NY,NZ)
% func(x,y,z) returns the 3D function to be integrated at argument x, y and z.
% a and b are x limits of integration, c and d are y limits of integration, and
% e and f are the z limits of integration.
% NX number of x intervals, NY number of y intervals, and NZ the number of z
% intervals. Note: NX, NY, NZ should be even but the program will correct for
% this if odd values are entered.
% WARNING: ensure that func(x,y,z) is `vector-enabled', i.e.
% can handle vectors correctly, otherwise misleading results
% may be obtained. This code is fully vectorized for speed.

% The 3D simpson's integrator has weights that are most easily determined 
% by taking the outer product of each column of the matrix of weights for the 
% 2D simpson's rule, with the vector of weights from the 1D Simpson rule. 
% For example let's take the vector of weights (1 4 2 4 1) for 4 intervals.
% In 2D we now get an array of weights that is given by: 
%    | 1  4  2  4  1 |
%    | 4 16  8 16  4 |
%    | 2  8  4  8  2 |
%    | 4 16  8 16  4 |
%    | 1  4  2  4  1 |
%
% Notice how the usual 1D simpson's weights appear around the sides of the
% array. In 3D if we take each column vector of this matrix and find it's outer
% product with the 1D weight vector we get of course a 3D matrix of weights. If
% we use the usual Matlab notation for a 3D array Z so that Z(:,:,k) represents
% the kth page of the array, we have:
% Z(:,:,1) = | 1  4  2  4  1 |
%            | 4 16  8 16  4 |
%            | 2  8  4  8  2 |
%            | 4 16  8 16  4 |
%            | 1  4  2  4  1 |
%
% Z(:,:,2) = | 4 16  8 16  4 |
%            |16 64 32 64 16 |
%            | 8 32 16 32  8 |
%            |16 64 32 64 16 |
%            | 4 16  8 16  4 |
%
% Z(:,:,3) = | 2  8  4  8  2 |
%            | 8 32 16 32  8 |
%            | 4 16  8 16  4 |
%            | 8 32 16 32  8 |
%            | 2  8  4  8  2 |
%
% Z(:,:,4) = | 4 16  8 16  4 |
%            |16 64 32 64 16 |
%            | 8 32 16 32  8 |
%            |16 64 32 64 16 |
%            | 4 16  8 16  4 |
%
% Z(:,:,5) = | 1  4  2  4  1 |
%            | 4 16  8 16  4 |
%            | 2  8  4  8  2 |
%            | 4 16  8 16  4 |
%            | 1  4  2  4  1 |
%
% Note that each face of the 3D array is made up of the 2D Simpson weights, ie
% Z(:,:,1) = Z(:,:,5) = Z(:,1,:) = Z(:,5,:) = Z(1,:,:) = Z(5,:,:)

%------------------------------------------------------------------------------%
% Examples:
% A) Integrate cos(x^2 + y^2 + z^2) over the region 0 <= x <=1, 0 <= y <= 1, 
%    0 <= z <= 1
% Set
% func = @(x,y,z) cos(x.^2 + y.^2 + z.^2) Note this is vector enabled
% ans = simp3D(func,0,1,0,1,0,1,128,128,128)
% 
% B) Determine the volume of a sphere of radius 1.
% 
% Set up an m file and define a function as follows:
%
% function z = sphere3D(x,y)
%
% zloc = x.^2 + y.^2 + z.^2;
% L = zloc <= 1;
% zmask = zeros(size(x));
% zmask(L) = 1;
% z = zmask;
%
%
% ans = simp3D('sphere3D',-1,1,-1,1,-1,1,192,192,192)
%
% Note you lose accuracy on curved regions at least O(h) than for regular
% regions.
%
% You'll only to be able to run a max of about 220 intervals in each direction
% with 1GB of memory. For a 32 bit OS like XP, the max addressable memory is ~3.2GB, so
% the max intervals will be ~ 220*3.2^(0.33333) = 324. A 64 bit OS with 8GB+
% memory recommended for large number of intervals. To use 512 intervals with
% double precision would require ~ 8.6GB of available memory. Singe precison
% uses half the memory if required.

%------------------------------------------------------------------------------%


% Ensure the number of intervals is even!
NX = 2*ceil(NX/2);
NY = 2*ceil(NY/2);
NZ = 2*ceil(NZ/2);

% Set up the integration step sizes in the x and y directions
hx = (b - a)/NX;
hy = (d - c)/NY;
hz = (f - e)/NZ;

% Define vectors spanning the integration domain.

xg = a:hx:b;
yg = c:hy:d;
zg = e:hz:f;
[xxg,yyg,zzg] = meshgrid(xg,yg,zg);

% Note that the meshgrid routine is only included inside simp3D to make it
% self-contained. If you were using simp3D inside a loop, it would be better to
% calculate the vectors and meshgrid step outside the function and pass xxg, yyg
% and zzg and a, b, c, d, e, f as globals say. This can save 25% in run time in 
% large loops. For single use or small loops the penalty is small.


% Now set up a matrix U that contains the values of the function evaluated at all
% points on the 3D grid setup by xg, yg and zg.

U = feval(func,xxg,yyg,zzg);

% Evaluate the contribution from the 8 corner points first.
% These all have weight 1; NB U(1,1,1) corresponds to func(a,c,e) etc.

s1 = ( U(1,1,1) + U(NX+1,1,1) + U(1,NY+1,1)  + U(1,1,NZ+1) + U(NX+1,NY+1,1) + U(NX+1,1,NZ+1) + U(1,NY+1,NZ+1) + U(NX+1,NY+1,NZ+1) );      


% Now sum the contributions from the terms along each edge not including
% corners. There are 12 edges in the 3D case that contribute to the sum
% and we get have points with weight 4 and points with weight 2. Points
% with weight 4 are acessed by indices 2:2:N (N=NX,NY,NZ) and we'll call these 
% odd grid points, while points with weight 2 are accessed by indices 3:2:N-1 
% and we'll call these even grid points.

% Define vectors of odd and even indices for each direction:

ixo = 2:2:NX;
ixe = 3:2:NX-1;
iyo = 2:2:NY;
iye = 3:2:NY-1;
izo = 2:2:NZ;
ize = 3:2:NZ-1;

s2 = 2*( sum(U(1,1,ize)) + sum(U(1,iye,1)) + sum(U(ixe,1,1)) + sum(U(NX+1,1,ize)) + ...
         sum(U(ixe,1,NZ+1)) + sum(U(NX+1,iye,1)) + sum(U(ixe,NY+1,1)) + sum(U(1,NY+1,ize)) + ...
         sum(U(NX+1,NY+1,ize)) + sum(U(1,iye,NZ+1)) + sum(U(ixe,NY+1,NZ+1)) + sum(U(NX+1,iye,NZ+1)) );
     
s3 = 4*( sum(U(1,1,izo)) + sum(U(1,iyo,1)) + sum(U(ixo,1,1)) + sum(U(NX+1,1,izo)) + ...
         sum(U(ixo,1,NZ+1)) + sum(U(NX+1,iyo,1)) + sum(U(ixo,NY+1,1)) + sum(U(1,NY+1,izo)) + ...
         sum(U(NX+1,NY+1,izo)) + sum(U(1,iyo,NZ+1)) + sum(U(ixo,NY+1,NZ+1)) + sum(U(NX+1,iyo,NZ+1)) );     

% Now we look at the contributions of the remaining points on the surface of each face. 
% There are of course 6 faces and each face is the same. Looking at our array example 
% above we see that there are only 3 different weights viz. 16, 8 and 4. Some thought will show that
% using our definitions above for odd and even gridpoints, that weight 16 is
% only found at points like (xodd,yodd,e), weight 4 is found at points like (xeven,yeven,e)
% while weight 8 is found at both (xodd,yeven,e) or (xeven,yodd,e) and the
% various permutations depending on what face we are looking at


% Our contribution from the surface points excluding edges and corners, is then

s4 =  4*( sum( sum( U(ixe,iye,1) ) ) + sum( sum( U(ixe,iye,NZ+1) ) ) + ...
          sum( sum( U(ixe,1,ize) ) ) + sum( sum( U(ixe,NY+1,ize) ) ) + ...
          sum( sum( U(1,iye,ize) ) ) + sum( sum( U(NX+1,iye,ize) ) ) );
      
s5 = 16*( sum( sum( U(ixo,iyo,1) ) ) + sum( sum( U(ixo,iyo,NZ+1) ) ) + ...
          sum( sum( U(ixo,1,izo) ) ) + sum( sum( U(ixo,NY+1,izo) ) ) + ...
          sum( sum( U(1,iyo,izo) ) ) + sum( sum( U(NX+1,iyo,izo) ) ) );
      
s6 =  8*( sum( sum( U(ixe,iyo,1) ) ) + sum( sum( U(ixe,iyo,NZ+1) ) ) + ...
          sum( sum( U(ixe,1,izo) ) ) + sum( sum( U(ixe,NY+1,izo) ) ) + ...
          sum( sum( U(1,iye,izo) ) ) + sum( sum( U(NX+1,iye,izo) ) ) );
      
s7 =  8*( sum( sum( U(ixo,iye,1) ) ) + sum( sum( U(ixo,iye,NZ+1) ) ) + ...
          sum( sum( U(ixo,1,ize) ) ) + sum( sum( U(ixo,NY+1,ize) ) ) + ...
          sum( sum( U(1,iyo,ize) ) ) + sum( sum( U(NX+1,iyo,ize) ) ) );
     
% Finally we turn to contribution from the interior grid points. Looking at our collection of
% arrays above we see that there are 4 different weights viz. 64, 32, 16 and 8.
% The 64 weights are associated with grid points of the type (xodd,yodd,zodd),
% the 8 weights are associated with (xeven,yeven,zeven), the 32 weights are
% associated with terms like (xodd,yodd,zeven) and the 16 weights are associated
% with terms like (xodd,yeven,zeven).

s8 = 64*sum( sum( sum( U(ixo,iyo,izo) ) ) );

s9 =  8*sum( sum( sum( U(ixe,iye,ize) ) ) );

s10 = 32*( sum( sum( sum( U(ixo,iyo,ize) ) ) ) + sum( sum( sum( U(ixo,iye,izo) ) ) ) + sum( sum( sum( U(ixe,iyo,izo) ) ) ) );
       
s11 = 16*( sum( sum( sum( U(ixo,iye,ize) ) ) ) + sum( sum( sum( U(ixe,iyo,ize) ) ) ) + sum( sum( sum( U(ixe,iye,izo) ) ) ) );
     
% Finally add all the contributions and multiply by the step sizes hx, hy and hz
% and a factor 1/27 (1/3 in each direction).


out = s1 + s2 + s3 + s4 + s5 + s6 + s7 + s8 + s9 +s10 + s11;
out = out*hx*hy*hz/27.0;