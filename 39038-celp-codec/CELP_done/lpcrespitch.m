function Phat = lpcrespitch(ehat,th,minlag,maxlag)
%  lpcrespitch --> Pitch estimation from prediction error sequence.
%
%    The function performs autocorrelation based pitch estimation on
%    the prediction error sequence, ehat. The function finds the maximum
%    autocorrelation value for lags in the interval minlag to maxlag. If
%    this peak value is larger than the threshold th*Re(0), then the
%    error frame originates from a voiced speech sound and the
%    corresponding lag index is the pitch period.

% Short-term autocorrelation.
[rehat,eta] = xcorr(ehat,maxlag,'biased');

% Find max autocorrelation for lags in the interval minlag to maxlag.
[remax,idx] = max(rehat(maxlag+minlag+1:2*maxlag+1));

% If peak value larger than threshold, then lag index is pitch period.
if (remax > th*rehat(maxlag+1))
  Phat = eta(maxlag+minlag+idx);
else
  Phat = 0;
end
