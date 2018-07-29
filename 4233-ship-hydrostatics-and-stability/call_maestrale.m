%CALL_MAESTRALE Runs Example 10.2, `An application of the wind criterion' of
%    the regulations BV 1033. Calls the function BV1003.
%    Companion file to Biran, A. (2003), Ship Hydrostatics and Stability, 
%    Oxford: Butterworth-Heinemann.

maestrale                        % load cross-curves of ship Maestral

cond = [ 1.03*9.81*2943 5.835 4.097 6.681 0.06 ];
sail = [ 1166.55 8.415 ];         % data of sail area   
bv1033(cond, Maestral, sail, 70)