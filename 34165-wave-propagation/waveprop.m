function [f, U, A, B] = waveprop(input)
% Function  [f, U, A, B] = WAVEPROP(input)  calculates the displacement
% fields on the soil interfaces, caused by the wave propagation of a
% unitary VERTICAL SV or SH wave through an elastic multilayer soil
% profile.
%
% Input to the function is a structure array "input", where:
%   input.Vs          : vector of shear wave velocities of the soil layers, 
%                          top one first - bedrock last 
%                          [Vstop ... Vsbottom Vsbedrock]
%   input.rho         : vector of the unit weight of the soil layers, 
%                          top one first - bedrock last
%                          [rhotop ... rhobottom rhobedrock]
%   input.damp        : vector of the material damping of the soil layers, 
%                          top one first - bedrock last 
%                          [ksitop ... ksibottom ksibedrock]
%   input.freq        : vector of the frequencies of interest
%                          [0:df:(N-1)*df] 
%   input.layer_thick : vector with the thickness of the layers, top one first    
%                          [Htop ... Hbottom]
%
% Output is a matrix [f U A B], where
%   f : frequency vector 
%   U : displacement on the interfaces 
%   A : waves propagating upwards
%   B : waves propagating downwards
%
% Attention ! 
% ~~~~~~~~~~~ 
% - The soil layers are considered to be over an elastic halfspace bedrock,
%   thus no "layer thickness" is assumed for the bedrock 
% - The damping introduced is the "geotechnical" definition, [i.e.
%   geotechnical definition (ksi =beta/2)]
%               
% Attention ! 
% ~~~~~~~~~~~ 
% - All displacements fields are calculated on the soil layer interfaces
%   row_num=interface_num, column_num=freq_num 
%
% ATTENTION ! 
% ~~~~~~~~~~~ 
% The Nyquist frequency (=N*df/2) has to be higher than the
% higher frequency in the highest frequency of interest in order to
% have a correct complex response, symmetric arround the Nyquist frequency
%
% % EXAMPLE:
% f0   = 0;
% Fs   = 100;  % (in Hz) Frequency sample
% NFFT = 2^12; % number of frequencies for discretization
% 
% input.Vs          = [200 300 2000];      % (m/s)
% input.rho         = [2000 2100 2400];    % (kgr/m3)
% input.damp        = [0.04 0.03 0.01];    % 
% input.freq        = linspace(f0,Fs,NFFT);% frequency range
% input.layer_thick = [10 10];             % (m) ! no thickness for bedrock!
% 
% % Call function
% [f, U, A, B] = waveprop(input);
% 
% % Frequency response function
% FRF = U(1,:)./U(end,:);
% 
% % plot
% figure(1);plot(f,abs(FRF));xlim([0 Fs/2])
% 
%
%--------------------------------------------------------------------------
% Dimitris Pitilakis (dpitilakis@gmail.com)
%
% Revised: 10 Dec 2011
%--------------------------------------------------------------------------



if length(input.Vs) ~= length(input.layer_thick)+1
    disp('There is a problem with the number of velocities Vs assigned to the various layers')
    disp(' ')
    disp('Solution: Assign velocities for the all soil layers and for the bedrock')
end

% frequency vector
f = input.freq;

% circular frequency vector
omega = 2*pi*input.freq;

% imaginary "i"
clear i; i=sqrt(-1);

% complex shear wave velocity
Vsstar = input.Vs.*(1+i*input.damp);

% thickness of the soil layers
h = input.layer_thick; 

% number of soil layers + bedrock
layernum = length(input.Vs); 

% complex impendance ratio on layer interfaces
az=zeros(layernum-1);
for i1 = 1:layernum-1
    az(i1) = input.rho(i1) * Vsstar(i1) / ( input.rho(i1+1) * Vsstar(i1+1) );
end

% Initialization of matrices
kstar = zeros(layernum,length(input.freq));
A     = zeros(layernum,length(input.freq));
B     = zeros(layernum,length(input.freq));
U     = zeros(layernum,length(input.freq));

% Calculate transfer functions
for i1 = 1:layernum  % Loop for the soil layers
    
    for i2 = 1:length(input.freq)  % Loop for the frequencies
        
        kstar(i1,i2) = omega(i2)./Vsstar(i1);  % complex wave number kstar=omega/Vsstar
        
        if i1 == 1
            A(i1,i2) = 0.5*exp(i*kstar(i1,i2)*input.layer_thick(i1)) + ...
                0.5*exp(-i*kstar(i1,i2)*input.layer_thick(i1));
            
            B(i1,i2) = 0.5*exp(i*kstar(i1,i2)*input.layer_thick(i1)) + ...
                0.5*exp(-i*kstar(i1,i2)*input.layer_thick(i1));
            
            U(i1,i2) = A(i1,i2) + B(i1,i2);
        else
            A(i1,i2) = 0.5*A(i1-1,i2) * (1+az(i1-1)) * exp(i*kstar(i1-1,i2)*input.layer_thick(i1-1)) + ...
                0.5*B(i1-1,i2) * (1-az(i1-1)) * exp(-i*kstar(i1-1,i2)*input.layer_thick(i1-1));
            
            B(i1,i2) = 0.5*A(i1-1,i2) * (1-az(i1-1)) * exp(i*kstar(i1-1,i2)*input.layer_thick(i1-1)) + ...
                0.5*B(i1-1,i2) * (1+az(i1-1)) * exp(-i*kstar(i1-1,i2)*input.layer_thick(i1-1));
            
            U(i1,i2) = A(i1,i2) + B(i1,i2);
        end %end if
        
    end %end i2
    
end %end i1

N = length(input.freq);

% Complex conjugates for "perfect" ifft
if round(rem(N,2))==1 
    ia = 2:1:(N+1)/2; 
    ib = N:-1:(N+3)/2;
else ia = 2:1:N/2; ib = N:-1:N/2+2;
end

A(:,ib) = conj(A(:,ia)) ;
B(:,ib) = conj(B(:,ia)) ;
U(:,ib) = conj(U(:,ia)) ;
