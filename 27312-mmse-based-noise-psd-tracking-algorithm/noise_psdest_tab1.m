function [noise_psd ]=noise_psdest(noisy_dft_frame_p, I,speech_psd,noise_psd_old,tabel_inc_gamma )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%This m-file estimates the noise PSD and applies bias compensation
%%%%
%%%%Input parameters:   noisy_dft_frame:    noisy DFT frame
%%%%                    noise_psd_old:      estimated noise PSD of previous frame,
%%%%                    speech_psd:         estimated speech PS
%%%%                    I:                  frame number
%%%%
%%%%Output parameters:  noise_psd:          estimated noise PSD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Author: Richard C. Hendriks, 15/4/2010
%%%%%%%%%%%%%%%%%%%%%%%copyright: Delft university of Technology
%%%%%%%%%%%%%%%%%%%%%

init_per=5; % initial number of frames of noisy wave-file that are assumed to be noise only


a_post_snr=(noisy_dft_frame_p)./noise_psd_old;
xiest=max(a_post_snr-1,eps);
gain_function=(xiest./((xiest+1).*a_post_snr)).*(1+a_post_snr./(xiest.*(xiest+1)));
 
 
 %bias=noise_psd_old./(gammainc(noise_psd_old./(noise_psd_old+speech_psd),2).*(noise_psd_old+speech_psd)+noise_psd_old.*exp(-noise_psd_old./(noise_psd_old+speech_psd)));
[gains]=lookup_inc_gamma_in_table(tabel_inc_gamma ,speech_psd./noise_psd_old,-40:1:100,1);
 bias=noise_psd_old./((gains).*(noise_psd_old+speech_psd)+noise_psd_old.*exp(-noise_psd_old./(noise_psd_old+speech_psd)));
%  if I<(init_per);
%      gain_function=ones(size(gain_function));
%      estimate=bias.*gain_function.*(abs(noisy_dft_frame).^2);
%      noise_psd=0.92*noise_psd_old+(1-0.92)*estimate;
%  else
    estimate=bias.*gain_function.*(noisy_dft_frame_p);
    noise_psd=0.8 *noise_psd_old+(1-0.8 )*estimate;
%  end
%  

