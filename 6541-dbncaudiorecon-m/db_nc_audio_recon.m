function db_nc_audio_recon(file_name);
% Implements 4-channel tree-structured PR filter bank using 5th order
% Butterworth half-band filters constructed with 1st order allpass
% structures (ref. [Mit01] P10.40).  Uses double-buffer, non-causal IIR 
% synthesis filtering technique (ref. [Cre96]) to process and play 
% original multi-channel audio file, reconstructed audio file using uniform
% 16-bit quantization and PR structure described above, and error signal.

clc

B = 16; % Quantization bits
BU = 100; % Buffer length (even)
ST = 289; % Signal truncation parameter

% Process input data
[x1,fs] = wavread(file_name);
x1 = x1';
sz = size(x1);

if sz(2) > 8*BU*ST
    for n = 1:sz(1)
        x(n,:) = x1(n,1:8*BU*ST); % Truncate signal for simplicity, odd multiple of BU
    end
else
    x = x1;
end

x = [x zeros(sz(1),8*BU - rem(sz(2),8*BU))]; % Make input even length for all branches

% Perform four-channel, tree-structured filtering of multi-channel input 
for m = 1:sz(1)
    
    % Analysis stage
    [H00,L00,Z1f00,Z0f00] = nciab(x(m,:),BU);
    [H01,L01,Z1f01,Z0f01] = nciab(L00,BU);
    [H10,L10,Z1f10,Z0f10] = nciab(L01,BU);
    
    % Perform quantization
    Q00 = uquan(H00,B);
    Q01 = uquan(H01,B);
    Q10 = uquan(H10,B);
    Q11 = uquan(L10,B);
    
    % Synthesis stage
    Y00 = ncisb(H10,L10,BU,Z1f10,Z0f10);
    Y01 = ncisb(H01,Y00,BU,Z1f01,Z0f01);
    y1(m,:) = ncisb(H00,Y01,BU,Z1f00,Z0f00);
end

% Produce error signal
szx = size(x);
szy = size(y1);
for n = 1:szy(1)
    y(n,:) = y1(n,1:szx(2)); % Truncate output signal to input signal length
end
z = x - y;

% Produce audio output
disp('Original audio file (PRESS ANY KEY)');
pause
wavplay(x',fs)
disp('Processed audio file (PRESS ANY KEY)');
pause
wavplay(y',fs)
disp('Error signal (PRESS ANY KEY)');
pause
wavplay(z',fs)

% Plot error signal
for t = 1:sz(1)
    figure(t)
    plot(z(t,:))
end