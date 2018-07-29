function Callbacks_ideal_vocal_tract_GUI25(f,C)
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
case 5
graphicPanel5 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
case 6
graphicPanel6 = axes('parent',f,...
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
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER CODE FOR THE VARIABLES AND CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Variables
vowel_index=1;
ipd=100;
Lm=40;
L=400;
ilog=1;
ftable=[270 2290 3010; 390 1990 2550; 530 1840 2480; 660 1720 2410;...
    520 1190 2390; 730 1090 2390; 570 840 2410; 490 1350 1690;...
    440 1020 2240; 300 870 2240; 300 870 2240; 500 1500 2500];
btable=[40 60 75];
fk=[270 2290 3010];
bk=[40 60 75];
M=3;
fs=10000;
hn=[];
g=[];
iglottal=0;
vowels=['IY'; 'IH'; 'EH'; 'AE'; 'AH'; 'AA'; 'AO'; 'ER'; 'UH'; 'UW'; 'OO'; 'Ne'];
filename=vowels(1,:);
alpha1=40;
alpha2=20;

% nfft: size of fft and ifft for conversion from time to frequency or
% frequency to time domain
    nfft=1000;

% Name GUI
    set(f,'Name','ideal_vocal_tract_GUI');

% CALLBACKS
% Callback for button1 -- vowel choice from popuplist
 function button1Callback(h,eventdata)
     vowel_index=get(button1,'val');
     fk=ftable(vowel_index,:);
     bk=btable;
     filename=vowels(vowel_index,:);
 end

% Callback for button2 -- ipd: pitch period in msec
 function button2Callback(h,eventdata)
     ipd=str2num(get(button2,'string'));
     if ipd < 2
         waitfor(msgbox('pitch period must lie between 2 and 15 msec'));
     elseif ipd > 15
         waitfor(msgbox('pitch period must lie between 2 and 15 msec'));
     end
     ipd=ipd*fs/1000;
 end

% Callback for button3 -- Lm: frame duration in msec, (editable)
 function button3Callback(h,eventdata)
     Lm=str2num(get(button3,'string'));
      if Lm < 0
         waitfor(msgbox('The frame duration cannot be negative'));
     end
     L=round(Lm*fs/1000);
 end

% Callback for button4 -- log/linear popuplist (1=log, 2=linear); option
% for plotting vowel and ideal frequency responses
 function button4Callback(h,eventdata)
     ilog=get(button4,'val');
 end

% Callback for button10 -- iglottal: use glottal puse (1) or skip glottal
% pulse (0)
    function button10Callback(h,eventdata)
        iglottal=get(button10,'val');
    end

% Callback for button8 -- alpha1 for glottal pulse
    function button8Callback(h,eventdata)
        alpha1=str2num(get(button8,'string'))/100;
        if alpha1 < 0
            waitfor(msgbox('alpha1 must lie between 0 and 100'));
        elseif alpha1 > 1
            waitfor(msgbox('alpha1 must lie between 0 and 100'));
        end
    end

% Callback for button9 -- alpha2 for glottal pulse
    function button9Callback(h,eventdata)
        alpha2=str2num(get(button9,'string'))/100;
    if alpha2 < 0
        waitfor(msgbox('alpha2 must lie between 0 and 100'));
    elseif alpha2 > 1
        waitfor(msgbox('alpha2 must lie between 0 and 100'));
     end
    end

% Callback for button5 -- Run ideal vocal tract responses
 function button5Callback(h,eventdata)
    
% eps: smallest spectral magnitude for plotting log magnitude spectra
    eps=1.e-3;
    
% form rosenberg glottal pulse, g; rise % from alpha1; fall % from alpha2
    button8Callback(h,eventdata);
    button9Callback(h,eventdata);
    button10Callback(h,eventdata);
    button2Callback(h,eventdata);
    button3Callback(h,eventdata);
    button4Callback(h,eventdata);
    
    n1=round(ipd*alpha1);
    n2=round(ipd*alpha2);
    g=[];
    x1=0:n1;
    g=[g 0.5*(1-cos(pi*x1/n1))];
    x2=1:n2;
    g=[g cos(pi*x2/(2*n2))];
    g=[g zeros(1,ipd-length(g))];
    
% create periodic voiced excitation
    e=zeros(1,nfft);
    e(1:ipd:nfft)=1;
    EM=zeros(1,nfft);
    EM(1:round(nfft/ipd):nfft)=1;
    
% glottal_pulse excitation based on iglottal (1: use glottal pulse, 0 skip 
% glottal pulse
if (iglottal == 1)
    eg=conv(e,g);
else
    eg=e;
end
    ege(1:nfft)=0;
    ege(1:nfft)=eg(1:nfft);
    EGM=abs(fft(ege,nfft));
    
% convert to second order system format
    zk=exp(-2*pi*bk/fs);
    fkn=cos(2*pi*fk/fs);
    
% transform into frequency domain    
    HR=[];
    HT=zeros(1,nfft);
    HP=(complex(ones(1,nfft),zeros(1,nfft)))';
    for k=1:M
        B=1-2*zk(k)*fkn(k)+zk(k)*zk(k);
        A=[1 -2*zk(k)*fkn(k) zk(k)*zk(k)];
        [H,W]=freqz(B,A,nfft,'whole',fs);
        HP=HP.*H;
        HL=(abs(H));
        HT=HT.*HL';
    end
    
% inverse transform to give vocal tract impulse response
    hn=ifft(HP,nfft);
    hmax=max(max(hn),-min(hn));
    for index=1:nfft
        if (max(max(hn(index:nfft)),-min(hn(index:nfft)))) < hmax/50
            nl=index;
            break;
        end
    end
    
% plot elements of composite response in the 6 graphics Panels
% plot ideal impulse excitation signal in graphics Panel 5 (top left panel)
    reset(graphicPanel5);
    axes(graphicPanel5);
    
    if (iglottal == 0)
        stem(0:nfft-1,e(1:nfft),'b','LineWidth',2),axis tight;
    else
        plot(0:nfft-1,eg(1:nfft),'b','LineWidth',2),axis tight;
    end
    xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
    xlabel(xpp),ylabel('Amplitude');grid on;legend('Excitation Pulses');
    
% plot vowel impulse response in graphics Panel 3 (middle left panel)
    reset(graphicPanel3);
    axes(graphicPanel3);
    
    plot(0:nl,hn(1:nl+1),'r','LineWidth',2);
    xlabel(xpp),ylabel('Amplitude');
    axis tight, grid on;legend('Vowel Vocal Tract Impulse Response');
    
% plot linear or log magnitude frequency response of ideal impulse
% excitation signal in graphics Panel 6 (top right panel); use lin/log
% option to decide whether to plot linear or log magnitude responses
    if (ilog == 1)
        reset(graphicPanel6);
        axes(graphicPanel6);
        plot(W(1:nfft/2+1),20*log10(EGM(1:nfft/2+1)+eps),'b','LineWidth',2);
        axis tight,xlabel('Frequency in Hz'),ylabel('Log Magnitude (dB)');
        legend('Excitation Pulses Log Spectrum');
        
% plot linear or log magnitude frequency response of ideal vocal tract
% impulse response in graphics Panel 4 (middle right panel); use lin/log
% option to decide whether to plot linear or log magnitude response
        reset(graphicPanel4);
        axes(graphicPanel4);
        plot(W(1:nfft/2+1),20*log10(abs(HP(1:nfft/2+1))),'r','LineWidth',2);
        axis tight,grid on, xlabel('Frequency in Hz');
        ylabel('Log Magnitude (dB)');legend('Vocal Tract Log Spectrum');
    else
        reset(graphicPanel6);
        axes(graphicPanel6);
        plot(W(1:nfft/2+1),EGM(1:nfft/2+1),'b','LineWidth',2);
        axis tight,xlabel('Frequency in Hz'),ylabel('Magnitude');
        legend('Excitation Pulses Linear Spectrum');
    
        reset(graphicPanel4);
        axes(graphicPanel4);
        plot(W(1:nfft/2+1),abs(HP(1:nfft/2+1)),'r','LineWidth',2);
        xlabel('Frequency in Hz'),ylabel('Magnitude'),axis tight,grid on;
        legend('Vocal Tract Linear Spectrum');
    end
    axis tight;
    
% take product of magnitudes, convolve time responses
    he=zeros(1,L+nfft-1);
    for index=1:ipd:L
        he(index:index+nfft-1)=he(index:index+nfft-1)+hn(1:nfft)';
    end
    EMV=EGM(1:nfft/2+1).*abs(HP(1:nfft/2+1))';
    
% plot ideal periodic vowel impulse response in graphics Panel 1 (lower
% left panel); note: no glottal pulse used in this simple ideal vocal tract
% model
    reset(graphicPanel1);
    axes(graphicPanel1);
    plot(0:L-1,he(1:L),'b','LineWidth',2);
    xlabel(xpp),ylabel('Amplitude');
    axis tight,grid on;legend('Vowel Waveform');
    
% plot linear or log magnitude frequency response of ideal synthetic vowel
% impulse response in graphics Panel 2 (bottom right panel); use lin/log
% option to decide whether to plot linear or log magnitude response
    if (ilog == 1)
        reset(graphicPanel2);
        axes(graphicPanel2);
        plot(W(1:nfft/2+1),20*log10(EMV(1:nfft/2+1)+eps),'r','LineWidth',2);
        xlabel('Frequency in Hz'),ylabel('Log Magnitude (dB)');
        axis tight,grid on;legend('Vowel Log Spectrum');
    else
        reset(graphicPanel2);
        axes(graphicPanel2);
        plot(W(1:nfft/2+1),EMV(1:nfft/2+1),'r','LineWidth',2);
        xlabel('Frequency in Hz'),ylabel('Magnitude');
        axis tight, grid on;legend('Vowel Linear Spectrum');
    end
    
% set titleBox1 information for display
    stitle=sprintf('Ideal Vocal Tract -- Vowel:%s, ipd:%d, L:%d, fs:%d, eps:%6.3f',filename,ipd,L,fs,eps);
    set(titleBox1,'String',stitle);
    set(titleBox1,'FontSize',20);
 end

% Callback for button7 -- Play Synthetic Vowel
    function button7Callback(h,eventdata)
% play back synthetic speech output
    e=zeros(1,fs);
    e(1:ipd:fs)=1;
    if (iglottal == 1)
        y1=conv(e,g);
        yout=conv(y1,hn);
    else
        yout=conv(e,hn);
    end
    % uiwait(msgbox('Play out synthetic speech','speech out'));
    soundsc(yout,fs);
    end

% Callback for button6 -- Close GUI
 function button6Callback(h,eventdata)
     close(gcf);
 end
end