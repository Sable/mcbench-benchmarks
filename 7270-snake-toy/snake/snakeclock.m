function snakeclock()
% SNAKECLOCK - Create a clock using the snake toy.
  
% Copyright (C) 2005-2011 The MathWorks Inc.
  
  figure('units','norm','outerposition',[0 .5 1 .5],'renderer','o')
  setappdata(gcf,'noorbit',true);
  setappdata(gcf,'oncestepsize',10);

  %colonax = axes('pos',[0 0 1 1],'vis','off');
  xlim([0 1])
  ylim([0 1])
  line([ .35 .35 .66 .66],...
       [ .4  .6  .4  .6],...
       'marker','o','markersize',10,...
       'markerfacecolor','r','markeredgecolor','b',...
       'linestyle','none');
  
  digit([  0 0 .21 1],'hourmajor');
  digit([.15 0 .21 1],'hourminor');

  digit([.33 0 .21 1],'minmajor');
  digit([.48 0 .21 1],'minminor');
  
  digit([.66 0 .21 1],'secmajor');
  digit([.83 0 .21 1],'secminor');
  
  % Optimize the snakes
  delete(findobj(gcf,'type','patch','facecolor','none'));
  
  ts = datestr(now,'HH:MM:SS PM');

  applytime(ts,true);
  
  while true
    
    newts = datestr(now,'HH:MM:SS PM');
    
    if strcmp(newts,ts)
      pause(.25)
    else
      applytime(newts,false);
    end
    
    ts = newts;
  end
  
  
  function applytime(ts, speed)

    dig1 = str2double(ts(1));
    
    if isempty(dig1)
      dig1 = 0;
    end
    
    dig(1)=dig1;
    dig(2)=str2double(ts(2));
    dig(3)=str2double(ts(4));
    dig(4)=str2double(ts(5));
    dig(5)=str2double(ts(7));
    dig(6)=str2double(ts(8));

    
    ax(1) = getappdata(gcf,'hourmajor');
    ax(2) = getappdata(gcf,'hourminor');
    ax(3) = getappdata(gcf,'minmajor');
    ax(4) = getappdata(gcf,'minminor');
    ax(5) = getappdata(gcf,'secmajor');
    ax(6) = getappdata(gcf,'secminor');
    
    for i=1:6
      sn(i,:) = getappdata(ax(i),'snake');
    end
    
    
    if speed
      for i=1:6
        setnum(sn(i,:),dig(i),speed);
      end
    else
      for i=1:6
        [ yr(i) zr(i) rv(i,:) ] = getnum(dig(i));
      end
      setallnums(sn,rv,yr,zr);
    end

  end
  
  function digit(pos,name)
    ax = axes('units','norm','pos',pos);
    numinax(ax);
    setappdata(gcf,name,ax);
  end

  function numinax(ax)
  % Create a number snake in axes AX.
    
    axes(ax);
    h = snaketoy(gcf);
    g = hgtransform('parent',ax);
    set(h(1),'parent',g);
    setappdata(ax,'last_yr',0);
    setappdata(ax,'last_zr',0);
    view(2);
    setnum(h,0,true);
    setappdata(ax,'snake',h);
  end

  function [yr zr rv] = getnum(num)
    
    n = pi/2;
    
    switch num
     case 0
      rv = [ 0 0 0 0 0 0 pi 0 0 0 0 ...
             pi 0 0 0 0 0 0 pi 0 0 0 0 pi];
      yr = 0;
      zr=-pi/4;
     case 1
      rv = [ 0 0 0 0 0 0 0 0 0 0 0 0 ...
             0 0 0 0 0 0 0 0 0 0 0 0];
      yr = 0;
      zr=-pi/4;
     case 2
      rv = [ 0 0 0 0 pi 0 0 0 0 pi 0 0 ...
             0 pi 0 0 0 0 pi 0 0 0 n 0];
      yr = 0;
      zr=pi/4;
     case 3
      rv = [ 0 0 0 0 pi 0 0 0 0 pi 0 pi...
             pi 0 pi 0 0 0 0 pi 0 0 0 0];
      yr = 0;
      zr=pi/4;
     case 4
      rv = [ 0 0 0 0 0 0 0 0 0 pi n 0 ...
             0 0 0 0 0 -n n 0 0 0 0 0];
      yr = 0;
      zr=(pi/4)*3;
     case 5
      rv = [ 0 0 0 0 pi 0 0 0 0 pi 0 0 ...
             0 pi 0 0 0 0 pi 0 0 0 n 0];
      yr = pi;
      zr=pi/4;
     case 6
      rv = [ 0 0 0 0 0 0 0 0 0 0 pi 0 ...
             0 0 0 pi 0 0 0 0 pi 0 0 0];
      yr = pi;
      zr=-pi/4;
     case 7
      rv = [ 0 0 0 0 0 0 0 0 -n pi/3 0 0 ...
             0 0 0 0 0 0 0 0 0 0 0 0];
      yr = 0;
      zr=pi/4;
     case 8
      rv = [ 0 0 pi 0 0 pi 0 0 pi 0 0 0 ...
             0 0 0 pi 0 0 pi 0 0 pi 0 pi];
      yr = 0;
      zr=pi/4;
     otherwise  % Make this be 9
      rv = [ 0 0 0 0 0 0 0 0 0 0 pi 0 ...
             0 0 0 pi 0 0 0 0 pi 0 0 0];
      yr = pi;
      zr=(pi/4)*3;
    end    
    
  end
    
  function setallnums(h,rv,yr,zr)
  % Set all the angles at once.

    for i=1:size(h,1)
      ax(i) = ancestor(h(i,1),'axes');
      g(i) = get(h(i,1),'parent');
      last_yr(i) = getappdata(ax(i),'last_yr');
      last_zr(i) = getappdata(ax(i),'last_zr');
    end

    setappdata(gcf,'snakeconfigcallback',@transformallparents);
    
    snaketoy(reshape(h,1,24*6),rv,'once');
    
    for i=1:size(h,1)
      setappdata(ax(i),'last_yr',last_yr(i));
      setappdata(ax(i),'last_zr',last_zr(i));
    end

    function transformallparents(handles,index,total)
    % Transform for HANDLES at index of total.
      
      if index == total
        yri = yr;
        zri = zr;
        last_yr = yr;
        last_zr = zr;
      else
        for i=1:6
          yri(i) = last_yr(i)+((yr(i)-last_yr(i))/total)*index;
          zri(i) = last_zr(i)+((zr(i)-last_zr(i))/total)*index;
        end
      end
      for i=1:6
        set(g(i),'matrix',makehgtform('yrotate',yri(i),...
                                      'zrotate',zri(i)));
      end
    end    
    
  end
  
  
  function setnum(h, num, speed)
  % Make snake H turn into the number NUM
  
    ax = ancestor(h(1),'axes');

    oldnum = getappdata(ax,'digit');
    
    if isempty(oldnum) || oldnum ~= num
      
      [ yr zr rv ] = getnum(num);
      
      g = get(h(1),'parent');
      last_yr = getappdata(ax,'last_yr');
      last_zr = getappdata(ax,'last_zr');
      
      setappdata(gcf,'snakeconfigcallback',@transformparent);

      %snaketoy(h,rv,'snap');

      if nargin==3 && speed
        snaketoy(h,rv,'snap');
        transformparent(h,1,1);
      else
        snaketoy(h,rv,'once');
      end

      setappdata(ax,'last_yr',yr);
      setappdata(ax,'last_zr',zr);
      setappdata(ax,'digit',num);
    end 

    function transformparent(handles,index,total)
    % Transform for HANDLES at index of total.
      
      if index == total
        yri = yr;
        zri = zr;
        last_yr = yr;
        last_zr = zr;
      else
        yri = last_yr+((yr-last_yr)/total)*index;
        zri = last_zr+((zr-last_zr)/total)*index;
      end
      set(g,'matrix',makehgtform('yrotate',yri,...
                                 'zrotate',zri));
    end
  
  end

  
end