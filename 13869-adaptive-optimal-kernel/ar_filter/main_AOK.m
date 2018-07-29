%%%%%%%%%% Main Program for the Adaptive Optimal Kernel %%%%%%%%%%%
% Variable 'sig_in' is the input signal.
% Variable 'ofp' is the output signal.

clear all

% load chirp
% sig_in = chirp;

% load papertest;
% sig_in = papertest;

samp_freq = 500; %in Hz
signal_duration = 0.3;  %in seconds
t = 0:(1/samp_freq):signal_duration;
sig_in_tmp = cos(2*pi*37*t) + sin(2*pi*63*t) + sin(2*pi*100*t); % 37 + 63 + 100 Hz sinewave

sig_in_tmp = hilbert(sig_in_tmp');

sig_in = [real(sig_in_tmp) imag(sig_in_tmp)];

if ndims(sig_in) ~= 2
    error('I need a 2 x N matrix, real and imaginary parts of the signal.');
end

if size(sig_in, 1) > size(sig_in, 2)
    xr_tmp = sig_in(:,1)'; % IMPORTANT: Pass vectors as rows
    xi_tmp = sig_in(:,2)';  % IMPORTANT: Pass vectors as rows
else
    xr_tmp = sig_in(1, :); % IMPORTANT: Pass vectors as rows
    xi_tmp = sig_in(2, :);  % IMPORTANT: Pass vectors as rows
end

disp('ADAPTIVE OPTIMAL-KERNEL (AOK) TIME-FREQUENCY REPRESENTATION');
disp('   Version 5.0');
disp('  '); % print a blank line
xlen = length(sig_in);

tlag = input('Length of sliding analysis window (power of two, no larger than 256)\n (Number of samples along each dimension of the STAF): ');
disp('  '); % print a blank line
% Check to see if tlag is a power of 2
if (log2(tlag)  - floor(log2(tlag))) ~= 0
    error('Length of sliding window must be a power of 2');
end

% Check to see if tlag is <= 256
if (tlag > 256)
    error('Length of sliding window must be <= 256.');
end

fftlen = input('Number of output frequency samples per time-slice (power of two): ');
disp('  '); % print a blank line

% Check to see if fftlen is a power of 2
if (log2(fftlen) - floor(log2(fftlen))) ~= 0
    error('Number of output frequency samples must be a power of 2');
end

tstep = input('Time increment in samples between time-slice outputs: ');
disp('  '); % print a blank line

if (tstep < 1) || (tstep > xlen)
    error('Time increment must be between 1 and the length of the signal.');
end

% Allocate the output matrix
ofp = zeros(ceil((xlen + tlag + 2)/tstep), fftlen);

vol = input('Normalized volume of optimal kernel (Typically between 1 and 5): ');
disp('  '); % print a blank line

if (vol < 1) || (vol > 5)
    error('Normalized volume of optimal kernel must be between 1 and 5.');
end

% ===========================================================

if (fftlen < (2*tlag))
    fstep = 2*tlag/fftlen;
    fftlen = 2*tlag;
else
    fstep = 1;
end

nits = log2(tstep+2);   % number of gradient steps to take each time

alpha = 0.01;

mu = 0.5;               % gradient descent factor

forget = 0.001;		% set no. samples to 0.5 weight on running AF
nraf = tlag;		% theta size of rectangular AF
nrad = tlag;		% number of radial samples in polar AF
nphi = tlag;		% number of angular samples in polar AF
outdelay = tlag/2;	% delay in effective output time in samples
% nlag-1 < outdelay < nraf to prevent "echo" effect

nlag = tlag + 1;	% one-sided number of AF lags
mfft = ceil(log2(fftlen));
slen = floor( (sqrt(2)) *(nlag-1) + nraf + 3);	% number of delayed samples to maintain
vol = (2.0*vol*nphi*nrad*nrad)/(pi*tlag);   % normalize volume

polafm2 = zeros(nphi, nrad);
rectafr = zeros(nraf, nlag);
rectafi = zeros(nraf, nlag);

xr = zeros(slen,1);
xi = zeros(slen,1);
sigma = ones(nphi,1);

tlen = xlen + nraf + 2;

% ======================================

[rar,rai,rarN,raiN] = rectamake(nlag,nraf,forget);  % make running rect AF parms

plag = plagmake(nrad,nphi,nlag);

[ptheta, maxrad] = pthetamake(nrad,nphi,nraf);   % make running polar AF parms

[rectrotr, rectroti] = rectrotmake(nraf,nlag,outdelay);

[req, pheq] = rectopol(nraf,nlag,nrad,nphi);

outct = 0;

lastsigma = ones(1,nphi);

for ii=0:(tlen-1)

    xr = zeros(1, slen);
    xi = zeros(1, slen);

    if (ii < xlen)
        xr(1:(ii+1)) = fliplr(xr_tmp(1:(ii+1)));
        xi(1:(ii+1)) = fliplr(xi_tmp(1:(ii+1)));
    else
        xr((ii - xlen + 2):(ii + 1)) = fliplr(xr_tmp);
        xi((ii - xlen + 2):(ii + 1)) = fliplr(xi_tmp);
    end

    [rectafr, rectafi] = rectaf(xr,xi,nlag,nraf,rar,rai,rarN,raiN,rectafr,rectafi);

    if ( rem(ii, tstep) == 0 )	% output t-f slice
        outct = outct + 1;

        rectafm2 = rectafr.^2 + rectafi.^2;

        polafm2 = polafint(nrad,nphi,nraf,maxrad,nlag,plag,ptheta,rectafm2);

        %sigma keeps getting updated. need to pass old value into
        %new one

        sigma = sigupdate(nrad,nphi,nits,vol,mu,maxrad,polafm2,lastsigma);
        lastsigma = sigma;

        tfslicer = zeros(1, fftlen);
        tfslicei = zeros(1, fftlen);

        rtemp  = rectafr .* rectrotr + rectafi .* rectroti;
        rtemp1 = rectafi .* rectrotr - rectafr .* rectroti;

        rtemp2 = rectkern(0:(nlag-2),0:(nraf-1),nraf,nphi,req,pheq,sigma);

        % Computer first half of time-frequency domain
        tfslicer(1:(nlag-1)) = sum(rtemp(:, 1:(nlag-1)).*rtemp2);
        tfslicei(1:(nlag-1)) = sum(rtemp1(:, 1:(nlag-1)).*rtemp2);

        % Second half of TF domain is the first half reversed
        tfslicer((fftlen-nlag+3):(fftlen+1)) = tfslicer((nlag-1):-1:1);
        tfslicei((fftlen-nlag+3):(fftlen+1)) = -tfslicei((nlag-1):-1:1);

        % Compute the fft
        % It'd be nice if we could use MATLAB's fft, but I think the
        % custom fft_tfr does some sort of array flipping too
        [tfslicer, tfslicei] = fft_tfr(fftlen,mfft,tfslicer,tfslicei);

        itemp = fftlen/2 + fstep;
        j = 1;
        for i=itemp:fstep:(fftlen-1),
            ofp(outct,j) = tfslicer(i+1);
            j = j + 1;
        end

        for i=0:fstep:(itemp-1),
            ofp(outct,j) = tfslicer(i+1);
            j = j + 1;
        end
    end
end

% Now print the output
f_axis = samp_freq * ((-fftlen/2):fstep:((fftlen/2)-fstep)) / fftlen;  % in Hz
t_axis = 0:tstep:(tlen-1);  % in seconds
contour(t_axis,f_axis,flipud(abs(ofp')));
xlabel('Time');
ylabel('Frequency [Hz]');

fprintf('\nFinished. Output is in variable "ofp"\n');

