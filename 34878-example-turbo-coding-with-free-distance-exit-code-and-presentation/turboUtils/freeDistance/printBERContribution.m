function printBERContribution( d, Nd, wd, N, R )
%PRINTBERCONTRIBUTION Print contribution from distance spectrum components.
% d, Nd, wd are arrays of numbers, each index corresponding to one spectral
% component. N is interleaver size. R is rate.

%close all;

upperrange = 3.5;

%SNR Range in dB
SNR_range = [0:0.01:upperrange];

ebno = 10 .^ (SNR_range ./ 10);

ber=zeros(length(d), length(ebno));

linetypes = {'r--', 'b', 'b--', 'r:', 'b:', 'r-.', 'b-.'};
leg = cell(1,length(d));
for i=1:length(d)    
    ber(i+1,:) =  ber(i,:) + ((Nd(i) * wd(i)) / N) * qfunc (sqrt(d(i) * 2 * R * ebno));   
    semilogy(SNR_range, ber(i+1,:), linetypes{i});
    hold on
    leg{i} = sprintf('d = %d', d(i));
end
legend(leg);


    