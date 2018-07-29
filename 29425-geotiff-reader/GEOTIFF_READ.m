function [I]=GEOTIFF_READ(varargin)
% GEOTIFF_READ: read geotiff using imread and assign map info from infinfo.
%
% I = GEOTIFF_READ('filename');
% Reads whole images
% I = GEOTIFF_READ('filename','pixel_subset', [minx maxx miny maxy]);
% I = GEOTIFF_READ('filename','map_subset'  , [minx maxx miny maxy]);
% extract subset of the specified.

% output:
% I.z, image data
% I.x, x coordinate in map
% I.y, y coordinate in map
% I.info, misc. info

% imshow(I.z, 'xdata', I.x, 'ydata', I.y);
% shows image with map coordinate

% Version by Yushin Ahn, ahn.74@osu.edu
% Glacier Dynamics Laboratory, 
% Byrd Polar Resear Center, Ohio State University 
% Referenced enviread.m (Ian Howat)

name = varargin{1};

Tinfo        = imfinfo(name);
info.samples = Tinfo.Width;
info.lines   = Tinfo.Height;
info.imsize  = Tinfo.Offset;
info.bands   = Tinfo.SamplesPerPixel;


sub = [1, info.samples, 1, info.lines];
%data_type = Tinfo.BitDepth/8;
data_type = Tinfo.BitsPerSample(1)/8;
switch data_type
    case {1}
        format = 'uint8';
    case {2}
        format = 'int16';
    case{3}
        format = 'int32';
    case {4}
        format = 'single';
end

info.map_info.dx = Tinfo.ModelPixelScaleTag(1);
info.map_info.dy = Tinfo.ModelPixelScaleTag(2);
info.map_info.mapx = Tinfo.ModelTiepointTag(4);
info.map_info.mapy = Tinfo.ModelTiepointTag(5);
%info.map_info.projection_name = Tinfo.GeoAsciiParamsTag;
%info.map_info.projection_info = Tinfo.GeoDoubleParamsTag;

minx = info.map_info.mapx;
maxy = info.map_info.mapy;
maxx = minx + (info.samples-1).*info.map_info.dx;
miny = maxy - (info.lines-1  ).*info.map_info.dy;

%info.CornerMap = [minx miny; maxx miny; maxx maxy; minx maxy; minx miny]; 

xm = info.map_info.mapx;
ym = info.map_info.mapy;
x_ = xm + ((0:info.samples-1).*info.map_info.dx);
y_ = ym - ((0:info.lines  -1).*info.map_info.dy);
 
tmp1=[1 2];
tmp2=[4 3];
if nargin == 3;
    
    if strcmp(varargin{2},'pixel_subset');
        sub = varargin{3};
        
    elseif strcmp(varargin{2},'map_subset');
        sub  = varargin{3};
        subx = (sub(tmp1)-info.map_info.mapx  )./info.map_info.dx+1;
        suby = (info.map_info.mapy - sub(tmp2))./info.map_info.dy+1;
        subx = round(subx);
        suby = round(suby);
        
        subx(subx < 1) = 1;
        suby(suby < 1) = 1;
        subx(subx > info.samples) = info.samples;
        suby(suby > info.lines  ) = info.lines;
        sub = [subx,suby];
    end
    info.sub.samples = sub(2)-sub(1)+1;
    info.sub.lines   = sub(4)-sub(3)+1;
    info.sub.mapx = [ x_(sub(1)) x_(sub(2)) ];
    info.sub.mapy = [ y_(sub(3)) y_(sub(4)) ];
    info.sub.pixx = [sub(1) sub(2)];
    info.sub.pixy = [sub(3) sub(4)];
end
       
I.x = x_(sub(1):sub(2));
I.y = y_(sub(3):sub(4));


% % subset read bsq
% %offset1    = info.imsize - (info.samples*info.lines)*info.bands + (sub(3)-1)*info.samples*info.bands;
% offset1    = info.imsize - (info.samples*info.lines)*info.bands + (sub(3)-1)*info.samples;
% fid = fopen(name,'r','ieee-le');
% fseek(fid,offset1,'bof'); 
% 
% tmp=zeros(sub(4)-sub(3)+1, sub(2)-sub(1)+1,info.bands,format);
%  
% for b=1:info.bands
% 
%     for i=sub(3):sub(4)
%         t=fread(fid,info.samples,format);
%         tmp(i-sub(3)+1,:,b)=t(sub(1):sub(2));
%     end
%     offset2 = info.samples*info.lines*b+offset1;
%     fseek(fid,offset2,'bof');
% end
% fclose(fid);

% subset read
offset1    = info.imsize - (info.samples*info.lines)*info.bands*data_type + (sub(3)-1)*info.samples*info.bands*data_type;
%offset1    = info.imsize - (info.samples*info.lines)*info.bands;
fid = fopen(name,'r','ieee-le');
fseek(fid,offset1,'bof'); 

tmp=zeros(sub(4)-sub(3)+1, sub(2)-sub(1)+1,info.bands,format);

for i=sub(3):sub(4)
    t=fread(fid,info.samples*info.bands,format);
    for j=1:info.bands
        R = (sub(1)-1)*info.bands+j:info.bands:(sub(2)-1)*info.bands+j;
        tmp(i-sub(3)+1,:,j) = t(R);
    end
end

fclose(fid);



I.z=tmp;
I.info = info;





