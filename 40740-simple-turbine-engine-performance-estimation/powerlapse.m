function [lapse,compressionBenefit] = powerlapse(h,M,assumptions)
% POWERLAPSE determines the amount of power available from a gas turbine
% engine as a function of flight altitude and Mach number.
% 
%   lapse = POWERLAPSE(h,M,assumptions)
% 
%   lapse:       Ratio of available power to available power under sea
%                level static conditions, Pavail/Psls
%   h:           Altitude in meters
%   M:        	 Mach number
%   assumptions: Unused placeholder input; a stuct whose fields contain 
%                assumptions for analysis
% 
%   POWERLAPSE requires a standard atmosphere model on the MATLAB path.
% 
%   See also DEMOENGINEDECK,
%    STDATMO - http://www.mathworks.com/matlabcentral/fileexchange/28135.s

if exist('stdatmo','file') >= 2
    sigma = stdatmo(h)/1.22500;
elseif exist('atmosisa','file') >= 2
    [~,~,~,rho] = atmosisa(h);
    sigma = rho/1.22500;
else
    link = 'http://www.mathworks.com/matlabcentral/fileexchange/28135';
    a='POWERLAPSE requires a standard atmosphere model on the MATLAB path';
    b=['<a href="' link '">STDATMO on MatlabCentral</a>'];
    c=['<a href="' link '?download=true">STDATMO direct download</a>'];
    error('%s.\n%s\n%s',a,b,c)
end

% Interpolation method
%{
M0=[0
0.2
0.4
0.6
0.8];

b0 = [1.000
1.009
1.037
1.079
1.132];

compressionBenefit = interp1(M0,b0,M,'linear');
%}

compressionBenefit = (1+0.8*M.^2).^.3;

lapse = (sigma.^1.0).*compressionBenefit;

end