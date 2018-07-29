function [controller] = DFOC(K, Ti, Td, m, d, Ts, n, method)

% function [controller] = DFOC(K, Ti, Td, m, d, Ts, n, method)
%
% Digital Fractional Order P-I-D Controller (DFOC) of the form : 
% C(s) = K + Ti/s^m + Td*s^d for given sampling period Ts [sec].
% Continuos Laplace operator 's^a' can be approximated by three
% different approximation methods, which were already published
% by author at the Matlab Central File Exchange, MathWorks, Inc.:
% http://www.mathworks.com/matlabcentral/fileexchange/3672
% http://www.mathworks.com/matlabcentral/fileexchange/3673 
% http://www.mathworks.com/matlabcentral/fileexchange/31358
% Above functions are used according to a different set of input
% parameters of the DFOC function, namely, a parameter 'method'.
%
% Input parameters:     
% K : (P)roportional constant
% Ti: (I)ntegration constant
% Td: (D)erivative constant
% m : order of fractional integral
% d : order of fractional derivative
% Ts: sampling period in [sec]
% n : number of terms (approximation order) after truncation 
% method: used approximation method, the available options are:
% - CFE of Euler rule  :    'CFE_Euler'
% - CFE of Tustin rule :    'CFE_Tustin'
% - PSE of Euler rule  :    'PSE_Euler'
% - PSE of Tustin rule :    'PSE_Tustin'
% Note: If input parameter 'method' is not used during calling
% the function DFOC, the default method is set to 'PSE_Euler'.
% If the input parameter 'n' is not used during the calling of
% the function, value is set to 100. In function dfod1 it is 5.
%
% Output parameter:
% controller :  transfer function of the digital fractional-order
%               controller in the discrete z-domain for given Ts
%
% Example: C = DFOC(10.1, 20, 3.5, 0.5, 1, 0.1, 30, 'PSE_Tustin');
%
% Copyright (c), 2011. Author: Ivo Petras (ivo.petras@tuke.sk)

if nargin < 8  
    method='PSE_Euler'; 
end
if nargin < 7  
    n=100; 
end
if nargin < 6  
    disp('Missing input parameter(s)!')
end
% The following lines install necessary supporting functions:
if ~(exist('dfod1', 'file') == 2)
    P = requireFEXpackage(3672); 
end 
if ~(exist('dfod2', 'file') == 2)
    P = requireFEXpackage(3673);  
end 
if ~(exist('dfod3', 'file') == 2)
    P = requireFEXpackage(31358);  
end 
% Transfer function of the fractional-order PID controller:
switch lower(method)
    case 'cfe_euler'    
        controller = K + Ti*dfod1(n,Ts,0,-m) + Td*dfod1(n,Ts,0,d);
    case 'cfe_tustin'
        controller = K + Ti*dfod1(n,Ts,1,-m) + Td*dfod1(n,Ts,1,d);
    case 'pse_euler'    
        controller = K + Ti*dfod2(n,Ts,-m)  + Td*dfod2(n,Ts,d);
    case 'pse_tustin' 
        controller = K + Ti*dfod3(n,Ts,-m)  + Td*dfod3(n,Ts,d);
    otherwise
        disp('Unknown method.')
end  