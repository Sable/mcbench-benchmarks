N=32; % number of vertecies
R=0.5; % radius
dR=0.4; % random radius changing

itm=1000; % number of iteration of random search
cr=0.99; % contract ration
trm=100; % number of random tries in one iteration

ast=2*pi/N; % angel sep
al=0:ast:2*pi-ast;
RR=R+dR*rand(1,N); % radmom radius
r=[RR.*cos(al);
   RR.*sin(al)]; % points coordinaties

hfg=figure;
hf=fill(r(1,:),r(2,:),'r'); % plot random shape
axis equal;
set(hfg,'position',[400 400 300 300]);

% random search with contraction:
P=perimeter(r,N); % perimeter
A=polyarea(r(1,:),r(2,:)); % area
f=P/sqrt(A);  % parameter f need to minimize

rs=dR/2; % reigon size, star vlue
rr=r; % start points position
rrr=zeros(2,N); % current nodes position in try
rrr_min=zeros(2,N); % positions that minimize f1

fc=1;
ht=title(' ');
F1=getframe(gcf);
[im,map] = rgb2ind(F1.cdata,256,'nodither');
im(1,1,1,20) = 0;
for it=1:itm % iteration count
    for tr=1:trm % random tireis counter
        rrr=rr+rs*(rand(2,N)-0.5); % current random position
        P=perimeter(rrr,N); % perimeter
        A=polyarea(rrr(1,:),rrr(2,:)); % area
        f1=P/sqrt(A);  % parameter f need to minimize
        if f1<f
            f=f1;
            rrr_min=rrr;
        end
    end
    rr=rrr_min; % next iteration starts from curent minimum found
    %normaizie to sqrt of area size
    A=polyarea(rr(1,:),rr(2,:)); % area
    sA=sqrt(A);
    rr=rr/sA;
    rs=rs*cr; % contract search region
    set(hf,'XData',rr(1,:),'YData',rr(2,:));
    set(ht,'string',['iteration No. ' num2str(it)]);
    drawnow;
    if mod(it,20)==0
        F1=getframe(gcf);
        im(:,:,1,fc) = rgb2ind(F1.cdata,map,'nodither');
        fc=fc+1;
    end
end
clc; disp('movie making finished');
imwrite(im,map,'min_per.gif','DelayTime',0,'LoopCount',inf);