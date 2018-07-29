function logarr = logsample(arr, rmin, rmax, xc, yc, nr, nw)
% LOGSAMPLE  Compute log-polar transform of image
%     LOGARRAY = LOGSAMPLE(ARRAY, RMIN, RMAX, XC, YC, NR, NW) returns an
%     array of samples on a logarithmic grid. 
% 
%     ARRAY is the initial image array. 
%         
%     RMIN and RMAX are the radii of the innermost and outermost rings of
%     the log-polar sampling pattern, in terms of pixels in the original
%     image.  XC and YC are the position of the centre of the pattern in
%     the original image, in terms of the array indices of ARRAY.
%  
%     NR and NW specify the number of rings and the number of wedges in the
%     log-sampling pattern.
%
%       Any one of RMIN, RMAX, NR or NW may be given as the empty array. In
%       this case, it will be calculated from the other three using the
%       "circular samples" condition (see below).
% 
%     LOGARR(W+1, R+1) will contain the sample value for ring R and wedge
%     W. Ring 0 lies at radius RMIN and ring (NR-1) lies at radius RMAX in
%     the original image. Wedge W lies in the direction of the positive
%     x-axis, and W increases clockwise for an image in which the y-axis
%     points down the screen (as is normal). The next section gives the
%     exact relationship between ring and wedge indices and position in
%     terms of the original image's x and y coordinates. The imtransform
%     default of bilinear interpolation is adopted, but this could be
%     changed later with a resampler structure.
% 
% The log-polar formulae
% ----------------------
% 
% For reference, the formulae relating positions in the log-polar array to
% positions in the original image are as follows. R and W are ring and
% wedge numbers in the log-polar array and X and Y are column and row
% numbers in the original array, all treated as if they could take
% non-integer values.  For a sample at (X, Y):
% 
%                                         2           2
%     Radius of sample: P = sqrt( (X - XC)  + (Y - YC) )
% 
%     Angle of sample:  T = arctan( (Y - YC) / (X - XC) )
% 
%     Ring number:      R = K * log( P / RMIN )
% 
%         where         K = (NR - 1) / log( RMAX / RMIN )
% 
%     Wedge number:     W = NW * T / (2 * PI)
%
% The "circular samples" condition is
%
%                       RMAX = RMIN * exp( 2*pi*(NR-1)/NW )
%
% If this is satisfied, the spatial separation of neighbouring pixels in
% the log-polar array is approximately the same along the wedges and round
% the rings.
% 
% See also LOGSAMPBACK, LOGTFORM

% Copyright David Young 2010

t = logtform(rmin, rmax, nr, nw);
nr = t.tdata.nr;        % Get computed values, in case default used
nw = t.tdata.nw;
[U, V, ~] = size(arr);
Udata = [1, V] - xc;
Vdata = [1, U] - yc;
Xdata = [0, nr-1];
Ydata = [0, nw-1];
Size = [nw, nr];
logarr = imtransform(arr, t, ...
    'Udata', Udata, 'Vdata', Vdata, ...
    'Xdata', Xdata, 'Ydata', Ydata, 'Size', Size);

end