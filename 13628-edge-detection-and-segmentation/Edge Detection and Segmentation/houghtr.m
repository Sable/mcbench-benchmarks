% Question No: 4

% Detect the line segments in a binary image using Hough transform

function houghtr(x)
im=imread(x);
f=edge(im,'canny');
figure,imshow(f),title('Image after applying Canny Filter');
[h,theta,rho]=hough1(f,0.5);
imshow(theta,rho,h,[],'notruesize'),axis on,axis normal;
xlabel('\theta'),ylabel('\rho');
[r,c]=houghpeaks1(h,5);
hold on;
plot(theta(c),rho(r),'linestyle','none','marker','s','color','w');
lines=houghlines1(f,theta,rho,r,c);
figure,imshow(f),hold on;
for k=1:length(lines)
    xy=[lines(k).point1;lines(k).point2];
    plot(xy(:,2),xy(:,1),'Linewidth',4,'Color',[.6 .6 .6]);
end
end

function [h,theta,rho]=hough1(f,dtheta,drho)
if nargin<3
    drho=1;
end
if nargin<2
    dtheta=1;
end
f=double(f);
[m,n]=size(f);
theta=linspace(-90,0,ceil(90/dtheta)+1);
theta=[theta -fliplr(theta(2:end-1))];
ntheta=length(theta);
d=sqrt((m-1)^2+(n-1)^2);
q=ceil(d/drho);
nrho=2*q-1;
rho=linspace(-q*drho,q*drho,nrho);
[x,y,val]=find(f);
x=x-1;y=y-1;
h=zeros(nrho,length(theta));
for k=1:ceil(length(val)/1000)
    first=(k-1)*1000+1;
    last=min(first+999,length(x));
    x_matrix=repmat(x(first:last),1,ntheta);
    y_matrix=repmat(y(first:last),1,ntheta);
    val_matrix=repmat(val(first:last),1,ntheta);
    theta_matrix=repmat(theta,size(x_matrix,1),1)*pi/180;
    rho_matrix=x_matrix.*cos(theta_matrix)+y_matrix.*sin(theta_matrix);
    slope=(nrho-1)/(rho(end)-rho(1));
    rho_bin_index=round(slope*(rho_matrix-rho(1))+1);
    theta_bin_index=repmat(1:ntheta,size(x_matrix,1),1);
    h=h+full(sparse(rho_bin_index(:),theta_bin_index(:),val_matrix(:),nrho,ntheta));
end
end

function [r,c,hnew]=houghpeaks1(h,numpeaks,threshold,nhood)
if nargin<4
    nhood=size(h)/50;
    nhood=max(2*ceil(nhood/2)+1,1);
end
if nargin<3
    threshold=0.5*max(h(:));
end
if nargin<2
    numpeaks=1;
end
done=false;
hnew=h;r=[];c=[];
while ~done
    [p,q]=find(hnew==max(hnew(:)));
    p=p(1);q=q(1);
    if hnew(p,q)>=threshold
        r(end+1)=p;
        c(end+1)=q;
        p1=p-(nhood(1)-1)/2;
        p2=p+(nhood(1)-1)/2;
        q1=q-(nhood(2)-1)/2;
        q2=q+(nhood(2)-1)/2;
        [pp,qq]=ndgrid(p1:p2,q1:q2);
        pp=pp(:);qq=qq(:);
        badrho=find((pp<1)|(pp>size(h,1)));
        pp(badrho)=[];
        qq(badrho)=[];
        theta_too_low=find(qq<1);
        qq(theta_too_low)=size(h,2)+qq(theta_too_low);
        pp(theta_too_low)=size(h,1)-pp(theta_too_low)+1;
        theta_too_high=find(qq>size(h,2));
        qq(theta_too_high)=qq(theta_too_high)-size(h,2);
        pp(theta_too_high)=size(h,1)-pp(theta_too_high)+1;
        hnew(sub2ind(size(hnew),pp,qq))=0;
        done=length(r)==numpeaks;
    else
        done=true;
    end
end
end

function [r,c]=houghpixels1(f,theta,rho,rbin,cbin)
[x,y,val]=find(f);
x=x-1;
y=y-1;
theta_c=theta(cbin)*pi/180;
rho_xy=x*cos(theta_c)+y*sin(theta_c);
nrho=length(rho);
slope=(nrho-1)/(rho(end)-rho(1));
rho_bin_index=round(slope*(rho_xy-rho(1))+1);
idx=find(rho_bin_index==rbin);
r=x(idx)+1;
c=y(idx)+1;
end

function lines=houghlines1(f,theta,rho,rr,cc,fillgap,minlength)
if nargin<6
    fillgap=20;
end
if nargin<7
    minlength=40;
end
numlines=0;
lines=struct;
for k=1:length(rr)
    rbin=rr(k);
    cbin=cc(k);
    [r,c]=houghpixels1(f,theta,rho,rbin,cbin);
    if isempty(r)
        continue
    end
    omega=(90-theta(cbin))*pi/180;
    t=[cos(omega) sin(omega);-sin(omega) cos(omega)];
    xy=[r-1 c-1]*t;
    x=sort(xy(:,1));
    diff_x=[diff(x);Inf];
    idx=[0;find(diff_x>fillgap)];
    for p=1:length(idx)-1
        x1=x(idx(p)+1);
        x2=x(idx(p+1));
        linelength=x2-x1;
        if linelength>=minlength
            point1=[x1 rho(rbin)];
            point2=[x2 rho(rbin)];
            tinv=inv(t);
            point1=point1*tinv;
            point2=point2*tinv;
            numlines=numlines+1;
            lines(numlines).point1=point1+1;
            lines(numlines).point2=point2+1;
            lines(numlines).length=linelength;
            lines(numlines).theta=theta(cbin);
            lines(numlines).rho=rho(rbin);
        end
    end
end
end