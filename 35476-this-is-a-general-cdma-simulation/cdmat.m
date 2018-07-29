%% Code Division Multiple Access Transmitter
% CDMAt - Function
% 1. (s) Input the data 
% Input data must be (+/- 1's) (this is a PSK modulation (BPSK))
% 2. (hl) Hadamard matrix length 
% 3. (cn) code number to be used for this user (row - number of H - matrix)
% 4. Spread the data by multiplying s by cn.
% 6. Outpot of the function is spread symbol of user cn.
% Montadar Abas Taher
% 11/03/2011
function [outcdmat]=cdmat(s,hl,cn)
if cn>hl
    errordlg('The input code number must be equal or less than the Hadamard length','File Error');
end
%% Generate Hadamard Matrix of length (hl)
h=hadamard(hl);
%% Spread the input sequence
outcdmat=kron(s,h(cn,:));