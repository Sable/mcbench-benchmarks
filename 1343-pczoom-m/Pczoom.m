function pczoom(option)
%pczoom	2-D menu driven zooming function.
%	pczoom  typed at the command prompt with no input 
%	initialises the zooming function in the current figure window
%	Select from uimenu for  zoom options.
%
%	Features
%	1. Menu driven
%	2.	x,y or xy zoom  
%	3. zoom co-ordinates are stored in axes z-label
%		user data and past views restored sequentially
%		via successive right mouse clicks
%	4. operates on all axes in a figure
%	5. new axes added can be zoomed 
%	6. can be paused, reset and closed
%
%	menu options
%
%	xzoom 	: 	Click, hold,  drag  and release left mouse button 
%					vertical dash line drawn at point first clicked.
% 					vertical dash line tracks x-axis position of pointer until released.
% 	yzoom 	: 	as for xzoom but horizontal lines and y-position tracked till mouse released.
% 	xyzoom 	: 	rbbox starting at point mouse first clicked. Hold and drag to encompass
%					zoom area
% 	pause : pauses operation of zoom function 
% 	restart : restarts zoom with last state
% 	reset : redraws original plot as it was when pczoom first 
%          called
%	close : deletes menus. 
%
%	coordinates of all zoom coordinates for each axes from the 
%	strating from the initial state or the last reset are stored
%	and can be successively zoomed back out using right mouse clicks
% 	works on multiple axes in the particular figure window
% 
%	each axes on the figure can be zoomed separately
%	zoom parameters  stored in the userdata for each axes
%	Zlabel ( which obviously isn't used for 2-d plots)
%	current zoom type selected is stored in the zoom menu userdata
%	Can be paused and restarted
%
% 	Paul Casey
%  D.O.T.S.E. 
%	Naval Base
%	Auckland
%	New Zealand			 1/12/97
%	e-mail paulc@dotse.mil.nz
% 	developed on PC running Matlab 5.1, 
% 	revised and tested for 5.2 and 5.3 12/98 Paul Casey 
%  tested on  Matlab Release 11 ( ver 5.3.0.10183 ) 6/7/99
%  tested on Matlab Release 12 and 12.1 
if ~nargin

	% SAVE THE CURRENT WINDOWBUTTON FUNCTIONS	
	% TO be STORE IN THE MENU ITEM USERDATA FIELDS
	wbm_old = get(gcf,'WindowButtonMotionFcn');
 	wbu_old = get(gcf,'WindowButtonUpFcn');
	wbd_old = get(gcf,'WIndowButtonDownFcn');

	% FIND ALL THE AXES ON THE CURRENT FIGURE AND ASSIGN
	% THE REQUIRED INITIAL VALUES TO THE ZLABEL USERDATA FOR EACH 
	% AXES
	% CHECK THAT ZDATA IS NOT BEING USED AND THE pczoom IS NOT ALREADY 
	% ACTIVE

   ch = get(gcf,'ch');
   for n = 1:length(ch) 
      if strcmp(get(ch(n),'type'),'axes') 
         if ~isempty(get(get(ch(n),'zlabel'),'userdata')),        
            warndlg('one or more axes using zlabel user data and/or pczoom already active'),
				return
          else
            YLim = get(ch(n),'Ylim');
            XLim = get(ch(n),'Xlim');
            initials = [0 0 0 0 1,XLim,YLim];
            set(get(ch(n),'zlabel'),'userdata',initials)
         end
       end
   end
	if findobj(gcf,'tag','zoommenu')
		warndlg(' pczoom already active'),
		return
	end
	% SET THE ZOOM MENU

	Zoom_Menu = uimenu(gcf,...
   	'tag','zoommenu',...
		'interruptible','off',...
		'Label','Zoom Options');

	Xzoom = uimenu(Zoom_Menu,...
		'Label','X Zoom',...
		'tag','xzoom',...
		'Callback','pczoom(''xzoom'')');

	Yzoom = uimenu(Zoom_Menu,...
		'Label','Y Zoom',...
		'tag','yzoom',...
		'Callback','pczoom(''yzoom'')');

	XYzoom = uimenu(Zoom_Menu,...
		'Label','XY Zoom',...
		'tag','xyzoom',...	
		'Callback','pczoom(''xyzoom'')');

	Reset = uimenu(Zoom_Menu,...
		'Label','Reset',...
		'tag','Reset',...
		'userdata',wbu_old,...
		'Callback','pczoom(''reset'')	');

	Finish = uimenu(Zoom_Menu,...
		'Label','Close',...
		'tag','close',...
		'userdata',wbm_old,...
		'Callback','pczoom(''finish'')');

	holdbutton = uimenu(Zoom_Menu,...
		'Label','Pause',...
		'userdata',wbd_old,...
		'tag','holdbutton',...
		'callback','pczoom(''pause'')');

% ZOOM MENU CALL BACKS
elseif strcmp(option,'xzoom') | strcmp(option,'yzoom') | strcmp(option,'xyzoom')
	
   if strcmp(option,'xzoom')
		set(findobj(gcf,'tag','xzoom'),'enable','off'	)
		set(findobj(gcf,'tag','yzoom'),'enable','on'	)	
		set(findobj(gcf,'tag','xyzoom'),'enable','on'	)	
   elseif  strcmp(option,'yzoom')
		set(findobj(gcf,'tag','xzoom'),'enable','on'	)
		set(findobj(gcf,'tag','yzoom'),'enable','off'	)	
		set(findobj(gcf,'tag','xyzoom'),'enable','on'	)		
	elseif strcmp(option,'xyzoom')
		set(findobj(gcf,'tag','xzoom'),'enable','on'	)
		set(findobj(gcf,'tag','yzoom'),'enable','on'	)	
		set(findobj(gcf,'tag','xyzoom'),'enable','off'	)	
   end
	drawnow


   
   % assign zoom option to zoom menu userdata
   % this is so that for each recall of 
   % the function the zoom type is not lost
   % a bit tedious as you have to reidentify the handle 
   % by matching labels each time but saves using figure user data
   % which may be needed by another program
      
   set(findobj(gcf,'tag','zoommenu'),'userdata',option);

   % CALL TO DEFINE THE CALLBACK FOR EACH BUTTON PRESS
   set(gcf,'WindowButtonDownFcn','pczoom(''WindowButtonDown'')')
	set(gcf,'WindowButtonMotionFcn','')

% THE BUTTON PRESS CALLBACK
elseif strcmp(option,'WindowButtonDown')
   
   % FIND OBJECT SELECTED
   object_selected = get(gcf,'currentobject');
   
   % IF IT IS AN AXES OR CHILD OF AN AXES 
   % THEN DO THE ZOOM THING OTHERWISE DO NOTHING
   if strcmp(get(object_selected,'type'),'axes') | strcmp(get(get(object_selected,'parent'),'type'),'axes')

		% IF OBJECT IS  A CHILD OF AXES SET OBJECT TO PARENT
		if strcmp(get(get(object_selected,'parent'),'type'),'axes')
			object_selected = get(object_selected,'parent');
      end

  	   % GET THE POINT MOUSE CLICKED  AT 

      point = get(object_selected,'CurrentPoint');
      

	   % GET THE ZOOM PARAMETER DATA 
   	zoom_parameters = get(get(object_selected,'zlabel'),'userdata');
   
  	   % CHECK IF NEW AXES HAVE BEEN PLOTTED 
	   % IF ANY OF THE AXES ZLABEL USERDATA IS EMPTY THEN
	   % RESET THE DATA 
      if isempty(zoom_parameters)   
     		zoom_parameters = [0 0 0 0 1 get(object_selected,'XLim'),...
									get(object_selected,'YLim')];
	   end

		
   	% EXTRACT THE VARIOUS PARAMETERS
   	count = zoom_parameters(5);
   	current = zoom_parameters(1:4);
   	Xrecall = zoom_parameters(6:5+2*count);
   	Yrecall = zoom_parameters(6+2*count:5+4*count);

   	% CHECK WHICH MOUSE BUTTON WAS CLICKED AND ACT ACCORDINGLY

   	% IF LEFT MOUSE THEN RECORD THE POINT 
   	% STORE THE CO-ORDINATES AND RESET AXIS  IF REQUIRED
   	if strcmp(get(gcf,'selectiontype'),'normal'),
      
      	
   	   % ENTER THE X AND Y COORDINATES 
      	current(1) = point(1);
      	current(2) = point(3);

	      % SAVE THE NEW ZOOM PARAMETERS
	     	set(get(object_selected,'zlabel'),'userdata',[current count Xrecall Yrecall]);
		
			% EXTRACT THE ZOOM CONDITION 
		   zoomtype = get(findobj(gcf,'tag','zoommenu'),'userdata');

         % MAKE SURE LINE COLOR IS DIFFERENT FROM AXES BACKGROUND
         axes_color = get(gca,'color');
			if axes_color == [1 1 1];
				line_color = [1 0 0];
			elseif axes_color == [ 0 0 0]
				line_color = [1 0 0];
			else
	         line_color = [1 1 1] - axes_color;
   		end
      
			% PLOT LINE
			if strcmp(zoomtype,'xzoom')

				delete(findobj(gca,'tag','l1')),	
				delete(findobj(gca,'tag','l2')),
				p = get(gca,'currentpoint');
				y = get(gca,'YLim');
				pa = get(gca,'position');
				l1 = line([p(1) p(1)], [y(1) y(2)],'tag','l1','erasemode','xor','linestyle',':','color',line_color,'linewidth',.1);	
            l2 = line([p(1) p(1)], [y(1) y(2)],'visible','off','erasemode','xor','linestyle',':','tag','l2','color',line_color,'linewidth',.1);
            drawnow
				set(gcf,'windowbuttonmotionfcn','pczoom(''xmotionfcn'')');	

			elseif strcmp(zoomtype,'yzoom')
				delete(findobj('tag','l1')),
				delete(findobj('tag','l2')),		
				p = get(gca,'currentpoint');
				x = get(gca,'XLim');
				pa = get(gca,'position');,
				l1 = line([x(1) x(2)],[p(3) p(3)],'tag','l1','erasemode','xor','linestyle',':','color',line_color,'linewidth',.01);
				l2 = line([x(1) x(2)],[p(3) p(3)], 'visible','off','erasemode','xor','linestyle',':','tag','l2','color',line_color,'linewidth',.01);
				set(gcf,'windowbuttonmotionfcn','pczoom(''ymotionfcn'')');

			elseif strcmp(zoomtype,'xyzoom')
				delete(findobj(gcf,'tag','l1')),	
				delete(findobj(gcf,'tag','l2')),
				p = get(gca,'currentpoint');
				pa = get(gca,'position');
				h1 = line([p(1) p(1) p(1) p(1) p(1)],[p(3) p(3) p(3) p(3) p(3)],'tag','l1','erasemode','xor','linestyle',':','color',line_color,'linewidth',.01);
			   set(gcf,'windowbuttonmotionfcn','pczoom(''xymotionfcn'')');	
			end	
		
			set(gcf,'windowbuttonupfcn','pczoom(''buttonup'')')

		% IF RIGHT MOUSE BUTTON CLICKED
   	% THEN LOOK UP THE LAST ZOOM CO-ORDINATES
   	% RESET THE AXIS TO THE LAST SAVED SET
   	% IN THE RECALL LIST AND DECREMENT THE COUNTER
   	else 
			set(gcf,'windowbuttonupfcn','');
			set(gcf,'windowbuttonmotionfcn',get(findobj(gcf,'tag','close'),'userdata'));
      	zoom_parameters = get(get(object_selected,'zlabel'),'userdata');
      	if count > 1,
         	count = count-1;
      	else,
        	 	count = 1;
      	end, 
	      Xrecall = Xrecall(1:2*count);
   	   Yrecall = Yrecall(1:2*count);
	      set(object_selected,'Xlim',Xrecall(2*count-1:2*count));
	      set(object_selected,'Ylim',Yrecall(2*count-1:2*count)); 
   	   set(get(object_selected,'zlabel'),'userdata',[current count Xrecall Yrecall]);
		end
	end	
	
elseif strcmp(option,'buttonup')
		
	% FIND OBJECT SELECTED
   object_selected = get(gcf,'currentobject');

	% IF IT IS AN AXES OR CHILD OF AN AXES 
  	% THEN DO THE ZOOM THING OTHERWISE DO NOTHING
   if strcmp(get(object_selected,'type'),'axes') |...
      strcmp(get(get(object_selected,'parent'),'type'),'axes')
	
      % IF OBJECT IS  A CHILD OF AXES SET OBJECT TO PARENT
		if strcmp(get(get(object_selected,'parent'),'type'),'axes')
			object_selected = get(object_selected,'parent');
      end

		% GET CURRENT POINT WHEN BUTTON RELEASED

		point = get(object_selected,'CurrentPoint');
      % GET THE ZOOM PARAMETER DATA 
   	zoom_parameters = get(get(object_selected,'zlabel'),'userdata');
   	

		
   	% EXTRACT THE VARIOUS PARAMETERS
   	count = zoom_parameters(5);
   	current = zoom_parameters(1:4);
   	Xrecall = zoom_parameters(6:5+2*count);
   	Yrecall = zoom_parameters(6+2*count:5+4*count);

      % ENTER X AND Y COORDINATES
	   current(3) = point(1);
   	current(4) = point(3);

	   %SORT THE CURRENT ZOOM POINTS IN ASCENDING ORDER
   	% AS REQUIRED BY 'XLIM' AND 'YLIM' PROPERTIES 
      current([1 3]) = sort(current([1 3]));
      current([2 4]) = sort(current([2 4]));
	
		% EXTRACT THE ZOOM CONDITION 
	   zoomtype = get(findobj(gcf,'tag','zoommenu'),'userdata');

		% CHECK FOR COINCIDENT POINTS
		if ~((strcmp(zoomtype,'xzoom') & current(1) == current(3))...
			 |(strcmp(zoomtype,'yzoom') & current(2) == current(4))...
			 |(strcmp(zoomtype,'xyzoom') & any(current([1 2]) ==current([3 4]))))
     		% INCREMENT THE ZOOM SELECTED COUNTER
     		count = count+1;

     

     		% ZOOM ACCORDINGLY APPENDING THE SELECTED 
     	   % ZOOM CO-ORDINATES TO THE RECALL LIST
		 	  	if strcmp(zoomtype,'xzoom'),  
		
			   % SET THE NEW X LIMITS					
     			set(object_selected,'Xlim',current([1 3]));
		
			

   	   	% APPEND THE NEW X-ZOOM COORDINATES TO THE RECALL LIST
        		Xrecall = [Xrecall current([1 3])];

	     		% BUT RETAIN THE OLD Y LIMITS FOR THE APPENDED COORDINATES
   	  		Yrecall = [Yrecall Yrecall(2*count-3:2*count-2)];

				

     		   % SIMILARLY FOR THE OTHER TWO OPTIONS
	  	   elseif strcmp(zoomtype,'yzoom'),
		
   	  	   set(object_selected,'Ylim',current([2 4]));

					
      	 	Xrecall = [Xrecall Xrecall(2*count-3:2*count-2)];
      		Yrecall = [Yrecall current([2 4])];
			
				
   		else
         	set(object_selected,'Xlim',current([1 3]));
         	set(object_selected,'Ylim',current([2 4]));  
				
         	Xrecall = [Xrecall current([1 3])];
         	Yrecall = [Yrecall current([2 4])];
								
			end
			% RESET THE FLAGS DENOTING HOW MANY POINTS 
   		% TO BE COLLECTED FOR NEXT ZOOM
   		% STORE THE COUNTER AND SAVE ZOOM PARAMETERS
   		set(get(object_selected,'zlabel'),'userdata',[current count Xrecall Yrecall]);
			set(gcf,'windowbuttonmotionfcn',get(findobj(gcf,'tag','close'),'userdata')); 
		else
			error_handle = errordlg('One or both of x and y limits are identical start selection again',...
								'Zoom warning');			
			set(error_handle,'windowstyle','modal');
			set(get(object_selected,'zlabel'),'userdata',[current count Xrecall Yrecall]); 
		end
		delete(findobj('tag','l1')),
		delete(findobj('tag','l2')),			
	end	  	

% IF RESET THEN RESET ZOOM PARAMETERS TO THE ORIGINAL
% AND RESET THE AXIS TO THE ORIGINAL SETTINGS	
elseif strcmp(option,'reset')
	
   set(findobj('tag','xzoom'),'enable','on'	)
	set(findobj('tag','yzoom'),'enable','on'	)	
	set(findobj('tag','xyzoom'),'enable','on'	)
	set(findobj('tag','holdbutton'),'label','Pause')	
   set(findobj('tag','holdbutton'),'enable','on')

	% GET THE ZOOM PARAMETER DATA 
   zoom_parameters = get(get(gca,'zlabel'),'userdata');   
   if ~isempty(zoom_parameters)
		count = zoom_parameters(5);
	  	current = zoom_parameters(1:4);
  	 	Xrecall = zoom_parameters(6:5+2*count);
	   Yrecall = zoom_parameters(6+2*count:5+4*count);
   	set(gca,'Xlim',Xrecall(1:2));
   	set(gca,'Ylim',Yrecall(1:2));	
   	count = 1;     
  	   current = [0 0 0 0];
   	Xrecall = Xrecall(1:2);
   	Yrecall = Yrecall(1:2);
   	set(get(gca,'zlabel'),'userdata',[current count Xrecall Yrecall]);
   else
      % MUST HAVE JUST REDRAWN
      % DO NOTHING
      ;
   end

% IF FINISHED DELETE THE MENUS
% CLEAR THE USERDATA FOR THE AXES
% SET WINDOWBUTTONDOWNFCN TO ORIGINAL

elseif strcmp(option,'finish')
	%RESET THE WINDOW BUTTON FUNCTIONS 
   wbd_old = get(findobj(gcf,'tag','holdbutton'),'UserData');
	wbu_old = get(findobj(gcf,'tag','Reset'),'UserData');
   wbm_old = get(findobj(gcf,'tag','close'),'UserData');

   ch = get(gcf,'ch');
   for n = 1:length(ch)
      if strcmp(get(ch(n),'type'),'axes'),
         set(get(ch(n),'zlabel'),'userdata',[]);
      elseif strcmp(get(ch(n),'type'),'uimenu') 	
      	if strcmp(get(ch(n),'label'),'Zoom Options')
	         delete(ch(n))
			end
      end
   end
	set(gcf,'WindowButtondownFcn',wbd_old)
	set(gcf,'WindowButtonUpFcn',wbu_old)
   set(gcf,'WindowButtonMotionFcn',wbm_old)
% IF PAUSING OR RESTARING ZOOM THEN DISABLE OR ENABLE MENUS
elseif strcmp(option,'pause')
	holdbutton = findobj(gcf,'tag','holdbutton');
   zoomstate = get(holdbutton,'label');
		
   if strcmp(zoomstate,'Pause')
		%buttonstring = get(gcf,'windowbuttondownfcn');	
      %set(holdbutton,'userdata',buttonstring);
		set(gcf,'WindowButtonDownfcn',get(findobj(gcf,'tag','holdbutton'),'UserData'));
		set(gcf,'WindowButtonUpFcn',get(findobj(gcf,'tag','Reset'),'UserData'));
		set(gcf,'WindowButtonMotionFcn',get(findobj(gcf,'tag','close'),'UserData'));
		set(holdbutton,'label','Restart')
		set(gcf,'pointer','arrow');
		set(findobj(gcf,'tag','xzoom'),'enable','off')
		set(findobj(gcf,'tag','yzoom'),'enable','off')
		set(findobj(gcf,'tag','xyzoom'),'enable','off')	
   elseif strcmp(zoomstate,'Restart')
		set(holdbutton,'label','Pause')
		set(findobj(gcf,'tag','xzoom'),'enable','on')
		set(findobj(gcf,'tag','yzoom'),'enable','on')
		set(findobj(gcf,'tag','xyzoom'),'enable','on')
		zoomstring = get(findobj(gcf,'tag','zoommenu'),'userdata');
		if strcmp(zoomstring,'xzoom')|strcmp(zoomstring,'yzoom')|strcmp(zoomstring,'xyzoom')
			set(findobj(gcf,'tag',zoomstring),'enable','off')
			set(gcf,'WindowButtonDownFcn','pczoom(''WindowButtonDown'')');
			set(gcf,'windowButtondUpFcn','');
			set(gcf,'windowButtonMotionFcn','');
		end
   end
elseif strcmp(option,'xmotionfcn')
	l2 = findobj(gca,'tag','l2');
	set(l2,'visible','on');
   p = get(gca,'currentpoint');
   set(l2,'Xdata',[p(1) p(1)]);
elseif strcmp(option,'ymotionfcn')
	l2 = findobj(gcf,'tag','l2');
	set(l2,'visible','on'),
	p = get(gca,'currentpoint');
	set(l2,'Ydata',[p(3) p(3)]);
elseif strcmp(option,'xymotionfcn')
	l1 = findobj('tag','l1');
	p = get(gca,'currentpoint');
	X = get(l1,'XData');
	Y = get(l1,'YData');
	if ~isempty(X) & ~isempty(Y),
		set(l1,'Xdata',[X(1) p(1) p(1) X(1) X(1)]);
		set(l1,'Ydata',[Y(1) Y(1) p(3) p(3) Y(1)]);
	end,
end   




