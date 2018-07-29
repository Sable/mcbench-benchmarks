function [ewtc,mfb,Bw,Bt] = EWT2D_Curvelet(f,params)

%==========================================================================
% function [ewtc,mfb,Bw,Bt] = EWT2D_Curvelet(f,params)
%
% This function performs the Empirical Curvelet Transform. The Fourier 
% boundaries and angles are detected using the Pseudo-Polar FFT. 
%
% TO RUN THIS FUNCTION YOU NEED TO HAVE THE MATLAB POLARLAB TOOLBOX OF 
% MICHAEL ELAD: http://www.cs.technion.ac.il/~elad/Various/PolarLab.zip
%
% Input:
%   -f: input image
%   -params: structure containing the following parameters:
%       -params.log: 0 or 1 to indicate if we want to work with
%                    the log of the ff
%       -params.preproc: 'none','plaw','poly','morpho','tophat'
%       -params.method: 'locmax','locmaxmin','ftc'
%       -params.N: maximum number of supports (needed for the
%                  locmax and locmaxmin methods)
%       -params.degree: degree of the polynomial (needed for the
%                       polynomial approximation preprocessing)
%       -params.curvpreproc: 'none','plaw','poly','morpho','tophat'
%       -params.curvmethod: 'locmax','locmaxmin'
%       -params.curvN: maximum number of angles
%       -params.curvdegree: degree of the polynomial (needed for the
%                       polynomial approximation preprocessing)
%       -params.option: 1 = scales and angles are independants
%                       2 = scales first then angles per scales
%
% Output:
%   -ewtc: cell containing each filtered output subband (ewtc{1} is the 
%   lowpass subband the next ewtc{s}{t} are the bandpass filtered images, s
%   corresponds to the scales and t to the direction)
%   -mfb: cell containing the set of empirical filters in the Fourier 
%   domain (the indexation is the same as ewtc above)
%   -Bw: list of the detected scale boundaries
%   -Bt: list of the detected angle boundaries
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%==========================================================================

W=size(f,2);
H=size(f,1);

% Pseudo Polar FFT of f
PseudoFFT=PPFFT(f);

switch params.option
    case 1 
        %% Option 1 - scales and angles independent
        % Compute the mean spectrum with respect to the angle to find the scales
        meanppfft=sum(abs(PseudoFFT),2);

        % Detect the boundaries
        boundaries = EWT_Boundaries_Detect(fftshift(meanppfft),params);
        Bw = boundaries*pi/round(length(meanppfft)/2);
        
        % Compute the mean spectrum with respect to the magnitude frequency to find
        % the angles
        meanppfft=sum(abs(PseudoFFT),1);

        % Detect the boundaries
        boundaries = EWT_Angles_Detect(meanppfft',params);
        Bt = (boundaries-1)*pi/length(meanppfft)-3*pi/4;
                  
        % Build the filter bank
        mfb = EWT2D_Curvelet_FilterBank(Bw,Bt,W,H,params.option);

        % We filter the signal to extract each subband
        ff=fft2(f);

        ewtc=cell(length(mfb),1);
        % We extract the low frequencies first
        ewtc{1}=real(ifft2(conj(mfb{1}).*ff));
        for s=2:length(mfb)
            ewtc{s}=cell(length(mfb{s}),1);
            for t=1:length(mfb{s})
                ewtc{s}{t}=real(ifft2(conj(mfb{s}{t}).*ff));
            end
        end
    case 2
        %% Option 2 - scales first and then angles per scale
        % Compute the mean spectrum with respect to the angle to find the scales
        meanppfft=sum(abs(PseudoFFT),2);

        % Detect the boundaries
        boundaries = EWT_Boundaries_Detect(fftshift(meanppfft),params);
        Bw = boundaries*pi/round(length(meanppfft)/2);
        
        % We compute the angles limits for each scale
        Bt = cell(length(Bw),1);
        for s=1:length(Bw)-1
            % Compute the mean spectrum with respect to the magnitude frequency 
            % annuli to find the angles
            meanppfft=sum(abs(PseudoFFT(boundaries(s):boundaries(s+1),:)),1);
            % Detect the boundaries
            bounds = EWT_Angles_Detect(meanppfft',params);
            Bt{s} = (bounds-1)*pi/length(meanppfft)-3*pi/4;
        end
        meanppfft=sum(abs(PseudoFFT(boundaries(end):end,:)),1);
        % Detect the boundaries
        bounds = EWT_Angles_Detect(meanppfft',params);        
        Bt{length(Bw)} = (bounds-1)*pi/length(meanppfft)-3*pi/4;

        % Build the filter bank
        mfb = EWT2D_Curvelet_FilterBank(Bw,Bt,W,H,params.option);

        % We filter the signal to extract each subband
        ff=fft2(f);

        ewtc=cell(length(mfb),1);
        % We extract the low frequencies first
        ewtc{1}=real(ifft2(conj(mfb{1}).*ff));
        for s=2:length(mfb)
            ewtc{s}=cell(length(mfb{s}),1);
            for t=1:length(mfb{s})
                ewtc{s}{t}=real(ifft2(conj(mfb{s}{t}).*ff));
            end
        end
end
