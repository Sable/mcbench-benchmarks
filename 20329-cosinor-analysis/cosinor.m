function [] = cosinor(t,y,w,alpha)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COSINOR 	[]=cosinor(t,y,w,alpha)
%
% Description: 
%   Cosinor analysis uses the least squares method to fit a sine wave to a
%   time series. Cosinor analysis is often used in the analysis
%   of biologic time series that demonstrate predictible rhythms. This
%   method can be used with an unequally spaced time series.
%
%   Follows cosinor analysis of a time series as outlined by
%   Nelson et al. "Methods for Cosinor-Rhythmometry" Chronobiologica.
%   1979. Please consult reference.
%
% Input:
%   t - time series
%   y - value of series at time t
%   w - cycle length, defined by user based on prior knowledge of time
%       series
%   alpha - type I error used for cofidence interval calculations. Usually 
%       set to be 0.05 which corresponds with 95% cofidence intervals
%
% Define Variables:
%   M - Mesor, the average cylce value
%   Amp - Amplitude, half the distance between peaks of the fitted
%       waveform
%   phi - Acrophase, time point in the cycle of highest amplitude (in
%       radians)
%   RSS - Residual Sum of Squares, a measure of the deviation of the
%       cosinor fit from the original waveform
%
% Subfunctions:
%   'CIcalc.m'
%
% Example:
%   Define time series: 
%       y = [102,96.8,97,92.5,95,93,99.4,99.8,105.5];
%       t = [97,130,167.5,187.5,218,247.5,285,315,337.5]/360;
%   Define cycle length and alpha:
%       w = 2*pi;
%       alpha = .05;
%   Run Code:
%       cosinor(t,y,w,alpha)

% Record of revisions:
%     Date           Programmmer        Description of change
%     =====          ===========        ======================
%     5/16/08        Casey Cox          Original Code
%     6/24/08        Casey Cox          Revisions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin ~= 4
    error('Incorrect number of inputs');
end
if length(t) < 4
    error('There must be atleast four time measurements')
end

%% I. Parameter Estimation

n = length(t);

% Substituition
x = cos(w.*t);
z = sin(w.*t);

% Set up and solve the normal equations simultaneously
NE = [  n        sum(x)       sum(z)     sum(y);
      sum(x)   sum(x.^2)    sum(x.*z)    sum(x.*y);
      sum(z)   sum(x.*z)    sum(z.^2)    sum(z.*y);];

RNE = rref(NE);
M = RNE(1,4); beta = RNE(2,4); gamma = RNE(3,4);

%Calculate amplitude and acrophase from beta and gamma
Amp = sqrt(beta^2 + gamma^2);
theta = atan(abs(gamma/beta));

    % Calculate acrophase (phi) and convert from radians to degrees
    a = sign(beta);
    b = sign(gamma);
    if (a == 1 || a == 0) && b == 1
        phi = -theta;
    elseif a == -1 && (b == 1 || b == 0) 
        phi = -pi + theta;
    elseif (a == -1 || a == 0) && b == -1
        phi = -pi - theta;
    elseif a == 1 && (b == -1 || b == 0)
        phi = -2*pi + theta;
    end

% Display results
disp('Parameters:'); disp('---------------');
fprintf(1,'Mesor = %g \nAmplitude = %g \nAcrophase = %g \n\n',M,Amp,phi);

%Plot orginal data and cosine fit
f = M + Amp*cos(w.*t+phi);

    figure('name','Cosinor Analysis: Original data and fitted function');
    plot(t,y); hold on;
        xlabel('x-axis');
        ylabel('y-axis');
    plot(t,f,'r');
        legend('Original', 'Cosinor');
        xlim([min(t) max(t)]);
 
        

%% II. Confidence Limtes for Single Cosinor

%Residual sum of errors
RSS = sum((y - (M + beta.*x + gamma.*z)).^2);

%Residual varience estimation
sigma = sqrt(RSS/(n-3));

%Find confidence interval for mesor
    X = 1/n * sum((x - mean(x)).^2);
    Z = 1/n * sum((z - mean(z)).^2);
    T = 1/n * sum((x - mean(x)).*(z - mean(z)));

%Confidence interval for the mesor
CI_M = tinv(1-alpha/2,n-3)*sigma^2*sqrt(((sum(x.^2))*(sum(z.^2)) - (sum(x.*z))^2)/(n^3*(X*Z - T^2))); %#ok<NASGU>

%Find confidence intervals for the amplitude and acrophase
[CI_Amp_min, CI_Amp_max, CI_phi_min, CI_phi_max] = CIcalc(X,T,Z,beta,gamma,n,sigma,Amp,phi,alpha); %#ok<NASGU,NASGU>

%% III. Zero-amplitude test
p_3a = fpdf((n*(X*beta^2 + 2*T*beta*gamma + Z*gamma^2)/(2*sigma^2)),2,n-3);
fprintf(1,'Zero Amplitude Test \n')
fprintf(1,'------------------------------------------------------\n')
fprintf(1,'Amplitude        0.95 Confidence Limits        P Value\n')
fprintf(1,'---------        ----------------------        -------\n')
fprintf(1,' %.2f               (%.2f to %.2f)             %g\n\n',Amp,CI_Amp_min,CI_Amp_max,p_3a)
