function s_out = rot13(s_in,shift);

% ROT13 - ROT13 encryption / decryption
% This encrypts or decrypts a string using the ROT13 algorithm.
%
%   Syntax:   out = rot13(in,shift);
%
% Where in and out are strings, and shift is an optional
% alphabetical shift argument (default is 13, of course).

if nargin<2
    shift = 13;
end;

a_up = 65:90;
a_lo = 97:122;

nums = double(s_in);
nums(ismember(nums,a_up)) = a_up(1)+mod((nums(ismember(nums,a_up))-a_up(1)+shift),26);
nums(ismember(nums,a_lo)) = a_lo(1)+mod((nums(ismember(nums,a_lo))-a_lo(1)+shift),26);
s_out = char(nums);