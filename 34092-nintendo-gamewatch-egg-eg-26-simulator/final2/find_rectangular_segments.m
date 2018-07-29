Ie=imread('background05_empty.jpg');
%imshow(Ie);

I=imread('background05.jpg');
% imshow(I);
dI=double(rgb2gray(Ie))-double(rgb2gray(I));

%imshow(dI,[min(dI(:))  max(dI(:))]);

tr=0.45*max(max(abs(dI(:))));
% tr=0.1*max(abs(dI(:)));

bw=abs(dI)>tr;

%imshow(bw);

bw(226,426:428)=false;
bw(227,328)=false;
% imshow(bw);

L = bwlabel(bw,4);
map=rand(max(L(:))+1,3);
%imshow(L+1,map);

ns=max(L(:)); % number of initial segments

% find rectangles of initial segments:
six=zeros(ns,1);
siy=zeros(ns,1); % positions
six2=zeros(ns,1);
siy2=zeros(ns,1); % positions
for c=1:ns
    bwt=(L==c);
    [yt xt]=find(bwt);
    x1=min(xt);
    x2=max(xt);
    y1=min(yt);
    y2=max(yt);
    six(c)=x1;
    siy(c)=y1;
    six2(c)=x2;
    siy2(c)=y2;
end



[sy sx tmp3]=size(Ie);

%in_rect=false(sy,sx,ns);
in_rect=false(sy*sx,ns);
waitbar(0,'in rect');
for yc=1:sy
    for xc=1:sx
        for c=1:ns
            if (siy(c)<=yc)&&(yc<=siy2(c))&&(six(c)<=xc)&&(xc<=six2(c))
                %in_rect(yc,xc,c)=true;
                in_rect(yc+(xc-1)*sy,c)=true;
            end
        end
    end
    waitbar(yc/sy);
end



in_rect_u=unique(in_rect,'rows'); % unicue pixels class
% in_rect_u(class_counter,:) - what segments used

nsr0=size(in_rect_u,1); % new number of segments
nsr=nsr0-1;


sixr=zeros(nsr,1);
siyr=zeros(nsr,1); % positions
six2r=zeros(nsr,1);
siy2r=zeros(nsr,1); % positions

% find limits:
%in_rect(pixel_number,segment_number)
%for cr=1:nsr
tic
waitbar(0,'new limits');
for cr1=1:nsr % exlude big 
    cr=cr1+1;
    in_rect_u_t=in_rect_u(cr,:); % in_rect_u_t(segment_number)
    sgu=find(in_rect_u_t); % what segments used
    
    rect=false(sy,sx);
    
    for yc=1:sy
        for xc=1:sx
            %if all(in_rect_u_t==())
            pn=yc+(xc-1)*sy; % pixel number
            %in_rect(pn,:) - in wat seggments curent pixel
            if all(in_rect_u_t==in_rect(pn,:))
                rect(yc,xc)=true;
            end
        end
    end
    
    [py px]=find(rect);
    siyr(cr1)=min(py);
    siy2r(cr1)=max(py);
    sixr(cr1)=min(px);
    six2r(cr1)=max(px);
    waitbar(cr1/nsr);
end

sir=cell(nsr,1); % small images
sibwr=cell(nsr,1); % small images, masks
for cr1=1:nsr % exlude big 
    cr=cr1+1;
    y1=siyr(cr1);
    y2=siy2r(cr1);
    x1=sixr(cr1);
    x2=six2r(cr1);
    rect=false(sy,sx);
    rect(y1:y2,x1:x2)=true;
    bwt=false(sy,sx);
    bwt(rect)=bw(rect);
    It=trim_with_mask(I,bwt);
    sir{cr1}=It(y1:y2,x1:x2,:);
    sibwr{cr1}=bwt(y1:y2,x1:x2);
end

% rename back:
six=sixr;
siy=siyr;
six2=six2r;
siy2=siy2r;

si=sir;
sibw=sibwr;

save('segments','si','sibw','six','siy','six2','siy2');