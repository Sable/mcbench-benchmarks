function [x, y] = cursorg(action, arg1, CursorNumber, txtPOS)
%
% implement a cursor on a plot
%
%  EXAMPLE:
%		clf reset, plot(rand(10,1)), % create plot
%		CNo1=cursorg; % create one cursor
%		disp(' move cursor'), pause
%		CNo2=cursorg;
%		disp(' move other cursor'), pause
%		d=cursorg('read',CNo2)-cursorg('read',CNo1);
%		 title(['difference =' num2str( d )]);

if (nargin<1)
    action='init';
end
if strcmp(action,'init')
    if nargin>1		% where shell I put the cursorg
        if (~isempty(arg1))	% is it cursorg('init',[],...)
            ca=arg1;
        else
            ca=gca;
        end
    else
        ca=gca;
    end
    gf = get(ca,'parent');
    if (nargin<3)			% find a valid cursor number
        CursorNumber=1;
        while ~isempty( findobj('tag',['cursor' int2str(CursorNumber)]) )
            CursorNumber=	CursorNumber+1;
        end
        x=CursorNumber;
    end
    name=['cursor' int2str(CursorNumber)];
    Xlim=get(ca,'xlim');
    Ylim=get(ca,'ylim');
    posit=Xlim(1)+(0.2+rem(CursorNumber,3)*0.1)*(Xlim(2)-Xlim(1));
    if posit>Xlim(2),
        posit=mean(Xlim(1:2))+rem(CursorNumber,3)*0.011*(Xlim(2)-Xlim(1))  ;
    end
    
    h=findobj('parent',ca,'tag',name);  delete(h)
    
    hc=line('LineStyle','-',...
        'Xdata',[posit posit],'Ydata',Ylim,...
        'linewidth',2 ,'visible','on',...
        'tag',name);
    
    call=['cursorg(''cursorpress'' ,' int2str(CursorNumber) ' );'];
    
    set(hc,'ButtonDownFcn',call);
    if nargin<4,
        dx=0.1; dy=0.05;
        axpos=get(ca,'pos');
        x1=axpos(1); y1=axpos(2)+axpos(4);
        Nc=length(findcrs(gf,ca )); 
        if isempty(Nc) 
            Nc=0; 
        end
        txtPOS=[ x1+(Nc-1)*dx*1.05 y1 dx dy]  ;
    end
    % create or extend FRAME
    %     axpos=get(ca,'pos');
    editcall=['cursorg(''edit'' ,' int2str(CursorNumber) ' );'];
    uicontrol('style','edit',...
        'unit','normal',...
        'tag',['cursortext' int2str(CursorNumber)],...
        'pos',txtPOS,...
        'BackgroundColor',[0 0 1],...
        'ForegroundColor',[1 1 1],...
        'callback', editcall,...
        'string',num2str(posit))
    
    
    refresh
    
    set(hc,'Erasemode','xor')
    
elseif strcmp(action,'cursorpress'),
    
    name=['cursor' int2str(arg1)]; CursorNumber=arg1;
    co=findobj('tag',name)   ;
    
    set(gcf,'pointer','fleur');
    call=['cursorg(''cursorup'' ,' int2str(CursorNumber) ');'];
    set(co,'ButtonDownFcn','');
    callmv=['cursorg(''cursormove'' , ' int2str(CursorNumber) ');'];
    set(gcf,'WindowButtonMotionFcn', callmv );
    set(gcf,'WindowButtonUpFcn', call);
    
elseif strcmp(action,'cursormove'),
    CursorNumber=arg1; 
    name=['cursor' int2str(CursorNumber)] ;
    co=findobj('tag',name);
    ga=get(co,'parent');
    %     gf=get(ga,'parent');
    % Obtain coordinates of mouse click location in axes units
    pt = get(ga,'Currentpoint');
    t = pt(1,1);
    ax=get(ga,'xlim');
    if t<ax(1),
        t=ax(1);
    elseif t>ax(2),
        t=ax(2);
    end
    
    set(co,'xdata',[t t]);
    
    
elseif strcmp(action,'cursorup'),
    %*******************************>   cursorup
    
    CursorNumber=arg1; 
    name=['cursor' int2str(CursorNumber)];
    co=findobj('tag',name );
    ga=get(co,'parent'); gf=get(ga,'parent');
    call=['cursorg(''cursorpress'' , ' int2str(CursorNumber) ');'];
    set(co ,'ButtonDownFcn',call);
    set(gf,'WindowButtonMotionFcn','');
    set(gf,'WindowButtonUpFcn','');
    set(gcf,'pointer','arrow');
    txt=findobj('tag',['cursortext' int2str(CursorNumber)]);
    t=get(co,'xdata');
    set(txt,'string',sprintf('%5.3e',t(1)));
elseif strcmp(action,'edit'),
    %*******************************>   move to edit box
    CursorNumber=arg1; 
    nametxt=['cursortext' int2str(CursorNumber)] ;
    name=['cursor' int2str(CursorNumber)] ;
    co=findobj('tag',name);
    cotxt=findobj('tag',nametxt);
    ga=get(co,'parent');
    %     gf=get(ga,'parent');
    % Obtain coordinates of mouse click location in axes units
    %     pt = get(cotxt,'string');
    ax=get(ga,'xlim');
    %     t= pt;
    t=mean(ax(1:2)+rand(1)*diff(ax(1:2)));
    set(cotxt,'string','ERROR! ');
    if t<ax(1),
        t=ax(1);
    elseif t>ax(2),
        t=ax(2);
    end
    
    set(co,'xdata',[t t]);
    
    
elseif strcmp(action,'read'),
    %*******************************>   read
    CursorNumber=arg1; 
    name=['cursor' int2str(CursorNumber)];
    co=findobj('tag',name );
    pt = get(co,'xdata');
    x = pt(1,1);
elseif strcmp(action,'gethandle'),
    %*******************************>   gethandle
    CursorNumber=arg1; 
    name=['cursor' int2str(CursorNumber)];
    x=findobj('tag',name );
    
elseif strcmp(action,'setxloc'),
    %*******************************>   setxloc
    nametxt=['cursortext' int2str(arg1)] ;
    cotxt=findobj('tag',nametxt);
    pt = num2str(CursorNumber);
    set(cotxt,'string',pt);
    cursorg('edit',arg1);
elseif strcmp(action,'hide'),
    %*******************************>   hide
    h=cursorg('gethandle',arg1);
    set(h,'visible','off');
    
elseif strcmp(action,'show'),
    %*******************************>   show
    h=cursorg('gethandle',arg1);
    set(h,'visible','on');
elseif strcmp(action,'readxy'),
    %*******************************>   readxy
    % [x,y]=cursorg('readxy',Cno);   % NOTE y may be a vector
    % find the intersection of the cursor with other curves
    h=cursorg('gethandle',arg1);	
    xc=cursorg('read',arg1);
    ax=get(h,'parent');
    lines=findobj('type','line','parent',ax); % find all lines in axes
    %	lines( find(lines == h ) );
    y=[]; x=[];
    for q=1:length(lines) 
        Xd=get(lines(q),'xdata'); 
        Yd=get(lines(q),'ydata');
        S=get(lines(q),'tag');
        FLAG=length(Xd)<2;
        if length(S)>=7,
            if strcmp(S(1:6),'cursor') ,
                FLAG=1;
            end
        end	% if length
        if ~FLAG
            
            [~, ind]=min( abs(Xd-xc));	% find closest point
            y=[y ; Yd(ind)]; x=[x ; Xd(ind)];		% that's for nearest point
            % or find intersection
            %		d=Xd-xc;
            %	j1=find(d>0);  j2=find(d<0);
            %	[tmp1 ind1]=min(d(j1)); [tmp2 ind2]=min((j2));
            %		ind3=[j1(ind1) j2(ind2)];
            %		p=polyfit(Xd(ind3),Yd(ind3),1); y1=polyval(p,x);
            %	y=[y ; y1];
            
        end
    end
    
elseif strcmp(action,'setheight'),
    %*******************************>   setheight
    h=cursorg('gethandle',arg1);
    set(h,'ydata',CursorNumber);  % called as cursorg('setheight',1,[0.01 1])
elseif strcmp(action,'delete'),
    %*******************************>   delete
    CursorNumber=arg1;
    if strcmpi(arg1, 'all'),
        h=findobj('type','line');
        for q=1:length(h),
            S=get(h(q),'tag');
            if length(S)>=7,
                if strcmp(S(1:6),'cursor'),
                    delete(h(q));
                    Cno=eval(S(7)) ;
                    delete(findobj('tag',['cursortext' int2str(Cno)]))
                end
            end
        end
    else
        name=['cursor' int2str(CursorNumber)];
        co=findobj('tag',name );
        delete(co);
        delete(findobj('tag',['cursortext' int2str(CursorNumber)]))
    end
    
end
