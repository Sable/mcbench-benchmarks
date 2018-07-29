function Callbacks_filter_GUI25(f,C,start_path)
%SENSE COMPUTER AND SET FILE DELIMITER
switch(computer)				
    case 'MACI64',		char= '/';
    case 'GLNX86',  char='/';
    case 'PCWIN',	char= '\';
    case 'PCWIN64', char='\';
    case 'GLNXA64', char='/';
end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=C{1,1};
y=C{1,2};
a=C{1,3};
b=C{1,4};
u=C{1,5};
v=C{1,6};
m=C{1,7};
n=C{1,8};
lengthbutton=C{1,9};
widthbutton=C{1,10};
enterType=C{1,11};
enterString=C{1,12};
enterLabel=C{1,13};
noPanels=C{1,14};
noGraphicPanels=C{1,15};
noButtons=C{1,16};
labelDist=C{1,17};%distance that the label is below the button
noTitles=C{1,18};
buttonTextSize=C{1,19};
labelTextSize=C{1,20};
textboxFont=C{1,21};
textboxString=C{1,22};
textboxWeight=C{1,23};
textboxAngle=C{1,24};
labelHeight=C{1,25};
fileName=C{1,26};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PANELS
for j=0:noPanels-1
uipanel('Parent',f,...
'Units','Normalized',...
'Position',[x(1+4*j) y(1+4*j) x(2+4*j)-x(1+4*j) y(3+4*j)-y(2+4*j)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GRAPHIC PANELS
for i=0:noGraphicPanels-1
switch (i+1)
case 1
graphicPanel1 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
case 2
graphicPanel2 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
case 3
graphicPanel3 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
case 4
graphicPanel4 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TITLE BOXES
for k=0:noTitles-1
switch (k+1)
case 1
titleBox1 = uicontrol('parent',f,...
'Units','Normalized',...
'Position',[u(1+4*k) v(1+4*k) u(2+4*k)-u(1+4*k) v(3+4*k)-v(2+4*k)],...
'Style','text',...
'FontSize',textboxFont{k+1},...
'String',textboxString(k+1),...
'FontWeight',textboxWeight{k+1},...
'FontAngle',textboxAngle{k+1});
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BUTTONS
for i=0:(noButtons-1)
enterColor='w';
if strcmp(enterType{i+1},'pushbutton')==1 ||strcmp(enterType{i+1},'text')==1
enterColor='default';
end
if (strcmp(enterLabel{1,(i+1)},'')==0 &&...
        strcmp(enterLabel{1,(i+1)},'...')==0) %i.e. there is a label
%creating a label for some buttons
uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i)-labelDist-labelHeight(i+1) ...
(m(2+2*i)-m(1+2*i)) labelHeight(i+1)],...
'Style','text',...
'String',enterLabel{i+1},...
'FontSize', labelTextSize(i+1),...
'HorizontalAlignment','center');
end
switch (i+1)
case 1
button1=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button1Callback);
case 2
button2=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button2Callback);
case 3
button3=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button3Callback);
case 4
button4=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button4Callback);
case 5
button5=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button5Callback);
case 6
button6=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button6Callback);
case 7
button7=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button7Callback);
case 8
button8=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button8Callback);
case 9
button9=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button9Callback);
case 10
button10=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button10Callback);
case 11
button11=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button11Callback);
case 12
button12=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button12Callback);
case 13
button13=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button13Callback);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER CODE FOR THE VARIABLES AND CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
curr_file='abcd';
fs=10000;
fsNew=16000;
directory_name='abcd';
wav_file_names='abcd';
writefilename='abcd';
file_info_string=' ';
fileName=' ';
stitle1=' ';
yout=[];
fname='';
nsamp=1;
n=350;
ifilt=1;
bwidth=100;
tband=100;
b=[];
ydif=[];

 % spectrogram parameters
    winlen_WB=4;
    winlen_NB=40;
    nfft_WB=1024;
    nfft_NB=1024;
    overlap=95;
    map_index=2;
    select_win=1;
    logLinear_index=1;
    dyn_range=50;

% Name the GUI
    set(f,'Name','filter_signal');

%CALLBACKS

% Callback for button1 -- Get Speech Files Directory
 function button1Callback(h,eventdata)
     directory_name=uigetdir(start_path,'dialog_title');
     waitfor(msgbox('Please make sure you have already downloaded the speech and audio files and have put them in the same folder to which you downloaded the various speech processing exercises in order for the program to work seamlessly.'));
     A=strvcat(strcat((directory_name),[char,'*.wav']));
     struct_filenames=dir(A);
     wav_file_names={struct_filenames.name};
     set(button2,'String',wav_file_names);
     
% once the popupmenu/drop down menu is created, by default, the first
% selection from the popupmenu/drop down menu id not called
    indexOfDrpDwnMenu=1;
    
% by default first option from the popupmenu/dropdown menu will be loaded
    [curr_file,fs]=loadSelection(directory_name,wav_file_names,indexOfDrpDwnMenu);
 end

% Callback for button2 -- Choose speech file for play and plot
 function button2Callback(h,eventdata)
     indexOfDrpDwnMenu=get(button2,'val');
     [curr_file,fs]=loadSelection(directory_name,wav_file_names,indexOfDrpDwnMenu);
 end

%*************************************************************************
% function -- load selection from designated directory and file
%
function [curr_file,fs]=loadSelection(directory_name,wav_file_names,...
    indexOfDrpDwnMenu);
%
% read in speech/audio file
% fin_path is the complete path of the .wav file that is selected
    fin_path=strcat(directory_name,char,strvcat(wav_file_names(indexOfDrpDwnMenu)));
    
% clear speech/audio file
    clear curr_file;
    
% read in speech/audio signal into curr_file; sampling rate is fs 
    [curr_file,fs]=wavread(fin_path);
    
% create title information with file, sampling rate, number of samples
    fname=wav_file_names(indexOfDrpDwnMenu);
    FS=num2str(fs);
    nsamp=num2str(length(curr_file));
    file_info_string=strcat('  file: ',fname,', fs: ',FS,' Hz, nsamp:',nsamp);
end
%*************************************************************************

% Callback for button3 -- play current speech file
 function button3Callback(h,eventdata)
     soundsc(curr_file,fs);
 end

% Callback for button4 -- determine filter type, ifilt, from button4
 function button4Callback(h,eventdata)
% ifilt=1 for HPF, 2 for LPF, 3 for BPF
    ifilt=get(button4,'val');
 end

% Callback for button5 -- read in filter parameter, bwidth (width of stop band in
% Hz)
 function button5Callback(h,eventdata)
    bwidth=str2num(get(button5,'string'));
 end

% Callback for button6 -- read in filter parameter, tband (width of transition band in
% Hz)
 function button6Callback(h,eventdata)
    tband=str2num(get(button6,'string'));
 end

% Callback for button7 -- design filter using design_plot_filter; plot IR and FR
 function button7Callback(h,eventdata)
    button4Callback(h,eventdata);
    button5Callback(h,eventdata);
    button6Callback(h,eventdata);
    [b,n]=design_plot_filter(ifilt,bwidth,tband,fs);
 end

function [b,n]=design_plot_filter(ifilt,bwidth,tband,fs)
%
% design and plot IR and FR of HP, LP or BP FIR filter

% Inputs:
%   ifilt: filter type (1:HP, 2:LP, 3:BP)
%   bwidth: bandwidth of stop band(s) in Hz
%   tband: transition band width in Hz
%   fs: sampling rate of signal to be filtered
%
% Outputs:
%   b: filter impulse response
%   n: filter length minus 1 in samples

% determine n for each sampling rate
    tbandn=tband/fs;
    deltap=0.01;
    deltas=deltap;
    dinf=Dinfinity(deltap,deltas);
    f_k=fK(deltap,deltas);   
    n=round((dinf-f_k*tbandn^2)/tbandn+1);
    if (mod(n,2) == 1) n=n+1;
    end
%     disp(tband);
%     disp(bwidth);
%     disp(fs/2);
    if (ifilt == 1 || ifilt == 2)
        if (tband + bwidth > fs/2)
        waitfor(errordlg('LPF and HPF - The summmation of transition band and bandwidth should be greater than half the sampling rate'));
        end
    end
    
    if (ifilt == 3)
        if (tband + bwidth > fs/4)
            waitfor(errordlg('BPF - The summmation of transition band and bandwidth should be greater than one-fourth the sampling rate'));
        end
    end
    
    if (bwidth < 0)
        waitfor(errordlg('Bandwidth cannot be negative'));
    end
    
    if (tband < 0)
        waitfor(errordlg('Transition band cannot be negative'));
    end
    % if (fs == 6000) n=100;
    % elseif (fs == 6667) n=130;
    % elseif (fs == 8000) n=150;
    % elseif (fs == 10000) n=170;
    % elseif (fs == 16000) n=300;
    % elseif (fs == 20000) n=350;
    % else
        % fprintf('sampling rate incorrect \n');
        % uiwait(msgbox('sampling rate incorrect','Filter Design','modal'));
    % end
    
    if (ifilt == 1)    
% highpass design; set highpass cutoff frequency in Hz
        band1_start=0;
        band1_end=bwidth;
        band2_start=band1_end+tband;
        band2_end=fs/2;
    
% set firpm parameters, n,f,a as follows
        a=[0 0 1 1];
        f=[band1_start band1_end band2_start band2_end];
        f=2*f/fs;
        
    elseif (ifilt == 2)
        
% lowpass design; set lowpass cutoff frequency in Hz
        band1_start=0;
        band1_end=fs/2-tband-bwidth;
        band2_start=band1_end+tband;
        band2_end=fs/2;
    
% set firpm parameters, n,f,a as follows
        a=[1 1 0 0];
        f=[band1_start band1_end band2_start band2_end];
        f=2*f/fs;
        
    elseif (ifilt == 3)
        
% bandpass design; set lowpass and highpass cutoff frequencies in Hz
        band1_start=0;
        band1_end=bwidth;
        band2_start=band1_end+tband;
        band2_end=fs/2-tband-bwidth;
        band3_start=band2_end+tband;
        band3_end=fs/2;
        
% set firpm parameters, n,f,a as follows
        a=[0  0 1 1 0 0];
        f=[band1_start band1_end band2_start band2_end band3_start band3_end];
        f=2*f/fs;      
    end
          
% design filter using firpm function
    % fprintf('f:%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f \n',f);
    b=firpm(n,f,a);
    
% plot filter IR and FR on graphics Panel 2
    reset(graphicPanel2);
    axes(graphicPanel2);
    
% plot IR
    n1=0:n;
    plot(n1,b,'r','LineWidth',2);
    xpp=['time in samples; fs=',num2str(fs),' samples/second'];
    xlabel(xpp),ylabel('filter level');
    axis tight, grid on;legend('filter impulse response');
    
% compute FR
    nfft=4096;
    [h,w]=freqz(b,1,nfft,'whole',fs);
    
    if (ifilt == 1)
    stitle=sprintf('highpass filter: band edges:%d %d %d %d Hz, length:%d, fs:%d',...
    band1_start,band1_end,band2_start,band2_end,n+1,fs);
    elseif (ifilt == 2)
    stitle=sprintf('lowpass filter: band edges:%d %d %d %d Hz, length:%d, fs:%d',...
    band1_start,band1_end,band2_start,band2_end,n+1,fs);
    elseif (ifilt == 3)
    stitle=sprintf('bandpass filter: band edges:%d %d %d %d %d %d Hz, length:%d, fs:%d',...
    band1_start,band1_end,band2_start,band2_end,band3_start,band3_end,n+1,fs);
    end
    
% plot log magnitude FR on graphics Panel 1
    reset(graphicPanel1);
    axes(graphicPanel1);
    plot(w(1:nfft/2+1),20*log10(abs(h(1:nfft/2+1))),'b','LineWidth',2);
    xpp=['frequency in Hz; fs=',num2str(fs),' samples/second'];
    xlabel(xpp),ylabel('log magnitude (dB)');
    axis tight, grid on;legend('filter frequency response');
end

% Callback for button8 -- filter signal
 function button8Callback(h,eventdata)
     yin=[curr_file; zeros(n,1)];
     yinf=filter(b,1,yin);
     yout=yinf(n/2:round(n/2)+length(curr_file)-1);
     
% plot original signal on graphics Panel 3  
     reset(graphicPanel3);
     axes(graphicPanel3);
     l=length(curr_file);
     l1=(1:l)/fs;  % converting samples to time
     plot(l1,curr_file,'r','LineWidth',2);
     xpp=['Time in Seconds; fs=',num2str(fs),' samples/second'];
         xlabel(xpp),ylabel('Amplitude');
     axis tight;
     grid on;legend('original speech signal');
     hold off;  % turn hold off so that orevious contents of panel are replaced
     hold off;  % two hold off's are for speech file and Hamming window
    
% plot filtered signal on graphics Panel 4
     reset(graphicPanel4);
     axes(graphicPanel4);
     l=length(yout);
     l2=(1:l)/fs;  % converting samples to time
     plot(l2,yout,'b','LineWidth',2);
     xpp=['Time in Seconds; fs=',num2str(fs),' samples/second'];
         xlabel(xpp),ylabel('Amplitude');   
     axis tight;
     grid on;legend('filtered speech signal');
     
% setup text box
    stitle1=strcat('Filter Signal -- ',file_info_string);
    set(titleBox1,'String',stitle1);
    set(titleBox1,'FontSize',25);
 end

% Callback for button9 -- play original speech file and filtered signal
 function button9Callback(h,eventdata)
     soundsc(curr_file,fs);
     soundsc(yout,fs);
 end

% Callback for button 13 -- plot wideband spectrograms of original and
% filtered speech
    function button13Callback(h,eventdata)
     
 % convert window lengths from ms to samples
    winlen_WBsamples = fix(winlen_WB*0.001*fs); 
    winlen_NBsamples = fix(winlen_NB*0.001*fs);
% overlap in samples based on window size
	overlap_WB=fix(overlap*winlen_WBsamples/100);
    overlap_NB=fix(overlap*winlen_NBsamples/100);
% selection of window
	w_WB = window(@hamming,winlen_WBsamples);
    w_NB = window(@hamming,winlen_NBsamples);
    
% gray scale map
	t=colormap(gray);
	colormap(1-t);

% create and plot wideband spectrogram of original speech on graphics Panel 2
        [B,BA,F,T]=create_spectrogram(curr_file,nfft_WB,fs,w_WB,dyn_range,logLinear_index,overlap_WB);
        reset(graphicPanel2);
        axes(graphicPanel2);
        cla;
        imagesc(T,F,BA);
        
% title('Wideband spectrogram -- Original Speech Signal');
        xpp=['Wideband Spectrogram - Original Signal: Time in Seconds; fs=',num2str(fs),' samples/second'];
        axis xy,xlabel(xpp),ylabel('Frequency in Hz');
        axis([0 length(curr_file)/fs 0 fs/2]);grid on;
        axis tight;
        
% gray scale map
	t=colormap(gray);
	colormap(1-t);

% create and plot wideband spectrogram of filtered speech on graphics Panel 1
        [B,BA,F,T]=create_spectrogram(yout,nfft_WB,fs,w_WB,dyn_range,logLinear_index,overlap_WB);
        reset(graphicPanel1);
        axes(graphicPanel1);
        cla;
        imagesc(T,F,BA);
        
% title('Wideband spectrogram -- Filtered Speech Signal');
        xpp=['Wideband Spectrogram - Filtered Signal: Time in Seconds; fs=',num2str(fs),' samples/second'];
        axis xy,xlabel(xpp),ylabel('Frequency in Hz');
        axis([0 length(curr_file)/fs 0 fs/2]);grid on;
        axis tight;
 end

% Callback for button10 -- output signal filename
 function button10Callback(h,eventdata)
     fileName=get(button10,'string');
 end

% Callback for button11 -- save signal to output signal filename specified
% in button 10 in directory specified by user with uigetdir
 function button11Callback(h,eventdata)
     button10Callback(h,eventdata);
     newFolder=uigetdir(cd);
     oldFolder=cd(newFolder);
     % currentDir=pwd;
     % currDir=strcat(currentDir,char,writefilename);
     % wavwrite(yout,fs,currDir);
     wavwrite(yout,fs,16,fileName);
     cd(oldFolder);
 end

% Callback for button12 -- close GUI, close speech files
 function button12Callback(h,eventdata)
     fclose('all');
     close(gcf);
 end

% create spectrogram function
    function [B,BA,F,T]=create_spectrogram(y,nfft,fs,w,dyn_range,logLinear_index,overlap_new)
        [B,F,T]=spectrogram(y,w,overlap_new,nfft,fs,'yaxis');
        BA=[];
        if (logLinear_index == 1)
            BA=20*log10(abs(B));
            BAM=max(BA);
            BAmax=max(BAM);
            BA(find(BA < BAmax-dyn_range))=BAmax-dyn_range;       
        end
    end
end