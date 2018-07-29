function y = ncisb(H,L,BL,Zi1,Zi0)
% NCISB(H,L) takes in high/low channel data in vectors H,L, filters them 
% with non-causal IIR half-band allpass filters derived from 5th-order 
% Butterworth filter (ref. Mitra P10.40) and returns output data vector
% y using double-buffer scheme.  Works with NCIAB, use same BL.  Zf0, Zf1
% are initial condition vectors for synthesis filters for L and H channels,
% respectively
%
% Evan Ruzanski, 4/25/2003

% Build signals
while length(L) > length(H)
    H = [H 0];
end

while length(H) > length(L)
    L = [L 0];
end
    
u0 = 0.5*(H + L);
u1 = 0.5*(L - H);

% Synthesis = Analysis Filters (Mitra (2e) P10.40)
numa0 = [0.1056 1];
dena0 = [1 0.1056];

numa1 = [0.5278 1];
dena1 = [1 0.5278];

% Init buffer params
pointer = 1;
lenu = length(u0);
count = lenu/BL;
win = [pointer:pointer + BL - 1]; % Init data window

bcf = 1; % Init buffer switches
bcb = 4;

while count > 0 
    buf0(bcf,1:BL) = fliplr(u0(win)); % Use recursive double buffers, reverse data stream
    buf1(bcf,1:BL) = fliplr(u1(win));
    
    v0r = filter(numa0,dena0,buf0(bcf,1:BL),Zi0(1,count)); % Perform non-causal filter operation
    v1r = filter(numa1,dena1,buf1(bcf,1:BL),Zi1(1,count));
    
    buf0(bcb,1:BL) = fliplr(v0r); % Reverse output
    buf1(bcb,1:BL) = fliplr(v1r);
    
    v0p(win) = buf0(bcb,1:BL); % Dump buffers
    v1p(win) = buf1(bcb,1:BL);
    
    bcf = mod(bcf+2,2)+1; % Switch input buffer
    bcb = mod(bcb+2,2)+3; % Switch output buffer
    pointer = pointer + BL;
    win = [pointer:pointer + BL - 1]; % Slide window
    count = count - 1;
end

% Upsample v0
s = length(v0p); % Delay = 1;
w = zeros(1,2*s);
w(1:2:2*s(1)) = v0p;
v0hat = w;

% Upsample v1
s = length(v1p);
w = zeros(1,2*s);
w(2:2:2*s(1)) = v1p;
v1hat = w;

% Generate reconstructed output signal
y = v0hat + v1hat;
