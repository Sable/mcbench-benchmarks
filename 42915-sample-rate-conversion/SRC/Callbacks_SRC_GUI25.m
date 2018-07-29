function Callbacks_SRC_GUI25(f,C,start_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%SENSE COMPUTER AND SET FILE DELIMITER
switch(computer)				
    case 'MACI64',		char= '/';
    case 'GLNX86',  char='/';
    case 'PCWIN',	char= '\';
    case 'PCWIN64', char='\';
    case 'GLNXA64', char='/';
end

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

curr_file=1;
fs=10000;
fsNew=16000;
file_info_string=' ';
stitle1=' ';
directory_name='abcd';
wav_file_names='abcd';
writefilename='abcd';
yout=[];
fname='output';
fileName='out_file';
nsamp=1;
indexOfDrpDwnMenu=1;
fin_path='filename';
yout=[];

% Name the GUI
    set(f,'Name','sampling_rate_conversion');

% CALLBACKS

% Callback for button1 -- Get Speech Files Directory
 function button1Callback(h,eventdata)
     clear A wav_file_names;
     directory_name=uigetdir(start_path,'dialog_title');
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
 function button2Callback(~,eventdata)     
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
    
% retrieve fname from cell array
    fname=wav_file_names{indexOfDrpDwnMenu};
    
% correct filename by changing underbar characters to space characters
    fname(find(fname(:)=='_'))=' ';
end
%*************************************************************************

% Callback for button3 -- play current speech file
 function button3Callback(h,eventdata)
% play out current speech file
     soundsc(curr_file,fs);
 end

% Plot original file waveform
% Callback for button8 -- Plot Original Signal Waveform
    function button8Callback(h,eventdata)
 
% plot original signal waveform in graphics Panel 2
     grid off;
     reset(graphicPanel2);axes(graphicPanel2);cla;
     l=length(curr_file);
     i=(1:l)/fs;  % converting samples to time
     plot(i,curr_file,'k','LineWidth',2);
     xpp=['Time in Seconds; fs=',num2str(fs),' samples/second'];
         xlabel(xpp),ylabel('Amplitude');
     axis tight;
     grid on;legend('original speech file');
    end

% Plot Original Signal Long Time Spectrum
% Callback for button9 -- Plot Original Signal Long Time Spectrum
    function button9Callback(h,eventdata)
        nfft=1000;
% wrap file around nfft point spectrum
    x_LT=zeros(1,nfft);
    ss=1;
    es=ss+nfft-1;
    len=length(curr_file);
    while (es <= len)
        x_LT=x_LT+curr_file(ss:es)';
        ss=es+1;
        es=ss+nfft-1;
    end
    X_LT=20*log10(abs(fft(x_LT,nfft)));
    reset(graphicPanel2);axes(graphicPanel2);cla;
    f=0:fs/nfft:fs/2;
    plot(f,X_LT(1:nfft/2+1),'r','LineWidth',2);
    xlabel('Frequency (Hz)');ylabel('dB');
    axis tight; grid on; legend('Original Speech Signal Long Time Spectrum');
    end

% Callback for button4 -- read in output filename, writefilename, from button4
 function button4Callback(h,eventdata)
     writefilename=get(button4,'string');
 end

% Callback for button5 -- read in new sampling rate, fsNew, from button5
 function button5Callback(h,eventdata)
     %fsNew=str2num(get(button5,'string'));
     Index=get(button5,'val');
     a = [2000 4000 6000 8000 10000 16000 20000 40000];
     fsNew = a(Index); 
 end

% Callback for button6 -- convert sampling rate
 function button6Callback(h,eventdata)
     
% read in output filename (button4) and new sampling rate (button5)
     button4Callback(h,eventdata);
     button5Callback(h,eventdata);
     
% perform sampling rate conversion using function srconv
     yout=srconv(curr_file,fs,fsNew);
     
 % write out sample rate converted file
     youtm=max(max(yout),-min(yout));
     
% write output file using wavewrite
    yout=(yout/youtm)*0.98;
     
% setup Text Box
    stitle1=strcat('Sampling Rate Conversion -- ',file_info_string);
    set(titleBox1,'String',stitle1);
    set(titleBox1,'FontSize',20);
 end

% Callback for button10 -- Play Converted Speech Signal
    function button10Callback(h,eventdata)
% play out sampling rate converted array
       soundsc(yout,fsNew);
    end

% Callback for button11 -- Plot converted Speech Signal
% plot sampling rate converted waveform on graphics Panel 1
    function button11Callback(h,eventdata)
     reset(graphicPanel1);axes(graphicPanel1);cla;
     l=length(yout);
     i=(1:l)/fsNew;  % converting samples to time
     plot(i,yout,'b','LineWidth',2);
     xpp=['Time in Seconds; fs=',num2str(fsNew),' samples/second'];
         xlabel(xpp),ylabel('Amplitude');
     axis tight;
     grid on;legend('sample-rate converted speech file');
    end    

% Callback for button12 -- Plot Converted Speech Long Time Spectrum
    function button12Callback(h,eventdata)
        nfft=1000;
% wrap file around nfft point spectrum
    y_LT=zeros(1,nfft);
    ss=1;
    es=ss+nfft-1;
    len=length(yout);
    while (es <= len)
        y_LT=y_LT+yout(ss:es)';
        ss=es+1;
        es=ss+nfft-1;
    end
    Y_LT=20*log10(abs(fft(y_LT,nfft)));
    reset(graphicPanel1);axes(graphicPanel1);cla;
    f=0:fsNew/nfft:fsNew/2;
    plot(f,Y_LT(1:nfft/2+1),'r','LineWidth',2);
    xlabel('Frequency (Hz)');ylabel('dB');
    axis tight; grid on; legend('Converted Speech Signal Long Time Spectrum');
    end

% Callback for button13 -- Save Converted Speech in File
    function button13Callback(h,eventdata)
    button4Callback(h,eventdata)
    
% choose directory for writing out converted speech file
    newFolder=uigetdir(cd);
    oldFolder=cd(newFolder);
    wavwrite(yout,fsNew,16,writefilename);
    cd(oldFolder);
    fclose('all');
    end

% Callback for button7 -- terminate GUI
 function button7Callback(h,eventdata)
	 fclose('all');
     close(gcf);
 end
end