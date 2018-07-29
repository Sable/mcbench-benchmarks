clc
%% ###################### Primary Parameters ##########################

Samples=2^15;               % Total number of samples to be handled
ord_but = 3;
considerBeta = 0;

%% ##################### Secondary Parameters #########################
rate=SamplePerChip*cps;             % Sampling Rate = Fs (Samples/Sec.)
Tc = inv(cps);                      % Time Period of Chip(Sec)
Tb = TotalChips*Tc;                 % Time Period of Data Bit (Sec)
SamplePerBit = Tb*rate;
Br = inv(Tb);                       % Bit Rate (per Sec)
cutoff=0.75*cps;                    % cutoff frequency of LPF

TotalTime=(Samples-1)/rate;         % Total time length of simulation(sec)
Fsa=rate/Samples;
t=0:inv(rate):TotalTime;t=t';       % Time matrix of each sample
f=rate/2 - (Samples:-1:1)*Fsa;f=f'; % Frequency matrix of each sample

% #################### CDMA Coding Starts Here ########################
isexists = isequal(ismember({'DataBit','Chipbit','Signal','OutSignal'},...
    who),[1 1 1 1]);
if (isexists==0 || RegenerateData == 1)
    [DataBit,Chipbit,Signal,OutSignal] = CDMA_Encode(TotalChips, ...
        TotalUser,TotalDataBit); 
                                % This Generates a New Set of Data & Chip
end
                               

DataBit_sampled = MakeSampled(DataBit,Samples,SamplePerBit);
                                                                % Plot - 1
Signal_sampled = MakeSampled(Signal,Samples,SamplePerChip);
                                                                % Plot - 2
OutSignal_sampled = inpt_vol*MakeSampled(OutSignal,Samples,SamplePerChip);
                                                             % Plot - 3

%% ###################### Outsignal Passing Through Coax #################

if (PassThroughCoax==0),
    Processed_OutSignal_sampled = OutSignal_sampled;
else
    Processed_OutSignal_sampled = coax_simulator(Samples,rate,t,f, ...
        OutSignal_sampled,Zr,L,b,a,Ur,Er,cond,var_coax,T0,cutoff, ...
        ord_but,considerBeta);                        % Plot -4
end

% ##################### CDMA Decoding Starts Here ########################
[Decoded,Decoder_Chip_sampled,Temp_Decoded_sampled,Ingl] = CDMA_decode( ...
  Processed_OutSignal_sampled,Chipbit,User_to_Decode,SamplePerBit,...
  SamplePerChip,TotalDataBit);

Decoded_sampled = MakeSampled(Decoded,Samples,SamplePerBit);  % Plot - 5

% ############################### Result ################################
if (isequal(Decoded,DataBit(:,User_to_Decode))==1)
    disp('Data Successfully Recovered');
else
    disp('Error Detected in Data');    
end

% ########################### ESD Calculation ############################
fft_databit = fftshift(fft(DataBit_sampled(:,User_to_Decode)));
ESD_databit = fft_databit .* conj(fft_databit);

fft_chipbit = fftshift(fft(Decoder_Chip_sampled));
ESD_chipbit = fft_chipbit .* conj(fft_chipbit);

fft_signal = fftshift(fft(Signal_sampled(:,User_to_Decode)));
ESD_signal = fft_signal .* conj(fft_signal);

fft_OutSignal = fftshift(fft(OutSignal_sampled));
ESD_OutSignal = fft_OutSignal .* conj(fft_OutSignal);

fft_Processed_OutSignal = fftshift(fft(Processed_OutSignal_sampled));
ESD_Processed_OutSignal = fft_Processed_OutSignal .* ...
    conj(fft_Processed_OutSignal);

fft_Temp_Decoded = fftshift(fft(Temp_Decoded_sampled));
ESD_Temp_Decoded = fft_Temp_Decoded .* conj(fft_Temp_Decoded);

fft_Decoded_sampled = fftshift(fft(Decoded_sampled));
ESD_Decoded_sampled = fft_Decoded_sampled .* conj(fft_Decoded_sampled);

% ########################## Plotting the Output  ########################
clipto = TotalDataBit*SamplePerBit;
scrsz = get(0,'ScreenSize');
if (plot_In==1),        % plot_in = 1 < Time x axis; plot_in = 0 <  Sample x axis 
    if (Graphs_2_plot(1)==1),
    Fighand = figure();
    set(Fighand,'Name','Time Domain Representation:Encoding Process', ...
        'NumberTitle','off','Position',[1 1 scrsz(3) (scrsz(4)/1.1)])
    subplot(411),
    plot(t(1:clipto),DataBit_sampled(1:clipto,User_to_Decode),'r')
    axis ([min(t(1:clipto)),max(t(1:clipto)),min(DataBit_sampled(1:clipto,User_to_Decode))-0.2 ...
        max(DataBit_sampled(1:clipto,User_to_Decode))+0.2])
    xlabel(sprintf('Time(Sec.)(%d sec per bit)',Tb))
    ylabel('Signal Voltage (Volt)')
    title (sprintf('Data bits of user %d',User_to_Decode))
    
    subplot(412),
    plot(t(1:clipto),Decoder_Chip_sampled(1:clipto),'b')
    axis ([min(t(1:clipto)),max(t(1:clipto)),min(Decoder_Chip_sampled(1:clipto,User_to_Decode))-0.2 ...
        max(Decoder_Chip_sampled(1:clipto,User_to_Decode))+0.2])
    xlabel(sprintf('Time(Sec.)(%d sec per chip)',Tc))
    ylabel('Signal Voltage (Volt)')
    title (sprintf('Chip bits of user %d',User_to_Decode))
    
    subplot(413),
    plot(t(1:clipto),Signal_sampled(1:clipto,User_to_Decode),'b')
    axis ([min(t(1:clipto)),max(t(1:clipto)),min(Signal_sampled(1:clipto,User_to_Decode))-0.2 ...
        max(Signal_sampled(1:clipto,User_to_Decode))+0.2])
    xlabel('Time(Sec.)')
    ylabel('Signal Voltage (Volt)')
    title ('Multiplication of Data and Chip')    
    
    subplot(414),
    plot(t(1:clipto),OutSignal_sampled(1:clipto),'b')
    axis tight
    xlabel('Time(Sec.)')
    ylabel('Signal Voltage (Volt)')
    title (sprintf('Summation of Data-chip product for %d Users', ...
        TotalUser))
    end
    
    if (Graphs_2_plot(2)==1),
    Fighand = figure();
    set(Fighand,'Name','Time Domain Representation:Decoding Process', ...
        'NumberTitle','off','Position',[1 1 scrsz(3) (scrsz(4)/1.1)])
    subplot(411),
    plot(t(1:clipto),Processed_OutSignal_sampled(1:clipto),'b')
    axis tight
    xlabel('Time(Sec.)')
    ylabel('Signal Voltage (Volt)')
    title ('Summation of Data-chip product after passing through coax')
    
    subplot(412),
    plot(t(1:clipto),Decoder_Chip_sampled(1:clipto),'b')
    axis ([min(t(1:clipto)),max(t(1:clipto)),min(Decoder_Chip_sampled(1:clipto,User_to_Decode))-0.2 ...
        max(Decoder_Chip_sampled(1:clipto,User_to_Decode))+0.2])
    xlabel(sprintf('Time(Sec.)(%d sec per bit)',Tb))
    ylabel('Signal Voltage (Volt)')
    title (sprintf('Chip bits of user %d',User_to_Decode))
    
    subplot(413),
    plot(t(1:clipto),Temp_Decoded_sampled(1:clipto),'b')
    axis tight
    xlabel(sprintf('Time(Sec.)(%d sec per bit)',Tb))
    ylabel('Signal Voltage (Volt)')
    title (['Multiplication of Received Signal and Chip bits(blue)', ...
    ' Average in bit period(red)']);
    
    Decoded_sampled = max(Ingl)*Decoded_sampled;
    subplot(414),
    hold on
    plot(t(1:clipto),Ingl(1:clipto),'b')
    plot(t(1:clipto),Decoded_sampled(1:clipto),'r')    
    hold off
    axis tight
    xlabel('Time(Sec.)')
    ylabel('Signal Voltage (Volt)')
    title ('Output of the integrator') 
    end
elseif (plot_In==0),
    if (Graphs_2_plot(1)==1),
    Fighand = figure();
    set(Fighand,'Name','Time Domain Representation:Encoding Process', ...
        'NumberTitle','off','Position',[1 1 scrsz(3) (scrsz(4)/1.1)])
    subplot(411),
    plot((1:clipto),DataBit_sampled(1:clipto,User_to_Decode),'r')
    axis ([min((1:clipto)),max((1:clipto)),min(DataBit_sampled(1:clipto,User_to_Decode))-0.2 ...
        max(DataBit_sampled(1:clipto,User_to_Decode))+0.2])
    xlabel(sprintf('No of Samples(%d Samples per bit)',Tb*Rate))
    ylabel('Signal Voltage (Volt)')
    title (sprintf('Data bits of user %d',User_to_Decode))
    
    subplot(412),
    plot((1:clipto),Decoder_Chip_sampled(1:clipto),'b')
    axis ([min((1:clipto)),max((1:clipto)),min(Decoder_Chip_sampled(1:clipto,User_to_Decode))-0.2 ...
        max(Decoder_Chip_sampled(1:clipto,User_to_Decode))+0.2])
    xlabel(sprintf('No of Samples(%d Samples per chip)',Tc*rate))
    ylabel('Signal Voltage (Volt)')
    title (sprintf('Chip bits of user %d',User_to_Decode))
    
    subplot(413),
    plot((1:clipto),Signal_sampled(1:clipto,User_to_Decode),'b')
    axis ([min((1:clipto)),max((1:clipto)),min(Signal_sampled(1:clipto,User_to_Decode))-0.2 ...
        max(Signal_sampled(1:clipto,User_to_Decode))+0.2])
    xlabel('No of Sample')
    ylabel('Signal Voltage (Volt)')
    title ('Multiplication of Data and Chip')    
    
    subplot(414),
    plot((1:clipto),OutSignal_sampled(1:clipto),'b')
    axis tight
    xlabel('No of Sample')
    ylabel('Signal Voltage (Volt)')
    title (sprintf('Summation of Data-chip product for %d Users', ...
        TotalUser))
    end
    
    if (Graphs_2_plot(2)==1),
    Fighand = figure();
    set(Fighand,'Name','Time Domain Representation:Decoding Process', ...
        'NumberTitle','off','Position',[1 1 scrsz(3) (scrsz(4)/1.1)])
    subplot(411),
    plot((1:clipto),Processed_OutSignal_sampled(1:clipto),'b')
    axis tight
    xlabel('No of Sample')
    ylabel('Signal Voltage (Volt)')
    title ('Summation of Data-chip product after passing through coax')
    
    subplot(412),
    plot((1:clipto),Decoder_Chip_sampled(1:clipto),'b')
    axis ([min((1:clipto)),max((1:clipto)),min(Decoder_Chip_sampled(1:clipto,User_to_Decode))-0.2 ...
        max(Decoder_Chip_sampled(1:clipto,User_to_Decode))+0.2])
    xlabel(sprintf('No of Samples(%d samples per bit)',Tb*rate))
    ylabel('Signal Voltage (Volt)')
    title (sprintf('Chip bits of user %d',User_to_Decode))
    
    subplot(413),
    plot((1:clipto),Temp_Decoded_sampled(1:clipto),'b')
    axis tight
    xlabel(sprintf('No of Samples(%d samples per bit)',Tb*rate))
    ylabel('Signal Voltage (Volt)')
    title (['Multiplication of Received Signal and Chip bits(blue)', ...
    ' Average in bit period(red)']);
    
    Decoded_sampled = max(Ingl)*Decoded_sampled;
    subplot(414),
    hold on
    plot((1:clipto),Ingl(1:clipto),'b')
    plot((1:clipto),Decoded_sampled(1:clipto),'r')    
    hold off
    axis tight
    xlabel('Samples')
    ylabel('Signal Voltage (Volt)')
    title ('Output of the integrator') 
    end
end

if (Graphs_2_plot(3)==1),
Fighand = figure();
    set(Fighand,'Name','Frequency Domain Representation', ...
        'NumberTitle','off','Position',[1 1 scrsz(3) (scrsz(4)/1.1)])
    subplot(211)
    plot(f,ESD_databit,f,ESD_chipbit)
    axis ([min(f)/5,max(f)/5,min(ESD_databit),max(ESD_databit)])
    xlabel('Frequency(Hz)')
    ylabel('FFT Value')
    legend('FFT of Data','FFT of Chipping Sequence')
    title('Frequency Domain representation of Data & Chip')
    
    subplot(212)
    plot(f,ESD_signal)
    axis ([min(f)/5,max(f)/5,min(ESD_signal),max(ESD_signal)])
    xlabel('Frequency(Hz)')
    ylabel('FFT Value')
 title('Frequency Domain representation of Multiplication of Data & Chip')
end

if (Graphs_2_plot(4)==1),
    Fighand = figure();
    set(Fighand,'Name','Frequency Domain Representation', ...
        'NumberTitle','off','Position',[1 1 scrsz(3) (scrsz(4)/1.1)])
 
    subplot(311)
    plot(f,ESD_OutSignal)
    axis ([min(f)/5,max(f)/5,min(ESD_OutSignal),max(ESD_OutSignal)])
    xlabel('Frequency(Hz)')
    ylabel('FFT Value')
 title('Frequency Domain of sum of product sequences')
 
    subplot(312)
    plot(f,ESD_Processed_OutSignal)
    axis ([min(f)/5,max(f)/5,min(ESD_Processed_OutSignal),max(ESD_Processed_OutSignal)])
    xlabel('Frequency(Hz)')
    ylabel('FFT Value')
 title( ...
'Frequency Spectrum of sum of product sequence after passing through coax')

    subplot(313)
    plot(f,ESD_Decoded_sampled)
    axis ([min(f)/5,max(f)/5,min(ESD_Decoded_sampled),max(ESD_Decoded_sampled)])
    xlabel('Frequency(Hz)')
    ylabel('FFT Value')
 title( ...
'Frequency Domain of Decoded Data')
end