function [cout,marked_img,curvature]=arcss(varargin)
[I,H,L,Gap_size,EP] = parse_inputs(varargin{:});
%%
%When you give inputs manually, then comment the two above lines and uncomment
%the following lines:
%function [cout,marked_img,curvature]=arcss()%for manual input
%I = imread('Lena.bmp');
%H = 0.7;
%L = 0.2;
%Gap_size = 1;
%EP = 0;

%%


%{
Find corners in intensity image.

Publications:
=============
1. M. Awrangjeb and G. Lu, “An Improved Curvature Scale-Space Corner Detector and a Robust Corner Matching Approach for Transformed Image Identification,” IEEE Transactions on Image Processing, 17(12), 2425–2441, 2008.
2. M. Awrangjeb, G. Lu, and M. M. Murshed, “An Affine Resilient Curvature Scale-Space Corner Detector,” 32nd IEEE International Conference on Acoustics, Speech, and Signal Processing (ICASSP 2007), Hawaii, USA, 1233–1236, 2007.

Better results will be found using following corner detectors:
==============================================================
1.  M. Awrangjeb, G. Lu and C. S. Fraser, “A Fast Corner Detector Based on the Chord-to-Point Distance Accumulation Technique,” Digital Image Computing: Techniques and Applications (DICTA 2009), 519-525, 2009, Melbourne, Australia.
2.  M. Awrangjeb and G. Lu, “Robust Image Corner Detection Based on the Chord-to-Point Distance Accumulation Technique,” IEEE Transactions on Multimedia, 10(6), 1059–1072, 2008.

Source codes available:
=======================
http://www.mathworks.com/matlabcentral/fileexchange/authors/39158

%       Syntax :        
%       [cout,marked_img, curvature] = corner_css(I, H,    L, Gap_size, End_Point)
%       [cout,marked_img, curvature] = corner_css(I, 0.7, 0.2,   1,     0)
%
%       Input :
%       I -  the input image, it could be gray, color or binary image. If I is
%           empty([]), input image can be get from a open file dialog box.
%       H,L -  high and low threshold of Canny edge detector. The default value
%           is 0.7 and 0.2.
%       Gap_size -  a paremeter use to fill the gaps in the contours, the gap
%           not more than gap_size were filled in this stage. The default 
%           Gap_size is 1 pixels.
%       End_Point - 1 if you want to get the end points of the curves as
%       corners, 0 otherwise; default is 0.
%
%       Output :
%       cout -  a position pair list of detected corners in the input image.
%       marked_image -  image with detected corner marked.
%       curvature - curvature values at the corner locations

%}
%%

global GFP;
GFP{1} = [300 5 0.03]; % col1 = affine-length, col2 = sigma, col3 = Threshold
GFP{2} = [250 4 0.03];
GFP{3} = [200 3 0.03];

if size(I,3)==3
    I=rgb2gray(I); % Transform RGB image to a Gray one. 
end

%detect edges
%tic
BW=edge(I,'canny',[L,H]);  % Detect edges: [L,H] low and high sensitivity thresholds, if not specified canny selects
%time_for_detecting_edge=toc % automatically

%extract curves
%tic
[curve,curve_start,curve_end,curve_mode,curve_num,TJ,img1]=extract_curve(BW,Gap_size);  % Extract curves
%time_for_extracting_curve=toc

%detect corners
tic
[index S curveAL IND c1] = get_corner(curve,curve_mode,curve_num); % Detect corners
[corner_out c2] = localize_corner(curve,curve_mode,curve_num,index,c1,S,curveAL,IND); % localize corners
%[corner_out c2] = localize_corner(curve,curve_start,curve_end,curve_mode,curve_num,sig,index,c1,S,curveAL,IND); % localize corners
[corner_final c3] = Refine_TJunctions(corner_out,TJ,c2,curve, curve_num, curve_start, curve_end,curve_mode,EP);
%corner_final = corner_out;
time_for_detecting_corner=toc

%mark corner on the edge image
img=img1;
for i=1:size(corner_final,1)
    img=mark(img,corner_final(i,1),corner_final(i,2),7);
end

marked_img=img;
figure(); imshow(marked_img);
title('Detected corners on the edge image');

%mark corners on the original image
img=I;
for i=1:size(corner_final,1)
    img=mark(img,corner_final(i,1),corner_final(i,2),7);
end
figure();
imshow(img);
title('Detected corners and their curvature on the original image');
for i=1:size(corner_final,1)
   text(corner_final(i,2),corner_final(i,1),int2str(c3(i,1)*1000));
end
 
imwrite(img,'corners.jpg');
%imwrite(img1,'edge.jpg');
cout = corner_final;
curvature = c3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% extract curves from input edge-image
function [curve,curve_start,curve_end,curve_mode,cur_num,TJ,img]=extract_curve(BW,Gap_size)
%   Function to extract curves from binary edge map, if the endpoint of a
%   contour is nearly connected to another endpoint, fill the gap and continue
%   the extraction. The default gap size is 1 pixles.
[L,W]=size(BW);
BW1=zeros(L+2*Gap_size,W+2*Gap_size);
BW_edge=zeros(L,W);
BW1(Gap_size+1:Gap_size+L,Gap_size+1:Gap_size+W)=BW;
[r,c]=find(BW1==1); %returns indices of non-zero elements
cur_num=0;

while size(r,1)>0 %when number of rows > 0
    point=[r(1),c(1)];
    cur=point;
    BW1(point(1),point(2))=0; %make the pixel black
    [I,J]=find(BW1(point(1)-Gap_size:point(1)+Gap_size,point(2)-Gap_size:point(2)+Gap_size)==1); 
                               %find if any pixel around the current point is an edge pixel
    while size(I,1)>0 %if number of row > 0
        dist=(I-Gap_size-1).^2+(J-Gap_size-1).^2;
        [min_dist,index]=min(dist);
        p=point+[I(index),J(index)];
        point = p-Gap_size-1; % next is the current point
        cur=[cur;point]; %add point to curve 
        BW1(point(1),point(2))=0;%make the pixel black
        [I,J]=find(BW1(point(1)-Gap_size:point(1)+Gap_size,point(2)-Gap_size:point(2)+Gap_size)==1);
                                %find if any pixel around the current point 
                                %is an edge pixel
    end
    
    % Extract edge towards another direction
    point=[r(1),c(1)];
    BW1(point(1),point(2))=0;
    [I,J]=find(BW1(point(1)-Gap_size:point(1)+Gap_size,point(2)-Gap_size:point(2)+Gap_size)==1);
    
    while size(I,1)>0
        dist=(I-Gap_size-1).^2+(J-Gap_size-1).^2;
        [min_dist,index]=min(dist);
        point=point+[I(index),J(index)]-Gap_size-1;
        cur=[point;cur];
        BW1(point(1),point(2))=0;
        [I,J]=find(BW1(point(1)-Gap_size:point(1)+Gap_size,point(2)-Gap_size:point(2)+Gap_size)==1);
    end
        
    if size(cur,1)>(size(BW,1)+size(BW,2))/15 %for 512 by 512 image, choose curve if its length > 40
        cur_num=cur_num+1;
        curve{cur_num}=cur-Gap_size;
    end
    [r,c]=find(BW1==1);
    
end

for i=1:cur_num
    curve_start(i,:)=curve{i}(1,:);
    curve_end(i,:)=curve{i}(size(curve{i},1),:);
    if (curve_start(i,1)-curve_end(i,1))^2+...
        (curve_start(i,2)-curve_end(i,2))^2<=32  %if curve's ends are within sqrt(32) pixels
        curve_mode(i,:)='loop';
    else
        curve_mode(i,:)='line';
    end
    BW_edge(curve{i}(:,1)+(curve{i}(:,2)-1)*L)=1;
end
%%%
TJ = find_TJunctions(curve, cur_num, Gap_size+1); % if a contour goes just outsize of ends, i.e., outside of gapsize
%%%
img=~BW_edge;
%for i=1:size(TJ,1)
%    img=mark(img,TJ(i,1),TJ(i,2),10);
%end
%figure();
%imshow(img);
%figure();
%imshow(~BW_edge)
%title('Edge map showing T-corners')
%imwrite(~BW_edge,'edge.jpg');

% corner detection procedure
function [index S curveAL IND Curvature]= get_corner(curve,curve_mode,curve_num)
%[index S curveAL IND c1]
global GFP;
%GFP{1} = [300 7 0.02]; % col1 = affine-length, col2 = sigma, col3 = Threshold
%GFP{2} = [250 6 0.03];
%GFP{3} = [200 5 0.04];
%GFP{4} = [150 4 0.05];
%GFP{5} = [100 3 0.06];
%GFP{6} = [50 2 0.07];
%GFP{7} = [4 1 0.08];

[GF width] = makeGFilter();
for i=1:curve_num;
    x=curve{i}(:,1);
    y=curve{i}(:,2);
    L=size(x,1);
    [xL yL L_aff ind] = affine_length(x,y,L);
    curveAL{i} = [xL yL];
    IND{i} = ind;
    if L_aff>GFP{1}(1,1)
        gau = GF{1};
        W=width(1,1);
        Thresh = GFP{1}(1,3);
        S(i,1) = GFP{1}(1,2);
    elseif L_aff>GFP{2}(1,1)
        gau = GF{2};
        W=width(2,1);
        Thresh = GFP{2}(1,3);        
        S(i,1) = GFP{2}(1,2);
    else %if L_aff>GFP{3}(1,1)
        gau = GF{3};
        W=width(3,1);
        Thresh = GFP{3}(1,3);        
        S(i,1) = GFP{3}(1,2);
    %elseif L_aff>GFP{4}(1,1)
    %    gau = GF{4};
    %    W=width(4,1);
    %    Thresh = GFP{4}(1,3);
    %    S(i,1) = GFP{4}(1,2);
    %elseif L_aff>GFP{5}(1,1)
    %    gau = GF{5};
    %    W=width(5,1);
    %    Thresh = GFP{5}(1,3);
    %    S(i,1) = GFP{5}(1,2);
    %elseif L_aff>GFP{6}(1,1)
    %    gau = GF{6};
    %    W=width(6,1);
    %    Thresh = GFP{6}(1,3);
    %    S(i,1) = GFP{6}(1,2);
    %else
    %    gau = GF{7};
    %    W=width(7,1);
    %    Thresh = GFP{7}(1,3);
    %    S(i,1) = GFP{7}(1,2);
    end
    if L_aff>W
            if curve_mode(i,:)=='loop' % wrap around the curve by W pixles at both ends
                x1=[xL(L_aff-W+1:L_aff);xL;xL(1:W)];
                y1=[yL(L_aff-W+1:L_aff);yL;yL(1:W)];
            else % extend each line curve by W pixels at both ends
                x1=[ones(W,1)*2*xL(1)-xL(W+1:-1:2);xL;ones(W,1)*2*xL(L_aff)-xL(L_aff-1:-1:L_aff-W)];
                y1=[ones(W,1)*2*yL(1)-yL(W+1:-1:2);yL;ones(W,1)*2*yL(L_aff)-yL(L_aff-1:-1:L_aff-W)];
            end

            
            xx=conv(x1,gau);
            xx=xx(W+1:L_aff+3*W);
            yy=conv(y1,gau);
            yy=yy(W+1:L_aff+3*W);
            
            Xu=[xx(2)-xx(1) ; (xx(3:L_aff+2*W)-xx(1:L_aff+2*W-2))/2 ; xx(L_aff+2*W)-xx(L_aff+2*W-1)];
            Yu=[yy(2)-yy(1) ; (yy(3:L_aff+2*W)-yy(1:L_aff+2*W-2))/2 ; yy(L_aff+2*W)-yy(L_aff+2*W-1)];
            Xuu=[Xu(2)-Xu(1) ; (Xu(3:L_aff+2*W)-Xu(1:L_aff+2*W-2))/2 ; Xu(L_aff+2*W)-Xu(L_aff+2*W-1)];
            Yuu=[Yu(2)-Yu(1) ; (Yu(3:L_aff+2*W)-Yu(1:L_aff+2*W-2))/2 ; Yu(L_aff+2*W)-Yu(L_aff+2*W-1)];
            Xuuu=[Xuu(2)-Xuu(1) ; (Xuu(3:L_aff+2*W)-Xuu(1:L_aff+2*W-2))/2 ; Xuu(L_aff+2*W)-Xuu(L_aff+2*W-1)];
            Yuuu=[Yuu(2)-Yuu(1) ; (Yuu(3:L_aff+2*W)-Yuu(1:L_aff+2*W-2))/2 ; Yuu(L_aff+2*W)-Yuu(L_aff+2*W-1)];
            
            a = Xu.*Yuu-Xuu.*Yu;
            b = Xuuu.*Yu-Xu.*Yuuu;
            
            Xt = Xu./(a.^(1/3));
            Yt = Yu./(a.^(1/3));
            Xtt = ((Xu.*b)./(3*(a.^(5/3)))) + (Xuu./(a.^(2/3)));
            Ytt = ((Yu.*b)./(3*(a.^(5/3)))) + (Yuu./(a.^(2/3)));
            
            K=abs((Xt.*Ytt-Xtt.*Yt)./((Xt.*Xt+Yt.*Yt).^1.5));
            K=ceil(K*100)/100;
        
        % Find curvature local maxima as corner candidates
        extremum=[];
        N=size(K,1);
        n=0;
        Search=1;
        
        for j=1:N-1
            if (K(j+1)-K(j))*Search>0
                n=n+1;
                extremum(n)=j;  % In extremum, odd points are minima and even points are maxima
                Search=-Search; % minima: when K starts to go up; maxima: when K starts to go down 
            end
        end
        if mod(size(extremum,2),2)==0 %to make odd number of extrema
            n=n+1;
            extremum(n)=N;
        end

        n = size(extremum,2);
        flag = ones(size(extremum));
  
        % Compare each maxima with its two local minima to remove false corners
        for j=2:2:n % if the maxima is less than local minima, remove it as flase corner
            if (K(extremum(j)) < 2*K(extremum(j-1)) | K(extremum(j)) < 2*K(extremum(j+1)))
                flag(j)=0;
            end
        end
        extremum = extremum(2:2:n); % only maxima are corners, not minima
        flag = flag(2:2:n);
        extremum = extremum(find(flag==1));
        
        % Compare each selected maxima with global Thresh to remove round
        % corners
        n = size(extremum,2);
        flag = ones(size(extremum));
  
        % Compare each maxima with its two local minima to remove false corners
        for j=1:n % if the maxima is less than local minima, remove it as flase corner
            if (K(extremum(j)) <= Thresh)
                flag(j)=0;
            end
        end
        extremum = extremum(find(flag==1));
        extremum = extremum-W;
        extremum = extremum(find(extremum>0 & extremum<=L_aff)); % find corners which are not endpoints of the curve        
    %index{i} = ind(extremum);    
    Curvature{i} = K(extremum+W);
    index{i} = extremum';
    else
        Curvature{i} = [];
        index{i} = [];
    end
    
end
here = 1;
%%%%%%%%%%%%%%%%%%%

function [xl yl L_aff ind] = affine_length(x,y,L);
xu=[x(2)-x(1) ; (x(3:L)-x(1:L-2))/2 ; x(L)-x(L-1)];
yu=[y(2)-y(1) ; (y(3:L)-y(1:L-2))/2 ; y(L)-y(L-1)];
xuu=[xu(2)-xu(1) ; (xu(3:L)-xu(1:L-2))/2 ; xu(L)-xu(L-1)];
yuu=[yu(2)-yu(1) ; (yu(3:L)-yu(1:L-2))/2 ; yu(L)-yu(L-1)];

L_aff = floor(abs(sum((xu.*yuu-xuu.*yu).^(1/3))));
seg_al = 1.0;
al = 0; j = 1; t = seg_al;
for i=1:L
    al = al + (xu(i,1)*yuu(i,1)-xuu(i,1)*yu(i,1))^(1/3);
    if abs(al)-t>=0
        xl(j,1) = x(i,1);
        yl(j,1) = y(i,1);
        ind(j,1) = i;
        j = j+1;
        t = seg_al*j;
    end
end
%if L_aff>size(ind,1)
%    xl(L_aff,1) = x(L,1);
%    yl(L_aff,1) = y(L,1);
%    ind(L_aff,1) = L;
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show corners into the output images or into the edge-image
function img1=mark(img,x,y,w)
[M,N,C]=size(img);
img1=img;
if isa(img,'logical')
    img1(max(1,x-floor(w/2)):min(M,x+floor(w/2)),max(1,y-floor(w/2)):min(N,y+floor(w/2)),:)=...
        (img1(max(1,x-floor(w/2)):min(M,x+floor(w/2)),max(1,y-floor(w/2)):min(N,y+floor(w/2)),:)<1);
    img1(x-floor(w/2)+1:x+floor(w/2)-1,y-floor(w/2)+1:y+floor(w/2)-1,:)=...
        img(x-floor(w/2)+1:x+floor(w/2)-1,y-floor(w/2)+1:y+floor(w/2)-1,:);
else
    img1(max(1,x-floor(w/2)):min(M,x+floor(w/2)),max(1,y-floor(w/2)):min(N,y+floor(w/2)),:)=...
        (img1(max(1,x-floor(w/2)):min(M,x+floor(w/2)),max(1,y-floor(w/2)):min(N,y+floor(w/2)),:)<128)*255;
    img1(x-floor(w/2)+1:x+floor(w/2)-1,y-floor(w/2)+1:y+floor(w/2)-1,:)=...
        img(x-floor(w/2)+1:x+floor(w/2)-1,y-floor(w/2)+1:y+floor(w/2)-1,:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parses the inputs into input_parameters
function [I,H,L,Gap_size,EP] = parse_inputs(varargin);

error(nargchk(0,5,nargin));
Para=[0.5,0.2,1,0]; %Default experience value;
if nargin>=2
    I=varargin{1};
    for i=2:nargin
        if size(varargin{i},1)>0
            Para(i-1)=varargin{i};
        end
    end
end

if nargin==1
    I=varargin{1};
end
    
if nargin==0 | size(I,1)==0
    [fname,dire]=uigetfile('*.bmp;*.jpg;*.gif','Open the image to be detected');
    I=imread([dire,fname]);
end

H=Para(1);
L=Para(2);
Gap_size=Para(3);
EP = Para(4);

% find T-junctions within (gap by gap) neighborhood, where gap = Gap_size +
% 1; edges were continued (see edge_extraction procedure) when ends are within (Gap_size by Gap_size)
function TJ = find_TJunctions(curve, cur_num, gap); % finds T-Junctions in planar curves
TJ = [];
for i = 1:cur_num
    cur = curve{i};
    szi = size(cur,1);
    for j = 1:cur_num
        if i ~= j
            temp_cur = curve{j};
            compare_send = temp_cur - ones(size(temp_cur, 1),1)* cur(1,:);
            compare_send = compare_send.^2;
            compare_send = compare_send(:,1)+compare_send(:,2);
            if min(compare_send)<=gap*gap       % Add curve strat-points as T-junctions using a (gap by gap) neighborhood
                TJ = [TJ; cur(1,:)];
            end
            
            compare_eend = temp_cur - ones(size(temp_cur, 1),1)* cur(szi,:);
            compare_eend = compare_eend.^2;
            compare_eend = compare_eend(:,1)+compare_eend(:,2);
            if min(compare_eend)<=gap*gap       % Add end-points T-junctions using a (gap by gap) neighborhood
                TJ = [TJ; cur(szi,:)];
            end
        end
    end
end
%%%

% Localize corners at lower scales down to sigma = 0.7
function [corner_out c2] = localize_corner(curve,curve_mode,curve_num,index,c1,S,curveAL,IND); % localize corners
%global GFP;
%GFP{1} = [300 7 0.02]; % col1 = affine-length, col2 = sigma, col3 = Threshold
%GFP{2} = [250 6 0.03];
%GFP{3} = [200 5 0.04];
%GFP{4} = [150 4 0.05];
%GFP{5} = [100 3 0.06];
%GFP{6} = [50 2 0.07];
%GFP{7} = [4 1 0.08];

corner_out = [];
c2 = [];
neighbor = 3;
%[GF width] = makeGFilter();
%final = 0;
GaussianDieOff = .0001; 
pw = 1:30;
for sig = max(S)-1:-1:1
    %if sig == 1
    %    final = 1;
    %end
    ssq = sig*sig;
    width = max(find(exp(-(pw.*pw)/(2*ssq))>GaussianDieOff));
    if isempty(width)
        width = 1;  
    end
    t = (-width:width);
    gau = exp(-(t.*t)/(2*ssq))/(2*pi*ssq); 
    gau=gau/sum(gau);
    for i=1:curve_num
        if sig ~= S(i,1)-1
            continue;
        else
        S(i,1) = S(i,1)-1;
        xL = curveAL{i}(:,1);
        yL = curveAL{i}(:,2);
        W=width;        
        L_aff = size(xL,1);
        if L_aff>W & size(index{i},1)>0
            %expand the ends to gaussian window                      
            if curve_mode(i,:)=='loop' % wrap around the curve by W pixles at both ends
                x1=[xL(L_aff-W+1:L_aff);xL;xL(1:W)];
                y1=[yL(L_aff-W+1:L_aff);yL;yL(1:W)];
            else % extend each line curve by W pixels at both ends
                x1=[ones(W,1)*2*xL(1)-xL(W+1:-1:2);xL;ones(W,1)*2*xL(L_aff)-xL(L_aff-1:-1:L_aff-W)];
                y1=[ones(W,1)*2*yL(1)-yL(W+1:-1:2);yL;ones(W,1)*2*yL(L_aff)-yL(L_aff-1:-1:L_aff-W)];
            end

            
            xx=conv(x1,gau);
            xx=xx(W+1:L_aff+3*W);
            yy=conv(y1,gau);
            yy=yy(W+1:L_aff+3*W);
            
            Xu=[xx(2)-xx(1) ; (xx(3:L_aff+2*W)-xx(1:L_aff+2*W-2))/2 ; xx(L_aff+2*W)-xx(L_aff+2*W-1)];
            Yu=[yy(2)-yy(1) ; (yy(3:L_aff+2*W)-yy(1:L_aff+2*W-2))/2 ; yy(L_aff+2*W)-yy(L_aff+2*W-1)];
            Xuu=[Xu(2)-Xu(1) ; (Xu(3:L_aff+2*W)-Xu(1:L_aff+2*W-2))/2 ; Xu(L_aff+2*W)-Xu(L_aff+2*W-1)];
            Yuu=[Yu(2)-Yu(1) ; (Yu(3:L_aff+2*W)-Yu(1:L_aff+2*W-2))/2 ; Yu(L_aff+2*W)-Yu(L_aff+2*W-1)];
            Xuuu=[Xuu(2)-Xuu(1) ; (Xuu(3:L_aff+2*W)-Xuu(1:L_aff+2*W-2))/2 ; Xuu(L_aff+2*W)-Xuu(L_aff+2*W-1)];
            Yuuu=[Yuu(2)-Yuu(1) ; (Yuu(3:L_aff+2*W)-Yuu(1:L_aff+2*W-2))/2 ; Yuu(L_aff+2*W)-Yuu(L_aff+2*W-1)];
            
            a = Xu.*Yuu-Xuu.*Yu;
            b = Xuuu.*Yu-Xu.*Yuuu;
            
            Xt = Xu./(a.^(1/3));
            Yt = Yu./(a.^(1/3));
            Xtt = ((Xu.*b)./(3*(a.^(5/3)))) + (Xuu./(a.^(2/3)));
            Ytt = ((Yu.*b)./(3*(a.^(5/3)))) + (Yuu./(a.^(2/3)));
            
            K=abs((Xt.*Ytt-Xtt.*Yt)./((Xt.*Xt+Yt.*Yt).^1.5));
            K=ceil(K*100)/100;
            ct = size(index{i},1);
            for j=1:ct
                %sig1 = sig
                %i1 = i
                %j1 = j
                %if (sig == 1 & i == 1)
                %    here = 1;
                %end
                [m ind] = max(K(W+index{i}(j,1)-neighbor:W+index{i}(j,1)+neighbor));
                ind = ind + index{i}(j,1) - neighbor-1;
                if (ind>0 & ind<=L_aff)
                    index{i}(j,1) = ind;
                    c1{i}(j,1) = m;
                end
            end            
        end
        end
    end
end

% define width and Gaussian function for sigma = 1 to findout final corner
% positions on the curves
sig = 1;
ssq = sig*sig;
width = max(find(exp(-(pw.*pw)/(2*ssq))>GaussianDieOff));
if isempty(width)
    width = 1;  
end
t = (-width:width);
gau = exp(-(t.*t)/(2*ssq))/(2*pi*ssq); 
gau=gau/sum(gau);

for i=1:curve_num
    %if final % think whether further localization with arbitrary parameter needed,
                 % if needed then execute all fllowing statements
    
    
                 W = width; % width if Gaussian filter at sigma = 1
                indd = IND{i};
                x = curve{i}(:,1);
                y = curve{i}(:,2);
                L=size(x,1);
            if curve_mode(i,:)=='loop' % wrap around the curve by W pixles at both ends
                x2=[x(L-W+1:L);x;x(1:W)];
                y2=[y(L-W+1:L);y;y(1:W)];
            else % extend each line curve by W pixels at both ends
                x2=[ones(W,1)*2*x(1)-x(W+1:-1:2);x;ones(W,1)*2*x(L)-x(L-1:-1:L-W)];
                y2=[ones(W,1)*2*y(1)-y(W+1:-1:2);y;ones(W,1)*2*y(L)-y(L-1:-1:L-W)];
            end
            
            xx2=conv(x2,gau);
            xx2=xx2(W+1:L+3*W);
            yy2=conv(y2,gau);
            yy2=yy2(W+1:L+3*W);
            Xu2=[xx2(2)-xx2(1) ; (xx2(3:L+2*W)-xx2(1:L+2*W-2))/2 ; xx2(L+2*W)-xx2(L+2*W-1)];
            Yu2=[yy2(2)-yy2(1) ; (yy2(3:L+2*W)-yy2(1:L+2*W-2))/2 ; yy2(L+2*W)-yy2(L+2*W-1)];
            Xuu2=[Xu2(2)-Xu2(1) ; (Xu2(3:L+2*W)-Xu2(1:L+2*W-2))/2 ; Xu2(L+2*W)-Xu2(L+2*W-1)];
            Yuu2=[Yu2(2)-Yu2(1) ; (Yu2(3:L+2*W)-Yu2(1:L+2*W-2))/2 ; Yu2(L+2*W)-Yu2(L+2*W-1)];
            K2=abs((Xu2.*Yuu2-Xuu2.*Yu2)./((Xu2.*Xu2+Yu2.*Yu2).^1.5));
            K2=ceil(K2*100)/100;
            ct = size(index{i},1);
            index1{i} = indd(index{i});
            for j=1:ct
                [m ind] = max(K2(W+index1{i}(j,1)-neighbor:W+index1{i}(j,1)+neighbor));
                ind = ind + index1{i}(j,1) - neighbor-1;
                if (ind>0 & ind<=L)
                    index1{i}(j,1) = ind;
                    c1{i}(j,1) = m;
                end
            end
     %   end
end
% find corner positions from planer curves
for i=1:curve_num
    for j=1:size(index1{i},1)
        corner_out = [corner_out;curve{i}(index1{i}(j,1),:)];
        c2 = [c2;c1{i}(j,1)];
    end
end
%%%

% Compare T-junctions with obtained corners and add T-junctions to corners
% which are far away (outside a 5 by 5 neighborhood) from detected corners
function [corner_final c3] = Refine_TJunctions(corner_out,TJ,c2,curve, curve_num, curve_start, curve_end, curve_mode,EP);
%corner_final = corner_out;
c3=c2;

%%%%% add end points
if EP
corner_num = size(corner_out,1);
for i=1:curve_num
        if size(curve{i},1)>0 & curve_mode(i,:)=='line'
            
            % Start point compare with detected corners
            compare_corner=corner_out-ones(size(corner_out,1),1)*curve_start(i,:);
            compare_corner=compare_corner.^2;
            compare_corner=compare_corner(:,1)+compare_corner(:,2);
            if min(compare_corner)>100       % Add end points far from detected corners 
                corner_num=corner_num+1;
                corner_out(corner_num,:)=curve_start(i,:);
                c3 = [c3;8];
            end
            
            % End point compare with detected corners
            compare_corner=corner_out-ones(size(corner_out,1),1)*curve_end(i,:);
            compare_corner=compare_corner.^2;
            compare_corner=compare_corner(:,1)+compare_corner(:,2);
            if min(compare_corner)>100
                corner_num=corner_num+1;
                corner_out(corner_num,:)=curve_end(i,:);
                c3 = [c3;9];
            end
        end
end
end
%%%%%%%%%%%%%%%5

%%%%%Add T-junctions
corner_final = corner_out;
for i=1:size(TJ,1)
    % T-junctions compared with detected corners
    if size(corner_final)>0
        compare_corner=corner_final-ones(size(corner_final,1),1)*TJ(i,:);
        compare_corner=compare_corner.^2;
        compare_corner=compare_corner(:,1)+compare_corner(:,2);
        if min(compare_corner)>100       % Add end points far from detected corners, i.e. outside of 5 by 5 neighbor
            corner_final = [corner_final; TJ(i,:)];
            c3 = [c3;10];
        end
    else
        corner_final = [corner_final; TJ(i,:)];
        c3 = [c3;10];
    end
end

function [G W] = makeGFilter();

GaussianDieOff = .0001; 
pw = 1:100;
sig = 5;
for i = 1:3
    ssq = sig*sig;
    width = max(find(exp(-(pw.*pw)/(2*ssq))>GaussianDieOff));
    if isempty(width)
        width = 1;  
    end
    t = (-width:width);
    gau = exp(-(t.*t)/(2*ssq))/(2*pi*ssq); 
    gau=gau/sum(gau);
    G{i} = gau;
    W(i,1) = width;
    sig = sig-1;
end
%here = 1;