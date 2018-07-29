function surrblk = phaseran(recblk,nsurr)

% Input data
% ----------
% recblk: is a 2D array. Row: time sample. Column: recording.
% An odd number of time samples (height) is expected. If that is not
% the case, recblock is reduced by 1 sample before the surrogate
% data is created.
% The class must be double and it must be nonsparse.
%
% nsurr: is the number of image block surrogates that you want to 
% generate.
% 
% Output data
% ---------------------
% surrblk: 3D multidimensional array image block with the surrogate
% datasets along the third dimension
% 
% Example 1
% ---------
%   x = randn(31,4);
%   x(:,4) = sum(x,2); % Create correlation in the data
%   r1 = corrcoef(x) 
%   surr = phaseran(x,10);
%   r2 = corrcoef(surr(:,:,1)) % Check that the correlation is preserved

%   Carlos Gias
%   Date: 21/08/2011

% Reference:
% Prichard, D., Theiler, J. Generating Surrogate Data for Time Series
% with Several Simultaneously Measured Variables (1994)
% Physical Review Letters, Vol 73, Number 7

% Get parameters
[nfrms,nts] = size(recblk);
if rem(nfrms,2)==0
    nfrms = nfrms-1;
    recblk=recblk(1:nfrms,:);
end
    
% Get parameters
len_ser = (nfrms-1)/2;
interv1 = 2:len_ser+1; 
interv2 = len_ser+2:nfrms;

% Fourier transform of the original dataset
fft_recblk = fft(recblk);

% Create the surrogate recording blocks one by one
surrblk = zeros(nfrms, nts, nsurr);
for k = 1:nsurr
   ph_rnd = rand([len_ser 1]);
   
   % Create the random phases for all the time series
   ph_interv1 = repmat(exp( 2*pi*1i*ph_rnd),1,nts);
   ph_interv2 = conj( flipud( ph_interv1));
   
   % Randomize all the time series simultaneously
   fft_recblk_surr = fft_recblk;
   fft_recblk_surr(interv1,:) = fft_recblk(interv1,:).*ph_interv1;
   fft_recblk_surr(interv2,:) = fft_recblk(interv2,:).*ph_interv2;
   
   % Inverse transform
   surrblk(:,:,k)= real(ifft(fft_recblk_surr));
end
