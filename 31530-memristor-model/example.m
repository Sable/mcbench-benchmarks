%% Example.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2011, M. Affan Zidan, A. G. Radwan and K. N. Salama       %
% King Abdullah University of Science and Technology                      %
% All rights reserved.                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%
% Time
t = [];
t = 0:0.001:4;

% Input Voltage
v = 1.5*sin(2*pi*t);                   %sin
%v = 2 * square(2*pi*t,50);             %square
%v = sawtooth(2*pi*(t+3/(4*pi)),0.5);  	%triangle
%v = ones(1,length(t));                 %DC
%v= 0.5*fix(t);                         % Staircase input

% Memristor Resistance
r = memristor(t, v, 2*10^3);

% Current
i = v./r;

%% Plotting
[ha,hl1,hl2] = plotyy(t,v,t,i);
xlabel('Time')
set(hl1,'color','b');
set(hl2,'color','r');
axes(ha(1));
ylabel('Voltage')
axes(ha(2));
set(ha(2),'YColor','r');
ylabel('Current','color','r')
Title('Memristor Voltage and Current vs. Time')

figure;
plot(t,r,'color',[0,0.5,0]);
ylabel('Resistance');
xlabel('Time');
Title('Memristor Resistance vs. Time')

figure;
plot(v,r,'color',[0,0.5,0]);
xlabel('Voltage')
ylabel('Resistance');
Title('Memristor Resistance vs. Voltage')

figure;
plot(v,i);
xlabel('Voltage');
ylabel('Current')
Title('Memristor Current vs. Voltage')

figure;
subplot(2,2,1)
[ha,hl1,hl2] = plotyy(t,v,t,i);
xlabel('Time')
set(hl1,'color','b');
set(hl2,'color','r');
axes(ha(1));
ylabel('Voltage')
axes(ha(2));
set(ha(2),'YColor','r');
ylabel('Current','color','r')
Title('Memristor Voltage and Current vs. Time')

subplot(2,2,3)
plot(t,r,'color',[0,0.5,0]);
ylabel('Resistance');
xlabel('Time');
Title('Memristor Resistance vs. Time')

subplot(2,2,4)
plot(v,r,'color',[0,0.5,0]);
xlabel('Voltage')
ylabel('Resistance');
Title('Memristor Resistance vs. Voltage')

subplot(2,2,2)
plot(v,i);
xlabel('Voltage');
ylabel('Current')
Title('Memristor Current vs. Voltage')

%%
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
%eof