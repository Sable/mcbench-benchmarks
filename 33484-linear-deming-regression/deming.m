function [ b sigma2_x x_est y_est stats] = deming(x,y,lambda,alpha)
% [ b sigma2_x x_est y_est stats] = deming(x,y,lambda,alpha)
%
% deming() performs a linear Deming regression to find the linear
% coefficients:
%                     y = b(1) + b(2)*x
% under the assumptions that x and y *both* contain measurement error with
% measurement error variance related as lambda = sigma2_y/sigma2_x
% (sigma2_x and sigma2_y is the measurement error variance of the x and y
% variables, respectively).
%
% Computations are performed as described by Anders Christian Jenson in a
% May 2007 description of the Deming regression function for MethComp
% (web: http://staff.pubhealth.ku.dk/~bxc/MethComp/Deming.pdf), which
% includes a nice derivation of the slope, intercept, variance, and (x,y)
% estimates.
%
% Inputs: x         - [Nx1] Measured data w/ error
%         y         - [Nx1] Measured data w/ error
%         lambda    - [1x1] [OPTIONAL] Relationship between measurement
%                           error expressed as ratio:   sigma2_y / sigma2_x
%                           (default = 1)
%         alpha     - [1x1] [OPTIONAL] Confidence level
%                           (default = 0.05)
%
% Outputs: b        - [2x1] Intercept (1) and slope (2)
%          sigma2_x - [1x1] Error variance
%                           Note:  sigma2_y = lambda*sigma2_x
%          x_est    - [Nx1] Estimated x values
%          y_est    - [Nx1] Estimated y values
%          stats    - [STR] Additional statistical information
%                        .s_e  - Standard error of regression estimate
%                        .s_b  - Jacknife estimate of standard error of the 
%                                slope and intercept
%                        .t_c  - *Critical t-value used for confidence intervals
%                        .b_ci - *Confidence interval for slope and intercept
%
% *stats.b_ci and stats.t_c are only available if the statistics package is
%  installed and/or the tinv function is available.
%
% Example:
%
%   % Setup Problem
%   N      = 10;       % Number of samples
%   x_e    = 2;        % Measurement error variance for x
%   y_e    = 2;        % Measurement error variance for y
%   b_true = [100; 1]; % True coefficient values
%
%   % Generate Data
%   x_true = (1:9/(N-1):10).';              % True x-values
%   y_true = b_true(1) + b_true(2)*x_true;  % True y-values
%   x_meas = x_true + sqrt(x_e)*randn(size(x_true)); % Noisy x-value measurements
%   y_meas = y_true + sqrt(y_e)*randn(size(x_true)); % Noisy y-value measurements
%
%   % Estimate b-values (Deming)
%   [b_dem sigma x_est y_est]  = deming(x_meas,y_meas,y_e/x_e);
%
%   % Estimate b-values (Least Squares)
%   b_lsr  = flipud(polyfit(x_meas,y_meas,1).'); 
%
%   % Plot Results for Comparison
%   figure;hold all;
%   pMeas = plot(x_meas,y_meas,'x','LineWidth',2);
%   pRef  = plot(x_true,y_true,'-.','Color',[.7 .7 .7],'LineWidth',3);
%   axis image;
%   pLSR  = plot(x_true,b_lsr(1)+b_lsr(2)*x_true,'Color',[0 .5 0],'LineWidth',3);
%   plot([x_meas x_meas].',[y_meas b_lsr(1)+b_lsr(2)*x_meas].','Color',[0 .5 0],'LineWidth',1);
%   pDEM  = plot(x_true,b_dem(1)+b_dem(2)*x_true,'Color',[1 0  0],'LineWidth',3);
%   plot([x_meas x_est].',[y_meas y_est].','Color',[1 0 0],'LineWidth',1);
%   legend([pMeas pRef pLSR pDEM], 'Measurements','True Relationship', ...
%                                  'Least Squares Regression','Deming Regression');
%
% Copyright (c) 2011, Hidden Solutions, LLC
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%
%   * Redistributions of source code must retain the above copyright
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright
%      notice, this list of conditions and the following disclaimer in the
%      documentation and/or other materials provided with the distribution.
%    * Neither the name Hidden Solutions, LLC nor the names of any
%      contributors may be used to endorse or promote products derived from 
%      this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL HIDDEN SOLUTIONS, LLC BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
% Author: James S. Hall (Hidden Solutions, LLC - www.hiddensolutionsllc.com)
% Date:   10/27/2011
%

% Assign defaults
if nargin < 3
  lambda = 1;
end

% Check that x and y appear as expected
if length(x) ~= length(y)
  error('x and y must have the same length');
end
if size(x,2) > 1 || size(y,2) > 1
  error('x and y must both be vectors');
end

% Verify that lambda isn't anything unexpected
if numel(lambda) > 1
  error('lambda must be a scalar value');
end

% Set default value for alpha
if nargin < 5
  alpha = 0.05;
end

% Generate working variables
n            = length(y);  % Number of elements
m_x          = mean(x);    % Mean value of x
m_y          = mean(y);    % Mean value of y
c_xy         = cov(x,y);   % Covariance matrix of x and y
s_xx         = c_xy(1);    % Variance of x
s_xy         = c_xy(2);    % Covarince of x and y
s_yy         = c_xy(4);    % Variance of y
  
% Assign slope an intercept (in closed-form)
b            = zeros(2,1);
b(2)         = (s_yy - lambda*s_xx + sqrt((s_yy - lambda*s_xx).^2 + 4*lambda*s_xy^2)) ./ ...
               (2*s_xy);
b(1)         = m_y - b(2)*m_x;

% Don't compute x_est, y_est, and sigma2_x if they aren't requested
if nargout > 1

  % Assign x/y estimated values
  x_est        = x    + b(2)./(b(2).^2 + lambda)*(y - b(1) - b(2)*x);
  y_est        = b(1) + b(2)*x_est;

  % Determine sigma2
  sigma2_x     = sum(lambda*(x-x_est).^2 + (y - b(1) - b(2)*x_est).^2)./(2*lambda*(n-2));

  if nargout > 4
    
    % Compute standard error of the linear regression
    % Equivalent to: sqrt(sum(((y-y_est).^2 + (x-x_est).^2))/(n-2))
    % Note - (n-2) is used for unbiased estimate since x AND y are estimated
    %         here
    stats.s_e = sqrt((1 + lambda)*sigma2_x);
    
    % Perform deming regression with one less sample for jacknife analysis
    b_sub = zeros(2,n);
    ignoreFlag = [false; true(n-1,1)];
    for nn = 1:n
      b_sub(:,nn) = deming(x(circshift(ignoreFlag,nn)),y(circshift(ignoreFlag,nn)),lambda);
    end
    
    % Compute standard error of the slope and intercept
    stats.s_b = std(b_sub,[],2);
    
    % Compute confidence intervals for slope and intercept
    if exist('tinv','file')
      % Statistics toolbox is installed
      stats.t_c    = tinv(1-alpha/2,n-2);
      stats.b_ci   = b*[1 1] + stats.t_c*stats.s_b*[-1 1];
    else
      % Create empty variables
      stats.tc     = [];
      stats.b_ci   = [];
    end
    
  end
  
end


end
