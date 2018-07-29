function hfig = bullbingo(varargin)

% bullbingo   interactive Bullshit Bingo
%
%   hfig = bullbingo(game)
%
%           Supported games at the moment are
%           'original' (default), 'Telecom', 'PC' and 'kuitu'
%
%  RIGHT-CLICK on background for new game

% Pekka Kumpulainen  5.4.2001
% 14.1.2003 'Telecom' version added
% 11.6.2008 "English only" version

if nargin < 1
  hfig = init('original')
else
  switch varargin{1}
    case 'hit'
      hit
    case 'Newgame'
      Newgame(varargin{2})
    otherwise
      hfig = init(varargin{1});
  end
end

%%%%%%%%%%%%%%%%%%%
function hfig = init(game)

x = repmat(.5:1:4.5,5,1);
y = x';

hfig = figure('Units','normalized', ...
              'Position',[.1 .1 .6 .8], ...
              'DefaultTextInterpreter','tex', ...
              'PaperUnits','normalized', ...
              'PaperPosition',[.1 .2 .8 .6], ...
              'DefaultTextHorizontalAlignment','center', ...
              'WindowButtonDownFcn','bullbingo hit');
              
cmenu = uicontextmenu;
uimenu(cmenu, 'Label', 'Original', 'Callback', 'bullbingo(''Newgame'',''original'')');
uimenu(cmenu, 'Label', 'Telecom', 'Callback', 'bullbingo(''Newgame'',''Telecom'')');
uimenu(cmenu, 'Label', 'PC', 'Callback', 'bullbingo(''Newgame'',''PC'')');
uimenu(cmenu, 'Label', 'Data analysis', 'Callback', 'bullbingo(''Newgame'',''Data Analysis'')');
set(hfig,'UIContextMenu', cmenu);


hax1 = axes('Tag','titleax', ...
            'Units','normalized', ...
            'Position',[.1 .8 .8 .1], ...
            'Box','on', ...
            'XGrid','off', ...
            'XLim',[0 1], ...
            'Ylim',[0 1], ...
            'YGrid','off', ...
            'XTick',[0 1], ...
            'YTick',[0 1], ...
            'XtickLabel','', ...
            'YtickLabel','', ...
            'Visible','on');
%            'UIContextMenu', cmenu);
ht = get(hax1,'Title');
set(ht,'String',{upper(game) 'Bullshit Bingo'}, ...
       'FontWeight','bold', ...
       'FontSize',16);
ht = text('position',[.5 .5], ...
          'string',{'Do you keep falling asleep in meetings and seminars?' 'What about those long and boring conference calls?' 'Here is a way to change all of that!'});

ht = get(hax1,'XLabel');
set(ht,'String',{'\bfHow to play:\rm Check off each block when you hear these words during a meeting, seminar, or phone call.' 'When you get five blocks horizontally, vertically, or diagonally, stand up and shout  \bfBULLSHIT!!'});

hax2 = axes('Tag','Bingo_Table', ...
            'Units','normalized', ...
            'Position',[.1 .2 .8 .5], ...
            'XLim',[0 5], ...
            'Ylim',[0 5], ...
            'YDir','reverse', ...
            'Box','on', ...
            'GridLineStyle','-', ...
            'XGrid','on', ...
            'YGrid','on', ...
            'XTick',0:5, ...
            'XtickLabel','', ...
            'YTick',0:5, ...
            'YtickLabel','');
         
% make empty strings and fill
ud.ht = text(x(:),y(:),'');
filltable(ud.ht,game)

% make invisible crosses
ud.hl = zeros(5);
x = [.3 .7 .7 .3 .3 .7]-1;
y = [.3 .7 NaN NaN .7 .3]-1;
for ii1 = 1:5;
   for ii2 = 1:5;
      ud.hl(ii2,ii1) = line(x+ii1,y+ii2, ...
         'LineWidth',2, ...
         'Color',[1 0 0], ...
         'Visible','off', ...
         'EraseMode','xor');
   end
end

h_b = text('Tag','BINGO', ...
  'Parent',hax2 , ...
  'Position',[2.5 2.5], ...
  'String',{'BINGO!' 'BULLSHIT!'}, ...
  'FontUnits','points', ...
  'FontSize',48, ...
  'FontWeight','bold', ...
  'Rotation',30, ...
  'EraseMode','xor', ...
  'Color',[0 0 1], ...
  'Visible','off');

% set userdata
ud.hitmap = zeros(5);
ud.isbingo = 0;
%ud.game = game;
set(hax2,'UserData',ud);

% testimonials
hax = axes('Units','normalized', ...
           'Position',[.05 0 .9 .2], ...
           'Visible','off');
h = text('Parent',hax, ...
  'Units','normalized', ...
  'Position',[0 .9], ...
  'FontSize',9, ...
  'HorizontalAlignment','left', ...
  'VerticalAlignment', 'top', ...
  'String',{'\bfTestimonials from satisfied players:\rm'
            '"I had only been in the meeting for five minutes when I won."   -Jack W. - Boston'
            '"My attention span at meetings has improved dramatically."   -David D. - Florida'
            '"What a gas. Meetings will never be the same for me after my first win."   -Bill R - New York City'
            '"The atmosphere was tense in the last process meeting as 14 of us waited for the 5th  box." -Ben G. - Denver'
            '"The speaker was stunned as eight of us screamed ''Bullshit'' for the third time in 2 hours."   - Kathleen L. - Atlanta'});
            

% button 
%hb = uicontrol('Style','pushbutton', ...
%  'Units','pixels', ...
%  'Position',[0 0 100 20], ...
%  'String','New game', ...
%  'Callback','bullbingo Newgame');

% init
%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
function filltable(ht,game)

switch game
    case 'original'
        words = {'Synergy'
            'Bluetooth'
            'Gap Analysis'
            'Best Practice'
            'EDMS-codes'
            {'Sales' 'Package'}
            'Bandwidth'
            'Microsoft'
            {'Market' 'Development'}
            'Benchmark'
            'Value-Added'
            {'Type' 'Approvals'}
            'Win-Win'
            'Launch'
            'Propriety'
            'Result-Driven'
            'Windows CE'
            {'Knowledge' 'Base'}
            {'Total Quality'; '[or]'; 'Quality Driven'}
            'WAP'
            'E1'
            'Hardware'
            {'Technical' 'Requirements'}
            'Features'
            'Usability'};
    case 'PC'
        words = {'USB'
            'AGP'
            'PCI'
            'PCMCIA'
            'SCSI'
            'IEEE'
            'ISA'
            'ATX'
            'AT'
            'IDE'
            'TCP/IP'
            'CDROM'
            'BIOS'
            'DVD'
            'IPX'
            'SVGA'
            'LCD'
            'TFT'
            'SIMM'
            'DIMM'
            'EDORAM'
            'MMX'
            'DAT'
            'CDRW'
            'PS/2'
            'AMD'
            'PPP'
            'SLIP'
            'ISDN'
            'ADSL'
            'NT'
            'UNIX'
            'DOS'
            'PC'};
    case 'Telecom'
        words = {'GSM'
            '3G'
            'GPRS'
            'OSS'
            'UMTS'
            'TRX'
            'Optimizer'
            'MSC'
            'WCDMA'
            'Use Case'
            'Benefit'
            'Support'
            'KPI'
            'Performance'
            'UMTS'
            'BTS'
            'Network'
            'TCH'
            'SDCCH'
            'Access'
            'HO'
            'HangOver Failure'
            'End-to-end'
            'Service'
            'SGSN'
            'BSC'
            'KQI'
            'Super-KPI'
            'Multivendor'
            'Solution'
            'Business Case'
            'Support'
            'SLA'
            'Application'
            'QOS'};
    case 'Data Analysis'
        words = {'A/D conversion'
            'Analysis'
            'Time series'
            'Amplitude'
            'Amplitude response'
            {'Autocorrelation';'function'}
            'Butterworth'
            'Chebyshev'
            'Band width'
            'Estimate'
            'FFT'
            'Histogram'
            'Window function'
            'Impulse response'
            'Distribution'
            'Distribution function'
            'Mean'
            'Noise'
            'Convolution'
            'Correlation'
            {'Correlation';'coefficient'}
            'Covariance'
            'Quantization'
            'Aliasing'
            'Linear'
            'LTI system'
            'Minimum phase'
            'Pole'
            'quadratic mean'
            'Zero'
            'Normal distribution'
            'Nyquist frequency'
            'Sample Mean'
            'Sampling period'
            'Sampling'
            'Overlapping'
            'Periodogram'
            'Process'
            'Cut-off frequency'
            'Regression'
            'Resolution'
            {'Cross-correlation';'function'}
            'Group delay'
            'Signal'
            'Spectrum'
            'Frequency'
            'Frequency resolution'
            'Frequency response'
            {'Power spectral';'density'}
            {'Probability density';'function'}
            'Trendi'
            'Phase response'
            'Attenuation'
            'Degree of freedom'
            'Variance'
            'White noise'
            'z-transform'};

    otherwise
        close(gcf)
        error(['Unknown game: ' game])

end

ind = randperm(length(words));
for ii = 1:25;
  set(ht(ii),'string',words{ind(ii)});
end

% filltable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%
function hit

%hax = overobj('axes');
hax = findobj(gcbf,'Tag','Bingo_Table');
%if isempty(hax) | get(hax,'Tag') ~= ('Bingo_Table'); return; end
tmp1 = ceil(get(hax,'currentpoint'));
if min(tmp1(1,1:2))<1 || max(tmp1(1,1:2))>5; return; end

ud = get(hax,'UserData');
if ~ud.hitmap(tmp1(1,2),tmp1(1,1)) && ~ud.isbingo
  ud.hitmap(tmp1(1,2),tmp1(1,1)) = 1;
  set(hax,'UserData',ud);
  set(ud.hl(tmp1(1,2),tmp1(1,1)),'Visible','on');
end

%Tarkista onko rivi täynnä!!
if any([sum(ud.hitmap) sum(ud.hitmap') trace(ud.hitmap) trace(fliplr(ud.hitmap))]>=5)
  set(findobj(gcbf,'Tag','BINGO'),'Visible','on');
  ud.isbingo = 1;
  set(hax,'UserData',ud);
end
% hit
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
function Newgame(game)

hax = findobj(gcbf,'Tag','Bingo_Table');
ud = get(hax,'UserData');
ud.hitmap = zeros(5);
ud.isbingo = 0;
set(hax,'UserData',ud);

set(ud.hl,'Visible','off');
set(findobj(gcbf,'Tag','BINGO'),'Visible','off');

filltable(ud.ht,game)
hax = findobj(gcbf,'Tag','titleax');
set(get(hax,'title'),'String',{upper(game) 'Bullshit Bingo'});

% Newgame
%%%%%%%%%%%%%%%%%%%
