function rs=sonomeasure(segArray,rpos,polygon,ns)
rx=rpos(1);
ry=rpos(2);
n=size(segArray,1);
if nargin<4
    ns=24;
    if nargin<3
        polygon=false;
    end
end
if polygon
    segArray=[segArray(1:end-1,:),segArray(2:end)];
end
a=2*pi/ns;%angle between two adjacent sensors
% Simulate the ultrasonic data
% Measure: Point Discretization %to be improved
dl=.1;
segadd=[];
for k=1:n
    lx=segArray(k,1)-segArray(k,3);
    ly=segArray(k,2)-segArray(k,4);
    l=sqrt(lx^2+ly^2);
    if lx
        xadd=segArray(k,1):-(dl*lx/l):segArray(k,3);
        yadd=(xadd-segArray(k,1))*ly/lx+segArray(k,2);
    else
        yadd=segArray(k,2):-(dl*ly/l):segArray(k,4);
        xadd=segArray(k,1)*ones(1,length(yadd));
    end
    segadd=[segadd;[xadd',yadd']];
end
segadd=[segadd;segArray(:,1:2);segArray(:,3:4)];

%determine sections
nadd=size(segadd,1);
nsect=zeros(1,nadd);
ssect=zeros(ns,nadd+1);
for k=1:nadd
    ak=vectorangle([1,0],segadd(k,:)-[rx,ry],1)/a;
    nsect(k)=ceil(ak)+(ak==0);
    sk=nsect(k);
    ssect(sk,1)=ssect(sk,1)+1;
    ssect(sk,ssect(sk,1)+1)=k;
end
%choose min
rs=zeros(1,ns);%distance radius of probing
for k=1:ns
    if ssect(k,1)
        pts=segadd(ssect(k,2:1+ssect(k,1)),:);
        rs(k)=min((pts(:,1)-rx).^2+(pts(:,2)-ry).^2);rs(k)=sqrt(rs(k));
    else
        rs(k)=0;%inf;
    end
end
end
