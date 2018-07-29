function y = sfg(type,t,ff,f0,f1,ana)
%function sfg:SimpleFunctionGenerator
%generate function signal of sin,square&duty,iso triangle,sweep
%attention: this function is simple function generator ,
%     so it is not accurate .
%arguments
%type:wave style
%   case 'sin':sin wave generate
%   case 'sq':square wave (duty 50%) generate
%   case 'du':duty square generate
%   case 'tr':iso triangle wave generate
%   case 'sa':sawtooth wave generate
%   case 'sw':sweep wave generate
%   case 'demo':all wave style demo,
%               plot wave form and fft magnitude.
%t:time vector ex: [t0:ts:t1]
%  t0:start time, ts:time step(sampling time), t1:end time            
%ff:fundamental frequency
%f0:duty ratio of square wave
%f0:initial frequency of sweep wave
%f1:end target frequency of sweep wave
%ana:wave analyze mode,plot wave graph 
%    and frequency spectrum(fft result) about all wave style
%    if ana is 1 then plot graph.
%
%output'y':function wave output
%   sfg example
%   ex 1: sin wave without plot
%     t=0:0.01:10;                   % time range= 0 to 10sec
%                                     ,time step = 0.01sec
%     ff=2;                          % fundamental frequancy(Hz)
%     y=sfg('sin',t,ff);             % sin wave 
%   ex 2: sin wave with plot
%     t=0:0.01:10;                   % time range= 0 to 10sec
%                                     ,time step = 0.01sec
%     ff=2;                          % fundamental frequancy(Hz)
%     y=sfg('sin',t,ff,0,0,1);       % sin wave 
%                                      arg4 & arg5 is dummy data
%   ex 3: duty square  wave with plot
%     t=0:0.01:10;                   % time range= 0 to 10sec
%                                     ,time step = 0.01sec
%     ff=2;                          % fundamental frequancy(Hz)
%     duty=70;                       % duty ratio(%) 0<duty<100
%     y=sfg('du',t,ff,duty,0,1);  % duty square wave 
%                                      arg4 & arg5 is dummy data
%   ex 4: sweep wave without plot
%     t=0:0.01:10;                   % time range= 0 to 10sec
%                                     ,time step = 0.01sec
%     ft=2;                          % sweep target frequency(Hz)
%     f0=1;                          % start frequency(Hz)
%     f1=10;                         % target end frequency(Hz)
%     duty=70;                       % duty ratio(%) 0<duty<100
%     y=sfg('sw',t,ft,f0,f1);        % duty square wave 
%                                     

%   Author(s): Hiroyuki Kato
%   Kato-Yosetsu-Kogyo,inc. in Aichi,Japan.
%   $Revision: 1.0 (First release) $  $Date: 2013/09/12 18:35$

if nargin==1 &&  ~strcmp(type,'demo'),error('invalid argument');end
if ~strcmp(type,'demo') && nargin==2 ,error('invalid argument');end
if nargin<6, ana=0; end
if nargin<5, f1=0; end
if nargin<4, f0=0; end
if nargin<3, ff=0; end
    
switch type
    case 'sin'
        %sin wave
        y = sin(2*pi*ff*t);
        if ana==1,plotana(t,y);end
    
    case 'sq'
        %square wave
        y = sqg(t,ff);
        if ana==1,plotana(t,y);end

    case 'du'
        %duty wave
        if nargin==3, f0=50;end
        y = dug(t,ff,f0);
        if ana==1,plotana(t,y);end
        
    case 'tr'
        %triangle        
        y = trg(t,ff);
        if ana==1,plotana(t,y);end

    case 'sa'
        %sawtooth
        y = sag(t,ff);
        if ana==1,plotana(t,y);end
        
    case 'sw'
        %sweep
        if nargin<=4,error('invalid argument');end
        y = swg(t,ff,f0,f1);
        if ana==1,plotana(t,y);end

    case 'demo'
                tt=(0:4*1/2^8:4-4*1/2^8);
                fff=1/2;
                ff00=70;
                ff01=1;
                ff1=10;
                
                y1 = sin(2*pi*fff*tt);
                y2 = sqg(tt,fff);
                y3 = dug(tt,fff,ff00);
                y4 = trg(tt,fff);
                y5 = sag(tt,fff);
                y6 = swg(tt,fff,ff01,ff1);
                
                
                figure

                subplot 231
                                
                plot(tt,y1,'LineWidth',2)
                ylim([-1.1 1.1])
                grid on
                title({'sin wave';' sfg(''sin'',[0:4*1/256:4-4*1/256],1/2)'});
                xlabel('time (sec)')
                ylabel('Amplitude')

              
                subplot 234
                [f sp1]=ffft(tt,y1);
                stem(f,sp1)
                xlim([0 fff*10])
                grid on
                title({'sin wave';'Amplitude Spectrum of y(t)'})
                xlabel('Frequency (Hz)')
                ylabel('|Y(f)|')

                
                subplot 232
                plot(tt,y2,'LineWidth',2)
                ylim([-1.1 1.1])
                grid on
                title({'square wave';' sfg(''sq'',[0:4*1/256:4-4*1/256],1/2)'});
                xlabel('time (sec)')
                
                subplot 235
                [f sp1]=ffft(tt,y2);
                stem(f,sp1)
                xlim([0 fff*20])
                title({'square wave';'Amplitude Spectrum of y(t)'})
                xlabel('Frequency (Hz)')
                grid on
                
                subplot 233
                plot(tt,y3,'LineWidth',2)
                ylim([-1.1 1.1])
                xlabel('time (sec)')
                title({'duty square wave';' sfg(''du'',[0:4*1/256:4-4*1/256],1/2,70)'});
                grid on
              
                subplot 236
                [f sp1]=ffft(tt,y3);
                stem(f,sp1)
                xlim([0 fff*20])
                title({'duty square wave';'Amplitude Spectrum of y(t)'})
                xlabel('Frequency (Hz)')
                grid on
                
                
                figure

                subplot 231
                                
                plot(tt,y4,'LineWidth',2)
                ylim([-1.1 1.1])
                grid on
                title({'iso triangle wave';' sfg(''tr'',[0:4*1/256:4-4*1/256],1/2)'});
                xlabel('time (sec)')
                ylabel('Amplitude')

              
                subplot 234
                [f sp1]=ffft(tt,y4);
                stem(f,sp1)
                xlim([0 fff*10])
                grid on
                title({'iso triangle wave';'Amplitude Spectrum of y(t)'})
                xlabel('Frequency (Hz)')
                ylabel('|Y(f)|')

                
                subplot 232
                plot(tt,y5,'LineWidth',2)
                ylim([-1.1 1.1])
                grid on
                title({'saw wave';' sfg(''sa'',[0:4*1/256:4-4*1/256],1/2)'});
                xlabel('time (sec)')
                
                subplot 235
                [f sp1]=ffft(tt,y5);
                stem(f,sp1)
                xlim([0 fff*20])
                title({'saw wave';'Amplitude Spectrum of y(t)'})
                xlabel('Frequency (Hz)')
                grid on
                
                subplot 233
                plot(tt,y6,'LineWidth',2)
                ylim([-1.1 1.1])
                xlabel('time (sec)')
                title({'sweep wave';' sfg(''du'',[0:4*1/256:4-4*1/256],1/2,70)'});
                grid on
              
                subplot 236
                [f sp1]=ffft(tt,y6);
                stem(f,sp1)
                xlim([0 ff1*3])
                title({'sweep wave';'Amplitude Spectrum of y(t)'})
                xlabel('Frequency (Hz)')
                grid on
                
                y=0;%dummy output
        
end
end

    function y = sqg(t,ff)
            %square wave
            y = 2*gt(sin(2*pi*ff*t),0)-1;
    end

    function y = dug(t,ff,f0)
            %duty wave
            y = 2*lt(mod(t,1/ff)*ff,f0/100)-1;
    end

    function y = trg(t,ff)
            %triangle 
           aa=lt(mod(t,1/ff)*ff,0.5);
           bb(aa==1)=mod(t(aa==1),1/ff)*ff;
           bb(aa~=1)=-mod(t(aa~=1),1/ff)*ff+1;
           y = 4*bb-1;
    end

           

    function y= sag(t,ff)
            %sawtooth
            y = 2*mod(t,1/ff)*ff-1;
    end
    
    function y =swg(t,ff,f0,f1)
            w   = (f1-f0).*(ff).*mod(t,1/ff);
            y = sin(2*pi*(w./2+f0).*mod(t,1/ff));
    end

    function [f sp] = ffft(t,sig)
            L=length(t);
            Fs=1/(t(2)-t(1));
            NFFT = 2^nextpow2(L);
            Y = fft(sig,NFFT)/L;
            f = Fs/2*linspace(0,1,NFFT/2);
            sp = 2*abs(Y(1:NFFT/2));

    end

    function plotana(t,y)
    [f sp] = ffft(t,y);
    figure
    subplot 211
    plot(t,y,'LineWidth',2)
    grid on
    ylim([-1.1 1.1])
    xlabel('time (sec)')
    ylabel('Amplitude')
    title({'sfg execution plot and fft'});
    grid on
    
    subplot 212
    stem(f,sp)
    xlabel('Frequency (Hz)')
    ylabel('magnitude')
    grid on
               
    end
              
    
