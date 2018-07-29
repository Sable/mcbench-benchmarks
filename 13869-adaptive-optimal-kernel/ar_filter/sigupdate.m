function sigma = sigupdate(nrad,nphi,nits,vol,mu0,maxrad,polafm2,lastsigma)
%   sigupdate: update RG kernel parameters
% G.A. Reina 16 Jan 2007
% Modified from the C code provided by D. L. Jones and R. G. Baraniuk
% "An Adaptive Optimal-Kernel Time-Frequency Representation"
%   by D. L. Jones and R. G. Baraniuk, IEEE Transactions on Signal 
%   Processing, Vol. 43, No. 10, pp. 2361--2371, October 1995.

sigma = lastsigma;

for ii=0:(nits-1),
    gradsum = 0.0;
    gradsum1 = 0.0;


    for i=0:(nphi-1),
        grad(i+1) = 0.0;

        ee1 = exp( - 1.0/(sigma(i+1).^2) );	% use Kaiser's efficient method
        ee2 = 1.0;
        eec = ee1*ee1;
      
        
        for j=1:(maxrad(i+1)-1)
            ee2 = ee1*ee2;
            ee1 = eec*ee1;
            grad(i+1) = grad(i+1) + (j.^3)*ee2*polafm2(j+1, i+1);
        end
        grad(i+1) = grad(i+1)/(sigma(i+1).^3);

        gradsum = gradsum + grad(i+1).^2;
        gradsum1 = gradsum1 + sigma(i+1)*grad(i+1);
        
    end
    
    gradsum1 = 2*gradsum1;

    if ( gradsum < 0.0000001 )
        gradsum = 0.0000001;
    end

    if ( gradsum1 < 0.0000001 )
        gradsum1 = 0.0000001;
    end

    mu = ( sqrt(gradsum1.^2 + 4.0*gradsum*vol*mu0) - gradsum1 ) / ( 2.0*gradsum );

    sigma = sigma + mu*grad;
    sigma(sigma < 0.5) = 0.5;
    tvol = sum(sigma.^2);
    
    volfac = sqrt(vol/tvol);

    sigma = volfac*sigma;

end
