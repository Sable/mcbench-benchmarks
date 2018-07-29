function ncquiverref(x,y,u,v,units,reftype,refvec,veccol,cont)

% NCQUIVERREF: Vector plotting function for either map or Cartesian axes.
%
% function ncquiverref(x,y,u,v,units,reftype,refvec,veccol,cont)
%
% This function is a substitute for the standard version of quiver
% and quiverm available using a vanilla release of matlab. This version
% assumes a 2D vector field being plotted using a gridded flow field 
% from numerical models with a regular geometry. The function enables
% the scaling of vectors according to a reference vector plotted in the 
% lower right hand corner of the plot axes. The function works for both
% map and Cartesian axes and allows the color of vectors to be changed.
% 
% If a reference value is not provided, the reference value is calculated 
% by rounding the median or maximum lengths of the quiver vectors to the 
% first significant digit. Scaling of vectors still occurs even 
% if the reference vector plotting is switched off. This enables
% different subplots to share identical scaling so that the relative
% magnitude of vectors can be compared between subplots (provided they 
% share the same grid). 
%
% The function includes the ability to plot color vectors, all of equal
% length but color coded according to their magnitude. In this case, a 
% colorbar is provided, complete with units, and no scaling vector is 
% plotted.
%
% Input:
% x       - x-coordinate or latitude
%
% y       - y-coordinate or longitude
%
% u       - u-component (Cartesian +x-direction, map +longitude-direction)
%
% v       - v-component (Cartesian +y-direction, map +latitude-direction)
%
% units   - a string providing the units of the vector field.  This assumes
%           the default Tex interpreter is being used as set 
%           elsewhere using set(0,'DefaultTextInterpreter','tex').
%
% reftype - character variable specifying the type of reference vector.
%           Allowable values are 'median' for giving a reference
%           vector based on the median, or 'max' for giving the
%           reference vector based on the maximum.  This argument may 
%           be omitted with 'max' as the default. If reftype is entered 
%           as a number, then this is the value of the reference vector 
%           in the units of the data in u and v. If veccol is set to
%           'col', this argument has no effect and should be entered
%           only as a dummy argument.
%
% refvec  - logical that turns off or on the plotting of the reference
%           vector scale for plotting vectors.  The default is 'true'.
%
% veccol  - color of the vectors to be plotted.  This may either be in the
%           form of RGB or as a single letter, such as 'b' for blue
%           using standard Matlab color specifications. This may be set
%           to 'col' if the vectors are to be color coded by magnitude
%           instead of sized by magnitude. In this case, all vectors
%           have the same size based on the optimum value for the grid
%           provided, and a colorbar is provided to reference the values.
%
% cont    - contour levels to be used if color shading the vectors.  For
%           this to work, veccol='col', and as a result all vectors
%           are made of equal length but color coded according to their
%           magnitude. The contour levels must be non-zero, and must include
%           at least one value.   The values at the divider between
%           vector color categories.
%
% Output:
% Output is graphical to the current active figure axes. All vectors
% are centered on the grid points, rather than the starting point of the 
% vector being positioned on the grid point. This can easily be changed
% in the code if required, but is the preference of the author.
%
% Written by Andrew Roberts
% Naval Postgraduate School
% Tested using MATLAB Version 7.11.0.584 (R2010b)
%
% $Id: ncquiverref.m 254 2011-02-09 05:26:08Z aroberts $

% make sure the mapping toolbox is present
h=ver('map') ; if length(h)==0 ; error('Mapping toolbox not installed') ; end

% error checking of inputs
if nargin<4; error('Missing vector field input data'); end

% set default units
if nargin<5 ; units=''; end

% set default reftype value
if nargin<6 ; reftype='max' ; end

% default it to turn on the reference vector
if nargin<7 ; refvec=true ; end

% default vector color is blue
col=false;
if nargin<8 ; 
 veccol='b' ; 
elseif ischar(veccol) & strcmp(veccol,'col')
 col=true ;
 refvec=false;
 if nargin<9; error('No contour values provided'); end
end

% get current axis 
h=get(gcf,'CurrentAxes');

% use meshgrid if needed
sx=size(x); sy=size(y);
if (sx(1)==1 & sy(1)==1) | (sx(2)==1 & sy(2)==1);
 [x,y]=meshgrid(x,y);
elseif sx(1)==1 | sx(2)==1;
 error('Dimensions of x and y are inconsistent')
elseif sy(1)==1 | sy(2)==1;
 error('Dimensions of x and y are inconsistent')
elseif sx~=sy
 error('Dimensions of x and y are inconsistent')
end

% check sizes all agree in input data
if size(x)~=size(y); error('x and y sizes disagree'); end
if size(x)~=size(u); error('x and u sizes disagree'); end
if size(y)~=size(v); error('y and v sizes disagree'); end

% If plotting on a matlab map, determine if the axes are map or cartesian
% coordinates, and if the former calculate mapping to plot axis, and 
% then do vector field otherwise just plot the vector field.
if ismap(h)

 disp('Quivering on current map axes')

 % set lat and lon
 lat=x;
 lon=y;

 % get x and y location on the map
 sz=size(x);
 mstruct=gcm;
 [x,y] = mfwdtran(mstruct,lat,lon,h,'none');
 xz=size(x);
 if sz~=xz
  error('Change in size of x using mfwdtran. Try changing surface to none in the code')
 end

 % get angle on the map, but do not distort the length according to the projection
 % so that all vectors can use the same reference vector.  DO NOT project
 % the length of the vector to be different in x and y directions.
 [th,z] = cart2pol(u,v);
 [thproj,len] = vfwdtran(mstruct,lat,lon,90*ones(size(lat)));
 [u,v] = pol2cart(th+deg2rad(thproj),z);

elseif isempty(h)

  disp('Creating new Cartesian axes')

  % get the magnitude of the vector field
  [th,z] = cart2pol(u,v);

  % set up axes
  axis([min(x(:)) max(x(:)) min(y(:)) max(y(:))])
  axis xy;
  axis tight;
  set(gca,'Layer','bottom');
  box on;

else

 disp('Quivering on current Cartesian axes')

 % get the magnitude of the vector field
 [th,z] = cart2pol(u,v);

end

% remove masked grid points from the input by filling coordinates with NaN;
x(isnan(u))=NaN;
y(isnan(u))=NaN;

% Scale the vectors according to the reference arrow vector length based on
% the mean distance between grid points. This is a good measure, as it remains 
% constant for multiple plots using the same grid with different values.
x1=abs(diff(x')); x2=abs(diff(x)); 
y1=abs(diff(y')); y2=abs(diff(y));
[th,z1] = cart2pol(x1,y1); [th,z2] = cart2pol(x2,y2);
scalelength=min(mean(z1(~isnan(z1))),mean(z2(~isnan(z2))));

% Calculate reference vector length based on rounded median
% or maximum value of plot.  The default is median based.
if isnumeric(reftype) & ~col
	disp('Calculating reference vector based on input number');
	refval=reftype;
elseif strcmp(reftype,'median') & ~col
	disp('Calculating reference vector based on median');
        z(z==0)=NaN;
	refval=median(z(~isnan(z)))
elseif strcmp(reftype,'max') & ~col
	disp('Calculating reference vector based on maximum');
	refval=max(z(~isnan(z)));
elseif ~col
	error('reftype must be either "max" or "median"');
else
	disp('Color vectors being used with constant length');
end

% Remove NaN values that will not be plotted
% and turn points into a row of coordinates
u=u(~isnan(x))';
v=v(~isnan(x))';
y=y(~isnan(x))';
x=x(~isnan(x))';

% Set arrow size (1= full length of vector)
arrow=0.40;

% set the length of the vectors to be constant and generate 
% a color for each particular vector
if col 

 % get the magnitude and direction of each vector
 [th,z] = cart2pol(u,v);

 % check cont has at least one value
 if isempty(cont) | length(cont)==0 | any(cont==0)
  error('cont must be non-zero and contain at least one value')
 end

 % arrange contour values from min to max, and 
 % add an extra value for the purpose of processing
 cont=sort(abs(cont));
 cont(end+1)=cont(end)+1;

 % set the colormap 
 hc=colormap(jet(length(cont)));

 for i=1:length(cont)

  if i==1
   mask=find(z<cont(i));
  elseif i==length(cont)
   mask=find(z>=cont(i-1));
  else
   mask=find(z<cont(i) & z>=cont(i-1));
  end

  % Center vectors over grid points
  [u,v] = pol2cart(th(mask),scalelength);
  xstart=x(mask)-0.5*u;
  xend=x(mask)+0.5*u;
  ystart=y(mask)-0.5*v;
  yend=y(mask)+0.5*v;

  % Get x coordinates of each vector plotted
  lx = [xstart; ...
       xstart+(1-arrow/3)*(xend-xstart); ...
       xend-arrow*(u+arrow*v); ...
       xend; ...
       xend-arrow*(u-arrow*v); ...
       xstart+(1-arrow/3)*(xend-xstart); ...
       repmat(NaN,size(xstart))];

  % Get y coordinates of each vector plotted
  ly = [ystart; ...
       ystart+(1-arrow/3)*(yend-ystart); ...
       yend-arrow*(v-arrow*u); ...
       yend; ...
       yend-arrow*(v+arrow*u); ...
       ystart+(1-arrow/3)*(yend-ystart); ...
       repmat(NaN,size(ystart))];

  % Plot the vectors
  line(lx,ly,'Color',hc(i,:));

 end

 % generate the colorbar and get its dimensions
 hcb=colorbar('peer',gca,'location','EastOutside');
 xlimcb=get(hcb,'xlim');
 ylimcb=get(hcb,'ylim');

 % initialize the cell array for the colorbar labels
 tickn=cell(1,length(cont)+1);

 for i=1:length(cont)

  % set lower and upper bounds on the y-axis of the colorbar
  ycb1=ylimcb(1)+(i-1)*(ylimcb(2)-ylimcb(1))/length(cont);
  ycb2=ylimcb(1)+(i)*(ylimcb(2)-ylimcb(1))/length(cont);

  % patch the color bar (this is required because of an error in the 
  % matlab postscript generator which becomes evident when trying to print)
  patch([xlimcb(1);xlimcb(1);xlimcb(2);xlimcb(2)],[ycb1;ycb2;ycb2;ycb1],...
        hc(i,:),'Parent',hcb);

  % set tick labels of colorbar
  tickn{i+1}=num2str(cont(i));

 end

 % Add exponent to colorbar if required and add units
 if max(abs(cont))>=10000 | max(abs(cont))<=1
   factor=fix(log10(max(abs(cont))))-1;
   for i=1:length(cont)-1
    tickn{i+1}=num2str(cont(i)/(10^factor));
   end
   text(xlimcb(1),ylimcb(1),{' ',['{\times} 10^{',num2str(factor),'} ',units]},...
        'Parent',hcb,...
        'HorizontalAlign','left','VerticalAlign','top')
 else
   text(xlimcb(1),ylimcb(1),{' ',units},...
        'Parent',hcb,...
        'HorizontalAlign','left','VerticalAlign','top')
 end

 % Set the upper tick to units and turn on the new labels
 tickn{end}='';
 tickn{1}='0';
 tickpos=ylimcb(1)+diff(ylimcb)*[0:length(cont)]/length(cont);
 set(hcb,'YTickLabel',tickn,'YTickMode','manual','YTick',tickpos)

 % Add up arrow for top of colorbar
 %text(xlimcb(2),ylimcb(2),[' $\uparrow$'],'Interpreter','LaTex','Parent',hcb,...
 %     'HorizontalAlign','left','VerticalAlign','top')

 yl=diff(ylimcb)*0.03;
 yt=ylimcb(2);
 ys=diff(ylimcb)*0.012;
 ya=yt-ys;
 yb=ylimcb(2)-yl;
 xc=xlimcb(2)+0.25*diff(xlimcb);
 xl=xc-ys; xr=xc+ys;
 line([xc xc xl xc xr],[yb yt ya yt ya],'color','k',...
      'Clipping','off','Parent',hcb,'linewidth',0.3)


else 

 % set scale value based on refval and scale length
 roundp=floor(log10(refval));
 refval=floor(refval/(10^roundp))*(10^roundp);
 scale=scalelength/refval;

 % Center vectors over grid points
 xstart=x-0.5*scale*u;
 xend=x+0.5*scale*u;
 ystart=y-0.5*scale*v;
 yend=y+0.5*scale*v;


 % Get x coordinates of each vector plotted
 lx = [xstart; x; ...
      xstart+(1-arrow/3)*(xend-xstart); ...
      xend-arrow*(scale*u+arrow*(scale*v)); ...
      xend; ...
      xend-arrow*(scale*u-arrow*(scale*v)); ...
      xstart+(1-arrow/3)*(xend-xstart); ...
      repmat(NaN,size(x))];

 % Get y coordinates of each vector plotted
 ly = [ystart; y; ...
      ystart+(1-arrow/3)*(yend-ystart); ...
      yend-arrow*(scale*v-arrow*(scale*u)); ...
      yend; ...
      yend-arrow*(scale*v+arrow*(scale*u)); ...
      ystart+(1-arrow/3)*(yend-ystart); ...
      repmat(NaN,size(y))];

 % Plot the vectors
 line(lx,ly,'Color',veccol);

end

% Draw the reference vector key at altitude 2 above the map and grid
if refvec

 % Get the reference text string, formatted to powers of ten if required
 if refval < 0.1 | refval > 100 
  factor=floor(log10(refval));
  reftext=[num2str(refval/(10^factor)),' \times 10^{',num2str(factor),'} ',units,' '];
 else
  reftext=[num2str(refval),' ',units,' '];
 end

 % Get the current axis limits
 xlim=get(gca,'xlim'); xp1=xlim(1); xp2=xlim(2);
 ylim=get(gca,'ylim'); yp1=ylim(1); yp2=ylim(2);

 % set padding around the reference vector
 padx=diff(xlim)/100; 
 pady=diff(ylim)/100;

 % Set x position of reference vector
 xend=xp2-padx;
 xstart=xend-scalelength;

 % Plot reference text in lower right hand corner
 ht=text(xstart,yp1+pady,reftext,'Visible','off','Parent',gca,'FontSize',8.5,...
        'VerticalAlignment','Bottom','HorizontalAlignment','Right');
 textextent=get(ht,'Extent');

 % Draw patch over area of vector key 
 xl=textextent(1)-padx;
 xr=xp2;
 yb=yp1;
 yt=textextent(2)+textextent(4)+pady;
 hp=patch([xl; xl; xr; xr],[yb; yt; yt; yb],[2; 2; 2; 2],'w',...
          'LineWidth',0.5,'Parent',gca);
 uistack(hp,'top');

 % Redraw reference text on top of patch
 ht=text(xstart,(yb+yt)/2,2.1,reftext,'Parent',gca,'FontSize',8.5,...
         'VerticalAlignment','Middle','HorizontalAlignment','Right');

 % Set y position of reference vector
 yend=textextent(2)+textextent(4)/2;
 ystart=yend;

 % Get x coordinates of reference vector plotted
 lx = [xstart; ...
      xstart+(1-arrow/3)*(xend-xstart); ...
      xend-arrow*scalelength; ...
      xend; ...
      xend-arrow*scalelength; ...
      xstart+(1-arrow/3)*(xend-xstart); ...
      NaN];

 % Get y coordinates of reference vector plotted
 ly = [ystart; ...
      ystart+(1-arrow/3)*(yend-ystart); ...
      yend+arrow*(arrow*scalelength); ...
      yend; ...
      yend-arrow*(arrow*scalelength); ...
      ystart+(1-arrow/3)*(yend-ystart); ...
      NaN];

 % Get z coordinates of reference vector
 lz = 2*ones(size(ly));

 % Plot the reference vector
 line(lx,ly,lz,'Color',veccol);

else

 disp('No reference vector is being plotted')

end

end % function

