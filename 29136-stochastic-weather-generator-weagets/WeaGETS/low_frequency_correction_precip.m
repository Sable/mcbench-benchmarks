function low_frequency_correction_precip(filenamein,filenameout)
% this program is to correct the low-frequency variability of
% precipitation for weather generator using a power spectral scheme based
% on Fast Fourier Transforms (FFT). 
 
% generate the monthly precip based on FFT (preserve the monthly variability)
FFT_monthly_precip('monthly_observed_P');

% correct monthly variability
[monthly_corrected_precip]=monthly_precip_correction(filenameout);

% generate the yearly precip using FFT (keep yearly variability)
FFT_yearly_precip('yearly_observed_P');

% correct interannual variability
[yearly_corrected_precip]=yearly_precip_correction('monthly_corrected_precip');

% calulate the ratio of monthly std between before yearly adjusted and after yearly adjusted
[std_ratio]=stand_dev_ratio(filenamein,'yearly_corrected_precip');

% reduction of the monthly std according to the std ratio between yearly
% adjusted before and yearly adjusted after, when we use FFT to calculate
% the monthly precip
FFT_monthly_std_reduction('monthly_observed_P');

% correct monthly variability that std was reduced
[monthly_corrected_precip]=monthly_precip_correction(filenameout);

% correct interannual variability again (keep both monthly and yearly variability) 
[yearly_corrected_precip]=yearly_precip_correction('monthly_corrected_precip');

% calculate the ratio of monthly std between after yearly adjusted and
% observed data again
[std_ratio2]=stand_dev_ratio2(filenamein,'yearly_corrected_precip');
abs_std_ratio=abs(1-std_ratio2);

% check whether the std ratio of any month greater than 0.1 
ratio_threshold=abs_std_ratio(1,:)>0.1;

while sum(ratio_threshold)~=0
    load('std_ratio2')
    std_ratio2=1-std_ratio2;
    load('std_ratio')
    std_ratio=std_ratio-std_ratio2;
    save('std_ratio','std_ratio')

    FFT_monthly_std_reduction('monthly_observed_P');

    % correct monthly variability that std was reduced
    [monthly_corrected_precip]=monthly_precip_correction(filenameout);

    % correct interannual variability again (keep both monthly and yearly variability) 
    [yearly_corrected_precip]=yearly_precip_correction('monthly_corrected_precip');
    
    % calculate the ratio of monthly std between after yearly adjusted and
    % observed data again
    [std_ratio2]=stand_dev_ratio2(filenamein,'yearly_corrected_precip'); 
    abs_std_ratio=abs(1-std_ratio2);
    % check whether the std ratio of any month greater than 0.1 
    ratio_threshold=abs_std_ratio(1,:)>0.1;
end



