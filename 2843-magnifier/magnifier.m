function magnifier
% MAGNIFIER - Pixel Magnification for any graphic.
%
% The figure window created by the MAGNIFIER command will display a
% magnification of pixels of the area under the mouse.  To use it,
% click in the MAGNIFIER window, and drag the mouse to the area of
% interest.

% Written by Eric Ludlam <eludlam@mathworks.com>
% Copyright 2002 The MathWorks Inc

    
  ad.f=figure('renderer','painters','menubar','none',...
              'busyaction','cancel','doublebuffer','off','tag','magnifier',...
              'name','Magnifier','numbertitle','off');
  ad.a=axes('parent',ad.f);

  f=getframe(ad.f, [ get(ad.f,'currentpoint') 100 100 ] );
  ad.i = image(f.cdata,'parent',ad.a,'erasemode','none');
  set(ad.a, 'color','none','xticklabel',[],'yticklabel',[],'box','on',...
             'position',[.05 .05 .9 .9],'layer','bottom');
  
  title('Click and drag to magnify');
  set(ad.f,'windowbuttondownfcn',@magnifybuttondown);
  set(ad.f,'windowbuttonupfcn',@magnifybuttonup);
  
  set(ad.f ,'handlevisibility','callback');
  setappdata(ad.f,'magnifier',ad);

function magnifymotion(a,b)

  global inmotion;
  
  if isempty(inmotion)
  
    inmotion = 1;
    
    ad=getappdata(a,'magnifier');
    cp = get(ad.f,'currentpoint');

    f = getframe(ad.f, [ cp-50 100 100 ]);
  
    set(ad.i,'cdata',f.cdata);
    
    inmotion = [];
    
  end

function magnifybuttondown(a,b)
% Button down function in the magnifier
  
  ad=getappdata(a,'magnifier');
  ad.down = 1;
  set(ad.f,'windowbuttonmotionfcn',@magnifymotion)
  setappdata(ad.f,'magnifier',ad);

  
function magnifybuttonup(a,b)
  
  ad=getappdata(a,'magnifier');
  ad.down=0;
  set(ad.f,'windowbuttonmotionfcn',[])
  setappdata(ad.f,'magnifier',ad);

  