function y = goertzel_general_shortened(x,indvec)
% GOERTZEL_GENERAL_SHORTENED(X,INDVEC) computes DTFT of one-dimensional
% signal X at 'indices' contained in INDVEC, using the generalized (and shortened)
% second-order Goertzel algorithm.
% Thanks to the generalization, the 'indices' can be non-integer valued
% in the range 0 to N-1, where N is the length of X.
% (Index 0 corresponds to the DC component.)
% Integers in INDVEC result in the classical DFT coefficients.
%
% The output is a column complex vector of length LENGTH(INDVEC) containing
% the desired DTFT values.
%
% See also: goertzel_classic.
       
% (c) 2009-2012, Pavel Rajmic, Brno University of Technology, Czech Rep.


%% Check the input arguments
if nargin < 2
    error('Not enough input arguments')
end
if ~isvector(x) || isempty(x)
    error('X must be a nonempty vector')
end

if ~isvector(indvec) || isempty(indvec)
    error('INDVEC must be a nonempty vector')
end
if ~isreal(indvec)
    error('INDVEC must contain real numbers')
end
% if isinteger(indvec)
%     disp('Warning: The traditional Goertzel algorithm is a bit more effective in case of INDVEC being integer-valued')
% end

lx = length(x);
x = reshape(x,lx,1); %forcing x to be column


%% Initialization
no_freq = length(indvec); %number of frequencies to compute
y = zeros(no_freq,1); %memory allocation for the output coefficients


%% Computation via second-order system
% loop over the particular frequencies
for cnt_freq = 1:no_freq
    
    %for a single frequency:
    %a/ precompute the constants
    pik_term = 2*pi*(indvec(cnt_freq))/(lx);
    cos_pik_term2 = cos(pik_term) * 2;
    cc = exp(-1i*pik_term); % complex constant
    %b/ state variables
    s0 = 0;
    s1 = 0;
    s2 = 0;
    %c/ 'main' loop
    for ind = 1:lx-1 %number of iterations is (by one) less than the length of signal
        %new state
        s0 = x(ind) + cos_pik_term2 * s1 - s2;  % (*)
        %shifting the state variables
        s2 = s1;
        s1 = s0;
    end
    %d/ final computations
    s0 = x(lx) + cos_pik_term2 * s1 - s2; %correspond to one extra performing of (*)
    y(cnt_freq) = s0 - s1*cc; %resultant complex coefficient
    
    %complex multiplication substituting the last iteration
    %and correcting the phase for (potentially) non-integer valued
    %frequencies at the same time
    y(cnt_freq) = y(cnt_freq) * exp(-1i*pik_term*(lx-1));
end