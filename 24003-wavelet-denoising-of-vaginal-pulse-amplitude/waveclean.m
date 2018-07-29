function sigclean=waveclean(signal)
%waveclean=WAVELET-USING FUNCTION CLEANER
%function to automatically clean a function using wavelets, function
%should be length 2^J, where J is a positive integer
% 
% Appropriate citation:
% Prause, N., Williams, K., & Bosworth, K. (2009). Wavelet denoising of
% vaginal pulse amplitude. Psychophysiology, in press.
%
%USAGE:
%           sigclean=waveclean(signal)
%INPUTS:
%           signal=the original signal to be cleaned
%OUTPUTS:
%           sigclean=the cleaned signal
%
%NOTES: will automatically lengthen if length does not equal 2^J, but this
%           introduces inaccuracies and is not recommended
%       will not work for anything but SPAN-lab, for now...

%length 2^J, find J
J=log2(length(signal));

%test for proper length
if J ~= round(J)
    %adjust length to next 2^J; mirror 
    %NOTE: *Avoid having a length that is not a power of two if at all
    %       possible*
    J=ceil(J);
    signal_extension=length(signal);
    signal(signal_extension+1:2^J)=signal(signal_extension:-1:2*signal_extension-2^J+1);
end

%wavelet: Coiflet works well for this data
wavelet_filter=MakeONFilter('Coiflet',5);

%stationary wavelet transform
signal_fwtstat=FWT_Stat(signal,1,wavelet_filter);

%remove the noise and unneeded constituent signals
signal_fwtstat(:,1:J-7)=0;
signal_fwtstat(:,J-4:J)=0;

%soft threshholding for signals we want to keep
for o=J-6:J-5
    signal_fwtstat_o=signal_fwtstat(:,o);
    To=2*median(abs(signal_fwtstat_o));
    %while the max is outside To, find where the max is
    %multiply by the 'smoothmult' function, where the radius is the
    %distance to the nearest point arbitrarily close to 0 (<=To/16)
    while max(abs(signal_fwtstat_o)) > To*23/16
        maxsignal_fwtstat_o=find(abs(signal_fwtstat_o) == max(abs(signal_fwtstat_o)));
        zerosignal_fwtstat_o=find(abs(signal_fwtstat_o) <= To/8); 
        smoothmult_radius=min(abs(zerosignal_fwtstat_o-maxsignal_fwtstat_o(1,1)));
        smoothmult_mid=maxsignal_fwtstat_o;
        signal_fwtstat_omax=signal_fwtstat_o(maxsignal_fwtstat_o(1,1));
        %if maxsignal_fwtstat_o is on boundaries, only smoothmult on one side, not both
        if maxsignal_fwtstat_o == 1
            signal_fwtstat_o=smoothmultR(signal_fwtstat_o,To/signal_fwtstat_omax,smoothmult_mid(1,1),smoothmult_radius(1,1));
        elseif maxsignal_fwtstat_o == length(signal_fwtstat_o)
            signal_fwtstat_o=smoothmultL(signal_fwtstat_o,To/signal_fwtstat_omax,smoothmult_mid(1,1),smoothmult_radius(1,1));
        else
            %if boundary(s) within smoothmult_radius 
            if abs(maxsignal_fwtstat_o-1) < smoothmult_radius
                smoothmult_radius=abs(maxsignal_fwtstat_o-1);
            elseif abs(maxsignal_fwtstat_o-length(signal_fwtstat_o)) < smoothmult_radius
                smoothmult_radius=abs(maxsignal_fwtstat_o-length(signal_fwtstat_o));
            end   
            signal_fwtstat_o=smoothmult(signal_fwtstat_o,To/signal_fwtstat_omax,smoothmult_mid(1,1),smoothmult_radius(1,1));
        end
    end
    signal_fwtstat(:,o)=signal_fwtstat_o;
end

%inverse wavelet transform
sigclean=IWT_Stat(signal_fwtstat,wavelet_filter);

%plot original and clean signals
figure(12)
subplot(2,1,1)
plot(signal)
ylabel('Original signal')
subplot(2,1,2)
plot(sigclean,'r')
ylabel('Cleaned signal')
