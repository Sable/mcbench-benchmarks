global ai ps st hp pc paus frs datas highpass lowpass hhp hlp numerator_hp numerator_lp

%clear all previously not closed devices:
delete(daqfind);

% prepare device:
ai = analoginput('winsound');
chan = addchannel(ai,1);
Fs=44100;  % sampling frequency
dt=1/Fs;
set(ai,'SampleRate',Fs);
set(ai,'SamplesPerTrigger',Inf);

highpass=false;
lowpass=false;

load('numerator_hp.mat');
load('numerator_lp.mat');

fmin=60; % Hz
ps=round(Fs/fmin); % frames size

frs=4; % frames to skeep for speed

set(ai,'BufferingConfig',[ps 32]);
set(ai,'SamplesAcquiredFcn','piece_processing');
set(ai,'SamplesAcquiredFcnCount',ps);

hf=figure;
fcl=get(hf,'color');
ha=axes;
%set(ha,'position',[0.1300    0.1100    0.7750    0.8150]);
ysh=0.1;
set(ha,'position',[0.1300    0.1100+ysh    0.7750    0.8150-ysh]);
hp=plot((0:ps-1)*dt,zeros(1,ps),'b-');
xlabel('time,s');



h = uicontrol('Style', 'pushbutton', 'String', 'stop',...
    'units','normalized',...
    'Position', [0.92 0.012 0.08 0.06], 'Callback', 'stp');

h = uicontrol('Style', 'pushbutton', 'String', 'pause',...
    'units','normalized',...
    'Position', [0.83 0.012 0.08 0.06], 'Callback', 'pau');

hhp = uicontrol('Style', 'checkbox', 'String', 'high pass 400Hz',...
    'units','normalized',...
    'BackgroundColor',fcl,...
    'Position', [0.54 0.012 0.2 0.06], 'Callback', 'hpcb');

hlp = uicontrol('Style', 'checkbox', 'String', 'low pass 400Hz',...
    'units','normalized',...
    'BackgroundColor',fcl,...
    'Position', [0.32 0.012 0.2 0.06], 'Callback', 'lpcb');

set(hf,'MenuBar','figure','ToolBar','figure');

pc=1; % pieces counter
st=false; % stop flag
paus=false; % pause flag
%datas=zeros(2*ps,1); % two last data vectors
datas=zeros(3*ps,1);
start(ai); % star device



