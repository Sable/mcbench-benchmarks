%DVBS2Constellation Signal Constellations taken from ETSI EN 302 307
% [CONSTELLATION, BITMAPPING] = DVBS2Constellation(MODSCHEME,GAMMA) returns 
% the constellation points and the bit mapping specified in the DVB-S2 Standard
% ETSI EN 302 307. The output vector CONSTELLATION contains the constellation 
% points and the output vector BITMAPPING contains the associated bit mapping. 
% The data of these vectors is organized such that the vectors can directly 
% fed into the sigmapper or llr_demod_mex constructor. 
%
% The DVB-S2 Standard ETSI EN 302 307 specifies signal constellations for
% four different modulation schemes: QPSK, 8PSK, 16APSK and 32APSK. 
%
% MODSCHEME denotes the modulation scheme. GAMMA sets the constellation radius 
% ratios which are required when using the constellation schemes 16APSK and 
% 32APSK. If the modulation schemes QPSK and 8PSK are used, no additional 
% input GAMMA is needed.
% (for more information:
% http://www.etsi.org/deliver/etsi_en/302300_302399/302307/01.02.01_60/en_3
% 02307v010201p.pdf)
%
% Important: The radius of the inner circle of the modulation schemes 16APSK 
% and 32 APSK always has unit length. If the signal power should be normalized 
% to one, the constellations points must be scaled accordingly.
%
% Input: MODSCHEME [char] 'QPSK', '8PSK', '16APSK', '32APSK'
%        GAMMA [1x1] (16APSK), [1x2] (32APSK)
%         
% Output: CONSTELLATION [1xM]
%         MAPPING [1xM]
%
% Version 0.1
%
% Author: Bernhard Schmidt
%
% Copyright 2011 by Bernhard Schmidt
% Permission is granted to use this program/data for educational/research
% only

function [constellation, mapping] = DVBS2Constellation(ModScheme,varargin)

if ischar(ModScheme)
    switch lower(ModScheme)
        case 'qpsk'
            R = 1; % radius
            M = 4; % modulation order
            phi0 = pi/4;
            mapping = [0,2,3,1];
            
        case '8psk'
            R = 1;
            M = 8;
            phi0 = pi/4;
            mapping = [0,4,6,2,3,7,5,1];
            
        case '16apsk'
            if nargin ==2
                if isscalar(varargin(1))
                    gamma = varargin{1};
                    R = [1 1*gamma]; % r1 = 1; r2 = r1*gamma
                    M = [4 12];
                    phi0 = [pi/4 pi/12];
                    mapping = [12,14,15,13,4,0,8,10,2,6,7,3,11,9,1,5];
                else
                    disp('GAMMA must be scalar!')
                end
            else
                error('GAMMA is missing!')
            end      
        case '32apsk'
            if nargin ==2
                if length(varargin{1})==2
                    gamma = varargin{1};
                    R = [1 1*gamma(1) 1*gamma(2)]; % r1 = 1; r2 = r1*gamma(1), r3 = r1*gamma(2)
                    M = [4 12 16];
                    phi0 = [pi/4 pi/12 0];
                    mapping = [17,21,23,19,16,0,1,5,4,20,22,6,7,3,2,18,24,8,25,9,13,29,12,28,30,14,31,15,11,27,10,26];
                    
                else
                    disp('GAMMA must have length 2!')
                end
            else
                error('GAMMA is missing!')
            end      
            
        otherwise
            error(['Valid constellation schemes are QPSK, 8PSK, 16APSK and 32APSK!'])
    end
else
    error('First input must be char!')
end

constellation =[];

for k = 1:length(R)
    for kk = 0:M(k)-1
        
        constellation = [constellation R(k)*exp(1j*(2*pi*kk/M(k)+phi0(k)))];
        
    end
end