%Bob Gess, June 2008, for EE473
%Allows simulation of the received signal without generating a new
%transmitted signal.

fcarr=20000         %set carrier frequency
noise_offset=6000   %How far away (in Hz) jamming signal is from center frequency

%Restores clean signal before new noise environment is simulated
sumiq=no_noise_sumiq;
msumiq=no_noise_msumiq;

[rnd_noise,nb_noise]=noise(sumiq,tiq,N,noise_offset);

sumiq=sumiq+nb_noise;
msumiq=msumiq+nb_noise;

%Received signal
[bit_errs_qpsk,bitout1,bitout2,ycfo1,ycfo2]=demod(msumiq,cs_t,sn_t,tiq,data,N,fcarr);


[bit_errs_ss,i_out,q_out]=despread(tiq,sumiq,cs_t,sn_t,seq1,seq2,data,N,fcarr);


