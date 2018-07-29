function [] = starviewer(action);
% This a a night sky viewer in a simple implementation.
% Click-and-drag to dynamically rotate the sky.
% Green line = horizon, Blue line = Galactic Equator,
% Yellow line = Ecliptic.
% To slow down motion, change the embedded dumb counter in the 
% 'motion' section.
%
% Mike Hanchak, Dayton, OH, USA
% 8/26/03

if nargin < 1,
   action = 'build';
end

% SwitchYard logic follows...
switch action
case 'build'
   
   if isempty(which('bsc2.txt')),
      errordlg('You need the bsc2.txt file to run this program.');
      
   end
      
   if isempty(findobj('tag','sky'))
      www = figure('tag','sky');
   else
      www = findobj('tag','sky');
      figure(www);
      clf
   end
   set(www,'position',[25   75   600   500],'color',[0 0 0],'name',...
      'StarViewer ver. 1.0 - Click and Drag to dynamically rotate.');
   
   % set viewing latitude on Earth
   lat = (90-40)*pi/180;
   latmat = [1 0 0 ; 0 cos(lat) -sin(lat); 0 sin(lat) cos(lat)];
   
   % plot celestial sphere
   [X Y Z] = sphere(24);
   % reshape sphere data for easier manipulation and remove extra lines
   all = [reshape(X,1,625) reshape(X',1,625);...
         reshape(Y,1,625) reshape(Y',1,625);...
         -reshape(Z,1,625) reshape(Z',1,625)];
   for i = 1:2:24
      all(3,25*i+1:25*i+25)=fliplr(all(3,25*i+1:25*i+25));
   end
   
   celvec = latmat*all;
   
   cel_sphere = plot3(celvec(1,:),celvec(2,:),celvec(3,:));
   set(cel_sphere,'color',[.3 .3 .3]);
   hold on
   
   % plot celestial equator
   rad = 1;%.98;
   th = linspace(0, 2*pi,25);
   x = rad*cos(th);y = rad*sin(th);
   temp1 = latmat*[x;y;zeros(1,length(x))];
   cel_equ = plot3(temp1(1,:),temp1(2,:),temp1(3,:));
   set(cel_equ,'color',[0 0 .8]);%,'linewidth',2);
   
   % plot ecliptic
   tilt = 23.5*pi/180;
   temp = latmat*[1 0 0;0 cos(tilt) -sin(tilt);0 sin(tilt) cos(tilt)]...
      *[x;y;zeros(1,length(x))];
   ecl = plot3(temp(1,:),temp(2,:),temp(3,:));
   set(ecl,'color',[.8 .8 0]);
   
   % Plot various text objects
   aaa(1) = text(rad,0 ,0 ,'0h RA, 0.0 D');
   aaa(2) = text(-rad,0 ,0 ,'12h RA, 0.0 D');
   aaa(3) = text(0,-1,0,'N');
   aaa(4) = text(0,1,0,'S');
   aaa(5) = text(1,0,0,'W');
   aaa(6) = text(-1,0,0,'E');
   set(aaa,'color','white','fontsize',8);
   
   % plot horizon
   plot(x,y,'g-');
   
   % plot stars from Yale Bright Star Catalog v5, J2000 locations.
   stardata = dlmread('bsc2.txt','\t',1,0);
   %stardata = sortrows(stardata(:,1:3),3);
   ras = stardata(:,1)';
   decs = stardata(:,2)';
   mags = stardata(:,3)';
   vecs = [cos(ras).*cos(decs);
      sin(ras).*cos(decs);
      sin(decs)];
   vecs = latmat*vecs;
   stars(1) = plot3(vecs(1,1:800),vecs(2,1:800),vecs(3,1:800),'wo');
   %stars = plot3(vecs(1,:),vecs(2,:),vecs(3,:),'w.');
   set(stars(1),'markersize',2.5,'markerfacecolor',[1 1 1]);
   stars(2) = plot3(vecs(1,801:end),vecs(2,801:end),vecs(3,801:end),'wo');
   set(stars(2),'markersize',.5,'markerfacecolor',[1 1 1]);
   
   
   % camera stuff
   axis off
   camva(45)
   camtarget([1 0 0])
   campos([0 0 0])
   
   rdata.oldpt = [];
   rdata.coor = [0 0];
   set(gca,'userdata',rdata);
   
   hdata.cel_sphere = cel_sphere;
   hdata.ecl = ecl;
   hdata.aaa = aaa;
   hdata.stars = stars;
   hdata.latmat = latmat;
   set(gcf,'userdata',hdata,'renderer','zbuffer');
   
   move = 0;
   qqq = uicontrol('units','norm','position',[.01 .01 .15 .05],...
      'string','toggle motion','tag','move',...
      'userdata',move,'callback','starviewer(''moveit'')');
   uicontrol('units','norm','position',[.18 .01 .1 .05],...
      'string','reset','callback','starviewer;');
   uicontrol('units','norm','position',[.9 .01 .09 .05],...
      'string','quit','callback','close;');
     
   rot3d_sky;
   
case 'moveit'
   move=get(findobj('tag','move'),'userdata');
   if move==0, move=1; else, move=0; end;
   set(findobj('tag','move'),'userdata',move);
   starviewer('motion');
      
case 'motion'
   hdata = get(gcf,'userdata');
   cel_sphere = hdata.cel_sphere;
   ecl = hdata.ecl;
   aaa = hdata.aaa;
   stars = hdata.stars;
   latmat = hdata.latmat;
   
   % moves the stars
   phi = -.001;
   rotate = [cos(phi) -sin(phi) 0;sin(phi) cos(phi) 0;0 0 1];
   move = get(findobj('tag','move'),'userdata');
   
   while move ==1;
      x = get(cel_sphere,'xdata');
      y = get(cel_sphere,'ydata');
      z = get(cel_sphere,'zdata');
      temp = latmat*rotate*inv(latmat)*[x;y;z];
      set(cel_sphere,'xdata',temp(1,:));
      set(cel_sphere,'ydata',temp(2,:));
      set(cel_sphere,'zdata',temp(3,:));
      
      x = get(ecl,'xdata');
      y = get(ecl,'ydata');
      z = get(ecl,'zdata');
      temp = latmat*rotate*inv(latmat)*[x;y;z];
      set(ecl,'xdata',temp(1,:));
      set(ecl,'ydata',temp(2,:));
      set(ecl,'zdata',temp(3,:));
      
      x = get(aaa(2),'position')';
      temp = latmat*rotate*inv(latmat)*x;
      set(aaa(2),'position',temp');
      
      x = get(aaa(1),'position')';
      temp = latmat*rotate*inv(latmat)*x;
      set(aaa(1),'position',temp');
      
      x = get(stars(1),'xdata');
      y = get(stars(1),'ydata');
      z = get(stars(1),'zdata');
      temp = latmat*rotate*inv(latmat)*[x;y;z];
      set(stars(1),'xdata',temp(1,:));
      set(stars(1),'ydata',temp(2,:));
      set(stars(1),'zdata',temp(3,:));
      
      x = get(stars(2),'xdata');
      y = get(stars(2),'ydata');
      z = get(stars(2),'zdata');
      temp = latmat*rotate*inv(latmat)*[x;y;z];
      set(stars(2),'xdata',temp(1,:));
      set(stars(2),'ydata',temp(2,:));
      set(stars(2),'zdata',temp(3,:));
      
      drawnow          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      for jj = 1:50000 %%%%%%%%%%%%%%%%%% change this to change speed %
      end              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      move = get(findobj('tag','move'),'userdata');
      if isempty(move)
         break;
      end
      
   end
   
   
case 'down'
   rot3d_sky('down');
case 'up'
   rot3d_sky('up');
case 'rot'
   rot3d_sky('rot');
case 'zoom'
   rot3d_sky('zoom');
case 'off'
   rot3d_sky('off');
otherwise
   disp('hmmmm.');   
end


function rot3d_sky(huh)

% simpiflied version of view3d
% only has xy rotation and zoom
if nargin<1
   set(gcf,'WindowButtonDownFcn','starviewer(''down'')');
   set(gcf,'WindowButtonUpFcn','starviewer(''up'')');
   set(gcf,'WindowButtonMotionFcn','');
   axis vis3d
else
   
   switch huh
   case 'down'
      if strcmp(get(gcf,'SelectionType'),'normal')
         set(gcf,'WindowButtonMotionFcn','starviewer(''rot'')');
      elseif strcmp(get(gcf,'SelectionType'),'alt')
         set(gcf,'WindowButtonMotionFcn','starviewer(''zoom'')');
      elseif strcmp(get(gcf,'SelectionType'),'open') %zoom out fully
         set(gca,'cameraviewangle',55);
         %   temp1 = get(gca,'currentpoint');
         %   temp1 = (temp1(1,:) + temp1(2,:))/2; % average points
         %   camtarget([temp1]);
      end
      rdata = get(gca,'userdata');
      rdata.oldpt = get(0,'PointerLocation');
      set(gca,'userdata',rdata);
   case 'up'
      set(gcf,'WindowButtonMotionFcn','');
   case 'rot'
      deg2rad = pi/180;
      rad2deg = 180/pi;
      
      rdata = get(gca,'userdata');
      
      oldpt = rdata.oldpt;
      newpt = get(0,'PointerLocation');
      dx = (newpt(1) - oldpt(1))*.1;
      dy = (newpt(2) - oldpt(2))*.1;
      
      coor = rdata.coor;
      
      theta = coor(1) + dx;
      phi = coor(2) - dy;
      
      if phi >= 85
         phi = 85;
      elseif phi<= -85
         phi = -85;
      end
      
      newtarg = [cos(theta*deg2rad)*cos(phi*deg2rad), ...
            sin(theta*deg2rad)*cos(phi*deg2rad), sin(phi*deg2rad)];
      set(gca,'cameratarget', newtarg);
      
      rdata.oldpt = newpt;
      rdata.coor = [theta phi];
      set(gca,'userdata',rdata);
   case 'zoom'
      rdata = get(gca,'userdata');
      oldpt = rdata.oldpt;
      newpt = get(0,'PointerLocation');
      dy = (newpt(2) - oldpt(2))/abs(oldpt(2));
      oldva = get(gca,'cameraviewangle');
      newva = oldva - 10*dy;
      if newva>=55,
         newva = 55;
      elseif newva<5
         newva = 5;
      end
      set(gca,'cameraviewangle',newva);
      rdata.oldpt = newpt;
      set(gca,'userdata',rdata);
      
   case 'off'
      set(gcf,'WindowButtonDownFcn','');
      set(gcf,'WindowButtonUpFcn','');
      set(gcf,'WindowButtonMotionFcn','');
   end
   
end
