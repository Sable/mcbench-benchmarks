clear all; close all; clc; format compact
% This script is based from the posting on thread "Modbus RS232 ASCII
% Communication Functions" by Steven Edmund with a Programmable Logic
% Controller (PLC)
%
% It has been adapted slightly to take multiple reading from a a JLD416PVA
% power meter, such as the one available from Annex Depot Inc, on the web
% at www.lightobject.com.
%
% Copyright (c) 2012, 
% Profs. W. R. Ashurst and T. D. Placek
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% remove any remaining serial objects to prevent serial issues
g = instrfind; 
if ~isempty(g);
   fclose(g);
   delete(g)
   clear g
end

% Initialize Serial Port Object [s]
[s] = serialstart();
messageReadAll = append_crc([9,3,0,0,0,6])
% messageReadAll =
%      9     3     0     0     0     6   196   128
% instrument address is 9, modbus mode is 3, starting address is 0000 and
% read 6 registers

N = 400; % take N readings
data = zeros(N,5); % pre-allocate for speed
t=clock;

for k = 1:N
    fwrite(s, messageReadAll); % broadcast the message on RS485 line
    allRdg = fread(s, 17); % get the instrument response
    [data(k,1), data(k,2), data(k,3), data(k,4)] = ...
        parseHB416PVA(allRdg); % parse the response
    data(k,5) = etime(clock,t);
    pause(0.1) % arbitrary delay between readings
    k % so you know the loop count
end

% make plots for Voltage, Current and Power
subplot(3,1,1);
plot(data(:,5),data(:,1));
xlabel('Time, (seconds)'); ylabel('Voltage, (V)')
subplot(3,1,2); 
plot(data(:,5),data(:,2));
xlabel('Time, (seconds)'); ylabel('Current, (A)')
subplot(3,1,3); 
plot(data(:,5),data(:,3));
xlabel('Time, (seconds)'); ylabel('Power, (W)')

% close the serial port
fclose(s);
