function x = array(r,c);
% X = ARRAY(R,C) allows interactively create arrays of given size instead of typing them
% in command line. 
%R - number of rows
%C - number of columns

arr_size = [r,c];

if arr_size(2) < 2
    fig_dim = [arr_size(1)*25+60, 120];
else  
    fig_dim = [arr_size(1)*25+60, arr_size(2)*60+15]; %[y,x]
end
arr_fig = figure('unit','pixels','NumberTitle','off','Menubar','none','resize','on','position', [75 75 fig_dim(2) fig_dim(1)]);

ok_but = uicontrol('Style','pushbutton','unit','pixels','String','OK','position',[5 15 20 20],...
    'callback','uiresume','tag','ok');
cancel_but = uicontrol('Style','pushbutton','unit','pixels','String','Cancel','position',[35 15 40 20],...
    'callback','uiresume','tag','cancel');
bd_size = 5; %border size
posx = bd_size;
posxb = posx;
posy = fig_dim(1)-20-bd_size;

for i = 1:arr_size(1)
    for j = 1:arr_size(2)
        a(i,j)=uicontrol('Style','edit','unit','pixels','position', [posx posy 50 20]);
        posx = posx+50+bd_size;
    end
    posx = posxb;
    posy = posy-20-bd_size;
end

uiwait;
but = gco;

if strcmp(get(but,'tag'),'ok')
    [r,c] = size(a);
    for i = 1:r
        for j = 1:c
            x(i,j) = str2num(get(a(i,j),'string'));
        end
    end
    close;    
else 
    close;
    return;
end
    
