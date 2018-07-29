function  resistance = memristor(time,voltage,r_i,r_off,r_on,d,u_v)
%% MEMRISTOR  Numerical solution for memristor device
%
%   MEMRISTOR(time, v)
%   MEMRISTOR(time, voltage, r_i)
%   MEMRISTOR(time, voltage, r_i, r_off)
%   MEMRISTOR(time, voltage, r_i, r_off, r_on)
%   MEMRISTOR(time, voltage, r_i, r_off, r_on, d)
%   MEMRISTOR(time, voltage, r_i, r_off, r_on, d, u_v)
%
%   MEMRISTOR(time, voltage, ...) returns the numerical solution of the 
%   resistance of the memristor for a arbitrary voltage and time vectors.
%
%   note: time and the voltage vectors have to be of the same length.
%
%   Function Parameters:
%   time:     time vector
%   v:        voltage vector
%   r_i:      intial resistance of the device in ?(default: 1K?)
%   r_off:    off (maximum) resistance of the device in ? (default: 38K?)
%   r_on:     on (minimum) resistance of the device in ? (default: 0.1K?)
%   d:        device length in nm (default: 10nm)
%   u_v:      dopant drift mobilty of the device material (default: 10^-14)
%
%   Example:
%   	t = 0:0.001:4;
%   	v = 1.5*sin(2*pi*t); %f = 1Hz
%       r = memristor(t, v, 2*10^3);
%       plot(t,r)
%
%       i = v./r;
%       figure
%       plot(i,v)

% Authors:
% M. Affan Zidan, A. G. Radwan, and K. N. Salama
% King Abdullah University of Science and Technology
% Email: {mohammed.zidan,ahmed.radwan,khaled.salama}@kaust.edu.sa

% References:
% [1]	A. G. Radwan, M. Affan Zidan, and K. N. Salama, “On the 
%       mathematical modeling of Memristors,”22nd International Conference 
%       on Microelectronics (ICM 2010), pp. 284-287, Egyptime, December 
%       2010
% 	
% [2]	A. G. Radwan, M. Affan Zidan, and K. N. Salama, “HP memristor 
%       mathematical model forperiodic signals and DC,” IEEE International 
%       Midwest Symposium on Circuits and Systems(MWSCAS), pp. 861-864, 
%       USA, August 2010
%
% [3]   D. B. Strukovoltage, G. S. Snider, and D. R. Stewartime, “The 
%       missing memristor found,” Nature, vol. 435, pp. 80–83, 2008

% History:
% Created: 14-May-2011

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2011, M. Affan Zidan, A. G. Radwan and K. N. Salama       %
% All rights reserved.                                                    %
%                                                                         %
% Redistribution and use in source and binary forms, with or without      %
% modification, are permitted provided that the following conditions are  %
% met:                                                                    %
%     * Redistributions of source code must retain the above copyright    %
%       notice, this list of conditions and the following disclaimer.     %
%     * Redistributions in binary form must reproduce the above copyright %
%       notice, this list of conditions and the following disclaimer in   %
%       the documentation and/or other materials provided with the        %
%       distribution                                                      %
%     * Neither the name of the King Abdullah University of Science and   %
%       Technology (KAUST) nor the names of its contributors may be used  %
%       to endorse or promote products derived from this software without %
%       specific prior written permission.                                %
%                                                                         %
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS     %
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT           %
% NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   %
% FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE          %
% COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECtime,            %
% INDIRECtime, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES   %
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR      %
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)      %
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACtime,  %
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING  %
% IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE      %
% POSSIBILITY OF SUCH DAMAGE.                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Error checking
if nargin <2
    error('Function expects at least time and voltage vectors');
end

% time and voltage have to be of the same length
if ~isequal(length(time),length(voltage))
    error('Time and voltage vectors have to be of the same length.');
end
%% Default values
if nargin < 7
    u_v = 10^-14;
end
if nargin < 6
    d = 10*10^-9;
end
if nargin < 5
    r_on = 0.1*10^3;
end
if nargin < 4
    r_off = 38*10^3;
end
if nargin < 3
    r_i = 2*10^3;
end
%% Memristor resistance
k = u_v * r_on / d^2;
r_d = r_off - r_on;
resistance(1) = r_i;
area(1) = 0;
i1=1;
for i=2:length(time)
    area(i) = area(i1) + 0.5*(voltage(i)+voltage(i1))*(time(i)-time(i1));
    resistance(i) = sqrt( resistance(1)^2 + 2 * k * r_d * area(i));
    i1=i;
end
% saturation condition
resistance(resistance>r_off)=r_off;
resistance(resistance<r_on)=r_on;
%eof
