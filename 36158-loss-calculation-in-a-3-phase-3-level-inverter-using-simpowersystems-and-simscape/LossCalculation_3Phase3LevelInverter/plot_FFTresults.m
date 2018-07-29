load FFTresults
h1=figure;
    set(h1,'Name','FFT Analysis of Phase A Current at bus B1');
    ScreenS=get(0,'Screensize');
    set(h1,'Position',[ScreenS(3)/50 ScreenS(4)/4.2 ScreenS(3)/1.6 ScreenS(4)/1.5])
subplot(2,2,1)
plot(FFTresults_4s.FFTdata.t,FFTresults_4s.FFTdata.Y)
grid
axis([4 4.06 -225 225])
ylabel('Magnitude (A)')
title ('Ia at bus B1 at 4 seconds')
subplot(2,2,3)
plot(FFTresults_8s.FFTdata.t,FFTresults_8s.FFTdata.Y)
grid
axis([8 8.06 -225 225])
xlabel ('Time (s)')
ylabel('Magnitude (A)')
title ('Ia at bus B1 at 8 seconds')
subplot(2,2,2)
bar(FFTresults_4s.freq,FFTresults_4s.mag)
grid
ylabel('Magnitude (A)')
axis([0 2500 0 35])
THDvalue_4s=num2str(FFTresults_4s.THD,'%5.1f');
title ( [ 'FFT of Ia at bus B1 at 4 seconds'  ' (THD= '  THDvalue_4s  '% )'  ] )
subplot(2,2,4)
bar(FFTresults_8s.freq,FFTresults_8s.mag)
grid
xlabel ('Frequency (Hz)')
ylabel('Magnitude (A)')
axis([0 2500 0 35])
THDvalue_8s=num2str(FFTresults_8s.THD,'%5.1f');
title ( [ 'FFT of Ia at bus B1 at 8 seconds'  ' (THD= '  THDvalue_8s  '% )'  ] )