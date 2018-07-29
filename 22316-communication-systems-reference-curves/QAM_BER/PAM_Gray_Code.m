function [bitOrder symOrder] = PAM_Gray_Code()
% Returns the Gray symbol ordering for M-ary PAM signals
% for M= 2, 4, 8, 16, 32, and 64.
% The ordering exactly matches the one given in:
% [1] Cho, K., and Yoon, D., "On the general BER expression of one- and
%     two-dimensional amplitude modulations", IEEE Trans. Comm., Vol. 50,
%     No. 7, pp. 1074-1080, 2002.
%
% To check, enter the following at the MATLAB prompt:
% [bo so] = PAM_Gray_Code;
% bo{4}
% The output will exactly match the 4th row of Table II in [1].

bitOrder{1} = {'1' '0'};  % BPSK bit ordering
symOrder{1} = bin2dec(cell2mat(bitOrder{1}')); % BPSK Symbol ordering
% Construct the Gray mapping using the pattern shown in [1, Table II].
for k=2:6
    LSB = 1;
    M = 2^k;
    for j=1:M/2
        firstBit = num2str(LSB);
        secondBit = num2str(xor(LSB,1));
        bitOrder{k}{j*2-1} = [bitOrder{k-1}{j} firstBit];
        bitOrder{k}{j*2} = [bitOrder{k-1}{j} secondBit];
        LSB = xor(LSB,1);
    end
    symOrder{k} = bin2dec(cell2mat(bitOrder{k}'));
end
