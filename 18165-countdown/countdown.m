function countdown(mins,secs,endMssg,showIllusion)
% Copyright 2007 The MathWorks, Inc.
% Creates a figure to countdown remaining time (minutes/seconds only).
%
% By default, the figure includes an optical illusion created with lines
% and patches. This can be turned off.
%
% SYNTAX:
%   COUNTDOWN(MINS)
%   COUNTDOWN(MINS,SECS)
%   COUNTDOWN(MINS,SECS,ENDMSSG)
%   COUNTDOWN(MINS,SECS,ENDMSSG,SHOWILLUSION)
%     (SHOWILLUSION is a binary input to SHOW (1=default) or SUPRESS (0)
%     optical illusion.) 
%
% EXAMPLE:
%   %1) 15 minutes
%   countdown(15)
%
%   %2) 15 minutes, 30 seconds, then flash message 'Pencils Down!!!'
%   countdown(15,30,'Pencils Down!!!')
%   % Note: same as countdown(15.5,0,'Pencils Down!!!')
%   
%   %3) 5 minutes, 0 seconds; default ending message; suppress optical illusion
%   countdown(5,0,[],0)

% Created by Brett Shoelson
% brett.shoelson@mathworks.com
% 12/31/07

% Revisions:
% 01/01/08 Added new input argument (in position 3) to allow easy setting of
%          ending message. Also changed default ending message, and added
%          examples.)

if nargin < 2
    secs = 0;
end
secs = secs + rem(mins,1)*60;
mins = floor(mins);

if nargin < 3 || isempty(endMssg)
    endMssg = 'Time''s Up!';
end

if nargin < 4
    showIllusion = 1; %DEFAULT
end

countdownfig = figure('numbertitle','off','name','COUNTDOWN',...
    'color','w','menubar','none','toolbar','none',...
    'pos',[267 65 748 900],'closerequestfcn',@cleanup);

if showIllusion
    createIllusion;
    edtpos = [0.1 0.75 0.8 0.2];
else
    edtpos = [0.1 0.1 0.8 0.8];
end
edtbox = uicontrol('style','edit','string','STARTING','units','normalized',...
    'position',edtpos,'fontsize',62,'foregroundcolor','r');
timerobj = timer('timerfcn',@updateDisplay,'period',1,'executionmode','fixedrate');
secsElapsed = 0;
start(timerobj);

    function updateDisplay(varargin)
        secsElapsed = secsElapsed + 1;
        if secsElapsed > secs + mins*60
            set(edtbox,'string',endMssg);
            tmp = get(0,'screensize');
            set(countdownfig,'pos',[1 40 tmp(3) tmp(4)-80]);
            set(edtbox,'foregroundcolor',1-get(edtbox,'foregroundcolor')); %,'backgroundcolor',1-get(edtbox,'backgroundcolor')
        else
            set(edtbox,'string',...
                datestr([2003  10  24  12  mins  secs-secsElapsed],'MM:SS'));
        end
    end

    function cleanup(varargin)
        stop(timerobj);
        delete(timerobj);
        closereq;
    end

    function createIllusion(varargin)
        %%%%%%%%%%%%
        %PARAMETERS
        pct = 0.7;%Vertical size of axis (Pct of figure)
        nlines = 9;%Number of lines
        fc = [0 0 0];%Facecolor
        lc = [1 1 1]*0.5;%Linecolor
        sz = 0.04;%Patchwidth
        lw = 2; %Linewidth
        %%%%%%%%%%%%

        subplot('position',[0 0 1 pct]);
        y = 1:nlines;

        axis off;
        hold on;
        xs = [0 1 1 0 0,reshape(repmat(reshape([3:2:floor(1/sz);2:2:floor(1/sz)-1],[],1),1,2)',[],1)']*sz;
        ys = [0 0 1 1 0, repmat([0 1 1 0],1,(numel(xs)-5)/4)];
        h = zeros(1,nlines);
        for jj=1:nlines
            h(jj) = patch(xs,ys+jj,fc);
        end
        line(xlim,[y;y],'color',lc,'linewidth',lw);
        shifts = repmat([1 2 3 2],1,3);
        for ii = 1:max(y)
            set(h(ii),'xdata',get(h(ii),'xdata')+ sz/shifts(ii));
        end
        set(gca,'xlim',[0 1]);
    end

end
