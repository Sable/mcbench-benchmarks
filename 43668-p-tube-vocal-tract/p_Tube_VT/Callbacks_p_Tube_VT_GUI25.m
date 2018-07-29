function Callbacks_p_Tube_VT_GUI25(f,C)
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
rG=0.7; rL=0.7;
fs=10000; ls=1.75;
fno=1;
% area=ones(1,10);
c=35000;
nfft=4000;
p=10;
ipd=100;
fileout='out_p_tube';
sliderpos1=0.7;
sliderpos2=0.7;
filename='area_1';
source='figure5.40';
seq_length=4001;

% Name the GUI
    set(f,'Name','p_Tube_VT_GUI');

% CALLBACKS
% Callback for button1 -- mat file with areas and other parameters

set_slider_pos()

 function button1Callback(h,eventdata)
     fno=get(button1,'val');
     set(button6,'val',(rG+1)/2);
     set(button7,'val',(rL+1)/2);
 end

% Callback for button2 -- read in sampling rate, fs, of vocal tract
% synthesis
 function button2Callback(h,eventdata)
     fs=str2num(get(button2,'string'));
 end

% Callback for button3 -- report length of each uniform tube, ls
 function button3Callback(h,eventdata)
     ls=str2num(get(button3,'string'));
 end

% Callback for button4 -- glottal reflection coefficient, rG, edit button
 function button4Callback(h,eventdata)
     set(button4,'string',num2str(sliderpos1));
     rG=sliderpos1;
 end

% Callback for button5 -- lips reflection coefficient, rL, edit button
 function button5Callback(h,eventdata)
     set(button5,'string',num2str(sliderpos2));
     rL=sliderpos2;
 end

% Callback for button6 -- rG slider (range of -1 to +1) edit button
 function button6Callback(h,eventdata)
     sliderpos1=get(button6,'val')*2-1;
     button4Callback(h,eventdata);
 end

% Callback for button7 -- rL slider  (range of -1 to +1) edit button
 function button7Callback(h,eventdata)
     sliderpos2=get(button7,'val')*2-1;
     button5Callback(h,eventdata);
 end

% Callback for button8 -- name of output text file, fileout, for saving
% p-tube vocal tract resonances
 function button8Callback(h,eventdata)
     fileout=get(button8,'string');
 end

% Callback for button11 -- ipd:  pitch period in samples
    function button11Callback(h,eventdata)
        ipd=num2str(get(button11,'string'));
    end

% Callback for button9 -- run the p-tube VT model code
 function button9Callback(h,eventdata)
     
% send message to change either rG or rL to be less than 1 for realistic
% vowel sound
    if (rG == 1 & rL == 1)
    uiwait(msgbox('change rG or rL to be less than 1 for correct vowel sound',...
        'set rG, rL','modal'));
    end


% read in source file for areas and other parameters
     clear area;
     filename=['area_',num2str(fno),'.mat'];
     areas=load(filename);
     
% extract p-tube vocal tract information from areas structure, including the
% p-tube areas, areas.area. the source of the area data, areas.source, 
% the number of tubes, areas.p, the size of fft for synthesis, 
% areas.nfft, the sampling rate of the simulation, areas.fs, the
% speed of sound in cm/sec, areas.c, and the length of each of the
% p-uniform tubes, areas.ls
     area=areas.area;
     source=areas.source;
     p=areas.p;
     nfft=areas.nfft;
     fs=areas.fs;
     c=areas.c;
     ls=areas.ls;
     
% update buttons for fs and ls by writing the values obtained above into
% the appropriate edit buttons (button2 and button3)
    set(button2,'string',num2str(fs));
    set(button3,'string',num2str(ls));
     
% open text file for saving vocal tract resonance information
    fid=fopen(fileout,'wt');
    
% create input for plotting vocal tract area function across p sections
    yc=[area(1) area(1) area(1)];
    xc=[0 1 1 1 1];
    for index=2:p-1
        yc=[yc area(index) area(index) area(index) area(index)];
        xc=[xc index index index index];
    end
    yc=[yc area(p) area(p) area(p)];
    xc=[xc p];
    
% plot vocal tract area function in Graphics Panel 1
    grid off;
    reset(graphicPanel1);
    axes(graphicPanel1);
    
% plot p-tube area function
    amax=max(yc);
    plot(xc,yc,'b','LineWidth',2);
    hold on,plot(xc,-yc,'b','LineWidth',2);
    plot([0 p],[0 0],'r--','LineWidth',2);
    axis ([0 p -amax*1.1 amax*1.1]);
    xlabel('Distance from Glottis');
    ylabel('Area(square cm)');
    stitle=sprintf(' source: %s, p: %d, ls: %6.2f',source,p,ls);
    
% set title in titleBox1; adjust font size to 20
    stitle1=strcat('p-Tube Vocal Tract -- ',stitle);
    set(titleBox1,'String',stitle1);
    set(titleBox1,'FontSize',20);

% transform from vocal tract areas areas(1:p-1) to reflection coefficients,
% k(1:p-1)
    clear k;
    k(1:p-1)=(-area(2:p)+area(1:p-1))./(area(2:p)+area(1:p-1));
    r(1:p-1)=-k(1:p-1);
    k=[rG -r rL];
    
% plot set of reflection coefficients on Graphics Panel 2
    reset(graphicPanel2);
    axes(graphicPanel2);
    stem(0:p,k,'r','LineWidth',2);
    axis([0 p -1 1]);
    xlabel('Distance from Glottis'); ylabel('Reflection Coefficients');
    
% print out (to ascii text file) the set of reflection coefficients and areas
    fprintf(fid,'areas-to-spectrum using p: %d, nfft: %d,',p,nfft);
    fprintf(fid,' fs: %d \n',fs);
    for index=1:p-1
        fprintf(fid,'index: %d, k:%6.4f,',index,k(index));
        fprintf(fid,' areas:%6.3f, %6.3f \n',area(index+1),area(index));
    end
    
%
% solve nodal equations for the p tubes
%
% matrix1 columns are uG, u1+, u2+, ..., up+, u(p+1)+
% matrix1 rows are n=0,1,2,...,NL
% matrix2 columns are u1-, u2-, ...,up-
% matrix2 rows are n=1,2,...,NL+1
%
    NL=3000; % number of time slots for solution
    
% initialize nodal equations
    uplus=zeros(p+2,NL+1);
    uminus=zeros(p,NL+1);
    uplus(1:2,1)=[1,(1+rG)/2];

% solve nodal equations for NL iterations
    for n=1:NL
        uminus(p,n+1)=-rL*uplus(p+1,n);
        for node=p-1:-1:1
            uminus(node,n+1)=-r(node)*uplus(node+1,n)+...
                (1-r(node))*uminus(node+1,n+1);
        end
        uplus(2,n+1)=uminus(1,n+1)*rG;
        for node=3:p+1
            uplus(node,n+1)=uplus(node-1,n)*(1+r(node-2))+...
                uminus(node-1,n+1)*r(node-2);
        end
        uplus(p+2,n+1)=(1+rL)*uplus(p+1,n);
    end
    
% save output as vocal tract impulse response
    h(1:NL+1)=uplus(p+2,1:NL+1);
    
% truncate impulse response to nl=500 samples
    nl=500;
    nir=0:nl-1;
    
% plot resulting vocal tract impulse response in Figure 3
    reset(graphicPanel3);
    axes(graphicPanel3);
    
    plot(nir,h(1:nl),'b','LineWidth',2);
    xpp=['Time in Samples;  fs=',num2str(fs),' samples/second'];
    xlabel(xpp),ylabel('Amplitude');
    grid on, axis tight;
    s1=sprintf('source: %s, p: %d,',source,p);
    s2=sprintf(' rG,rL: %6.3f, %6.3f, fs:%6.1f',rG,rL,fs);
    stitle=strcat(s1,s2);
    legend('Vocal Tract Impulse Response');
    
% transform to spectral domain and plot log magnitude response
    h=[h, zeros(1,nfft-NL-1)];
            
% convert to log magnitude spectrum
    hs=fft(h,nfft);
    spectrum(1:nfft/2+1)=20*log10(1.e-1+abs(hs(1:nfft/2+1)));
    vmin=min(spectrum);
    vmax=max(spectrum);
    
% plot log magnitude spectrum in graphics Panel 4
    reset(graphicPanel4);
    axes(graphicPanel4);
    
    freq=0:fs/nfft:fs/2;
    npts=nfft/2+1;
    plot(freq(1:npts),spectrum(1:npts),'g','LineWidth',2); grid;
    xlabel('Frequency(kHz)'); ylabel('Log Magnitude(dB)');
    axis([freq(1) freq(npts) vmin-2 vmax+2]);
    hold on;
    
% find formant locations and include on plot
    fmt=[];
    loc=[];
    nfmt=0;
    for index=10:npts-2
        if (spectrum(index+1) > spectrum(index) && ...
                spectrum(index+1) > spectrum(index+2))
            fmt=[fmt freq(index+1)];
            loc=[loc index];
            nfmt=nfmt+1;
        end
    end

% next estimate formant bandwidths
    bwlevel=6; % (db) range of bandwidth around formant peak
    if (nfmt <= 10)
        for nf=1:nfmt
            f=fmt(nf);
            index=loc(nf);
            peak=spectrum(index);
            [peakl,peakh]=findpeak(spectrum,index,peak,bwlevel);
            fr(nf)=f;
            bw(nf)=freq(peakh)-freq(peakl);
        end
    else
        peakspectrum=max(spectrum);
        nfe=1;
        for nf=1:nfmt
            f=fmt(nf);
            index=loc(nf);
            peak=spectrum(index);
            if (peak >= peakspectrum-20)
                fr(nfe)=f;
                bw(nfe)=0;
                fmt(nfe)=f;
                nfe=nfe+1;
            end
        end
        nfmt=nfe-1;
    end
    
% print out results to output text file
    fprintf(fid,'p-tube model results: \n');
    fprintf(fid,'rL,rG: %4.1f %4.1f \n',rL,rG);
    for formant=1:nfmt
        fprintf(fid,'formant frequency: %6.1f,',fr(formant));
        fprintf(fid,' formant bandwidth: %6.1f \n',bw(formant));
    end
    fprintf(fid,'\n \n');
    
% print formant locations on plots
    for nf=1:nfmt
        frfmt=[fmt(nf) fmt(nf)];
        vrfmt=[vmin vmax];
        plot(frfmt,vrfmt,'r','LineWidth',2);
        string=strcat('fmt',int2str(nf),':',int2str(fmt(nf)));
        if (mod(nf,2) == 0)
            text(fmt(nf)-200,vmax*.9,string);
        else
            text(fmt(nf)-200,vmin*1.1,string);
        end
    end
    
% convolve p-tube impulse response with periodic pulse train of period ipd
% samples (default is 100 Hz fundamental at fs=10000 Hz), and play out resulting
% speech waveform -- note wierd sound for rG=rL=1 since impulse response
% never dies out with no loss
        ipd=str2num(get(button11,'string'));
                   if (ipd < 0)
            waitfor(errordlg('IPD must be positive'));
        end
        seq_length=40*ipd;  % sequence length in samples
        xin=zeros(1,seq_length);
        xin(1:ipd:seq_length)=1;
        yout=conv(xin,h);
        soundsc(yout,fs);
    
% close up printing file
    fclose('all');    
 end

% Callback for button10 -- close the GUI
 function button10Callback(h,eventdata)
     close(gcf);
 end

function set_slider_pos()
    set(button6,'val',rG+0.15); %when set at exactly rG, slider bar is at 0.4
    set(button7,'val',rL+0.15); %when set at exactly rL, slider bar is at 0.4
end
end