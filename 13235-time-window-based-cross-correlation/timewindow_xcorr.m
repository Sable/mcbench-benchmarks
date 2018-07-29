% -------------------------------------------------------------------------
% timewindow_xcorr.m
% -------------------------------------------------------------------------
% Description: Calculates a time-window based cross-correlation for two
% real input vectors.  Outputs are not normalized (either within each
% window or across time) by default.  An FFT based calculation is used to
% determine the cross-correlation of the two signals:
%
%        IFFT(FFT(input_1).*CONJ(FFT(input_2))).
%
% The two vectors are broken into time-windows to build a 2-D array.  The
% FFT and IFFT calculations are restricted to the time-windows.
% -------------------------------------------------------------------------
% Usage: [lag_time,twin,xcl]=...
%    timewindow_xcorr(input_1,input_2,sample_frequency,...
%    time_window,time_step,max_lag_time,norm_output_flag)
% -------------------------------------------------------------------------
% Inputs:
% -------------------------------------------------------------------------
%          input_1 - input vector one (left)
%          input_2 - input vector two (right)
% sample_frequency - the sampling frequency of the two inputs (Hz)
%      time_window - the duration of the time window in seconds
%        time_step - time step in seconds (must be greater than zero)
%     max_lag_time - the maximum lag times to report in seconds
%                    (i.e., [-max_lag_time to max_lag_time])
% norm_output_flag - set to 1 to normalize within each time window (default
%                    value is 0 (i.e., no normalization))
% -------------------------------------------------------------------------
% Outputs:
% -------------------------------------------------------------------------
%    lag_time - the vector of lag time in seconds
%        twin - the starting times of each of the time windows in seconds
%         xcl - the output time cross-correlation
% -------------------------------------------------------------------------
% T. Streeter, 6 DEC 2004
% -------------------------------------------------------------------------
function [lag_time,twin,xcl]=timewindow_xcorr(varargin)

error(nargchk(6,7,nargin)) %check for number inputs

%Process Inputs:
%--------------------------------------------------------------------------
input_1=varargin{1};
input_2=varargin{2};
sample_frequency=varargin{3};
time_window=varargin{4};
time_step=varargin{5};
max_lag_time=varargin{6};

if nargin==7
    norm_output_flag=varargin{7};

    %Error check for valid input values:
    if isempty(find(norm_output_flag==[1 0]))
        error('norm_output_flag must be set to either 1 or 0.')
    end
    
else
    %Set to default if no input is provided:
    norm_output_flag=0;
end

% Check for input errors:
%--------------------------------------------------------------------------
if sample_frequency<=0
    error('The sampling frequency must be greater than zero.')
end

if time_window<=0
    error('The time window must be greater than zero.')
end

if round(time_step*sample_frequency)<=0
    error('The time step must be greater than zero samples.')
end

if time_window*sample_frequency>length(input_1)
    error(['The specified time window is larger than ',...
    'the duration of the input signal'])
end

if ndims(input_1)>2 | ndims(input_2)>2    
    error('input_1 and input_2 variables must be vectors')
end

if ~isreal(input_1) | ~isreal(input_2)
    error('Both input_1 and input_2 must be real')
end

% Correct the orientation of the two input vectors such the they are
% both size [1,Ntime] & check they are both the same length:
%--------------------------------------------------------------------------
[n1,m1]=size(input_1);
[n2,m2]=size(input_2);

if n1==1
    Ntime=m1;
    if n2==1
        if m1~=m2
            error('the lengths of input_1 and input_2 must be equal')
        end
    else
        if m1~=n2
            error('the lengths of input_1 and input_2 must be equal')
        else
            input_2=input_2';
        end
    end
else
    input_1=input_1';
    Ntime=n1;
    if n2==1
        if n1~=m2
            error('the lengths of input_1 and input_2 must be equal')
        end
    else
        if n1~=n2
            error('the lengths of input_1 and input_2 must be equal')
        else
            input_2=input_2';
        end
    end
end

% Generate time index array based upon a moving time window with
% overlap: 
%--------------------------------------------------------------------------
Lwin=round(time_window*sample_frequency);
	%length of a time window in samples
Lstep=round(time_step*sample_frequency); 
    %length of time step in samples

ntwin=1:floor((Ntime+1-Lwin)/Lstep);
    %index of time windows
single_window_index=(1:Lwin);
    %base window index array
starting_index=(ntwin-1)*(Lstep);
    %starting index of each window

time_index=ones(max(ntwin),1)*single_window_index+...
    starting_index'*ones(1,Lwin);
clear single_window_index starting_index

% Generate the output time vectors:
%--------------------------------------------------------------------------
twin=(0:length(time_index(:,1))-1)*time_step;
Nlag_max=ceil(max_lag_time*sample_frequency);
lags=-Nlag_max:Nlag_max;
lag_time=lags/sample_frequency;

% Pad input vectors with zeros and break into time windows, where the
% padding is increased if the input lag range is larger than length of a
% time window:
%--------------------------------------------------------------------------
if Lwin>Nlag_max
    N_zero_pad=Lwin;
else
    N_zero_pad=Lwin+2*Nlag_max;
end

input_1=[input_1(time_index) zeros(length(ntwin),N_zero_pad)];
input_2=[input_2(time_index) zeros(length(ntwin),N_zero_pad)];
clear time_index

% Take fft of the two inputs:
%--------------------------------------------------------------------------
I1_fft=fft(input_1,[],2);
I2_fft=fft(input_2,[],2);

% Take the inverse transform:
%--------------------------------------------------------------------------
xcl=ifft(I1_fft.*conj(I2_fft),[],2);

%This checks for any large complex terms in the inverse FFT, which should
%be small/zero given that the input signals are restricted to real only
%values: 
if max(max(imag(xcl)))>0
    disp(['Warning: terms in the inverse fft contain complex terms'])
end
clear I1_fft I2_fft input_1 input_2

% Shift the fft to correct for the sample flip (see fftshift.m for help):
%--------------------------------------------------------------------------
xcl=fftshift(real(xcl),2);

% Limit output results to the specified maximum lag time:
%--------------------------------------------------------------------------
Nmid=(N_zero_pad+Lwin)/2+1; %zero lag sample number in xcl
xcl=xcl(:,Nmid+(-Nlag_max:Nlag_max));

%Normalize output within each time window:
%--------------------------------------------------------------------------
if norm_output_flag==1
   %determine the output normalization within each time window
   xcl_max=max(abs(xcl),[],1);
   
   %Remove any zero values:
   xcl_max(find(xcl_max==0))=1;
   
   xcl=xcl./(ones(length(twin),1)*xcl_max);
end
