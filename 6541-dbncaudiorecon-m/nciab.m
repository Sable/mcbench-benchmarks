function [H,L,Zf1,Zf0] = nciab(x,BL)
% NCIAB(X) takes data in vector x, filters it with half-band allpass
% filter derived from 5th-order Butterworth filter (ref. Mitra P10.40)
% and returns sub-band coefficients for high-pass channel H and low-pass
% channel L.  BL is buffer length to frame data to transmit final all-
% pass filter conditions.  Zf1 and Zf0 are final condition vectors from
% outputs of analysis filters.
%
% Evan Ruzanski, 4/25/2003

% Set params
M = 2; % DS factor

% Prepare input data
while mod(length(x),2*BL) ~= 0 % Make input even length 
    x = [x 0];
end

% Filters (5th order Butterworth per Problem 10.40 Mitra (2e))
numa0 = [0.1056 1];
dena0 = [1 0.1056];

numa1 = [0.5278 1];
dena1 = [1 0.5278];

% Create signals (ref. Fig. 10.55 Mitra (2e))
x0 = [x]; 
x1 = [x]; 

% Downsample x0 
v0 = x0(1:M:length(x0));

% Downsample x1
v1 = x1(2:M:length(x1)); % Delay = 1

% Filter each channel
lenv = length(v0);
count = lenv/BL;
pointer = 1;
win = [pointer:pointer + BL - 1]; % Window frames of data

bcf = 1; % Init buffer switches
bcb = 4;

while count > 0
    buf0(bcf,1:BL) = v0(win); % Use recursive double buffers
    buf1(bcf,1:BL) = v1(win);
    
    [u01,Zf0(1,count)] = filter(numa0,dena0,buf0(bcf,1:BL));
    [u11,Zf1(1,count)] = filter(numa1,dena1,buf1(bcf,1:BL));
    
    buf0(bcb,1:BL) = u01; 
    buf1(bcb,1:BL) = u11;
    
    u0p(win) = buf0(bcb,1:BL);
    u1p(win) = buf1(bcb,1:BL);
    
    bcf = mod(bcf+2,2)+1; % Switch input buffer
    bcb = mod(bcb+2,2)+3; % Switch output buffer
    pointer = pointer + BL;
    win = [pointer:pointer + BL - 1]; % Slide window
    count = count - 1;
end

% Create/tx band coefficients
L = u0p + u1p;
H = u0p - u1p;