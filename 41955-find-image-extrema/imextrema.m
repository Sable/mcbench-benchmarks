%Tristan Ursell
%Image Extrema Finder
%May 2013
%
% [x,y,z,c]=imextrema(im1);
% [x,y,z,c]=imextrema(im1,hood);
%
%Estimate extrema in an image at pixel resolution.  The input image 'im1'
%is a grayscale image of any class.  The outputs 'x' and 'y' specify the
%pixel positions of the extrema, 'z' specifies the value of the image at
%the extrema positions, and 'c' classifies the extrema, with:
%
% c = -1 --> local minimum
% c =  0 --> saddle point
% c = +1 --> local maximum
% c = +2 --> locally flat / extrema undefined
%
%The optional variable 'hood' specifies the topology of the pixel
%neighborhood used to find extrema, the options are hood = 4 or hood = 8,
%8 is the default.
%
%Some extrema may not be mathematically defined at a single point, i.e. in
%the example below the saddle points come in pixel doublets -- this is a
%property of image discretization, not an issue with the algorithm.
%
%Image extrema can not occur on the image edge.
%
%If noise is an issue you might consider smoothing the input image with a
%Gaussian blur filter or a hmin (matlab: imhmin) transform.
%
%The algorithm will not find ridge lines.
%
%EXAMPLE 1:
%dx=500;
%Xpos=ones(dx,1)*(1:dx);
%Ypos=Xpos';
%Im1=cos(4*pi*Xpos/dx).*cos(6*pi*Ypos/dx)+5*((Xpos-dx/2).^2/dx^2+(Ypos-dx/2).^2/dx^2);
%Im1(Im1<-0.9)=-0.9;
%
%[x,y,z,c]=imextrema(Im1);
%
%figure
%hold on
%imagesc(Im1)
%plot(x(c==1),y(c==1),'w.')
%plot(x(c==-1),y(c==-1),'k.')
%plot(x(c==0),y(c==0),'kx')
%plot(x(c==2),y(c==2),'wx')
%axis equal tight
%title(['white dots = maxima, black dots = minima, black x = saddles, white x = flat'])
%
%
%EXAMPLE 2:
%Im1=imread('rice.png');
%Im1(Im1<100)=0;
%
%[x,y,z,c]=imextrema(Im1);
%
%figure
%hold on
%imagesc(Im1)
%plot(x(c==1),y(c==1),'rx')
%axis equal tight
%title(['red x = maxima'])
%colormap(gray)

function [x,y,z,c]=imextrema(im1,varargin)

%convert class
im1=double(im1);

%set pixel neighborhood topology
if ~isempty(varargin)
    if varargin{1}==8
        hood8=1;
    else
        hood8=0;
    end
else
    hood8=1;
end

%create edge filter
edge1=ones(size(im1));
edge1(1,:)=0;
edge1(end,:)=0;
edge1(:,1)=0;
edge1(:,end)=0;

if hood8
    %create shift images (3 x 3 neighborhood)
    shift_1=circshift(im1,[-1 0]);
    shift_2=circshift(im1,[1 0]);
    shift_3=circshift(im1,[0 1]);
    shift_4=circshift(im1,[0 -1]);
    shift_5=circshift(im1,[-1 -1]);
    shift_6=circshift(im1,[1 1]);
    shift_7=circshift(im1,[-1 1]);
    shift_8=circshift(im1,[1 -1]);
    
    %get inequality conditions
    cond1_gt=im1>shift_1;
    cond1_lt=im1<shift_1;
    cond2_gt=im1>shift_2;
    cond2_lt=im1<shift_2;
    cond3_gt=im1>shift_3;
    cond3_lt=im1<shift_3;
    cond4_gt=im1>shift_4;
    cond4_lt=im1<shift_4;
    cond5_gt=im1>shift_5;
    cond5_lt=im1<shift_5;
    cond6_gt=im1>shift_6;
    cond6_lt=im1<shift_6;
    cond7_gt=im1>shift_7;
    cond7_lt=im1<shift_7;
    cond8_gt=im1>shift_8;
    cond8_lt=im1<shift_8;
    
    cond1_e=im1==shift_1;
    cond2_e=im1==shift_2;
    cond3_e=im1==shift_3;
    cond4_e=im1==shift_4;
    cond5_e=im1==shift_5;
    cond6_e=im1==shift_6;
    cond7_e=im1==shift_7;
    cond8_e=im1==shift_8;
    
    %find peaks
    highs=cond1_gt.*cond2_gt.*cond3_gt.*cond4_gt...
        .*cond5_gt.*cond6_gt.*cond7_gt.*cond8_gt.*edge1;
    
    %find troughs
    lows=cond1_lt.*cond2_lt.*cond3_lt.*cond4_lt...
        .*cond5_lt.*cond6_lt.*cond7_lt.*cond8_lt.*edge1;
    
    %find saddles
    sads=or(...
        or(cond1_gt.*cond2_gt.*cond3_lt.*cond4_lt,...
        cond1_lt.*cond2_lt.*cond3_gt.*cond4_gt),...
        or(cond5_gt.*cond6_gt.*cond7_lt.*cond8_lt,...
        cond5_lt.*cond6_lt.*cond7_gt.*cond8_gt)).*edge1;
    
    %find locally flat
    flats=cond1_e.*cond2_e.*cond3_e.*cond4_e.*...
        cond5_e.*cond6_e.*cond7_e.*cond8_e.*edge1;
else
    %create shift images (3 x 3 neighborhood)
    shift_1=circshift(im1,[-1 0]);
    shift_2=circshift(im1,[1 0]);
    shift_3=circshift(im1,[0 1]);
    shift_4=circshift(im1,[0 -1]);
    
    %get conditions binary
    cond1_gt=im1>shift_1;
    cond1_lt=im1<shift_1;
    cond2_gt=im1>shift_2;
    cond2_lt=im1<shift_2;
    cond3_gt=im1>shift_3;
    cond3_lt=im1<shift_3;
    cond4_gt=im1>shift_4;
    cond4_lt=im1<shift_4;
    
    cond1_e=im1==shift_1;
    cond2_e=im1==shift_2;
    cond3_e=im1==shift_3;
    cond4_e=im1==shift_4;
    
    %find highs
    highs=cond1_gt.*cond2_gt.*cond3_gt.*cond4_gt.*edge1;    
    
    %find lows
    lows=cond1_lt.*cond2_lt.*cond3_lt.*cond4_lt.*edge1;
    
    %find saddles
    sads=or(cond1_gt.*cond2_gt.*cond3_lt.*cond4_lt,...
        cond1_lt.*cond2_lt.*cond3_gt.*cond4_gt).*edge1;

    %find locally flat
    flats=cond1_e.*cond2_e.*cond3_e.*cond4_e.*edge1;
end

%find locations of extrema
[y_h,x_h]=find(highs);
[y_l,x_l]=find(lows);
[y_s,x_s]=find(sads);
[y_f,x_f]=find(flats);

%find values
z_h=im1(highs==1);
z_l=im1(lows==1);
z_s=im1(sads==1);
z_f=im1(flats==1);

%create classification vector
c_h=ones(length(y_h),1);
c_l=-ones(length(y_l),1);
c_s=zeros(length(y_s),1);
c_f=2*ones(length(y_f),1);

%create outputs
x=[x_h;x_s;x_l;x_f];
y=[y_h;y_s;y_l;y_f];
z=[z_h;z_s;z_l;z_f];
c=[c_h;c_s;c_l;c_f];






