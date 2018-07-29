%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function kurtpar:	 						 			   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function gets Y signal and t time vector as inputs. %
% It  filters  the  signal according to original resonance %
% frequencies, and performs a kurtosis claculation of each %
% filtered signal.                                         %
% Finally, it sends the 3 kurtosis calculations as K1,K2,K3%
% outputs.                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [K1, K2, K3]=kurtpar(Y,t)
dt = t(2)-t(1);			% Get time interval.
Wmax = pi/dt;			% Get the maximum frequency.
W1 = 120;
W2 = 500;
W3 = 1500;
Delta1 = 40;			% \ Define the range around the resonance
Delta2 = 100;			% =>frequencies for the Kurtosis to be
Delta3 = 200;			% / calculated in.
% Create the filter using Butterworth filter.
if (Wmax > W1+Delta1)
    [B,A]=butter(6,[(W1-Delta1)/Wmax (W1+Delta1)/Wmax]);
    X=filtfilt(B,A,Y);	% Filtering within given limits & order
    K1=kurt(X);			% Kurtosis No.1
    K2=0;
    K3=0;
end
if (Wmax > W2+Delta2)
    % Create the filter using Butterworth filter.
    [B,A]=butter(6,[(W2-Delta2)/Wmax (W2+Delta2)/Wmax]);
    X=filtfilt(B,A,Y);	% Filtering within given limits & order
    K2=kurt(X);         % Kurtosis No.2
    K3=0;
end
if (Wmax > W3+Delta3)
    % Create the filter using Butterworth filter.
    [B,A]=butter(6,[(W3-Delta3)/Wmax (W3+Delta3)/Wmax]);
    X=filtfilt(B,A,Y);	% Filtering within given limits & order
    K3=kurt(X);         % Kurtosis No.3
end