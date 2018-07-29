function [filtr] = buttLPF(f,cutoff,n)
%**************************************************************
% buttLPF
%
% Generates a matrix determining the transfer function of a
% Butterworth Filter.
%
% f = frequency vector.
% cutoff = cutoff frequency
% n = Order of Butterworth LPF
% *************************************************************
    a = (f/cutoff).^(2*n);
    H = 1./sqrt(ones(size(a))+a);
    filtr=H;