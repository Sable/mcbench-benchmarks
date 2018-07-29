function polafm2 = polafint(nrad,nphi,ntheta,maxrad,nlag,plag,ptheta,rectafm2)
%  polafint: interpolate AF on polar grid;
% G.A. Reina 16 Jan 2007
% Modified from the C code provided by D. L. Jones and R. G. Baraniuk
% "An Adaptive Optimal-Kernel Time-Frequency Representation"
%   by D. L. Jones and R. G. Baraniuk, IEEE Transactions on Signal 
%   Processing, Vol. 43, No. 10, pp. 2361--2371, October 1995.

half_nphi = floor(nphi / 2);

polafm2 = zeros(max(maxrad), nphi);

for ii = 0:(nphi-1), % for all phi ...
    for jj = 0:(maxrad(ii+1)-1),	% and all radii with |theta| < pi

        ilag = floor(plag(jj+1, ii+1));
        rlag = plag(jj+1, ii+1) - ilag;

        if (ilag <= (nlag - 2))
            
            itheta = floor(ptheta(jj+1, ii+1));
            rtheta = ptheta(jj+1, ii+1) - itheta;

            % Some sort of wrap around going on here. Not quite sure why
            if (ii == (half_nphi))
                
                rtemp =  (rectafm2(itheta+2, ilag+1) ...
                    - rectafm2((nphi - (itheta + 1)), (ilag+1)))*rtheta ...
                    + rectafm2((nphi - (itheta + 1)), (ilag+1));

                rtemp1 =  (rectafm2(itheta+2, ilag+2) ...
                    - rectafm2((nphi - (itheta + 1)), (ilag+2)))*rtheta ...
                    + rectafm2((nphi - (itheta + 1)), (ilag+2));

                polafm2(jj+1, ii+1) = (rtemp1-rtemp)*rlag + rtemp;

            else

                itheta1 = itheta + 1;
                if ( itheta1 >= ntheta )
                    itheta1 = 0;
                end

                rtemp =  (rectafm2(itheta1+1, ilag+1) ...
                    - rectafm2(itheta+1, ilag+1))*rtheta ...
                    + rectafm2(itheta+1, ilag+1);

                rtemp1 =  (rectafm2(itheta1+1, ilag+2)...
                    - rectafm2(itheta+1, ilag+2))*rtheta ...
                    + rectafm2(itheta+1, ilag+2);

                polafm2(jj+1, ii+1) = (rtemp1-rtemp)*rlag + rtemp;
            end

        end
    end
end
