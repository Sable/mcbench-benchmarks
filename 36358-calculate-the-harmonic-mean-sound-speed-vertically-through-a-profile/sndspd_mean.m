function H =  sndspd_mean(z,ssp,d)
% harmonic_mean
%
% Val Schmidt
% Center for Coastal and Ocean Mapping
% University of New Hampshire
% 2012
%
% A routine to calculate the harmonic mean sound speed.
%    
%   z:         Vector of depth values. (m)
%   ssp:       Vector of sound speed values at the associated depths. (m/s)
%   d:         [Optional] maximum depth (m) (see below)
%
% Suppose one is given a sound speed profile (sound speeds [ssp] and depths [z]). 
% One wishes to know how long it will take a sound pulse (say from a sonar)
% to travel down through the water column. 
%
% Most people will realize that one cannot simply average the sound speeds
% and divide by the total depth. However many will incorrectly assume that
% a depth-weighted mean sound will produce the correct answer.
% Unfortunately it does not. 
%
% One must instead divide the total depth by the sum of the time it takes
% to the sound to pass through each layer of constant sound speed. This is
% called the 'harmonic mean'. The harbmonic mean is calculated like so.
%
%              |    i=n                | -1
%              |  SUM    delta z(i)    |
%              |   i=1   ---------     |
%              |            c(i)       |
% C_harmonic = |   ------------------- |
%              |    i=n                |
%              |  SUM     delta z(i)   |
%              |     i=1               |
%              |                       |
%
% When the maximum depth, 'd', is specified, two possible things may result
% depending on whether d is greater or less than the maximum depth in z.
%
% Sometimes one has a complete sound speed profile, but only needs the
% harmonic sound speed to some max depth less than the maximum depth of the
% profile. One may then specify the maximum depth as the argument 'd', and
% the function will return a harmonic mean to only that depth.
%
% Alternatively, one frequently has a sound speed profile for the upper
% portion of the water column only, but desireds a harmonic sound speed all
% the way to the bottom. Below some max depth temperature and salnity are
% constant and sound speed increases nearly linearly (to about 1 part in
% 10^4) with increasing depth. In this case, one may specify a the bottom
% depth, d. The function will then approximate the the sound speed at the
% bottom linearly from the final value in the ssp vector and calculate a
% harmonic sound speed for the entire path.
%
% When the sound speed profile is a constant linear gradient rather than 
% discrete values one can calculate the time required to traverse the
% layer directly rather than approximating the gradient in discrete steps.
% That time is given by 
%
%       1      c(i+1) 
% t =   - ln ( ------ )
%       g       c(i)
%
% This value is then added to the summation of travel times (with a
% corresponding addition to the summation of depth differences) in the
% haronic mean calculation above.

%%

% Initialize a variable. variables
t=0;

% Mackenzie Formula first-order term for sound speed as a function of
% depth.
D1=.0163;

% Check some details.
if ( ~isequal( size(z),size(ssp) ) )
    error('ERROR input vectors are not of same size');
end

% The algorithm below will produce incorrect results if the first depth
% value is not zero. So we force it to be zero, shifting the other depths
% appropriately.
top=z(1);
z=z-top;

% One can optionally specify a max bottom depth. This value may be less
% than, or deeper than, the lowest depth in the z vector. If it is less than
% than z(end), the harmonic mean to the depth, d is calculated. If it is more
% than z(end), the sound speed profile is extended to the depth d using the
% first-order depth dependent term from the Mackenzie equation and the
% results of the Harmonic mean calculation for a gradient.

if ( nargin==3 )

    % First we shift the d value as we did the z values to make sure
    % everything matches.
    d=d-top;
    
    % If d is less than the max depth in z truncate the z and ssp vectors
    % to that depth. 
    if (d < max(z) )
        idx=find( z <= d);
        z=z(idx);
        ssp=ssp(idx);
        
    % Otherwise we calculate the extra time in this final layer.
    else

    % We need the sound speed at hte specified bottom.
    ss_bottom = ssp(end) + ( d - z(end) ) * D1;
    
    % This is the equation for the time spent in a layer having a gradient
    % sound speed, D1, and where the difference in sound speed from the top to
    % the bottom of the layer is delta_ss.
    t= 1/D1 *log( ss_bottom / ssp(end) );
    
    end
    
else
    % Give d the max depth regardless.
    d=z(end);
end


% Calculate the harmonic mean sound speed.
H = ( (sum(diff(z)./ssp(1:(length(ssp)-1))) + t ) / d )^(-1);