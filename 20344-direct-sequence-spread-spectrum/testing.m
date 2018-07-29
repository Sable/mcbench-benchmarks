%Bob Gess, June 2008, for EE473
%Module name:  testing
%Simulates generation and transmission of a direct sequence spread spectrum
%modulation of a QPSK signal, injects random and/or jamming noise into the
%transmission path, and demodulates the received signal.  Total bit errors
%and bit error rate is output in the command window at the end of the run.

%The program also generates and demodulates a QPSK signal (with random
%noise and/or jamming) in order to compare DSSS performance to QPSK
%performance.

%Because of computer limitations, the sample rate was limited to 80,000
%samples per second (which winds up at 40,000 samples per second when data 
%is split into I and Q channels.  The PRN sequence rate is modifiable, but 
%should be set to 20,000 bps or less.  The data rate was originally  
%designed to runat 2000 bps, but the ratio between spreading signal and 
%data can be increased by decreasing the data rate (N).

%Serial to parallel takes a serial data stream and splits it into I and Q
%channels.

%Prnseq generates a separate PRN sequence for each channel.

%Spreader combines the data and the PRN sequence to create a stream of
%spread symbols.

%qpsk modulates the spread data onto the carrier signal.  It also generates
%a non-spread qpsk signal for comparison purposes.

%Noise generates both random noise and a BPSK jamming signal.  Modify
%amplitude for each in the noise module.  Set amplitude very low for one
%type or both if only one type of interference is desired or if no
%interference is desired.  

%demod demodulates the non-spread signal, converts the data into a single
%serial data stream, and outputs the total bit errors and bit error rate in
%the command window.

%despread demodulates the spread signal, converts the data into a single
%serial data stream, and outputs the total bit errors and bit error rate in
%the command window.

%downlink allows skipping the generation of the transmitted signals and
%focuses solely on the downlink portion.  This saves a considerable amount
%of time for simulations since the for/next loops used in generating the
%PRN sequences are skipped.

N=128         % Number of data bits(bit rate)
noise_offset=1000   %How far away (in Hz) jamming signal is from center frequency
chip_rate = 20000  %chip rate
fcarr=20000     %carrier frequency in Hz (0 to 40kHz)

[data,data2,Isymbols,Qsymbols]=serial_to_parallel(N);
Isymbols=Isymbols';
Qsymbols=Qsymbols';

[seq1,seq2]=a_prnseq(chip_rate);
%seq1
%seq2

[sig1,sig2]=spreader(Isymbols,Qsymbols,seq1,seq2,N);
%sig1
%sig2

[msumiq,sumiq,cs_t,sn_t,tiq]=qpsk_mod(sig1,sig2,Isymbols,Qsymbols,N,fcarr);
%transmitted signal at this point

[rnd_noise,nb_noise]=noise(sumiq,tiq,N,noise_offset);

no_noise_sumiq=sumiq;sumiq=sumiq+nb_noise;
no_noise_msumiq=msumiq;msumiq=msumiq+nb_noise;

%Received signal
[bit_errs_qpsk,bitout1,bitout2,ycfo1,ycfo2]=demod(msumiq,cs_t,sn_t,tiq,data,N,fcarr);


[bit_errs_ss,i_out,q_out]=despread(tiq,sumiq,cs_t,sn_t,seq1,seq2,data,N,fcarr);



