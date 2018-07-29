function Callbacks_glottal_pulse_GUI25(f,C)
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
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER CODE FOR THE VARIABLES AND CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Variables
alpha1=25;
alpha2=10;
period=100;
nfft=1024;
fs=10000;
ivowel=1;
fsd=10000;
imp_train=[];
pulse_train=[];
zout=[];
g=[];
vowels='IY';

% Name the GUI
    set(f,'Name','glottal_pulse_GUI');


% CALLBACKS
% Callback for button1 -- alpha1, editable button value for glottal pulse 
% opening cycle (in %) 
 function button1Callback(h,eventdata)
     alpha1=str2num(get(button1,'string'))/100;
     if alpha1 < 0
         waitfor(msgbox('alpha1 must lie between 0 and 100'));
     elseif alpha1 > 1
         waitfor(msgbox('alpha1 must lie between 0 and 100'));
     end
 end

% Callback for button2 -- alpha2, editable button value for glottal pulse
% closing cycle (in %)
 function button2Callback(h,eventdata)
     alpha2=str2num(get(button2,'string'))/100;
     if alpha2 < 0 
         waitfor(msgbox('alpha2 must lie between 0 and 100'));
     elseif (alpha2 > 1)
         waitfor(msgbox('alpha2 must lie between 0 and 100'));
     end
 end

% Callback for button3 -- period, editable button duration of pitch 
% period (in samples) at fs=10000 Hz
 function button3Callback(h,eventdata)
     period=str2num(get(button3,'string'));
     if period < 10
         waitfor(msgbox('pitch period must lie between 10 and 250 samples'));
     elseif period > 250
         waitfor(msgbox('pitch period must lie between 10 and 250 samples'));
     end
 end

% Callback for button4 -- ivowel: editable button for vowel sound impulse
% response to be convolved with glottal pulse
 function button4Callback(h,eventdata)
     ivowel=get(button4,'val');
 end

% Callback for button9 -- Generate Excitation -- both Rosenberg pulse and
% periodic extension at designated pitch period
    function button9Callback(h,eventdata)
        button3Callback(h,eventdata);
        button4Callback(h,eventdata);

     alpha1=str2num(get(button1,'string'))/100;
     alpha2=str2num(get(button2,'string'))/100;
     
% form rosenberg glottal pulse, g
    n1=round(period*alpha1);
    n2=round(period*alpha2);
    g=[];
    x1=0:n1;
    g=[g 0.5*(1-cos(pi*x1/n1))];
    x2=1:n2;
    g=[g cos(pi*x2/(2*n2))];
    g=[g zeros(1,period-length(g))];
    
% plot g as a time domain signal over a single period in graphics Panel 1
    reset(graphicPanel2);
    axes(graphicPanel2);
    
    x=0:length(g)-1;
    plot(x,g,'b','LineWidth',2);
    xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
    xlabel(xpp);
    ylabel('Pulse Amplitude');axis tight; grid on;
    s1=sprintf('Rosenberg pulse -- period: %d,',period);
    s2=sprintf(' alpha1, alpha2: %6.3f, %6.3f ',alpha1,alpha2);
    stitle=strcat(s1,s2);
    legend('Rosenberg Pulse');
    
% display glottal pulse parameters in titleBox1
    set(titleBox1,'String',stitle);
    set(titleBox1,'FontSize',25);
    
% plot log magnitude spectrum of glottal pulse, g, in graphics Panel 1
    ge=[g zeros(1,nfft-length(g))];
    gs=20*log10(abs(fft(ge)));
    freq=0:fs/nfft:fs/2;
    x2=[0 fs/2];
    s2=[0 0];
    
    reset(graphicPanel1);
    axes(graphicPanel1);
    plot(freq,gs(1:nfft/2+1),'r','LineWidth',2);
    hold on;
    plot(x2,s2,'g','LineWidth',2);
    xlabel('Frequency in Hz'),ylabel('Log Magnitude (dB)');
    axis tight; grid on;legend('Rosenberg Pulse Spectrum');
    
% play out periodic pulse train of impulses spaced period samples apart, 
% and of total length of fsd=10000 samples (fsd defined in list of
% variables at beginning of Callbacks)
    imp_train=zeros(1,fsd);
    imp_train(1:period:fsd)=1;

 % display impulse train for 1000 samples on Graphics Panel 5
    reset(graphicPanel5);
    axes(graphicPanel5);
    plot(0:1000,imp_train(1:1001),'r','LineWidth',2);
    xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
    xlabel(xpp),ylabel('Value'),axis tight, grid on; legend('Periodic Impulses');
    
% generate excitation pulses using Rosenberg pulse
    pulse_train=conv(g,imp_train);
    
% display glottal pulse train for 1000 samples on Graphics Panel 4
    reset(graphicPanel4);
    axes(graphicPanel4);
    plot(0:1000,pulse_train(1:1001),'b','LineWidth',2);
    xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
    xlabel(xpp),ylabel('Value'),axis tight, grid on; legend('Glottal Pulses');

% load vowel info (formants and bandwidths)
% load 'vowels_fmts_bw.mat'
    str=load('vowels_fmts_bw.mat');
    vowels=str.vowels;
    formants=str.formants;
    bandwidths=str.bandwidths;
    
% generate vowel impulse response
    fmts=formants(ivowel,:);
    fmts=[fmts 4500];
    yout=vowel_ir(fmts,bandwidths,fsd);
    
% convolve vowel impulse response with excitation
    zout=conv(yout,pulse_train);

% display periodic vowel sequence for 1000 samples on Graphics Panel 3
    reset(graphicPanel3);
    axes(graphicPanel3);
    plot(0:1000,zout(1:1001),'k','LineWidth',2);
    xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
    xlabel(xpp),ylabel('Value'),axis tight, grid on; 

    xleg=['Vowel Response:',vowels(ivowel,:),'  Period:',num2str(period)];
    legend(xleg);
    end

% Callback for button5 -- Play Periodic Impulses
    function button5Callback(h,eventdata)
    soundsc(imp_train,fsd);
    end

% Callback for button6 -- Play Glottal Pulses
    function button6Callback(h,eventdata)
    soundsc(pulse_train,fsd);
    end

% Callback for button7 -- Play Vowel Excited by Glottal Pulses
    function button7Callback(h,eventdata)
    soundsc(zout,fsd);
    end

% Callback for button8 -- close GUI
 function button8Callback(h,eventdata)
     close(gcf);
 end
end