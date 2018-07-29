% this is tha main screen of the program, which includes every aspect of our project you can see the help for further information 


function menu()
fig=figure('name','Cellular Project','menubar','none','numbertitle','off','units','normalized','color','w',...
    'position',[0.25 0.25 0.7 0.65])
h1=axes('units','normalized','position',[.01 0.3 0.3 .47],'xcolor',[1 1 1],'ycolor',[1 1 1])
t1=uicontrol('style','text','units','normalized','position',[0.4 0.8 0.3 0.1],'fontname','arial','fontsize',10,'string','Please Click On One Of The Following')
a1=uicontrol('style','listbox','string',[{'Traffic Cacluation'},{'Site Configuration'},{'Report'},{'Close'}],'units','normalized','position',[0.4 0.4 0.3 0.3],'fontname','comicsansms','fontsize',10,'callback',@push);
m1=uimenu('label','extra');
m2=uimenu('label','about');

uimenu(m2,'label','about me','callback',@me);
uimenu(m1,'label','maximize','callback',@men);
uimenu(m1,'label','traffic','callback',@tra,'separator','on');
uimenu(m1,'label','cellular','callback',@cel,'separator','off');
uimenu(m1,'label','close','callback',@cls,'separator','on');
m3=uimenu('label','help','callback',@help)
   axis(h1);
   ss=imread('ju1.jpg');
   imshow(ss)
	function help(varargin)
		open('help.doc')
	end
	function me(varargin)
str=sprintf(['Sanad Amin \n\n',...
    'Reg No:0057035 \n',...
    'Sanad_amin@hotmail.com'])
msgbox(str,'About Me','help')
    end
    function men(varargin)
        
       set(fig,'units','normalized','position',[0.01 0.01 1 0.95]) ;
    end
    function tra(varargin)
       run traffic 
    end
    function cel(varargin)
       run cellular 
    end
    function cls(varargin)
        close(gcf)
        
    end
    function push(varargin)
       val=get(a1,'value');
       if val==1;
         run traffic
       else if val==2;
               run cellular
		   else if val==3
				   open('report.doc')
			   end
		    if val==4;
                  close(gcf) ;
               end
          
           end
       end
    end

end