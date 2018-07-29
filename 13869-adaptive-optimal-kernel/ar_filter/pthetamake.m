function [ptheta, maxrad] = pthetamake(nrad, nphi, ntheta)
% pthetamake - make matrix of theta indicies for polar samples
% G.A. Reina 16 Jan 2007
% Modified from the C code provided by D. L. Jones and R. G. Baraniuk
% "An Adaptive Optimal-Kernel Time-Frequency Representation"
%   by D. L. Jones and R. G. Baraniuk, IEEE Transactions on Signal 
%   Processing, Vol. 43, No. 10, pp. 2361--2371, October 1995.

deltheta = 2*pi/ntheta;

maxrad = ones(1, nphi)*nrad;

for ii = 0:(nphi-1),
   
    for jj = 0:(nrad-1),
        theta = -((pi*sqrt(2)/nrad)*jj)*cos((pi*ii)/nphi); 
        
        if (theta > -eps)  % in the original code thiis is 0.0
            rtemp = theta / deltheta;
            if ( rtemp > (ntheta / 2 - 1))
                rtemp = -1;
                if (jj < maxrad(ii+1))
                    maxrad(ii+1) = jj;
                end
            end
        else
            rtemp = (theta + 2*pi) / deltheta;
            if (rtemp < ((ntheta/2) + 1))
                rtemp = -1;
                if (jj < maxrad(ii+1))
                    maxrad(ii+1) = jj;
                end
            end
         
        end
        
        ptheta(jj+1, ii+1) = rtemp;
          
    end
end
