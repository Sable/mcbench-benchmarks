function [ e, FS_inp ] = adapt_filt_tworef( varargin )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  []=ADAPT_FILTER_TWOREF()                                              %
%%  This function is written to allow the user to filter a input signal   %
%%  with an adaptive filter that utilizes 2 reference signals instead of  %
%%  the standard method which allows for only 1 reference signal.         %
%%                                                                        %
%%  USAGE:                                                                %
%%          e = adapt_filt_tworef( file1, file2, file3, M, lambda )       %
%%              Inputs:                                                   %
%%                   file1 : Signal File (wav) to be filtered             %
%%                   file2 : Reference Signal 1                           %
%%                   file3 : Reference Signal 2                           %
%%                       M : Order of filter to use                       %
%%                  lambda : Forgetting Factor ( .95 <= lambda <= 1 )     %
%%                           defaults to 0.95 if not entered.             %
%%                                                                        %
%%              Outputs:                                                  %
%%                       e : Filtered Signal                              %
%%                  FS_inp : Sampling Frequency of Input Signal           %
%%  EXAMPLE CALL:                                                         %
%%          e = adapt_filt_tworef( 'noisy_dsp.wav', 'intf1.wav', ...      %
%%                          'intf2.wav', 12, .9997 )                      %
%%                                                                        %
%% Author: Rob Clemens              Date: 3/16/06                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ inp, FS_inp, NBITS ] = wavread( varargin{ 1 } );
[ rv, FS_rv, NBITS ]   = wavread( varargin{ 2 } );
[ rh, FS_rh, NBITS ]   = wavread( varargin{ 3 } );

M = varargin{ 4 };

if ( length( inp ) ~= length( rv ) ) || ( length( inp ) ~= length( rh ) )
    msgbox( '//ERROR: Reference Signals must be the same size as Signal to Filter',...
        'ERROR', 'error' )
end

if length( varargin ) < 5
    lambda = 0.95;
else
    lambda = varargin{ 5 };
end

H                      = zeros( 1, 2 * M );
H                      = H';
ident_mat              = eye( 2 * M ); 
Rn                     = ident_mat ./ 0.01;
   
for z = 1 : length( rh )
    
    r_v( 1 : z ) = flipud( rv( 1 : z ) ); %create the rv(n), rv(n-1), ...
    r_h( 1 : z ) = flipud( rh( 1 : z ) ); %create the rh(n), rh(n-1), ...
    
    if length( r_v ) < M %if length is less than the order it zero pads
        r_v( z + 1 : M, 1 ) = 0;
        r_h( z + 1 : M, 1 ) = 0;   
    elseif length( r_v ) > M %If length is greater than M then it truncates
        r_v = r_v( 1 : M );
        r_h = r_h( 1 : M );
    end
    
    r_n    = [ r_v; r_h ]; %Create and update r(n)
    K      = ( Rn * r_n ) ./ ( lambda + r_n' * Rn * r_n ); %Create/update K
    e( z ) = inp( z ) - r_n' * H; %e is the filtered signal, input - r(n) * Filter Coefs
    H      = H + K * e( z ); %Update Filter Coefficients
    Rn     = ( lambda^-1 * Rn ) - ( lambda^-1 * K * r_n' * Rn ); %Update R(n)
    
end
