function ht = fix_xticklabels(handle,margins,textopts)

%FIX_XTICKLABELS will determine maximum allowed width
%   of long XTickLabels and convert them into multiple line 
%   format to fit maximum allowed width
%
%
%   IN:
%       handle      [optional] - axes handle (defaults to gca)
%       margins     [optional] - relative margins width (defaults to 0.1)
%       texopts     [optional] - cell array of addtitional text formating
%                                options (defaults to {} )
%
%   OUT:
%       ht - column vector of handles for created text objects
%
% This code was derrived from MY_XTICKLABELS by Pekka Kumpulainen 
% http://www.mathworks.com/matlabcentral/fileexchange/19059-myxticklabels
%   EXAMPLE:
%       figure;
%
%       bar(rand(1,4));
%       set(gca,'XTickLabel',{'Really very very long text', ...
%                             'One more long long long text', ...
%                             'Short one','Long long long text again'});
%       fix_xticklabels();
%
%       figure;
%
%       bar(rand(1,4));
%       set(gca,'XTickLabel',{'Really very very long text', ...
%                             'One more long long long text', ...
%                             'Short one','Long long long text again'});
%       fix_xticklabels(gca,0.1,{'FontSize',16});
%

% Mikhail Erofeev 07.06.2013
% Pekka Kumpulainen 12.2.2008

if(~exist('handle','var'))
    handle = gca;
end

if(~exist('textopts','var'))
   textopts={};
end
if(~exist('margins','var'))
    margins = 0.1;
end

xtickpos = get(handle,'XTick');
xtickstring = get(handle,'XTickLabel');


set(handle, 'XTickLabel','')
h_olds = findobj(handle, 'Tag', 'MUXTL');
if ~isempty(h_olds)
    delete(h_olds)
end

%% Make XTickLabels 
NTick = length(xtickpos);
Ybot = min(get(handle,'YLim'));

Xbot = get(handle,'XLim');
max_w = ((max(Xbot) - min(Xbot) )/NTick)*(1-margins);


ht = zeros(NTick,1);

NLabels = length(xtickstring);

for ii = 1:NTick
    str_id = mod( ii - 1 , NLabels) + 1;
    ht(ii) = text('String',xtickstring{str_id}, ...
        'Units','data', ...
        'VerticalAlignment', 'top', ...
        'HorizontalAlignment', 'center ', ...
        'Position',[xtickpos(ii) Ybot], ...
        'Tag','MUXTL');
end
if ~isempty(textopts)
    set(ht,textopts{:})
end

for ii = 1:NTick
    auto_width(ht(ii),max_w);
end

%% squeeze axis if needed

set(handle,'Units','pixels')
Axpos = get(handle,'Position');
% set(Hfig,'Units','pixels')
% Figpos = get(Hfig,'Position');

set(ht,'Units','pixels')
TickExt = zeros(NTick,4);
for ii = 1:NTick
    TickExt(ii,:) = get(ht(ii),'Extent');
end

needmove = -(Axpos(2) + min(TickExt(:,2)));

if needmove>0;
    Axpos(2) = Axpos(2)+needmove+2;
    Axpos(4) = Axpos(4)-needmove+2;
    set(handle,'Position',Axpos);
end

set(handle,'Units','normalized')
set(ht,'Units','normalized')
end

function []=auto_width(h,maxw)
    str = get(h,'string');
    set(h,'string',{});
    words = regexp(str,' ','split');
    
    
    tail = words(2:end);
    res = words(1);
    ln = 1;
    
    while(~isempty(tail))
        lin = res{ln};
        lin_e = [lin ' ' tail{1}];
        set(h,'string',lin_e);
        ext = get(h,'Extent');
        width=ext(3);
        if(width>maxw)
            ln =ln+1;
            res{ln} = tail{1};
        else
            res{ln} = lin_e;
        end
        tail = tail(2:end);
    end
    set(h,'string',res);
    ext = get(h,'Extent');
    width=ext(3);
    if(width>maxw)
        warning('FIX_XTICKLABELS:over','Overflown box');
    end
end
