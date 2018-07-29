clear
clc

A0=imread('cam.jpg');
% chk=[1 1 1 3 1 1 2 1 1 2 3 2 2 2 1 1 1 2 3 1 1 4 1 3 2 1 1,...
%     1 1 1 1 1 2 1 2 2 3 1 1 2 1 2 3 2 1 4 1 1 1 1 3 2 2 2 2,...
%     1 1 1 1]; % for cam1
% chk=[1 1 1 3 1 1 2 1 1 2 3 2 1 2 2 1 1 2 3 3 1 2 1 3 2, ...
%     1 1 1 1 1 1 1 3 2 1 1 2 2 2 1 2 2 2 1 1 1 3 2 1 1 3 2, ...
%     1 2 3 1 1 1 1]; % for cam
% chk=[1 1 1 3 1 1 2 1 1 2 3 1 1 1 4 1 1 2 3 1 1 4 1 1, ...
%     1 1 4 1 1 1 1 1 1 1 1 4 1 3 1 2 3 2 1 1 1 1 3 2 2,...
%     2 2 1 3 2 1 1 1 1 1]; % for cam3
% chk=[1 1 1 1 3 1 2 3 1 2 1 1 1 2 3 3 2 1 1 2 1 3 1 3 2 1,...
%     1 1 1 1 1 1 2 2 2 1 1 1 3 2 1 1 3 2 1 3 1 2 3 1 1 2 1,...
%     2 1 3 1 1 1]; % for cambook3
A0=rgb2gray(A0);
% A=A0([90:330],[1:604]); % for cam1
A=A0([99+30:99+260],[71:608]); % for cam
% A=A0([182:389],[1:600]); % for cam3
% A=A0([193:349],[1:504]); % for cambook3
return
figure(1), imshow(A)%, return

nSeg=10;
wSeg=floor(size(A,1)/nSeg);

for i=1:nSeg

    At=A((i-1)*wSeg+1:i*wSeg,:);
    %figure(2), imshow(At)

    gsv(i,:)=255-mean(double(At),1);
    x=[1:length(gsv(i,:))]; g=gsv(i,:);
    [gw,xw]=movAvg(g,1);
    %figure(3), plot(x,gsv(i,:),xw,gw)

    dgw=diffScheme(gw);
    [pk1,loc1]=peakDetect(dgw,20,5);
    % sub-pixel edge detection
    for i1=1:length(loc1)
        [X1(i1),P1(i1)]=subPx(dgw(loc1(i1)-5:loc1(i1)+5),...
            xw(loc1(i1)-5:loc1(i1)+5),...
            dgw(loc1(i1)),100);
        %g=dgw(loc1(i)-5:loc1(i)+20); gMax=dgw(loc1(i)); save subPxData.mat g gMax
    end
    [pk2,loc2]=peakDetect(-dgw,20,5);
    for i1=1:length(loc2)
        [X2(i1),P2(i1)]=subPx(-dgw(loc2(i1)-5:loc2(i1)+5),...
            xw(loc2(i1)-5:loc2(i1)+5),...
            -dgw(loc2(i1)),100);
    end
    P2=-P2;
    
    if length(loc1)~=length(loc2)
        disp('oops! ... left edge & right edge don''t match!!');
    end
    %figure(4), plot(xw,dgw,'.k-',xw(loc1),dgw(loc1),'o',...
    %    xw(loc2),dgw(loc2),'o',X1,P1,'o',X2,P2,'o')

    % black gap
    bGap=X2-X1;
    % white gap
    wGap=-X2(1:end-1)+X1(2:end);

    % discretizing barcodes
    %figure(5), subplot(2,1,1), plot(sort(bGap),'ok')
    %subplot(2,1,2), plot(sort(wGap),'or'), pause(0.1)
    
    % working on white gaps
    [wGap2,wid]=sort(wGap);
    dwGap2=wGap2(2:end)-wGap2(1:end-1);
    [wGap21,dwid]=sort(dwGap2);
    bound(1:3)=sort(dwid(end:-1:end-2)+1);
    clear wGap21 dwid
    s1=mean(wGap2(1:bound(1)-1));
    s2=mean(wGap2(bound(1):bound(2)-1));
    s3=mean(wGap2(bound(2):bound(3)-1));
    s4=mean(wGap2(bound(3):end));
    if s4/s1 <3.5 % 4 is not present
        if s2/s1>1.5
            S1=wid(1:bound(1)-1); % s1 and s2 are exclusive
            if s3/s2<1.2 % s2 and s3 are same
                S2=wid(bound(1):bound(3)-1);
                S3=wid(bound(3):end);
            else % s2 and s3 are separate
                S2=wid(bound(1):bound(2)-1);
                S3=wid(bound(2):end);
            end
        else
            S1=wid(1:bound(2)-1); % s1 and s2 are inclusive
            S2=wid(bound(2)-1:bound(3));
            S3=wid(bound(3)-1:end);
        end
        S4=[];
    else % 4 is present
        S1=wid(1:bound(1)-1);
        S2=wid(bound(1):bound(2)-1);
        S3=wid(bound(2):bound(3)-1);
        S4=wid(bound(3):end);
    end
    %figure(6),plot(wGap(S1),'o'),hold on,plot(wGap(S2),'.'),plot(wGap(S3),'x'),hold off
    wGap3(S1)=1; 
    wGap3(S2)=2;
    wGap3(S3)=3;
    if ~isempty('S4'), wGap3(S4)=4; end

    % working on black gaps
    [bGap2,bid]=sort(bGap);
    dbGap2=bGap2(2:end)-bGap2(1:end-1);
    [bGap21,dbid]=sort(dbGap2);
    bound(1:3)=sort(dbid(end:-1:end-2)+1);
    clear bGap21 dbid
    t1=mean(bGap2(1:bound(1)-1));
    t2=mean(bGap2(bound(1):bound(2)-1));
    t3=mean(bGap2(bound(2):bound(3)-1));
    t4=mean(bGap2(bound(3):end));
    if t4/t1 <3.5 % 4 is not present
        if t2/t1>1.5
            T1=bid(1:bound(1)-1); % t1 and t2 are exclusive
            if t3/t2<1.2 % t2 and t3 are same
                T2=bid(bound(1):bound(3)-1);
                T3=bid(bound(3):end);
            else % t2 and t3 are separate
                T2=bid(bound(1):bound(2)-1);
                T3=bid(bound(2):end);
            end
        else
            T1=bid(1:bound(2)-1); % t1 and t2 are inclusive
            T2=bid(bound(2)-1:bound(3));
            T3=bid(bound(3)-1:end);
        end
        T4=[];
    else % 4 is present
        T1=bid(1:bound(1)-1);
        T2=bid(bound(1):bound(2)-1);
        T3=bid(bound(2):bound(3)-1);
        T4=bid(bound(3):end);
    end
    %figure(7),plot(bGap(T1),'o'),hold on,plot(bGap(T2),'.'),plot(bGap(T3),'x'),hold off
    bGap3(T1)=1;
    bGap3(T2)=2;
    bGap3(T3)=3;
    if ~isempty('T4'), bGap3(T4)=4; end
    
    %wGap3=round(wGap/mean(wGap2(1:10)));
    %bGap3=round(bGap/mean(bGap2(1:10)));

    I(i).gap=zeros(length(bGap)+length(wGap),1);
    I(i).gap(1:2:end)=bGap3;
    I(i).gap(2:2:end)=wGap3;

    %disp(['segment: ',num2str(i),' | errors: ',num2str(sum((I(i).gap'-chk)~=0))])
    if i==1
        G=I(i).gap;
    else
        for j=1:length(I(i).gap)
            G(j)=G(j)+I(i).gap(j);
        end
    end

end

G=round(G/nSeg);
barcode=barcodeEAN13(G);
%reading_error=sum(sum(G'-chk))