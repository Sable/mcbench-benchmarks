function [x T] = LineEncoder(type,inbits,Tb,A)
% This function implements various Line Coding technique such as Unipolar
% RZ, Unipolar NRZ, Polar RZ, Ppolar NRZ, Manchester, and Bipolar NRZ.
%
% INPUT:
%           type = string accepting the type of coding as
%                    'uninrz'
%                    'unirz'
%                    'polnrz'
%                    'plorz'
%                    'manchester'
%                    'ami'
%           inbits = input bits row vector
%           Tb = Bit time period
%           A = Amplitude of the coding
%           Ts = Sampling time
% OUTPUT:
%           x = Output line coding row vector
%           T = time vector
%
%

%---Implemented by ASHISH MESHRAM
%---meetashish85@gmail.com http://www.facebook.com/ashishmeet

%---Checking input arguments
if nargin<4, A = 1;end
if nargin<3, Tb = 1e-9;end
if nargin<2, inbits = [1 0 1 0];end
if nargin<1, type = 'uninrz';end

%---Implementation starts here
Rb = 1/Tb; %---Bit rate
Fs = 4*Rb;
N = length(inbits);   %---Bit Length of input bits
tTb = linspace(0,Tb); %---interval of bit time period
x = [];
switch lower(type)
    case 'uninrz'
        for k = 1:N
            x = [x A*inbits(k)*ones(1,length(tTb))];
        end
    case 'unirz'
        for k = 1:N
            x = [x A*inbits(k)*ones(1,length(tTb)/2) 0*inbits(k)*ones(1,length(tTb)/2)];
        end
    case 'polrz'
        for k = 1:N
            c = ones(1,length(tTb)/2);
            b = zeros(1,length(tTb)/2);
            p = [c b];
            x = [x ((-1)^(inbits(k)+1))*(A/2)*p];
        end
    case 'polnrz'
        for k = 1:N
            x = [x ((-1)^(inbits(k) + 1))*A/2*ones(1,length(tTb))];
        end
    case 'manchester'
        for k = 1:N
            c = ones(1,length(tTb)/2);
            b = -1*ones(1,length(tTb)/2);
            p = [c b];
            x = [x ((-1)^(inbits(k)+1))*A/2*p];
        end
    case 'ami'
end

T = linspace(0,N*Tb,length(x)); %---Time vector for n bits