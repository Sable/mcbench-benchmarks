function [PHI, DPHI, DDPHI] = MLS1DShape(m, nnodes, xi, npoints, x, dmI, wtype, para)
% SHAPE FUNCTION OF 1D MLS APPROXIMATION
%
% SYNTAX: [PHI, DPHI, DDPHI] = MLS1DShape(m, nnodes, xi, npoints, x, dm, wtype, para)
%
% INPUT PARAMETERS
%    m - Total number of basis functions (1: Constant basis;  2: Linear basis;  3: Quadratic basis)
%    nnodes  - Total number of nodes used to construct MLS approximation
%    npoints - Total number of points whose MLS shape function to be evaluated
%    xi(nnodes) - Coordinates of nodes used to construct MLS approximation
%    x(npoints) - Coordinates of points whose MLS shape function to be evaluated
%    dm(nnodes) - Radius of support of nodes
%    wtype - Type of weight function
%    para  - Weight function parameter
%
% OUTPUT PARAMETERS
%    PHI   - MLS Shpae function
%    DPHI  - First order derivatives of MLS Shpae function
%    DDPHI - Second order derivatives of MLS Shpae function
%
% INITIALIZE WEIGHT FUNCTION MATRICES
wi   = zeros (1, nnodes);  % Weight funciton
dwi  = zeros (1, nnodes);
ddwi = zeros (1, nnodes);

% INITIALIZE SHAPE FUNCTION MATRICES
PHI   = zeros(npoints, nnodes);
DPHI  = zeros(npoints, nnodes);
DDPHI = zeros(npoints, nnodes);

% LOOP OVER ALL EVALUATION POINTS TO CALCULATE VALUE OF SHAPE FUNCTION Fi(X)
for j = 1 : npoints

	% DETERMINE WEIGHT FUNCTIONS AND THEIR DERIVATIVES AT EVERY NODE
	for i = 1 : nnodes
		di = x(j) - xi(i);
      [wi(i), dwi(i), ddwi(i)] = Weight(wtype, para, di, dmI(i));
	end
   
   % EVALUATE BASIS p, B MATRIX AND THEIR DERIVATIVES
   if (m == 1)  % Shepard function
      p = [ones(1, nnodes)]; 
      px   = [1];
      dpx  = [0];
      ddpx = [0];
      
      B    = p .* [wi];
      DB   = p .* [dwi];
      DDB  = p .* [ddwi];
   elseif (m == 2)
      p = [ones(1, nnodes); xi]; 
      px   = [1; x(j)];
      dpx  = [0; 1];
      ddpx = [0; 0];
      
      B    = p .* [wi; wi];
      DB   = p .* [dwi; dwi];
      DDB  = p .* [ddwi; ddwi];
   elseif (m == 3)
      p = [ones(1, nnodes); xi; xi.*xi]; 
      px   = [1; x(j); x(j)*x(j)];
      dpx  = [0; 1; 2*x(j)];
      ddpx = [0; 0; 2];
      
      B    = p .* [wi; wi; wi];
      DB   = p .* [dwi; dwi; dwi];
      DDB  = p .* [ddwi; ddwi; ddwi];
   else
      error('Invalid order of basis.');
   end
   
   % EVALUATE MATRICES A AND ITS DERIVATIVES
	A   = zeros (m, m);
	DA  = zeros (m, m);
	DDA = zeros (m, m);
	for i = 1 : nnodes
      pp = p(:,i) * p(:,i)';
      
      A   = A   + wi(i) * pp;
      DA  = DA  + dwi(i) * pp;
      DDA = DDA + ddwi(i) * pp;
   end
   
   AInv = inv(A);
      
   rx  = AInv * px;
   PHI(j,:) = rx' * B;   % shape function
    
   drx  = AInv * (dpx -DA * rx);
   DPHI(j,:) = drx' * B + rx' * DB;   % first order derivatives of shape function
   
   ddrx  = AInv * (ddpx - 2 * DA * drx - DDA * rx);
   DDPHI(j,:) = ddrx' * B + 2 * drx' * DB + rx' * DDB;     % second order derivatives of shape function
end

