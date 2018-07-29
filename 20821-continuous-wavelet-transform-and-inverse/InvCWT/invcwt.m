function Xrec = invcwt(wvcfs, mother, scale, param, k)
% Xrec = INVCWT(wvcfs, mother, scale, param,k)
%uses the Farge 1992 method of using delta functions to reconstruct
%waveform. 
%Relevant publications
% Farge, M., 1992: Wavelet transforms and their applications to turbulence.
% Annu. Rev. Fluid Mech., 24, 395–457.
%
%  Torrence and Compo Bul. Am Met. Soc. 1998, pp 68.
%
% companion to wavelet and wave_bases originally written by C Torrence and
% G Compo
% written by jon erickson: Washington and Lee Univ.  Updated Feb 2011
%
%INPUTS:
% WVCFS         CWT coefficients computed with wavelet.m
% MOTHER         mother wavelet name. ['Morlet' | 'DOG' | 'Paul']
% SCALE         vector of scales used for CWT
% PARAM         parameter whose meaning is dependent on mother wavelet. see contwt.m
%
% OUPUTS:
%   Xrec        reconstructed waveform
%
%%% Example usage:
% 
% %make a test signal
% dt = 0.1
% t = 0:dt:10;
% x = cos(2*t)
% 
% %compute the CWT
% [wave, period, scale, coi, dj,paramout, k] = contwt(x,dt);
% 
% %reconstruct the original signal
% Xrec = invcwt(wave, 'MORLET', scale, paramout, k);
% 
% %Plot results
% figure; 
% plot(t,x); %original signal
% hold on;
% plot(t, Xrec, 'r--')
% legend('Original signal', 'Reconstructed Signal')
% xlabel('Time'); 
% ylabel('Signal (arbitrary units)')
% 
% %plot wavelet coeffs
% figure;imagesc(abs(wave))


% take the real part of the wavelet transform.
Wr = real(wvcfs);
N = size(Wr, 2);
%compute the sum
scale = scale(:); %make a column vector
s = repmat(scale, [1, size(wvcfs,2)]);

summand = sum(Wr./sqrt(s), 1);

%compute the constant factor out front

%compute the fourier spectrum at each scale [Eq(12)]
for a1 = 1:length(scale)
    daughter=wave_bases(mother,k,scale(a1),param);
    Wdelta(a1) = (1/N)*sum(daughter);  %  [Eqn(12)]
end
% whos Wdelta
RealWdelta = real(Wdelta);
RealWdelta = RealWdelta(:); %make a column vector

C = sum(RealWdelta./sqrt(scale));

Xrec = (1/C)*summand;



