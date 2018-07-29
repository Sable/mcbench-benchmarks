function liveon
%Live sound analyser and voice coach © 
%©author: Lorincz Istvan
%note: Don't forget to disable all sound effects: Recording
%Devices=>Microphone Properties=>Enhancements=>Disable all sound effects
%CHECK

%fre-global variable that stores the dominant frequencies during streaming
global fre
fre=0;

%sampling rate. If you modify this don't forget to modify it @estimatef(x)
Fs = 20000;
%data acquisition initiation
AI = analoginput('winsound');
addchannel(AI,1);
set(AI,'SampleRate',Fs);
Fs = get(AI,'SampleRate');
duration = 0.03;
N = ceil(duration*Fs);


% Set samples per trigger.
set(AI,'SamplesPerTrigger',N);
% Set acquisition options.
set(AI,'TriggerType','Manual');
set(AI,'TriggerRepeat',1);
set(AI,'TimerPeriod',duration/4);
% Begin acquisition.
start(AI); 
trigger(AI);

% Process initial sound sample.
x = getdata(AI);
[X,spect] = estimatef(x);

%initialize data stream
initStream(AI,x,X,spect);

set(AI,'TimerFcn',@updateStream);


function [X,spect,xx] = estimatef(x)
Fs=20000;

%FILTER: Because of the filter you won't be able to analyze freq. above
%3000
%two filters are provided bb1-is for Fs=20.000 Hz and
%bb2 - is for Fs=44100Hz. Both filters are bandpass with 200Hz and 3200Hz
%as cut off freq.
%bb2=[-0.0118198702208293,-0.0110261118112533,-0.00953875386588919,...
%    -0.00754662283100208,-0.00531216343720672,-0.00314193665530427,...
%    -0.00135015204635622,-0.000219431654174084,3.64629583452341e-05,...
%    -0.000696770281545521,-0.00241416308616675,-0.00498544400058491,...
%    -0.00816423538820806,-0.0116121477364949,-0.0149356126260113,...
%    -0.0177316445958604,-0.0196374508134485,-0.0203780835235917,...
%    -0.0198062630374483,-0.0179291245900400,-0.0149179167167810,...
%    -0.0110984801136972,-0.00692247630763949,-0.00292158038313727,...
%    0.000351053872529409,0.00238605210551284,0.00278270932608029,...
%    0.00130609010682599,-0.00207058811622319,-0.00714392108694027,...
%    -0.0134822858381414,-0.0204529950761564,-0.0272731219678832,...
%    -0.0330798387143118,-0.0370138237481247,-0.0383076181496648,...
%    -0.0363699533390510,-0.0308571462033375,-0.0217236822198133,...
%    -0.00924599623650468,0.00598396708198956,0.0230958346592955,...
%    0.0410058389009456,0.0585042167383465,0.0743570108885342,...
%    0.0874127149862891,0.0967035666252910,0.101531689913520,...
%    0.101531689913520,0.0967035666252910,0.0874127149862891,...
%    0.0743570108885342,0.0585042167383465,0.0410058389009456,...
%    0.0230958346592955,0.00598396708198956,-0.00924599623650468,...
%    -0.0217236822198133,-0.0308571462033375,-0.0363699533390510,...
%    -0.0383076181496648,-0.0370138237481247,-0.0330798387143118,...
%    -0.0272731219678832,-0.0204529950761564,-0.0134822858381414,...
%   -0.00714392108694027,-0.00207058811622319,0.00130609010682599,...
%   0.00278270932608029,0.00238605210551284,0.000351053872529409,...
%   -0.00292158038313727,-0.00692247630763949,-0.0110984801136972,...
%    -0.0149179167167810,-0.0179291245900400,-0.0198062630374483,...
%    -0.0203780835235917,-0.0196374508134485,-0.0177316445958604,...
%    -0.0149356126260113,-0.0116121477364949,-0.00816423538820806,...
%    -0.00498544400058491,-0.00241416308616675,-0.000696770281545521,...
%    3.64629583452341e-05,-0.000219431654174084,-0.00135015204635622,...
%    -0.00314193665530427,-0.00531216343720672,-0.00754662283100208,...
%    -0.00953875386588919,-0.0110261118112533,-0.0118198702208293];

bb1=[-0.0162920552728471,-0.0118598164002612,-0.00371517416235967,...
    2.41262000671970e-05,-0.00534440888507741,-0.0161397171028928,...
    -0.0229544618184139,-0.0191934157195733,-0.00784548942075371,...
    0.000301286951378025,-0.00373336310818367,-0.0180995455433797,...
    -0.0305241330024763,-0.0289448918245746,-0.0133750539558794,...
    0.00235615570752758,0.00209571751385398,-0.0171116470614070,...
    -0.0398725908905499,-0.0442942613660926,-0.0222988676828442,...
    0.00952781158545338,0.0206203604375820,-0.00713420244618813,...
    -0.0583117793539729,-0.0880934169775466,-0.0527656325354938,...
    0.0544436632485507,0.190363548877518,0.284684406963428,...
    0.284684406963428,0.190363548877518,0.0544436632485507,...
    -0.0527656325354938,-0.0880934169775466,-0.0583117793539729,...
    -0.00713420244618813,0.0206203604375820,0.00952781158545338,...
    -0.0222988676828442,-0.0442942613660926,-0.0398725908905499,...
    -0.0171116470614070,0.00209571751385398,0.00235615570752758,...
    -0.0133750539558794,-0.0289448918245746,-0.0305241330024763,...
    -0.0180995455433797,-0.00373336310818367,0.000301286951378025,...
    -0.00784548942075371,-0.0191934157195733,-0.0229544618184139,...
    -0.0161397171028928,-0.00534440888507741,2.41262000671970e-05,...
    -0.00371517416235967,-0.0118598164002612,-0.0162920552728471];


%filtering
x=filter(bb1,1,x);
xx=x;
%zeropadding for a better frequency resolution
x(end+1:Fs)=0;

%geting the frequency spectrum
Y=abs(fft(x));
%Lreq=length(x);
%rez=Fs/Lreq;
spect=Y(1:length(x)/2-1);
%extracting dominant frquency
[ampl,freq1]=max(spect);
%here you can set the minimum amlpitude that triggers the voice coach
%def: 20
if ampl > 20
X=freq1*Fs/length(x);
else
    X=0;
end



 
  
function initStream(AI,x,X,spect)
%stream initializer

%voice coach window
figWindow = figure(1); clf;
set(gcf,'Name','Voice Coach');
set(gcf,'NumberTitle','off','MenuBar','none');
subplot(2,1,1);
fftPlot = plot(1:length(X),X);
hold on
%here you can set the reference frequencies
%default:[258;264;290;296;326;332;346;352;389;395;439;441;492;495;520;526]
%which covers C4-C5.
%Two frequencies define an interval for a note. So 16 frequencies => 8
%musical notes. You can find all the frequencies for the musical notes
%here: http://www.phy.mtu.edu/~suits/notefreqs.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=[258;264;290;296;326;332;346;352;389;395;439;441;492;495;520;526];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%length of reference lines is set by def to 5000, if you use it for a 
%longer time increase this value:
%%%%%%%%%%%%%%%
B=ones(1,5000);
%%%%%%%%%%%%%%%

C=(A*B)';
C4plot = plot(C);
hold off
title('Voice Coach');
xlabel('Time');
ylabel('Frequency (Hz)');

%here you can set the voice coach window limits 1 (don't forget
%updateStream)
xlim([0 2000]); ylim([0 800]);
grid on;

% Plot data window.
subplot(2,2,3);
samplePlot = plot(1:length(x),x);
title('Input Data');
xlabel('Sample Index');
ylabel('Input Voltage');
axis([0 length(x) -1 1]);
grid on;

% Plot Spectrum window.
subplot(2,2,4);
%if you change the resolution don't forget to modify the spectrum graph
%ticks
spectPlot = plot((0:length(spect)-1),spect);
title('Frequency Spectrum');
xlabel('Frequency');
ylabel('Amplitude');
%here you can the Sectrum window's limits
axis([0 3000 0 500]);
grid on;

% Create start/stop pushbutton.
uiButton = uicontrol('Style','pushbutton',...
   'Units', 'normalized',...
   'Position',[0.0150 0.0111 0.1 0.0556],...
   'Value',1,'String','Stop',...
   'Callback',@stopStream);

% Store variables in data field:
figData.figureWindow = figWindow;
figData.uiButton     = uiButton;
figData.samplePlot   = samplePlot;
figData.fftPlot      = fftPlot;
figData.C4plot       = C4plot;
figData.spectPlot    = spectPlot;
figData.AI           = AI;
set(gcf,'UserData',figData);
set(AI,'UserData',figData);


function x = updateStream(obj,event)
%where the live updaing happens

global fre 

figData = obj.userData;
x = peekdata(obj,obj.SamplesPerTrigger);
[X,spect,x]=estimatef(x);
fre(length(fre)+1)=X;

%Update Sample Plot display
set(figData.samplePlot,'YData',x); 
%Update Spectrum Plot display
set(figData.spectPlot,'YData',spect);
% Update voice coach display.
set(figData.fftPlot,'YData',fre,'LineWidth', 2);
set(figData.fftPlot,'XData',1:length(fre));
%here you can set the voice coach window limits 2
set(get(figData.fftPlot,'Parent'),'YLim',[0 800]);
set(get(figData.fftPlot,'Parent'),'XLim',[0 600]);
%moving the graph with the signal
if length(fre) > 300
set(get(figData.fftPlot,'Parent'),'XLim',[length(fre)-300 length(fre)+300]);
end


function stopStream(obj,event)

figData = get(gcbf,'UserData');
AI = figData.AI;
%Stop/start acquisition.
if isrunning(AI)
   stop(AI);
   set(figData.uiButton,'string','Restart');
else
   delete(AI);
   liveon;
end

  
  
  
  
  
  
  
  
  
  