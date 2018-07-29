function GW = GaborWavelet (R, C, Kmax, f, u, v, Delt2);
% Create the Gabor Wavelet Filter
% Author : Chai Zhi  
% e-mail : zh_chai@yahoo.cn

k = ( Kmax / ( f ^ v ) ) * exp( i * u * pi / 8 );% Wave Vector

kn2 = ( abs( k ) ) ^ 2;

GW = zeros ( R , C );

for m = -R/2 + 1 : R/2
    
    for n = -C/2 + 1 : C/2
        
        GW(m+R/2,n+C/2) = ( kn2 / Delt2 ) * exp( -0.5 * kn2 * ( m ^ 2 + n ^ 2 ) / Delt2) * ( exp( i * ( real( k ) * m + imag ( k ) * n ) ) - exp ( -0.5 * Delt2 ) );
    
    end

end
