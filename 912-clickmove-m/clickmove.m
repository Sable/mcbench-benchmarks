function clickmove(handle,opt,arg)
% function clickmove(handle,opt)
%
% This function allows the user to manipulate the 3-d view of a graph
% by point-click-drag.  The advantage this function has over similar
% ones is its highly intuitive interface, and the fact that the graph is
% displayed as it is pivoted, whereas in Matlab's built-in function it is
% simplified into a box.  In point of fact, I was unaware of the existence
% of Matlab's built-in 3d rotate function when I first wrote this; but I still
% like this one better.
%
% If the user does not provide a handle, the function will
% take the output of the gcf command (the current figure).  If
% there are no current figures, the function will create one.
%
% If the opt argument is empty or zero, the function will assign this 
% function to all the current axis' children as well; if it is non-zero
% the function will be only assigned to the current axis (In other words, 
% clicking on the AXES will invoke the function but clicking on the GRAPHIC
% objects will not)
%
% To turn the function off, enter the syntax
% clickmove(h,'off')
% where h is the figure handle to the axes or figure, or even graphic
% object for which you want to turn off clickmove.
% 
% Made by Brandon Kuczenski
% Updated / finalized 10-10-2001
% brandon_kuczenski@kensingtonlabs.com


if nargin==0
   handle=gcf;
   handletemp=gcf;
   opt=0;
else
	handletemp=handle;
   if ~ishandle(handle)
      warning('Input Parameter was not a handle ... selecting Current Figure')
      handle=gcf;
   end
   while handle~=floor(handle)
      % i.e the handle is not a figure but a child (figures are always integers)
      handle=get(handle,'parent');
      if strcmp(get(handle,'type'),'axes')
         handletemp=handle; % move up to axes - the lowest handle we can meaningfully 
         % deal with
      end
   end
   if nargin==1
      %i.e. no opt was provided
      opt=0;
   end
   
end

if ischar(opt)&strcmp(opt,'off')
   if ishandle(handletemp)
      % then because of line 39 we know it is an axes or a figure
      set(findobj(handletemp,'tag','clickmove'),'ButtonDownFcn','','tag','')
   else
      error('Can''t turn Clickmove off of a non-object')
   end
else
	if nargin<3; arg=0;end
	h=handle;
   switch arg
   case 1
%      disp('case 1')
      % THis is when the button is first pushed
      figure(h);
      a=gca;
      set(h,'windowbuttonmotionfcn',['clickmove(' ...
            num2str(h) ',[],2)']);
      set(h,'windowbuttonupfcn',['clickmove(' num2str(h) ',[],3)']);
      G.orig=get(a,'userdata');
      G.unit=get(gcf,'units');
      set(h,'units','normalized');
      G.pos=get(h,'currentpoint'); % [ X    Y ]
      G.view=get(a,'View');
      set(a,'Userdata',G);
   case 2
%      disp('case 2')
      % this is buttonmotionfcn while button is down
      % h is assumed to be the current figure, since it was clicked on
      figure(h);
      a=gca;
      G=get(a,'Userdata');
      H=get(h,'currentpoint'); %  [ X     Y ]
      th(1)=atan(5*(H(1)-0.5)) - atan(5*(G.pos(1)-0.5));
      th(2)=atan(5*(H(2)-0.5)) - atan(5*(G.pos(2)-0.5));
      th=th*180/pi;
      newview=mod(G.view-th,360);
%      disp(newview);

      set(a,'view',newview);
      
   case 3
%      disp('case 3')
      % this is buttonupfcn while button is down
      % Now we just have to clean up after ourselves
      figure(h);
      a=gca; % must be the CA because it was clicked on
      G=get(a,'userdata');
      set(h,'units',G.unit);
      set(h,'windowbuttonmotionfcn','');
      set(h,'windowbuttonupfcn','');
      set(a,'userdata',G.orig);
   otherwise
      
      %      disp('case 0')
      figure(h);
      set(h,'doublebuffer','on')
      a=gca;
      if ishandle(handletemp)&strcmp(get(handletemp,'type'),'axes')
         a=handletemp;
      end
      set(a,'Buttondownfcn',['clickmove(' num2str(h) ',[],1)'],'tag','clickmove')
      if opt==0
	      set(get(a,'children'),'Buttondownfcn', ...
            ['clickmove(' num2str(h) ',[],1)'],'tag','clickmove');
      end
      
   end

end % if 'off' ... else
