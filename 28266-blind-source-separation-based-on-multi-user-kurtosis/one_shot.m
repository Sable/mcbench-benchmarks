%HELP one_shot
%
%A simple test to perform BSS with MUK algorithm. The file MUK_algorithm
%must be located on the same folder.
%
%Programmed by: Vincent Choqueuse

close all;

%Parameter of the simulated signal
Const=[1 i -1 -i];  %PSK constallation
N=512;              %number of samples
nt=2;               %number of signals
nr=3;               %number of receivers (must be >nt)
noise_var=0.01;     %noise variance

fprintf('\n\t -> Create Random symbols (QPSK symbols)\n');
random_numbers=randint(nt,N,4);
random_symbols=Const(random_numbers+1);

fprintf('\t -> Create Random Channel Matrix\n');
channel_matrix=randn(nr,nt)+j*randn(nr,nt);

fprintf('\t -> Compute received samples\n');
received_signal=channel_matrix*random_symbols;

fprintf('\t -> Add Additive White Gaussian Noise\n');
noise=sqrt(noise_var/2)*(randn(nr,N)+i*randn(nr,N));
received_noisy_signal=received_signal+noise;

fprintf('\t -> Perform blind source separation\n');
[estimated_sources,estimated_channel]=MUK_algorithm(received_noisy_signal,nt);

%------------------------%
%     Display results    %
%------------------------%
fprintf('\t -> Display results\n\n');

for indice=1:nr
   figure('Name',sprintf('Signal %i',indice));
   plot(real(received_noisy_signal(indice,:)),imag(received_noisy_signal(indice,:)),'.');
   xlabel(sprintf('Re(y_%i (n))',indice));
   ylabel(sprintf('Im(y_%i (n))',indice));
   title(sprintf('Received signal %i',indice));
   axis('square');
   limit=max([abs(xlim) abs(ylim)]);
   axis([-limit limit -limit limit]);
end    

for indice=1:nt
   figure('Name',sprintf('Source %i',indice));
   plot(real(estimated_sources(indice,:)),imag(estimated_sources(indice,:)),'.');
   xlabel(sprintf('Re(x_%i (n))',indice));
   ylabel(sprintf('Im(x_%i (n))',indice));
   title(sprintf('Extracted source %i',indice));
   axis('square');
   limit=max([abs(xlim) abs(ylim)]);
   axis([-limit limit -limit limit]);
end    