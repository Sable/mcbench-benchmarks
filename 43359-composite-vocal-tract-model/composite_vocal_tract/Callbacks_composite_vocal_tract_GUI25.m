function Callbacks_composite_vocal_tract_GUI25(f,C)
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
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER CODE FOR THE VARIABLES AND CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Variables
fs=10000;
nfft=4000;
vowels=[];
ivowel=1;
fsd=10000;
iperiod=10;
period=100;
g=[];
yout=[];
hn=[];
iexc=1;
curr_file=[];
z3=[];
alpha1=40;
alpha2=20;

% spectrogram parameters
    winlen_WB=4;
    winlen_NB=40;
    nfft_WB=1024;
    nfft_NB=1024;
    overlap=95;
    map_index=2;
    select_win=1;
    logLinear_index=1;
    dyn_range=60;
    
% converting window lengths from ms to samples
    winlen_WBsamples = fix(winlen_WB*0.001*fsd); 
    winlen_NBsamples = fix(winlen_NB*0.001*fsd);
% overlap in samples based on window size
	overlap_WB=fix(overlap*winlen_WBsamples/100);
    overlap_NB=fix(overlap*winlen_NBsamples/100);
% selection of window
	w_WB = window(@hamming,winlen_WBsamples);
    w_NB = window(@hamming,winlen_NBsamples);

% Name the GUI
    set(f,'Name','composite_vocal_tract_GUI');

% CALLBACKS
% Callback for button1 -- choose the vowel sound, ivowel, from popup menu
 function button1Callback(h,eventdata)
     ivowel=get(button1,'val');
 end

% Callback for button2 -- iperiod: specified pitch period (ms)
 function button2Callback(h,eventdata)
     iperiod=str2num(get(button2,'string'));
      if iperiod < 2
          waitfor(msgbox('pitch period must lie between 2 and 15 msec'));
      elseif iperiod > 15
          waitfor(msgbox('pitch period must lie between 2 and 15 msec'));
     end
 end

% Callback for button3 -- fsd: synthetic vowel speech sampling rate
 function button3Callback(h,eventdata)
     fsd=str2num(get(button3,'string'));
      if fsd < 0
         waitfor(msgbox('The synthetic vowel speech sampling rate cannot be negative'));
     end
 end

% Callback for button9 -- glottal pulse opening, alpha1
    function button9Callback(h,eventdata)
        alpha1=str2num(get(button9,'string'))/100;
        if alpha1 < 0
            waitfor(msgbox('alpha1 must lie between 0 and 100'));
        elseif alpha1 > 1
            waitfor(msgbox('alpha1 must lie between 0 and 100'));
        end
    end

% Callback for button10 -- glottal pulse closing, alpha2
    function button10Callback(h,eventdata)
        alpha2=str2num(get(button10,'string'))/100;
        if alpha2 < 0
            waitfor(msgbox('alpha2 must lie between 0 and 100'));
        elseif alpha2 > 1
            waitfor(msgbox('alpha2 must lie between 0 and 100'));
     end
    end

% Callback for button7 -- Excitation;  Glottal Pulse or White Noise
    function button7Callback(h,eventdata)
        iexc=get(button7,'val');
    end

% Callback for button 11 -- spectrogram dynamic range, dyn_range
    function button11Callback(h,eventdata)
        dyn_range=str2num(get(button11,'string'));
    end

% Callback for button4 -- run composite vocal tract response
 function button4Callback(h,eventdata)

% load structure, 'vowels_fmts_bw.mat', with vowel info (formants and bandwidths)
    str=load('vowels_fmts_bw.mat');
    vowels=str.vowels;
    formants=str.formants;
    bandwidths=str.bandwidths;
    
% generate vowel impulse response, yout; fourth formant set to 4500 Hz
    fmts=formants(ivowel,:);
    fmts=[fmts 4500];
    yout=vowel_ir(fmts,bandwidths,fsd);

% convert from frequency and bandwidth to all-pole digital transfer
% function coefficients
    zk=exp(-2*pi*bandwidths/fsd);
    fkn=cos(2*pi*fmts/fsd);

% evaluate vocal tract log magnitude response; save in HT
    HR=[];
    HT=zeros(1,nfft);
    HP=(complex(ones(1,nfft),zeros(1,nfft)))';
    M=4;
    for k=1:M
        B=1-2*zk(k)*fkn(k)+zk(k)*zk(k);
        A=[1 -2*zk(k)*fkn(k) zk(k)*zk(k)];
        [H,W]=freqz(B,A,nfft,'whole',fsd);
        HP=HP.*H;
        HL=20*log10(abs(H));
        HT=HT+HL';
    end
    stitle=sprintf('vowel: %s, fsd: %d, period: %d ms ',vowels(ivowel,:),fsd,iperiod);
    
% plot vocal tract log magnitude response, HT, in graphics Panel 1
    reset(graphicPanel1);
    axes(graphicPanel1);
    
    plot(W(1:nfft/2+1),HT(1:nfft/2+1),'r--','LineWidth',2);
    xpp=['Frequency in Hz; fsd=',num2str(fsd),' samples/second'];
    xlabel(xpp),ylabel('Log Magnitude (dB)');
    grid,hold on;
    
% invert complex spectrum to give vocal tract impulse response, hn
    hn=ifft(HP,nfft);
    hmax=max(max(hn),-min(hn));
    for index=1:nfft
        if (max(max(hn(index:nfft)),-min(hn(index:nfft)))) < hmax/50
            nl=index;
            break;
        end
    end

% compute log magnitude response due to radiation at lips, HRL;
% approximate radiation load at lips using R(z)=R0 (1-alpha z^(-1))) where
% alpha is close to 1.0 (use a value of alpha=0.95 here)
    alpha=0.95;
    B=[1 -alpha];
    A=[1];
    [HR,W]=freqz(B,A,nfft,'whole',fsd);
    HRL=20*log10(abs(HR));
    HT=HT+HRL';
    
% plot radiation load log magnitude response on same plot as vocal tract
% log magnitude response (i.e., graphics Panel 1)
    plot(W(1:nfft/2+1),HRL(1:nfft/2+1),'g--','LineWidth',2);
    
% if excitation is voiced (iexc=1), compute glottal pulse (using Rosenberg pulse model) and
% determine the log magnitude response due to glottal excitation;
% otherwise skip this glottal pulse excitation
    if (iexc == 1)
% Rosenberg pulse parameters are period, leading edge duration, alpha1, and
% trailing edge duration, alpha2
    period=round(iperiod*fsd/1000);
    % alpha1=.50;
    % alpha2=.15;
    button9Callback(h,eventdata);
    button10Callback(h,eventdata);
    
% form rosenberg pulse using specified parameters
    n1=round(period*alpha1);
    n2=round(period*alpha2);
    g=[];
    x1=0:n1;
    g=[g 0.5*(1-cos(pi*x1/n1))];
    x2=1:n2;
    g=[g cos(pi*x2/(2*n2))];
    g=[g zeros(1,period-length(g))];
    
% plot log magnitude spectrum of Rosenberg pulse, g, on same plot as vocal
% tract and radiation responses (graphics Panel 1)
    ge=[g zeros(1,nfft-length(g))];
    gs=20*log10(abs(fft(ge)));
    HT=HT+gs;
    figure(1);
    freq=0:fsd/nfft:fsd/2;
    plot(freq,gs(1:nfft/2+1),'b--','LineWidth',2);
    end
    
% plot composite of vocal tract, radiation and glottal pulse for voiced log
% magnitude;  plot composite of vocal tract and radiation for noise
% excitation

% plot responses on graphics Panel 1
    freq=0:fsd/nfft:fsd/2;
    plot(freq,HT(1:nfft/2+1),'m','LineWidth',4);
    if (iexc == 1)
        legend('Vocal Tract Response','Radiation Response at Lips',...
        'Rosenberg Glottal Pulse','Composite Response');
    else
        legend('Vocal Tract Response','Radiation Response at Lips',...
            'Composite Response');
    end
    
% plot vocal tract impulse response on graphics Panel 2
    reset(graphicPanel2);
    axes(graphicPanel2);
    
    plot(0:nl,hn(1:nl+1),'r','LineWidth',2);
    xpp=['Time in Samples; fsd=',num2str(fsd),' samples/second'];
    xlabel(xpp);ylabel('Amplitude');grid on;
    lpp=['vowel ',vowels(ivowel,:),' Impulse Response'];legend(lpp);
    
% title box for exercise
    string1=strcat('Composite Vocal Tract for Vowel Sounds - ',stitle);
    set(titleBox1,'string',string1);
    set(titleBox1,'FontSize',25);
 end

% Callback for button5 -- for voiced excitation play out the following sequence:
%   1. pitch pulse excitation by itself (very buzzy)
%   2. glottal pulse excitation by itself (still very buzzy)
%   3. synthetic vowel with glottal pulse excitation source (more natural
%   sounding)
 function button5Callback(h,eventdata)
     if (iexc == 1)
% create excitation pulse train of duration fsd samples
    z1=zeros(1,fsd);
    z1(1:period:fsd)=1;
    z2=conv(g,z1);
    % z3=conv(z2,yout);
    z3=conv(z2,hn);
    uiwait(msgbox('Play Sequence: 1.Pitch Pulse Excitation; 2.Glottal Pulse Excitation; 3.Synthetic Vowel','Sequence'));
    soundsc(z1,fsd);
    soundsc(z2,fsd);
    soundsc(z3,fsd);
     else
% create excitation noise of duration fsd samples
    z1=randn(1,fsd);
    z3=conv(z1,hn);
    uiwait(msgbox('Play Sequence: 1. Noise Excitation; 2. Synthetic Vowel'));
    soundsc(z1,fsd);
    soundsc(z3,fsd);
     end
     
% save vowel in file on current directory
    fname=['vowel_',vowels(ivowel,:),'_fsd_',num2str(fsd),'.wav'];
    z3m=max(max(z3),-min(z3));
    z3n=z3(1:fsd)/z3m*0.99;
    wavwrite(z3n,fsd,16,fname);
 end

% Callback for Button8 -- Plot Vowel Spectrograms
    function button8Callback(h,eventdata)
        button11Callback(h,eventdata);  % dyn_range: spectrogram dynamic range
        
     if (iexc == 1)
% create excitation pulse train of duration fsd samples
    z1=zeros(1,fsd);
    z1(1:period:fsd)=1;
    z2=conv(g,z1);
    z3=conv(z2,hn);
     else
% create excitation noise of duration fsd samples
    z1=rand(1,fsd);
    z3=conv(z1,hn);
     end
    z3n(1:fsd)=z3(1:fsd);
    
% gray scale map
	t=colormap(gray);
	colormap(1-t);

% create and plot wideband spectrogram on graphics Panel 3
        [B,BA,F,T]=create_spectrogram(z3n,nfft_WB,fsd,w_WB,dyn_range,logLinear_index,overlap_WB);
        reset(graphicPanel3);
        axes(graphicPanel3);
        imagesc(T,F,BA);
        % title('Wideband spectrogram -- Composite Vowel');
        
        xpp=['Wideband Spectrogram: Time in Seconds; fsd=',num2str(fsd),' samples/second'];
        axis xy,xlabel(xpp),ylabel('Frequency in Hz');
        axis([0 length(z3)/fsd 0 fsd/2]);
        axis tight;
        
% create and plot narrowband spectrogram on graphics Panel 4
        [B,BA,F,T]=create_spectrogram(z3n,nfft_NB,fsd,w_NB,dyn_range,logLinear_index,overlap_NB);
        reset(graphicPanel4);
        axes(graphicPanel4);
        imagesc(T,F,BA);
        % title('Narrowband spectrogram -- Composite Vowel');
        
        xpp=['Narrowband Spectrogram: Time in Seconds; fsd=',num2str(fsd),' samples/second'];
        axis xy,xlabel(xpp),ylabel('Frequency in Hz');
        axis([0 length(z3)/fsd 0 fsd/2]);
        axis tight;
    end

% Callback for button6 -- Close GUI
 function button6Callback(h,eventdata)
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