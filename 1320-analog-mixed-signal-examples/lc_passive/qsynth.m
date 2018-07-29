function [Out1,Out2]=qsynth(Action,In1,In2)
% Dick Benson 
% Design single terminated elliptic passive LC low pass filters.
% Copyright 2001-2013 The MathWorks, Inc.
% [L,C] = qsynth('getLC');

    if nargin ==0
       Action = 'init';
    end;   

    if ~strcmp(Action,'init')
      Hqsynth_ = get(gcf,'userdata');
    end

    % handle index definitions
    i_f1      = 1;
    i_topology   = 2;
    i_order   = 3;
    i_synthpb = 4;
    i_ripl    = 5;
    i_ripv    = 6;
    i_stopl   = 7;
    i_stopv   = 8;
    i_ax1     = 9;
    i_pl1     = 10;
    i_pl2     = 11;
    i_fcl     = 12;
    i_fcv     = 13;
    i_lv      = 14;
    i_cv      = 15;
    i_lcl     = 16;
    i_testpb  = 17;
    
    if strcmp(Action,'init')
               
        Hqsynth_(i_f1)= figure('Color',[0 0 0] ,'Name','Qsynth: Single Terminated Ladder Elliptic Filter',... 
                          'Position',[20 20 640 440],...
                          'Resize','off',...
                          'Color',[0 0 1],...
                          'NumberTitle','off','visible','on');
                          % ###### userdata contains vector of handles if desired
        
        Hqsynth_(i_topology)=uicontrol('Style','popup','visible','on',...
                                    'String','RIN=1,RL=inf|RIN=0,RL=1',...
                                    'Position',[10 400 105 20],...
                                    'BackgroundColor',[0 0 0],...
                                    'ForeGroundColor',[0 1 1],...
                                    'Value',1,...
                                    'callback','qsynth(''clear'')',...
                                    'HorizontalAlignment','Left');  
        
        Hqsynth_(i_order)=uicontrol('Style','popup','visible','on',...
                                'String','Order:3|Order:5|Order:7|Order:9|Order:11',...
                                'Position',[10 380 105 20],...
                                'BackgroundColor',[0 0 0],...
                                'ForeGroundColor',[0 1 1],...
                                'Value',4,...
                                'HorizontalAlignment','Left');  
        
        Hqsynth_(i_ripl) =  uicontrol('Style','text','visible','on',...
                                'String','Ripple (dB):',...
                                'Position',[10,355,60,18],...
                                'BackGroundColor',[1 1 1]*0.8,...
                                'ForeGroundColor',[0 0 0],...
                                'HorizontalAlignment','left'); 
                               
         
         Hqsynth_(i_ripv) = uicontrol('Style','edit','visible','on',...
                                'Position',[70,355,45,18],...
                                'String','1',...
                                'BackgroundColor',[1 1 0],...
                                'ForeGroundColor',[0 0 0],...
                                'HorizontalAlignment','center',...
                                'Max',1);

        
         Hqsynth_(i_stopl) =  uicontrol('Style','text','visible','on',...
                                'String','Stop (dB):',...
                                'Position',[10,330,60,18],...
                                'BackGroundColor',[1 1 1]*0.8,...
                                'ForeGroundColor',[0 0 0],...
                                'HorizontalAlignment','left'); 
                               
         
         Hqsynth_(i_stopv) = uicontrol('Style','edit','visible','on',...
                                'Position',[70,330,45,18],...
                                'String','60',...
                                'BackgroundColor',[1 1 0],...
                                'ForeGroundColor',[0 0 0],...
                                'HorizontalAlignment','center',...
                                'Max',1);
                                
         Hqsynth_(i_fcl) =  uicontrol('Style','text','visible','on',...
                                'String','Cutoff (Hz):',...
                                'Position',[10,305,60,18],...
                                'BackGroundColor',[1 1 1]*0.8,...
                                'ForeGroundColor',[0 0 0],...
                                'HorizontalAlignment','left'); 
                               
         
         Hqsynth_(i_fcv) = uicontrol('Style','edit','visible','on',...
                                'Position',[70,305,45,18],...
                                'String','1.0e6',...
                                'BackgroundColor',[1 1 0],...
                                'ForeGroundColor',[0 0 0],...
                                'HorizontalAlignment','center',...
                                'Max',1);
                                
          Hqsynth_(i_lcl) =  uicontrol('Style','text','visible','on',...
                                'String','              L                         C',...
                                'Position',[10,280,165,18],...
                                'BackGroundColor',[1 1 1]*0.8,...
                                'ForeGroundColor',[0 0 0],...
                                'HorizontalAlignment','left');                                 
      
        Hqsynth_(i_lv)  =  uicontrol('Style','edit','visible','on',...
                                'Position',[10,35,85,240],...   % was 80
                                'String','',...
                                'BackgroundColor',[1 1 0],...
                                'ForeGroundColor',[0 0 0],...
                                'HorizontalAlignment','left',...
                                'Max',14); 
                                
        Hqsynth_(i_cv)  =  uicontrol('Style','edit','visible','on',...
                                'Position',[100,35,85,240],...  % was 95,35,80
                                'String','',...
                                'BackgroundColor',[1 1 0],...
                                'ForeGroundColor',[0 0 0],...
                                'HorizontalAlignment','left',...
                                'Max',14);                        
                                
                                
        Hqsynth_(i_ax1)=axes('Units','pixels','Position',[240,80,370,300],... 
                                'Box','on',...
                                'visible','on',...
                                'NextPlot','add',...
                                'DrawMode','fast',...           
                                'Color',[0 0 0],...
                                'TickDir','out',...
                                'YlimMode','auto',...
                                'XlimMode','auto',...
                                'Xcolor',[1 1 1],...    
                                'Ycolor',[1 1 1],...
                                'FontSize',12);
                                
        title('Singly Terminated Elliptic Filter ','color',[1 1 1],'fontsize',9);
        xlabel('Frequency in Hz','fontsize',9);
        ylabel('Magnitude in dB','fontsize',9)
        
        Hqsynth_(i_pl1) = plot(Hqsynth_(i_ax1),0,0,'clipping','on',...
                                  'Color',[0 1 0],...
                                  'erasemode','xor','visible','on');
        
        Hqsynth_(i_pl2) = plot(Hqsynth_(i_ax1),0,0,'clipping','on',...
                                  'Color',[1 0 0],...
                                  'erasemode','xor','visible','on');
        
        Hqsynth_(i_synthpb) = uicontrol('Style','Pushbutton',...
                              'Position',[10,10,105,20],...
                              'String','Synthesize',...
                              'Callback','qsynth(''synth'');');

        Hqsynth_(i_testpb) = uicontrol('Style','Pushbutton',...
                              'Position',[120,10,105,20],...
                              'String','Test',...
                              'Callback','qsynth(''test'');');

    
        set(Hqsynth_(i_f1),'userdata',Hqsynth_);
        zoom on
    
    elseif strcmp(Action,'synth')
       fmtstr = '%8.5g';
    
       n  = get(Hqsynth_(i_order),'value')*2+1;          % only odd orders supported 
       rp = str2num(get(Hqsynth_(i_ripv),'string'));
       rs = str2num(get(Hqsynth_(i_stopv),'string'));
       wn = 2*pi*str2num(get(Hqsynth_(i_fcv),'string'));
       
       [b,a]=ellip(n,rp,rs,wn,'s');
       save lpf_coefs b a
       w = 0:(wn/25):10*wn;
       h = freqs(b,a,w);
    
       
       set(Hqsynth_(i_ax1),'Ylim',[-rs-20,5],'Xlim',[0,10*wn/(2*pi)]);
       set(Hqsynth_(i_pl1),'xdata',w/(2*pi),'ydata',20*log10(h));
       
       topology = get(Hqsynth_(i_topology),'value');
       if topology ==1
          %  Rin = 1, Rl = inf , Vsource with 1 ohm Z0, no load 
          % must be odd order
          m     = b(2:length(b));
          zeros = roots(m);
          m2 = [];
          n2 = [];
          for i=1:length(a)  
              if rem(i,2)
                 n2=[n2,a(i),0];
              else
                 m2=[m2,a(i),0];
              end;
          end;
          m2=m2(1:(length(m2)-1));
          
          % remove admittance pole @ s=inf
          % z=m2/n2  y = n2/m2 yp = n2/m2-c1s
          
          C(1) = n2(1)/m2(1);  % shunt capacitor
          n2 = n2 - conv(m2,[C(1),0]);
          % now it gets tricky ....
          for i = 1:(n-1)/2
              % need an xmission zero @ w=wx
              wx = j*abs(zeros(2*i)); % pick an xmission zero....
              % do a partial removal of the impedance pole @ inf
              % first evaluate impedance @ w=wx
              zmag = polyval(m2,wx)/polyval(n2,wx);
              L(2*i) = zmag/wx;
              
              if i==1
                 n2=n2(3:length(n2));
              end;
              % this partially removes the pole
              m2 = m2-conv(n2,[L(2*i),0]);
              
              % now remaining admittance has a pole at w=wx
              % remove it by shunting a series LC
              
              % first must determine L & C values
              [q,r1]= deconv(m2,[1 0 abs(wx)^2]);  % r should be zero
              k    = n2(1);
              n2p  = n2/k;
              n2p  = n2p(1:length(n2p)-1);
              L(2*i+1)=1/(k*(polyval(n2p,wx)/polyval(q,wx)));
              C(2*i+1)= 1/(L(2*i+1)*(abs(wx)^2));

              % then remove the addmittance.... not obvious! 
              [n2pp,r2] = deconv(( n2p-q/(k*L(2*i+1)) )*k,[1 0 1/(C(2*i+1)*L(2*i+1))]);
              n2 = conv(n2pp,[1 0]);
              m2 = q;
          end;
          L=L';
          C=C';

      
       elseif topology==2
          % Rin=0, Rl=1 (Vsource input, 1 ohm load)
          % 
          m     = b(2:length(b)); % drop leading 0.0 term
          zeros = roots(m);       % 
          m2 = [];
          n2 = [];
          for i=1:length(a)  
              if rem(i,2)
                 n2=[n2,a(i),0];
              else
                 m2=[m2,a(i),0];
              end;
          end;
         
          m2=m2(1:(length(m2)-1));
          for i = 1:(n-1)/2
              % need an xmission zero @ w=wx
              wx = j*abs(zeros(2*i)); % pick an xmission zero....

              % do a partial removal of the impedance pole @ inf
              % first evaluate impedance @ w=wx
              zmag = polyval(n2,wx)/polyval(m2,wx);
              L(2*i-1) = zmag/wx;
              % this partially removes the pole

              n2 = n2-conv(m2,[L(2*i-1),0]);
              % now remaining admittance has a pole at w=wx

              % remove it by shunting a series LC
              % first must determine L & C values
              [q,r1] = deconv(n2,[1 0 abs(wx)^2]);  % r should be zero
              k = polyval(m2,wx)/polyval(conv(q,[1 0]),wx);
              L(2*i) = 1/k;
              C(2*i) = 1/(L(2*i)*(abs(wx)^2));
              [p,r2] = deconv( m2-k*conv(q,[1 0])   ,  [1 0 abs(wx)^2]);
              m2=p;
              n2=q;
          end;
          L(n)= n2(1)/m2;     % final series L .... amazing .... absolutly amazing! 
          L = fliplr(L)';     % need to reverse this network  
          C = [0,fliplr(C)]'; % 
          
       end;
       set(Hqsynth_(i_ripl),'userdata',L);
       set(Hqsynth_(i_ripv),'userdata',C);
       
       s='';
       for i=1:(length(L)-1)
           s=[s,sprintf([fmtstr,'\n'],L(i))];
       end;
       s=[s,sprintf(fmtstr,L(length(L)))];
       set(Hqsynth_(i_lv),'string',s);
       s='';
       for i=1:(length(C)-1)
           s=[s,sprintf([fmtstr,'\n'],C(i))];
       end;
       s=[s,sprintf(fmtstr,C(length(C)))];
       set(Hqsynth_(i_cv),'string',s);
    
    elseif strcmp(Action,'getLC');
      % Out1 = get(Hqsynth_(i_ripl),'userdata'); % inductors
      % Out2 = get(Hqsynth_(i_ripv),'userdata'); % capacitors
      % huh? ,  should get it from strings in edit fields
       caps = get(Hqsynth_(i_cv),'string'); 
       inds = get(Hqsynth_(i_lv),'string'); 
 
       for i=1:length(caps(:,1))
          Out2(i) = str2num(caps(i,:));
       end;
       
       for i=1:length(inds(:,1))
          Out1(i) = str2num(inds(i,:));
       end;
    
    
    elseif strcmp(Action,'test')
       topology = get(Hqsynth_(i_topology),'value');   % network topology
       wn = 2*pi*str2num(get(Hqsynth_(i_fcv),'string'));
       w  = 0:(wn/25):10*wn;
       [L,C]=qsynth('getLC');
       if topology ==1
          % test the synthesis 
          % begin with source resistor 
          [a,b,c,d,q]=pabcd([],[],[],[],[],'rs',1);
          % then the shunt capacitor
          [a,b,c,d,q]=pabcd(a,b,c,d,q,'cp',C(1)); 
          for i = 1:(length(L)-1)/2
              % series L
              [a,b,c,d,q]=pabcd(a,b,c,d,q,'ls',L((i*2)));
              % shunt series LC
              [a,b,c,d,q]=pabcd(a,b,c,d,q,'lcs',L((i*2)+1),C((i*2)+1));
          end;
          
       elseif topology ==2
          a = []; b = []; c = []; d = []; q = [];
          for i = 1:(length(L)-1)/2
              % series L
              [a,b,c,d,q]=pabcd(a,b,c,d,q,'ls',L((i*2-1)));
              % shunt series LC
              [a,b,c,d,q]=pabcd(a,b,c,d,q,'lcs',L((i*2)),C((i*2)));
          end;
          % finish with a series L
          [a,b,c,d,q]=pabcd(a,b,c,d,q,'ls',L(length(L)));
          % and a 1 ohm shunt R load resistor
          [a,b,c,d,q]=pabcd(a,b,c,d,q,'rp',1);
       end;
       
       % [mag,phase]   =   bode(q,a,w);
       h = freqs(q,a,w);
       set(Hqsynth_(i_pl2),'xdata',w/(2*pi),'ydata',20*log10(h));
       
       
    elseif strcmp(Action,'clear')
       set(Hqsynth_(i_ripl),'userdata',[]);
       set(Hqsynth_(i_ripv),'userdata',[]);
       set(Hqsynth_(i_cv),'string','');
       set(Hqsynth_(i_lv),'string','');
       set(Hqsynth_(i_pl2),'xdata',[],'ydata',[]);
       set(Hqsynth_(i_pl1),'xdata',[],'ydata',[]);
       
    else
       disp([Action,' not reconized in qsynth'])
    end;
    

% end qsynth

function [aout,bout,cout,dout,qout]=pabcd(ain,bin,cin,din,qin,element,val1,val2,val3)
% [aout,bout,cout,dout,qout]=pabcd(ain,bin,cin,din,qin,element,val1,val2)
% Uses chain matrix parameters to cascades abcd with denominator q (in) 
% with an element that has val1 (val2 for LC). 
% Useful for computing functions & parameters of ladder networks. 
% element code   description   
%     rs       = series resistor
%     lcs      = shunt series lc val1=l val2=c
%     ls       = series l
%     cp       = shunt c
%     rp       = shunt r
%     lcp      = series chunt lc val1=l val2=c val3 = r (in series with l for loss)
% 
%     a*e2-b*i2 = e1
%     c*e2-d*i2 = i1
% 
% Dick Benson 
%

      if strcmp(element,'rs')
           % rs  = series resistor
           a = 1;
           b = val1;
           c = 0;
           d = 1;
           q = 1;
      elseif strcmp(element,'lcs')
           % lcs = shunt series lc
           % l=val1 c=val2
           q = [val1*val2, 0 , 1];
           a = q;
           b = 0;
           c = [val2 0];
           d = q;
           
      elseif strcmp(element,'lcp')
          % l=val1 c=val2
           q = [val1*val2 val2*val3 1];
           a = q;
           b = [val1 val3];
           c = 0;
           d = q;
      elseif strcmp(element,'ls')     
           % ls = series l
           a = 1;
           b = [val1 0];
           c = 0;
           d = 1;
           q = 1;
      elseif strcmp(element,'cp')
           % cp = shunt c
           q = 1;
           a = 1;
           b = 0;
           c = [val1 0];
           d = 1;
      elseif strcmp(element,'rp')
           % rp = shunt r
           q = 1;
           a = 1;
           b = 0;
           c = 1/val1;
           d = 1;     
      else
         disp([element,' not supported in pabcd '])
      end;

      if isempty(ain)
         aout=a;
         bout=b;
         cout=c;
         dout=d;
         qout=q;
      else
         aout = padd(conv(ain,a),conv(bin,c));
         bout = padd(conv(ain,b),conv(bin,d));
         cout = padd(conv(cin,a),conv(din,c));  
         dout = padd(conv(cin,b),conv(din,d)); 
         qout = conv(qin,q);
      end;

% end function

function pout = padd(p1,p2)
    lp1 = length(p1);
    lp2 = length(p2);
    if lp1==lp2
       pout = p1+p2;
    elseif lp2>lp1 
       pout = p2;
       pout((lp2-lp1+1):lp2)=pout((lp2-lp1+1):lp2)+p1;
    else
       pout = p1;
       pout((lp1-lp2+1):lp1)=pout((lp1-lp2+1):lp1)+p2;
    end;
% end padd



