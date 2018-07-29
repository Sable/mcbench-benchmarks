function interannual_correction_temp(filenamein,filenameout)

% this program is to correct the interannual variability of Tmax and Tmin
% for weather generator using a power spectral scheme

% generate the yearly average Tmax using Fast Fourier Transforms (FFT)
% (keep interannual variability)
FFT_yearly_tmax('yearly_observed_tmax')

% adjust yearly variability for Tmax
yearly_tmax_correction(filenameout)

% generate the yearly average Tmin using Fast Fourier Transforms (FFT)
% (keep interannual variability)
FFT_yearly_tmin('yearly_observed_tmin')

% adjust yearly variability for Tmin
yearly_tmin_correction(filenameout)