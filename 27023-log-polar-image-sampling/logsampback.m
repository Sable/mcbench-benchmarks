function arr = logsampback(logarr, rmin, rmax)
% LOGSAMPLE  Compute reverse of log-polar transform of image
%     ARRAY = LOGSAMPBACK(LOGARRAY, RMIN, RMAX) takes an array of samples
%     on a logarithmic grid and resamples to a conventional grid. 
% 
%     LOGARRAY is an NW x NR log-sampled array, as returned by LOGSAMPLE.
%     The value for ring R, wedge W is stored at LOGARRAY(W+1,R+1).
%         
%     RMIN and RMAX are the radii of the innermost and outermost rings of
%     the log-polar sampling pattern, in terms of pixels in the original
%     image. One of these may be the empty array; in this case it will be
%     calculated assuming that the "circular samples" condition (see below)
%     is satisfied.
%
%     ARR returns a conventional image centred on the log-sampled image.
%     The default of bilinear interpolation is used. 
% 
% The log-polar formulae
% ----------------------
% 
% For reference, the formulae relating positions in the new image to
% positions in the log-polar array are as follows. R and W are ring and
% wedge numbers in the log-polar array and X and Y are column and row
% numbers in the original array, all treated as if they could take
% non-integer values.  For a sample at (X, Y):
% 
%     Radius of sample: P = RMIN * exp( R / K )
% 
%         where         K = (NR - 1) / log( RMAX / RMIN )
%
%     Angle of sample:  T = W * 2 * PI / NW
% 
%     Column number:    X = P * cos(T)  +  XC
% 
%     Row number:       Y = P * sin(T)  +  YC
%
% where XC = YC = ceil(RMAX)+1.
%
% The "circular samples" condition is
%
%                       RMAX = RMIN * exp( 2*pi*(NR-1)/NW )
%
% If this is satisfied, the spatial separation of neighbouring pixels in
% the log-polar array is approximately the same along the wedges and round
% the rings.
%
% See also LOGSAMPLE, LOGTFORM

% Copyright David Young 2010

[nw, nr, ~] = size(logarr);
t = fliptform(logtform(rmin, rmax, nr, nw));
xc = ceil(t.tdata.rmax) + 1;
X = 2*xc-1;
Xdata = [1, X] - xc;
Udata = [0, nr-1];
logarr = padarray(logarr, [1 0], 'circular');  %wraps round in theta
Vdata = [-1, nw];       % [0 nw-1] before padding
Size = [X, X];
arr = imtransform(logarr, t, ...
    'Udata', Udata, 'Vdata', Vdata, ...
    'Xdata', Xdata, 'Ydata', Xdata, 'Size', Size);

end