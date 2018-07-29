function [u,iterFlag] = solvePoissonSOR(y,maxIt,maxErr)
%SOLVEPOISSONSOR    Solve Poisson equation using Successive Overrelaxation
%(SOR) with Chebyshev acceleration.
%   [U,ITERFLAG] = SOLVEPOISSONSOR(Y,MAXIT,MAXERR) solves the Poisson 
%   equation using SOR with Chebyshev acceleration. First-order finite 
%   differences and Dirichlet boundary conditions are used. Y is the 2D 
%   observation matrix. The solution is returned in U (2D). ITERFLAG is set 
%   if maximum number of iterations has been reached.
%
%   Reference: Press, W.H., S.A. Teukolsky, W.T. Vetterling, and B.P. 
%   Flannery, 2007: Numerical Recipes: The Art of Scientific Computing, 3e.
%   Cambridge University Press: New York, p. 1024-1030, 1061-1065
%
%   Author: Evan Ruzanski, Radar and Communications Group, Colorado State
%   University, March 2011 (adapted from C implementation by Prof. Jack 
%   Tumblin, Northwestern University)

% Check input arguments; set default values if needed
if nargin == 1
    maxIt = 1e4;
    maxErr = 1e-4;
elseif nargin == 2
    maxErr = 1e-4;
end

% Set up initial value matrix with Dirichlet boundary conditions
[M,N] = size(y);
JT_BORD = 1;
u(M+2*JT_BORD,N+2*JT_BORD) = 0; % Initial conditions are zero
imax = M+JT_BORD; jmax = N+JT_BORD;

% Compute Jacobi radius (assume equal normalized grid spacing)
rjac = ( cos(pi/imax) + cos(pi/jmax) )/2;
rjac2 = rjac*rjac;

% Set initial Chebyshev weight (no acceleration on first pass)
chebW = 1;

% Iteratively modify the output buffer so the Laplacian at each pixel
% matches corresponding observed value
for k = 1:maxIt
    err2sum = 0; % Clear the maximum error finder for this pass
    for isOdd = 0:1 % For each checkboard (red-black) half-sweep of the image
        chk = isOdd; % Starting pixel for current scanline
        for j = 1+JT_BORD:jmax % Update every scanline...
            for i = 1+JT_BORD+chk:2:imax % ...but only half the pixels
                lapWanted = y(i-JT_BORD,j-JT_BORD);
                lapAvg = u(i+1,j) + u(i-1,j) + u(i,j+1) + u(i,j-1); % Sum NSEW neighbors
                lapNow = lapAvg - 4*u(i,j); % Current Laplacian
                lapErr = lapWanted - lapNow;
                
                % In-place correction by 1/4 of the Laplacian error but
                % exaggerate the correction by chebW factor, which grows as
                % large as 2.0
                u(i,j) = u(i,j) - 0.25*chebW*lapErr; 
                
                err2sum = err2sum + lapErr*lapErr; % Use sum-of-squares error as stopping criterion
            end % End one scanline
            chk = mod(chk+1,2); % Toggle 'chk' on each scanline
            if k==0 && isOdd == 0 % Initial pass on checkboard's second half?
                chebW = 1/(1-0.5*rjac2); % Calculate the Chebyshev polynomial
            else
                chebW = 1/(1-0.25*rjac2*chebW); % Asymptotically go towards value
            end
        end % End one scanline
    end % End one half-sweep
    
    % Check for convergence
    if err2sum < maxErr*maxErr
        break;
    end
end % Go to next iteration

% Check for convergence
if k==maxIt
    iterFlag = 1;
else
    iterFlag = 0;
end

% Trim border
u2(M,N) = 0;
for j = JT_BORD+1:jmax
    for i = JT_BORD+1:imax
        u2(i-JT_BORD,j-JT_BORD) = u(i,j);
    end
end
u = u2;