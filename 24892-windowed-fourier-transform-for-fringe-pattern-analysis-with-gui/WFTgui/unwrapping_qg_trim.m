function [p PathMap]=unwrapping_qg_trim(g,mask)
%Purpose: 
%Quality guided phase unwrapping.
%Version: 
%This is an extension of unwrapping_qg with 'trim' for acceleration. 
%Detials of trim can be found in [1]
%inputs and outputs
%g: phase to be unwrapped and amplitude as quality map
%mask: unwrapping mask, if 1, unwrap, if 0, don't unwrap 
%p: unwrapped phase
%PathMap: unwrapping path
%Interesting story:
%I spent lots of time but cannot speed up the algorihtm. Finally I found
%the time was consummed on "PathMap=PathMap+Unwrapped", a line to produce a
%PathMap. Both PathMap and Unwrapped are SX*SY matrices. I ignored it first
%because I though it is fast enough. But actually it consumed most of computing time.
%References
%[1]	D. C. Ghiglia and M. D. Pritt, Two-Dimensional Phase
%Unwrapping: Theory, Algorithm and Software, (John Wiley & Sons, Inc, 1998).
%by Qian Kemao (mkmqian@ntu.edu.sg)
%13 August 2008

%step 1. preparation and initilization
[SX SY]=size(g);%size of image
MaxQueneSize=SX+SY;%maximum Quene Size, set to be SX+SY [1]
HalfMaxQueneSize=fix(MaxQueneSize/2);%half of MaxQueneSize
MinQualityThresh=0.01;%Minimum quality threshold, set to a small value [1]
if nargin==1
    mask=ones(SX,SY); %mask is by default 1
end
a=abs(g);a=a.*mask; %amplitude as quality map
p=angle(g);%phase to be unwrapped
L=bwlabel(mask);%handle multi-region
Lnumber=max(max(L));%number of regions 

Unwrapped=zeros(SX,SY);%to indicate whether a pixel has been unwrapped
PathMap=zeros(SX,SY);%to view the unwrapping path
Qa=zeros(MaxQueneSize,1);%amplitude (array for quened pixels,AQP. 
%In AQP, pixels are ordered from higest quality to lowest quality)
Qx=zeros(MaxQueneSize,1);%x coordinate (AQP)
Qy=zeros(MaxQueneSize,1);%y coordinate (AQP)
Qn=0;%number of quened pixels  
Pa=zeros(SX*SY,1);%amplitude (array for postponed pixels, APP)
%In APP, no ordering of pixels.
Px=zeros(SX*SY,1);%x coordinate (APP)
Py=zeros(SX*SY,1);%y coordinate (APP)
Pn=0;%number of postponed pixels
Un=0; %number of pixels unwrapped (also indicates the order of unwrapping)

%step 2: Search seeds to start. A seed is the pixel with the highest 
%amppitude in each region.
for i=1:Lnumber
    %find highest quality as a seed
    [start_x start_y]=find(a==max(max(a.*(L==i))),1,'first');
    %push the seed into AQP
    [Qx Qy Qa Qn]=InsertQuene(Qx,Qy,Qa,Qn,start_x,start_y,a(start_x,start_y));
    Unwrapped(start_x,start_y)=1;%seed is taken as unwrapped
    Un=Un+1;%update Un
    PathMap(start_x,start_y)=Un;%update PathMap
end

%step 3: start flooding, for each quened pixel, its four neighbors are
%unwrapped.
while Qn>0 %unwrap while quened pixels are available
    %step 3.1: take out a pixel to process
    %process the first pixel in AQP, which has the highest quality
    cx=Qx(1);cy=Qy(1);
    %This pixel has been unwrapped and does not need any processing. 
    %What we are going to do is to unwrapp its 4-neighbores. 
    %Hence itself is delected from the AQP
    Qx(1:Qn-1)=Qx(2:Qn);%delete
    Qy(1:Qn-1)=Qy(2:Qn);%delete
    Qa(1:Qn-1)=Qa(2:Qn);%delete
    Qn=Qn-1; %consequently the number of quened pixels is reduced by 1.
    
    %step 3.2: push the left neighbor into the AQP or APP
    if cx-1>0 && Unwrapped(cx-1,cy)==0 && mask(cx-1,cy)==1 
        %unwrapping the left neighbor
        p(cx-1,cy)=p(cx-1,cy)-round((p(cx-1,cy)-p(cx,cy))/2/pi)*2*pi;
        if a(cx-1,cy)>MinQualityThresh %push into AQP if quality is high
            [Qx Qy Qa Qn]=InsertQuene(Qx,Qy,Qa,Qn,cx-1,cy,a(cx-1,cy));
            if Qn==MaxQueneSize %if AQP reaches preset size, split it
                [Qn,Px,Py,Pa,Pn,MinQualityThresh]= ... 
                    SplitQuene(Qx,Qy,Qa,Qn,Px,Py,Pa,Pn,HalfMaxQueneSize);
            end
        else %push into APP if qualtiy is low
            Pn=Pn+1;Px(Pn)=cx-1;Py(Pn)=cy;Pa(Pn)=a(cx-1,cy);
        end
        Unwrapped(cx-1,cy)=1;%mark this pixel as unwrapped.
        Un=Un+1; %update Un
        PathMap(cx-1,cy)=Un; %update PathMap
    end
    %step 3.3: push the right neighbor into the AQP or APP
    if cx+1<SX+1 && Unwrapped(cx+1,cy)==0 && mask(cx+1,cy)==1 
        p(cx+1,cy)=p(cx+1,cy)-round((p(cx+1,cy)-p(cx,cy))/2/pi)*2*pi;
        if a(cx+1,cy)>MinQualityThresh
            [Qx Qy Qa Qn]=InsertQuene(Qx,Qy,Qa,Qn,cx+1,cy,a(cx+1,cy));
            if Qn==MaxQueneSize
                [Qn,Px,Py,Pa,Pn,MinQualityThresh]= ... 
                    SplitQuene(Qx,Qy,Qa,Qn,Px,Py,Pa,Pn,HalfMaxQueneSize);
            end
        else
            Pn=Pn+1;Px(Pn)=cx+1;Py(Pn)=cy;Pa(Pn)=a(cx+1,cy);
        end
        Unwrapped(cx+1,cy)=1;
        Un=Un+1;
        PathMap(cx+1,cy)=Un;
    end
    %step 3.4: push the upper neighbor into the AQP or APP
    if cy-1>0 && Unwrapped(cx,cy-1)==0 && mask(cx,cy-1)==1 
        p(cx,cy-1)=p(cx,cy-1)-round((p(cx,cy-1)-p(cx,cy))/2/pi)*2*pi;
        if a(cx,cy-1)>MinQualityThresh
            [Qx Qy Qa Qn]=InsertQuene(Qx,Qy,Qa,Qn,cx,cy-1,a(cx,cy-1));
            if Qn==MaxQueneSize
                [Qn,Px,Py,Pa,Pn,MinQualityThresh]= ... 
                    SplitQuene(Qx,Qy,Qa,Qn,Px,Py,Pa,Pn,HalfMaxQueneSize);
            end
        else
            Pn=Pn+1;Px(Pn)=cx;Py(Pn)=cy-1;Pa(Pn)=a(cx,cy-1);
        end
        Unwrapped(cx,cy-1)=1;
        Un=Un+1;
        PathMap(cx,cy-1)=Un;
    end
    %step 3.5: push the lower neighbor into the AQP or APP
    if cy+1<SY+1 && Unwrapped(cx,cy+1)==0 && mask(cx,cy+1)==1 
        p(cx,cy+1)=p(cx,cy+1)-round((p(cx,cy+1)-p(cx,cy))/2/pi)*2*pi;
        if a(cx,cy+1)>MinQualityThresh
            [Qx Qy Qa Qn]=InsertQuene(Qx,Qy,Qa,Qn,cx,cy+1,a(cx,cy+1));
            if Qn==MaxQueneSize
                [Qn,Px,Py,Pa,Pn,MinQualityThresh]= ... 
                    SplitQuene(Qx,Qy,Qa,Qn,Px,Py,Pa,Pn,HalfMaxQueneSize);
            end
        else
            Pn=Pn+1;Px(Pn)=cx;Py(Pn)=cy+1;Pa(Pn)=a(cx,cy+1);
        end
        Unwrapped(cx,cy+1)=1;
        Un=Un+1;
        PathMap(cx,cy+1)=Un;
    end
    
    %step 3.6 if AQP is empty, copy data from APP
    if Qn==0 && Pn>0
        [Qx,Qy,Qa,Qn,Px,Py,Pa,Pn,MinQualityThresh]= ... 
            Copy2Quene(Qx,Qy,Qa,Qn,Px,Py,Pa,Pn,HalfMaxQueneSize);
    end
end
p=p.*mask+(min(min(p.*mask))-2*pi).*(1-mask);
PathMap=(Un-PathMap+1).*mask;


%function 1: Insert a pixel into AQP, maintain quality order
function [Qx, Qy, Qa, Qn]=InsertQuene(Qx,Qy,Qa,Qn,x,y,a)
I=find(Qa(1:Qn)<a,1,'first'); %find its proper inserting point
if isempty(I) %put in the end of AQP
    Qx(Qn+1)=x;
    Qy(Qn+1)=y;
    Qa(Qn+1)=a;
else %inset into AQP
    Qx(I+1:Qn+1)=Qx(I:Qn);
    Qx(I)=x;
    Qy(I+1:Qn+1)=Qy(I:Qn);
    Qy(I)=y;
    Qa(I+1:Qn+1)=Qa(I:Qn);
    Qa(I)=a;
end
Qn=Qn+1;%update Qn


%function 2: Split the Quene if it is too long
function [Qn,Px,Py,Pa,Pn,MinQualityThresh]= ... 
    SplitQuene(Qx,Qy,Qa,Qn,Px,Py,Pa,Pn,HalfMaxQueneSize)
%put second half of AQP into APP
Pa(Pn+1:Pn+Qn-HalfMaxQueneSize)=Qa(HalfMaxQueneSize+1:Qn);
Px(Pn+1:Pn+Qn-HalfMaxQueneSize)=Qx(HalfMaxQueneSize+1:Qn);
Py(Pn+1:Pn+Qn-HalfMaxQueneSize)=Qy(HalfMaxQueneSize+1:Qn);
Pn=Pn+Qn-HalfMaxQueneSize; %update Pn
Qn=HalfMaxQueneSize; %update Qn
MinQualityThresh=Qa(Qn);%Update MinQualityThresh


%function 3: Copy pixels from APP to AQP if AQP is empty
function [Qx,Qy,Qa,Qn,Px,Py,Pa,Pn,MinQualityThresh]= ...
    Copy2Quene(Qx,Qy,Qa,Qn,Px,Py,Pa,Pn,HalfMaxQueneSize)
Cn=min(Pn,HalfMaxQueneSize);%number of pixel to be copied
[temp I]=sort(Pa(1:Pn),'descend'); %sort APP and store in 'temp'
Qa(1:Cn)=temp(1:Cn); %copy to AQP
Qx(1:Cn)=Px(I(1:Cn));
Qy(1:Cn)=Py(I(1:Cn));
Qn=Cn; % update Qn
MinQualityThresh=Qa(Qn); %update MInQualityThresh
Pa(1:Pn-Cn)=temp(Cn+1:Pn); %arrange APP
Px(1:Pn-Cn)=Px(I(Cn+1:Pn));
Py(1:Pn-Cn)=Py(I(Cn+1:Pn));
Pn=Pn-Cn;%update Pn
