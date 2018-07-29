function makekmz(img,lat,lon,varargin)
%
% function makekmz(img,lat,lon,opt,optval)
%
% utility routine to create a kmz Google Earth overlay file from 
% a rectangular image img with arbitrary north/south alignment 
% given corresponding  pixel lat/lon locations.  Uses optional 
% arguments to specify processing options.  Can automatically 
% segment the output image into smaller pieces for easier 
% display in GoogleEarth on small graphics memory machines.
% can embed rotated input image into lat/lon image array
%
% note: lat,lon arrays can be either 2x2 arrays whose corner values
% specify the locations of the corners of the img array OR lat and
% can be one entry for each pixel.  By convention, for a [N,M]=size(img)
% non=rotated image img(1,1) is at the north-most and west-most corner.  
% img(*,1) decreases in latitude.  img(1,*) increases in longitude.  
% The matlab displayed array (axis ij) thuss appear similar to 
% the GoogleEarth display when aligned with north upward.
%
% Unless specified options require one argument
%    opt  arg          function 
%  imname (text):      output file name .kmz extension added [default 'default']
%  alpha (arg):        use alpha array (may be converted to transparency if 
%                       cmap also specified, see notes) with values 0 or 1
%                       (arg=alpha_map which must be the same size as img)
%  RotAngle (none):    enable image rotation/embedding [default unset]
%  RotLatLon (int):    rotation flag: grid in northing/easting if one 
%                       grid in lat/lon if 0 [default 1
%  destdir (txt):      destination directory [default './']
%  scale (arg):        scale img (on argument formated as [max min])
%                       [default [min(min(img)) max(max(img))]
%  cmap (arg):         use color map cmap for image 256 entries with 
%                       [r g b] each 0..1 [default gray()]
%  forcegray:          force use of gray scale even if cmap specified
%                        [default unset]
%  fignum (int):       display final image in figure(fignum) [default none]
%  timecode (arg):     add time code to kmz (arg=[YYYY,MM,DD,hh,mm,ss])
%                       [default none]
%  placemark (2 args): add placemark (requires 2 args: name, [lon,lat,alt])
%                       can specify multiple placemarks [default none]
%  segment (none):     segment image into subimage tiles of maxsize 
%                       if set [default set]
%  nosegment (none):   prevent (override) image segmentation [default unset]
%  maxsize (int):      segment (tile) image size [default 1024]
%  background (int):   background color index used in rotation [default 0]
%  nameprefix (text):  initial text applied to image name in kmz [default '']
%  copyright (text):   include copyright information in kmz png image
%                        file(s) [default none]
%  comment (text):     include comment in kmz png image file(s) [default 'none']%  nameprefix (text):  prefix text to internal kmz image name [default 'none']
%  workdir (/tmp):     temporary work area [default '/tmp']
%  quiet (none):       progress output [default set]
%  debug (none):       enable debug output [default unset]
%
% Note: to handle transparency when cmap is specified (needed when RotAngle
% is specified or alpha is provided), the bottom value of cmap is used for
% indicating transparency of the image.  img value that map to bottom cmap
% value are converted to the second value of cmap.

% written by David Long  9 Dec 2011

% set default values for input args
destdir=pwd();    % default output in current directory
imname='default'; % default output file name
clear iscale;     % default auto scaling
clear cmap        % default use grayscale 
forcegray=0;      % default do not force grayscale
clear fignum      % default do not create matlab figure window
RotAngle=0;       % default no rotation
RotLatLon=1;      % default northing/easting rotation
clear alphaa;     % default no alpha channel
clear segment     % default always unsegmented
segment=1;        % default segmented if larger than maxsize
maxsize=1024;     % maximum image segment size recommended by Google Earth
clear timecode    % default no time code
clear background  % default transparent/black background
debugflag=0;      % default no debug output
quiet=1;          % default show status
nplacemarks=0;    % default no placemarks
placemarkname=[]; 
placemarkloc=[];
copyrightowner=' '; % default no copyright specified
comment=' ';      % default no comments added
nameprefix=[];    % default no prefix for image title
if filesep()=='/'
  tmp='/tmp';     % default temporary work directory (linux)
else
  tmp=pwd();      % default temporary work directory (non-linux)
end

% check for enough input arguments
if exist('img')~=1 || exist('lat')~=1 || exist('lon')~=1 
  error('*** at least three arguments are required for makekmz');
end

today=date();    % get today's date
copyright=sprintf('Copyright %s',today(8:11));

% decode optional arguments
% note: not checking of the validity of the argument values is done!
narg=length(varargin);
if narg>1
  k=1;
  while k<= narg
    str=char(varargin(k));
    switch str
     case 'alpha'
      k=k+1;
      if k<=narg
        alphaa=cell2mat(varargin(k));
      end
      if size(img)~=size(alphaa)
	disp('*** alpha array size does not match image array size, ignoring');
	clear alphaa
      end
     case 'RotAngle'
      RotAngle=1;
     case 'RotLatLon'
      k=k+1;
      if k<=narg
        RotLatLon=cell2mat(varargin(k));
      end      
     case 'imname'
      k=k+1;
      if k<=narg
        imname=char(varargin(k));
      end
     case 'cmap'
      k=k+1;
      if k<=narg
        cmap=cell2mat(varargin(k));
      end
     case 'forcegray'
      forcegray=1;
     case 'scale'
      k=k+1;
      if k<=narg
        iscale=cell2mat(varargin(k));
      end
     case 'destdir'
      k=k+1;
      if k<=narg
        destdir=char(varargin(k));
      end
     case 'fignum'
      k=k+1;
      if k<=narg
        fignum=cell2mat(varargin(k));
      end
     case 'placemark'
      k=k+1;
      nplacemarks=nplacemarks+1;
      if k<=narg
        placemarkname(nplacemarks,1:length(char(varargin(k))))=char(varargin(k));
      else
        placemarkname(nplacemarks+1,1:7)='unnamed';
      end
      k=k+1;
      if k<=narg
        tmpstr=cell2mat(varargin(k));
        if length(tmpstr)<3
          tmpstr(3)=0;
        end
        placemarkloc(nplacemarks,1:3)=tmpstr(1:3);
      else
        placemarkloc(nplacemarks,1:3)=[0 0 0];
      end
     case 'timecode'
      k=k+1;
      if k<=narg
        timecode=cell2mat(varargin(k));
      end
      if length(timecode)~=6
	disp('*** timecode needs 6 entries in genkmzRs2, ignored');
	clear timecode
      end
     case 'segment'
      segment=1;
     case 'nosegment'
      clear segment
     case 'maxsize'
      k=k+1;
      if k<=narg
       maxsize=cell2mat(varargin(k));
       if maxsize<10 | maxsize > 20000
	 maxsize=1024;
       end
       end
     case 'background'
      k=k+1;
      if k<=narg
        background=cell2mat(varargin(k));
      end
     case 'copyright'
      k=k+1;
      if k<=narg
        copyrightowner=char(varargin(k));
      end
     case 'comment'
      k=k+1;
      if k<=narg
        comment=char(varargin(k));
      end
     case 'nameprefix'
      k=k+1;
      if k<=narg
        nameprefix=char(varargin(k));
      end
     case 'workdir'
      k=k+1;
      if k<=narg
        tmp=char(varargin(k));
      end
     case 'quiet'
      quiet=0;
     case 'debug'
      debugflag=1;
    end
    k=k+1;
  end
end

% find lat/lon extent of image
North=max(max(lat));
South=min(min(lat));
West=min(min(lon));
East=max(max(lon));

% make sure input array is real
if isreal(img)
  val=img;
  val(isnan(val)==1)=0;  % remove any NaNs
else
  val=abs(img);
end

% set array scaling
% [minout to maxout] is converted to [0 256] in output image
if exist('iscale','var')==1 % use input
  minout=iscale(1);
  if length(iscale)<2
    maxout=max(max(val));
  else
    maxout=iscale(2);
  end
else  % autoscaling
  minout=min(min(val));
  maxout=max(max(val));
  if maxout==minout
    maxout=maxout+1;
  end
end

% output input args when debugging
if debugflag
  disp('makekmz optional args:');
  disp(sprintf(' destdir = %s',destdir));
  disp(sprintf(' imname = %s',imname));
  disp(sprintf(' image size = %d,%d',size(val)));
  if length(nameprefix)>0
    disp(sprintf(' nameprefix = "%s"',nameprefix));
  end
  if length(copyrightowner)>1
    disp(sprintf(' copyrightowner = %s',comment));
  end
  if length(comment)>1
    disp(sprintf(' image comment = %s',comment));
  end
  if RotAngle ~= 0
    disp(sprintf(' image rotation enabled RotAngle. RotLatLon = %d',RotAngle,RotLatLon));
  end
  if exist('iscale','var')==1
    disp(sprintf(' scaling = [%f %f]  input range = [%f %f]',iscale(1),iscale(2),min(min(val)),max(max(val))));
  else
    disp(sprintf(' scaling = auto = [%f %f]',minout,maxout));
  end
  if exist('cmap','var')==1
    disp(sprintf(' cmap specified in input'));
  else
    disp(' no colormap specified');
  end
  if forcegray==1
    disp(' forcegray flag set, cmap not used')
  end
  if exist('background','var')==1
    disp(sprintf(' background color index %d enabled',background))
  end
  if exist('fignum','var')==1
    disp(sprintf(' image displayed in figure(%d)',fignum));
  else
    disp(' no image display');
  end
  if exist('segment','var')==1
    disp(sprintf(' image segmentation to maxsize of %d enabled',maxsize))
  end
  if nplacemarks>0
    disp(sprintf(' Placemarks specified: %d',nplacemarks))
    for n=1:nplacemarks
      disp(sprintf('  Placemark %d name = "%s" location: lon = %f lat= % f alt= %f',...
      n,placemarkname(n,:),placemarkloc(n,1:3)));
    end
  end
  disp(sprintf(' South-North extent: %f %f',South,North));
  disp(sprintf(' West-East extent:   %f %f',West,East));
  disp(sprintf(' Temporary work directory: %s',tmp));
end

% test for force gray
if forcegray==1
  clear cmap
end

% check for background color.  This can be used for filling unused
% portions of rotated images
if exist('background','var')==1
else
  background=0;
end

% if image rotation is enabled, see if rotation required
if RotAngle ~= 0
  % note: location (end,end) is not used when rotating
  dely_y=lat(end,1)-lat(1,1);
  dely_x=lon(end,1)-lon(1,1);
  delx_y=lat(1,end)-lat(1,1);
  delx_x=lon(1,end)-lon(1,1);
  
  % based on rotation option, set rotation parameters
  if RotLatLon==1 % when grid is in northing, easting
    LatConv=1852.23*60.0;
    RefLat=lat(1,1);
    LonConv=LatConv*cos(RefLat*pi/180);
    theta=-atan2(dely_x*LonConv,dely_y*LatConv);
  else            % when grid is in lat, long
    theta=-atan2(dely_x,dely_y);
    LonConv=1; LatConv=1;
  end  
  % if rotation angle is small, do not rotate
  if abs(theta)<0.01 || abs(abs(theta)-pi)<0.01
    RotAngle=0;  % do not rotate image is not needed
  else
    RotAngle=theta;
  end
end

if RotAngle ~= 0 %% image rotation
  % if image rotation is required, the rotated image is embedded
  % in a larger image with similar effective resolution
  % nearest neighbor interpolation is used to fill larger image from
  % input image
  % note: to make the portions of the larger image transparent in the
  % final kmz, an alpha channel is generated if not already present

  ci=cos(RotAngle); si=sin(RotAngle);

  % choose the enclosing image resolution
  ressf=max(abs(ci),abs(si));
  ResE=ressf*(East-West)/max(size(val));
  ResN=ressf*(North-South)/max(size(val));
  Ea3= West:ResE:East;
  Na3=South:ResN:North;
  if debugflag
    disp(sprintf('Rotating image %f: %f',RotAngle*180/pi,1./ressf))
  end

  % to fill output pixels,  use inverse transformation assuming a uniform grid

  [Ny Nx]=size(val); % input image size
  Na3=fliplr(Na3);   % reverse Y (lat) axis
  out=zeros([length(Na3) length(Ea3)])+background; % default background
  alpha1=zeros([length(Na3) length(Ea3)]); % default transparent
  [Nyp Nxp]=size(out); % output image size

  % rotate image corners
  vx= ci*[delx_x dely_x]*LonConv+si*[delx_y dely_y]*LatConv;
  vy=-si*[delx_x dely_x]*LonConv+ci*[delx_y dely_y]*LatConv;
  iResE=Nx/vx(1);
  iResN=Ny/vy(2);
  clear vx vy
  
  % define inverse mapping of output pixels to input pixels
  % to do nearest neighbor interpolation
  [Y,X]=meshgrid(Na3,Ea3);
  Xp=round(( ci*(X-lon(1,1))*LonConv+si*(Y-lat(1,1))*LatConv)*iResE+0.5);
  Yp=round((-si*(X-lon(1,1))*LonConv+ci*(Y-lat(1,1))*LatConv)*iResN+0.5);
  ind=find(Xp>0&Xp<=Nx&Yp>0&Yp<=Ny);
  clear X Y

  % process only valid pixel locations  
  ind1=sub2ind(size(val),Yp(ind),Xp(ind));
  out(ind)=val(ind1);
  if exist('alphaa','var')
    alpha1(ind)=alphaa(ind1);  % valid image location
  else
    alpha1(ind)=1;  % valid image location
  end
  clear ind ind1 Xp Yp
  
  if debugflag || ~quiet
    disp(sprintf('Rotating and embedding image'))
    disp(sprintf(' Output image resolution in deg: ResE=%f ResN=%f Ang=%f',ResE,ResN,RotAngle*180/pi))
    disp(sprintf(' Input image size:  %d %d',size(val)));
    disp(sprintf(' Output image size: %d %d',size(out)));
  end
  
  if quiet
    disp(sprintf('Rotating and embedding image'))
    disp(sprintf(' Output image size: %d %d  Input size: %d %d',size(out),size(val)));
  end
    
  val=out; % new image arrays to display
  alphaa=alpha1;  
  East=max(Ea3); % use new values for precise pixel matching
  North=max(Na3);
  clear E3 N3 out alpha1

else % rotation not done

  % transpose arrays for display
  val=val'; % equivalent to rot90(flipud(val),-1);
  if exist('alphaa','var')
    alphaa=alphaa';
  end
end

% if figure display asked for, display matlab figure of image
if exist('fignum','var')==1
  figure(fignum);clf;
  if 1 % image displayed with lat/lon axes
    ResE=(East-West)/size(val,2);
    ResN=(North-South)/size(val,1);
    imagesc(West:ResE:East,South:ResN:North,rot90(val),[minout maxout]);
    axis xy
    xlabel('longitude');ylabel('latitude');
  else % image displayed in matlab image form
    imagesc(rot90(val),[minout maxout]);
    xlabel('col index');ylabel('row index');
  end
  colorbar;
  if exist('cmap','var')==1
    colormap(cmap);   % apply user colormap
  else
    colormap('gray'); % apply default grayscale colormap
  end
  % add figure title string
  titlestr=sprintf('%s%s',nameprefix,imname);
  % escape any underbars in title for nice display of image name
  ind=find(titlestr=='_');
  if length(ind)>0
    for k=length(ind):-1:1
      if ind(k)==1
	titlestr=sprintf('\\%s',titlestr(ind(k):end));
      else
	titlestr=sprintf('%s\\%s',titlestr(1:ind(k)-1),titlestr(ind(k):end));
      end
    end
  end
  % add figure title
  title(titlestr);
end

% a kmz file is a zipped directory containing one .kml file
% and one or more image (e.g. png) files referenced in kml file
% put these in a subdirectory 

%% generate .kmz file by first creating .kml and image files in a temporary
%% directory and zipping together to create the .kmz

% temporary work name
tmpkml=sprintf('%s%c%s',tmp,filesep(),imname);

% create temporary working directory 
[success,message,messageid]=mkdir(tmp,imname);
if success==1 % make sure it is empty
  delete(sprintf('%s%c*',tmpkml,filesep()));
end

% create .kml file and write header
outfile=sprintf('%s%c%s.kml',tmpkml,filesep(),imname);
fid=fopen(outfile,'w');
fprintf(fid,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid,'<kml xmlns="http://earth.google.com/kml/2.0">\n');
fprintf(fid,'<Folder>\n');
fprintf(fid,'<name>%s%s</name>\n',nameprefix,imname);

if nplacemarks > 0  % add placemark markers
  for k=1:nplacemarks
    fprintf(fid,'<Placemark>\n');
    fprintf(fid,' <name>%s</name>\n',char(placemarkname(k,:)));
    fprintf(fid,' <description>%s</description>\n',char(placemarkname(k,:)));
    fprintf(fid,' <Point>\n');
    fprintf(fid,'  <coordinates>%f,%f,%f</coordinates>\n',placemarkloc(k,1:3));
    fprintf(fid,' </Point>\n');
    fprintf(fid,'</Placemark>\n');
  end
end

fprintf(fid,' <LookAt>\n');
fprintf(fid,'  <longitude>%f</longitude>\n',(East+West)*0.5);  % view center
fprintf(fid,'  <latitude>%f</latitude>\n',(North+South)*0.5);
fprintf(fid,'  <range>1000</range>\n');             % viewing height
fprintf(fid,'  <tilt>0</tilt>\n');                  % terrain tilt
fprintf(fid,' <heading>0</heading>\n');             % view heading
fprintf(fid,'</LookAt>\n');

if exist('timecode','var') % optionally add time code
  fprintf(fid,' <TimeStamp>\n');
  %% time string format 2011-10-22T07:00:00 => timecode=[year,mon,day,hr,mins,secs]
  fprintf(fid,'  <when>%0.4d-%0.2d-%0.2dT%0.2d:%0.2d:%0.2dZ</when>\n',timecode);
  fprintf(fid,' </TimeStamp>\n');
end

% if image is not segmented (tiled)
if exist('segment','var')==0 | (exist('segment','var')==1 & max(size(val))<= maxsize) % single unsegmented image

  fprintf(fid,'<GroundOverlay>\n');
  fprintf(fid,'<name>%s%s</name>\n',nameprefix,imname);
  fprintf(fid,'<color>ffffffff</color>\n');
  fprintf(fid,' <Icon>\n');
  fprintf(fid,'  <href>%s.png</href>\n',imname);
  fprintf(fid,'  <viewBoundScale>0.75</viewBoundScale>\n');
  fprintf(fid,' </Icon>\n');
  fprintf(fid,' <LatLonBox>\n');

  fprintf(fid,'  <north> %f</north>\n',North);
  fprintf(fid,'  <south> %f</south>\n',South);
  fprintf(fid,'  <west> %f</west>\n',West);
  fprintf(fid,'  <east> %f</east>\n',East);
  fprintf(fid,' </LatLonBox>\n');
  fprintf(fid,'</GroundOverlay>\n');
  fprintf(fid,'</Folder>\n');
  fprintf(fid,'</kml>\n');
  fclose(fid);

  % write out image to png
  fname=sprintf('%s%c%s%c%s.png',tmp,filesep(),imname,filesep(),imname);
  
  % scale the input array to [0..255]
  out1=floor(256*(val-minout)/(maxout-minout));
  out1(out1<0)=0; out1(out1>255)=255;

  % create 8 bit PNG file with desired options
  if exist('cmap','var')==1
    if exist('alphaa','var')==1
      if 1 % note: imwrite does not support alpha channel AND cmap at the
           % same time for 8-bit png, so use transparency where the first
           % value of the colormap is set to the transparent color 
	   % based on the alpha channel information with the bottom 
	   % color of the image moved to the second colormap index
	out1(out1==0)=1;   % bottom color of image changed
	out1(alphaa==0)=0; % location of transparency
	%disp('write with colormap and transparency')
	imwrite(uint8(out1'),cmap,fname, 'png','transparency',cmap(1,:),'BitDepth',8,copyright,copyrightowner,'Comment',comment );
      else % what we really want, but is not supported...
	imwrite(uint8(out1'),cmap,fname,'png','Alpha', alphaa','BitDepth',8,copyright,copyrightowner,'Comment',comment );
      end
    else
      %disp('write with colormap but no alpha channel')
      imwrite(uint8(out1'),cmap,fname,'png',copyright,copyrightowner,'Comment',comment);
    end
  else
    if exist('alphaa','var')==1
      %disp('write with alpha channel but no colormap')
      imwrite(uint8(out1'),fname,'png','Alpha', alphaa','BitDepth',8,copyright,copyrightowner,'Comment',comment);
    else
      %disp('write without colormap or alpha channel')
      imwrite(uint8(out1'),fname,'png',copyright,copyrightowner,'Comment',comment);
    end
  end

else % segment (tile) the input image and write each segment
  
  val=val';
  if exist('alphaa','var')
    alphaa=alphaa';
  end
  % number of segments (tiles) in each direction
  NX=ceil(size(val,2)/maxsize);
  NY=ceil(size(val,1)/maxsize);
  if debugflag
    disp(sprintf('Segmenting output image (%d,%d) %d (%d,%d)',size(val),maxsize,NX,NY))
  end
  nonblanksegments=0;
  
  % generate each subimage segment (tile)
  for x=1:NX
    for y=1:NY
      %disp(sprintf('processing segment %d,%d of %d,%d',x,y,NX,NY));

      % define subimage segment (tile) and copy contents
      maxx=min(x*maxsize,size(val,2));
      maxy=min(y*maxsize,size(val,1));
      out1=val((y-1)*maxsize+1:maxy,(x-1)*maxsize+1:maxx);
      if exist('alphaa','var')
	alpha1=alphaa((y-1)*maxsize+1:maxy,(x-1)*maxsize+1:maxx);
      end
      
      % check to see if subimage segment is blank
      notblank=1;
      if exist('alphaa','var')
	if max(max(alpha1))==0 % blank segment
	  notblank=0;
	end
      else
	if max(max(out1))==min(min(out1)) % blank segment
	  notblank=0;
	end
      end
      
      % if not blank, generate output image segment
      if notblank==1
	nonblanksegments=nonblanksegments+1;
	North1=North+(y-1)*maxsize*(South-North)/size(val,1);
	South1=North+maxy*(South-North)/size(val,1);
	West1=West+(x-1)*maxsize*(East-West)/size(val,2);
	East1=West+maxx*(East-West)/size(val,2);

	fprintf(fid,'<GroundOverlay>\n');
	fprintf(fid,'<name>%s%s_%d_%d</name>\n',nameprefix,imname,x,y);
	fprintf(fid,'<color>ffffffff</color>\n');
	fprintf(fid,' <Icon>\n');
	fprintf(fid,'  <href>%s_%d_%d.png</href>\n',imname,x,y);
	fprintf(fid,'  <viewBoundScale>0.75</viewBoundScale>\n');
	fprintf(fid,' </Icon>\n');
	fprintf(fid,' <LatLonBox>\n');
	fprintf(fid,'  <north> %f</north>\n',North1);
	fprintf(fid,'  <south> %f</south>\n',South1);
	fprintf(fid,'  <west> %f</west>\n',West1);
	fprintf(fid,'  <east> %f</east>\n',East1);
	fprintf(fid,' </LatLonBox>\n');
	fprintf(fid,'</GroundOverlay>\n');
      
	% write out image to png
	fname=sprintf('%s%c%s%c%s_%d_%d.png',tmp,filesep(),imname,filesep(),imname,x,y);
	
	% scale the input array to [0..255]
	out1=floor(256*(out1-minout)/(maxout-minout));
	out1(out1<0)=0; out1(out1>255)=255;

	% create 8 bit PNG file with desired options
	% (note that transpose is not needed here as is it taken
        % care in the image segmentation process)
	if exist('cmap','var')==1
	  if exist('alphaa','var')==1
	    if 1 % note: imwrite does not support alpha channel AND cmap at the
		 % same time for 8-bit png, so use transparency where the first
		 % value of the colormap is set to the transparent color 
		 % based on the alpha channel information with the bottom 
		 % color of the image moved to the second colormap index
	      out1(out1==0)=1;   % bottom color of image changed
	      out1(alpha1==0)=0; % location of transparency
	      imwrite(uint8(out1),cmap,fname,'png','transparency',cmap(1,:),'BitDepth',8,copyright,copyrightowner,'Comment',comment);
	    else % what we really want, but is not supported...
	      imwrite(uint8(out1),fname,'png','Alpha',alpha1,'BitDepth',8,copyright,copyrightowner,'Comment',comment);
	    end
	  else
	    imwrite(uint8(out1),cmap,fname,'png',copyright,copyrightowner,'Comment',comment);
	  end
	else
	  if exist('alphaa','var')==1
	    imwrite(uint8(out1),fname,'png','Alpha',alpha1,'BitDepth',8,copyright,copyrightowner,'Comment',comment);
	  else
	    imwrite(uint8(out1),fname,'png',copyright,copyrightowner,'Comment',comment);
	  end
	end
      end
    end
  end
  
  if debugflag || quiet
    disp(sprintf(' Output image segments: %d of %d',nonblanksegments,NX*NY));
  end
  
  if nonblanksegments==0
    disp('*** makekmz warning: all blank segments, no image output');
  end
  
  % finish up kmz
  fprintf(fid,'</Folder>\n');
  fprintf(fid,'</kml>\n');
  fclose(fid);
  
end

% zip working directory to create .kmz file
zip([destdir filesep() imname '.kmz.zip'],[tmpkml filesep() '*']);
[status,message,messageid]=movefile([destdir filesep() imname '.kmz.zip'], [destdir filesep() imname '.kmz']);
if status ~= 1
  error(['*** failed to rename final .kmz file *** ' message])
end

% remove temporary directory and contents
[status,message,messageid]=rmdir(tmpkml,'s');

if debugflag || quiet
  disp(sprintf('Created kmz file: %s%c%s.kmz',destdir,filesep(),imname));
end
