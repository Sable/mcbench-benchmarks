function rfdemo2(ext)
% function rfdemo2(ext)
%
% RFDEMO1 shows cycles extracted from signal
% using rainflow algoritm. Good for very long
% time signals (100 000 points).
% 
% INPUT:  ext - option; number, vector with turning
%               points or pure signal. Default ext=10000.
% 
% OUTPUT: no enable.
% 
% SYNTAX:
%         >>rfdemo2
%         >>rfdemo2(50000)
%         >>rfdemo2(my_time_signal)

% By Adam Nies³ony
% ajn@po.opole.pl

error(nargchk(0,1,nargin))

if nargin==0,
    % turning points from 10000 random numbers
    ext=sig2ext(randn(10000,1));
elseif length(ext(:))==1,
    % turning points from n random numbers    
    ext=sig2ext(randn(1,ext));
else
    % turning points from vector ext
    ext=sig2ext(ext);
end

ext=sig2ext(ext);
rf=rainflow(ext);
figure, rfhist(rf,30,'ampl')
figure, rfhist(rf,30,'mean')
figure, rfmatrix(rf,30,30)