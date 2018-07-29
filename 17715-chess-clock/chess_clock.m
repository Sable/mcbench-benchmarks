function chess_clock
% CHESS_CLOCK Digital chess clock (Fischer clock)
%
% Set time limits and optional extra time per move
% Press space bar to switch the timer
% Press Esc to pause or exit
% Active timer is indicated by bold font

%
% By Mathias Benedek, 2007-11-25, last updated 2007-12-02


fig_cc = figure('Units','normalized','NumberTitle','off','MenuBar','none','Name','Chess clock','Position',[.3 .6 .4 .15],'KeyPressFcn','keypressed');

ctimer(1) = uicontrol('Style','edit','Units','normalized','Position',[.1 .2 .35 .6],'FontSize',40,'BackgroundColor',[1 1 1],'ForegroundColor',[.4 .4 .4],'Enable','inactive');
ctimer(2) = uicontrol('Style','edit','Units','normalized','Position',[.55 .2 .35 .6],'FontSize',40,'BackgroundColor',[0 0 0],'ForegroundColor',[.6 .6 .6],'Enable','inactive');
rndcntr = uicontrol('Style','text','Units','normalized','Position',[.45 .2 .1 .1],'FontSize',10,'String','','BackgroundColor', get(fig_cc,'Color'));

player = {'white','black'};
status = 0; %0 reset, 1 running, -1 exit


while status >= 0

    %initial values for prompt
    timelimit = [20, 20]; %[min]
    extratime = 0; %[sec]
    roundnr = 0;

    timeset = inputdlg({'Time limit for white [min]', 'Time limit for black [min]','Extra time per move [sec]'},'Time limits',1,{num2str(timelimit(1)), num2str(timelimit(2)), num2str(extratime)});
    if isempty(timeset)
        close(fig_cc);
        return;
    end
    %Initialize values
    timelimits = str2double(timeset(1:2)) * 60; %total time per player [sec]
    timeleft = timelimits; %remaining time per player [sec]
    extratime = str2double(timeset(3)); %extra time per move [sec]
    pausetime = 0;
    set(ctimer(1),'String',sprintf('%02.0f:%02.0f',floor(ceil(timeleft(1))/60), floor(mod(ceil(timeleft(1)),60))));
    set(ctimer(2),'String',sprintf('%02.0f:%02.0f',floor(ceil(timeleft(2))/60), floor(mod(ceil(timeleft(2)),60))));
    set(rndcntr,'String',roundnr);
    turn = 1; %white, black = 2

    questdlg('Ready?','','Go!','Go!');
    roundnr = 1;
    status = 1;
    starttime = clock;
    timeleft(turn) = timeleft(turn) + extratime;

    while ~any(timeleft <= 0) && status == 1

        etimetotal = etime(clock, starttime);
        %remaining time for player <turn> = total available time (sum of limit, pause and extra time) - (elapsed time + remaining time of opponent player)
        timeleft(turn) = sum(timelimits) + pausetime + extratime*((roundnr-1)*2 + turn) - (etimetotal + timeleft(3-turn)); %this way of calculation ensures correct total timing

        %refresh clock display
        set(ctimer(1),'String',sprintf('%02.0f:%02.0f',floor(ceil(timeleft(1))/60), floor(mod(ceil(timeleft(1)),60))));
        set(ctimer(2),'String',sprintf('%02.0f:%02.0f',floor(ceil(timeleft(2))/60), floor(mod(ceil(timeleft(2)),60))));
        set(ctimer(turn),'FontWeight','bold')
        set(ctimer(3 - turn),'FontWeight','normal')
        set(rndcntr,'String',roundnr);
        pause(.02);

        %check for keypress
        ch = double(get(fig_cc,'CurrentCharacter'));
        if ~isempty(ch)            
            switch ch
                case 32, %Space
                    turn = 3 - turn;
                    timeleft(turn) = timeleft(turn) + extratime;
                    if turn == 1
                        roundnr = roundnr + 1;
                    end
                    
                case 27, %Esc
                    tic;
                    butt = questdlg('Resume?','Paused','Resume','Reset','Exit','Resume');
                    pausetime = pausetime + toc;
                    switch butt
                        case 'Resume'
                        case 'Reset'
                            status = 0;
                        case 'Exit'
                            status = -1;
                    end
            end
            
            set(fig_cc,'CurrentCharacter','x') %dummy
        end

    end%while


    %Time over
    if any(timeleft <= 0)
        idx = find((timeleft <= 0));
        butt = questdlg(['Time over for ',player{idx},'!'],'','Reset','Exit','Reset');
        switch butt
            case 'Reset'
                status = 0;
            case 'Exit'
                status = -1;
            otherwise
                status = -1;
        end

    end

end

close(fig_cc);



function keypressed
%dummy function to keep figure on top after keypress