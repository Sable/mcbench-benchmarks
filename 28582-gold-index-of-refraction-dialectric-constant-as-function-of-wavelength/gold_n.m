function [N]=gold_n(wl)

% the function calculates the index of refraction of gold (complex value), in the range of wavelength
% between 188nm and 1942nm.
% the input may be a scalar or vector, but it have to be an integer and in the right range.
% the values were taken from the paper: 
%       P. B. Johnson, and R. W. Christy, "Optical Constants of the Noble Metals," Physical Review B 6, 4370 (1972).
% (the paper is available here: http://prb.aps.org/abstract/PRB/v6/i12/p4370_1 )
% the values for wavelength calculated with linear interpolation.
%
% Moshe Lindner, August 2010 (C).

if any((max(wl)>1942) || (min(wl)<188))
    error('Wavelength is out of range! (should be in the range of 188nm - 1942nm)')
    return
elseif any(wl~=ceil(wl))
    error('Wavelength must be an integer!')
    return
end
    

% n = real part
n=[0.92 0.56 0.43 0.35 0.27 0.22 0.17 0.16 0.14 0.13 0.14 0.21 0.29 0.43 0.62 1.04 1.31 1.39 1.45 1.46 1.47 1.46 1.48 1.5 1.48 1.48 1.54 1.53 1.53 1.49 1.47 1.43 1.38 1.35 1.33 1.33 1.32 1.32 1.3 1.31 1.3 1.3 1.3 1.3 1.33 1.33 1.34 1.32 1.28]';
n=n(end:-1:1);
% k = imaginary part
k=[13.78 11.21 9.519 8.145 7.15 6.35 5.663 5.083 4.542 4.103 3.697 3.272 2.863 2.455 2.081 1.833 1.849 1.914 1.948 1.958 1.952 1.933 1.895 1.866 1.871 1.883 1.898 1.893 1.889 1.878 1.869 1.847 1.803 1.749 1.688 1.631 1.577 1.536 1.497 1.46 1.427 1.387 1.35 1.304 1.277 1.251 1.226 1.203 1.188]';
k=k(end:-1:1);
% ev = photon energy in electronvolts
ev=[0.64 0.77 0.89 1.02 1.14 1.26 1.39 1.51 1.64 1.76 1.88 2.01 2.13 2.26 2.38 2.50 2.63 2.75 2.88 3 3.12 3.25 3.37 3.5 3.62 3.74 3.87 3.99 4.12 4.24 4.36 4.49 4.61 4.74 4.86 4.98 5.11 5.23 5.36 5.48 5.6 5.73 5.85 5.98 6.1 6.22 6.35 6.47 6.6]';
ev=ev(end:-1:1);
h=6.62606896e-34; % [J*sec] (Plank const.)
c=3e8; %[m/sec]  (speed of light)
q=1.6e-19; % [C] (electron charge)
lambda=1e9*h*c./(ev.*q);% wavelength in nanometer

lam=188:1942;
n1=interp1(lambda,n,lam,'linear');
k1=interp1(lambda,k,lam,'linear');

for q=1:length(wl)
    N(q)=n1(lam==wl(q)) + i*k1(lam==wl(q));
end


