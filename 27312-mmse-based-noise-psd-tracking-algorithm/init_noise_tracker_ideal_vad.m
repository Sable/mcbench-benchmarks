function   noise_psd_init =init_noise_tracker_ideal_vad(noisy,fr_size,fft_size,hop,sq_hann_window)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%This m-file computes an initial noise PSD estimate by means of a
%%%%Bartlett estimate.
%%%%Input parameters:   noisy:          noisy signal
%%%%                    fr_size:        frame size
%%%%                    fft_size:       fft size
%%%%                    hop:            hop size of frame
%%%%                    sq_hann_window: analysis window
%%%%Output parameters:  noise_psd_init: initial noise PSD estimate
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Author: Richard C. Hendriks, 15/4/2010
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
 
for I=1:5
    noisy_frame=sq_hann_window.*noisy((I-1)*hop+1:(I-1)*hop+fr_size);
    noisy_dft_frame_matrix(:,I)=fft(noisy_frame,fft_size);
end
    noise_psd_init=mean(abs(noisy_dft_frame_matrix(1:fr_size/2+1,1:end)).^2,2);%%%compute the initialisation of the noise tracking algorithms.