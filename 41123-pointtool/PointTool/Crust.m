function [t,tnorm]=Crust(p)
%error check

if nargin>1
    error('The only input must be the Nx3 array of points');
end

[n]=size(p,2);
if n ~=3
       error('Input 3D points must be stored in a Nx3 array');
end 
clear  n


%%   Main
starttime=clock;

%add points to the given ones, this is usefull
%to create outside tetraedroms
tic
h = waitbar(0,'Please wait , the surface is compute......','name','surface computation');
[p,nshield]=AddShield(p);
fprintf('Added Shield: %4.4f s\n',toc)
waitbar(1/6);


tic
tetr=delaunayn(p);%creating tedraedron
tetr=int32(tetr);%use integer to save memory
fprintf('Delaunay Triangulation Time: %4.4f s\n',toc)
waitbar(2/6);


%connectivity data
%find triangles to tetraedrom and tetraedrom to triangles connectivity data
tic
[t2tetr,tetr2t,t]=Connectivity(tetr);
fprintf('Connectivity Time: %4.4f s\n',toc)
waitbar(3/6);

tic
[cc,r]=CC(p,tetr);%Circumcenters of tetraedroms
fprintf('Circumcenters Time: %4.4f s\n',toc)
clear n
waitbar(4/6)

tic
[tbound,Ifact]=Marking(p,tetr,tetr2t,t2tetr,cc,r,nshield);%Flagging tetraedroms as inside or outside
fprintf('Walking Time: %4.4f s\n',toc)
waitbar(5/6)
%recostructed raw surface
t=t(tbound,:);
% Ifact=Ifact(tbound);
clear tetr tetr2t t2tetr

%m
tic
[t,tnorm]=ManifoldExtraction(t,p);
fprintf('Manifold extraction Time: %4.4f s\n',toc)
waitbar(6/6);


time=etime(clock,starttime);
fprintf('Total Time: %4.4f s\n',time)
close(h);

end


%% Circumcenters
function [cc,r]=CC(p,tetr)
%finds circumcenters from a set of tetraedroms


%batch the code to save memory
ntetr=size(tetr,1);
cutsize=25000;
i1=1;i2=cutsize;
r=zeros(ntetr,1);
cc=zeros(ntetr,1);

if i2>ntetr
    i2=ntetr;%to trigeer the terminate criterion
end


while 1




%points of tetraedrom
p1=(p(tetr(i1:i2,1),:));
p2=(p(tetr(i1:i2,2),:));
p3=(p(tetr(i1:i2,3),:));
p4=(p(tetr(i1:i2,4),:));

%vectors of tetraedrom edges
v21=p1-p2;
v31=p3-p1;
v41=p4-p1;




%Solve the system using cramer method
d1=sum(v41.*(p1+p4)*.5,2);
d2=sum(v21.*(p1+p2)*.5,2);
d3=sum(v31.*(p1+p3)*.5,2);

det23=(v21(:,2).*v31(:,3))-(v21(:,3).*v31(:,2));
det13=(v21(:,3).*v31(:,1))-(v21(:,1).*v31(:,3));
det12=(v21(:,1).*v31(:,2))-(v21(:,2).*v31(:,1));

Det=v41(:,1).*det23+v41(:,2).*det13+v41(:,3).*det12;


detx=d1.*det23+...
    v41(:,2).*(-(d2.*v31(:,3))+(v21(:,3).*d3))+...
    v41(:,3).*((d2.*v31(:,2))-(v21(:,2).*d3));

dety=v41(:,1).*((d2.*v31(:,3))-(v21(:,3).*d3))+...
    d1.*det13+...
    v41(:,3).*((d3.*v21(:,1))-(v31(:,1).*d2));

detz=v41(:,1).*((v21(:,2).*d3)-(d2.*v31(:,2)))...
    +v41(:,2).*(d2.*v31(:,1)-v21(:,1).*d3)...
    +d1.*(det12);

%Circumcenters
cc(i1:i2,1)=detx./Det;
cc(i1:i2,2)=dety./Det;
cc(i1:i2,3)=detz./Det;

%Circumradius
r(i1:i2)=realsqrt((sum((p2-cc(i1:i2,:)).^2,2)));%ciecum radius

if i2==ntetr
    break;%terminate criterion
end

i1=i1+cutsize;
i2=i2+cutsize;

if i2>ntetr
    i2=ntetr;%to trigeer the terminate criterion
end

end

end



%% Connectivity

function [t2tetr,tetr2t,t]=Connectivity(tetr)

%Gets conectivity relantionships among tetraedroms

numt = size(tetr,1);
vect = 1:numt;
t = [tetr(:,[1,2,3]); tetr(:,[2,3,4]); tetr(:,[1,3,4]);tetr(:,[1,2,4])];%triangles not unique
[t,j,j] = unique(sort(t,2),'rows');%triangles
t2tetr = [j(vect), j(vect+numt), j(vect+2*numt),j(vect+3*numt)];%each tetraedrom has 4 triangles


% triang-to-tetr connectivity

nume = size(t,1);
tetr2t  = zeros(nume,2,'int32');
count= ones(nume,1,'int8');
for k = 1:numt

    for j=1:4
        ce = t2tetr(k,j);
        tetr2t(ce,count(ce)) = k;
        count(ce)=count(ce)+1;
    end

end


end      % connectivity()



%% Marking
function [tbound,Ifact]=Marking(p,tetr,tetr2t,t2tetr,cc,r,nshield)
%The more important routine to flag tetredroms as outside or inside

%costants for the algorithm

TOLLDIFF=.01;%tollerance decrease at each iteration
% (the higher the value the more robust but slower is the algorithm. It is also required
% a higher MAXLEVEL value to rach the end of iterations. );


INITTOLL=.99;%starting tollerance

MAXLEVEL=10/TOLLDIFF;%maximum  reachable level 
BRUTELEVEL=MAXLEVEL-50;%level to start  brute continuation



%preallocation
np=size(p,1)-nshield;%nshield = number of shield points put at the end of array
numtetr=size(tetr,1);
nt=size(tetr2t,1);
% deleted=true(numtetr,1);%deleted tetraedroms
% checked=false(numtetr,1);%checked tetraedroms
onfront=false(nt,1);%tetraedroms that need to be checked
% countchecked=0;%counter of checked tetraedroms


%First flag as outside tetraedroms with Shield points

%unvectorized
% for i=1:numtetr
%     for j=1:4
%         if tetr(i,j)>np;
%             deleted(i)=true;
%             checked(i)=true;
%             onfront(t2tetr(i,:))=true;
%             countchecked=countchecked+1;
%             break
%         end
%     end
% end

%vectorized
deleted=any(tetr>np,2);%deleted tetraedroms
checked=deleted;%checked tetraedroms
onfront(t2tetr(checked,:))=true;
countchecked=sum(checked);%counter of checked tetraedroms


%tollerances to mark as in or out
toll=zeros(nt,1)+INITTOLL;
level=0;

%intersection factor
%it is computed from radius of the tetraedroms circumscribed sphere
% and the distance between their center
Ifact=IntersectionFactor(tetr2t,cc,r);
clear cc r




%         Now we scan all tetraedroms. When one is scanned puts on front is
%         neighbor. This means that now  the neighobor can be checked too.
%         At the begining only tetraedroms with shield points are on front,
%         because we are sure the are out. Tetraedrom with high
%         intersection factor  will be marked as equal else different. When
%         I say high i mean under a set tollerance that becames lower as
%         the algorithm progresses. This Aims to avoid errors propagation
%         when a tetraedrom is wrong marked.
%
ids=1:nt;
queue=ids(onfront);
nt=length(queue);
while countchecked<numtetr && level<MAXLEVEL
    level=level+1;%level of scan reached

    for i=1:nt%loop trough triangles <-----better is check only unchecked

        id=queue(i);

        tetr1=tetr2t(id,1);tetr2=tetr2t(id,2);%tetraedroms linked to triangle under analysis
        if  tetr2==0 %do not check boundary triangles
            onfront(id)=false;
            continue

        elseif (checked(tetr1) && checked(tetr2)) %tetraedroms are already checked
            onfront(id)=false;
            continue

        end

        if Ifact(id)>=toll(id) %flag as equal
            if checked(tetr1)%find the checked one between the two
                deleted(tetr2)=deleted(tetr1) ;%flag as equal
                checked(tetr2)=true;%check
                countchecked=countchecked+1;
                onfront(t2tetr(tetr2,:))=true;%put on front all tetreadrom triangles
            else
                deleted(tetr1)=deleted(tetr2) ;%flag as equal
                checked(tetr1)=true;%check
                countchecked=countchecked+1;
                onfront(t2tetr(tetr1,:))=true;%put on front all tetreadrom triangles
            end
            onfront(id)=false;%remove from front


        elseif Ifact(id)<-toll(id)%flag as different
            if checked(tetr1)%find the checked one between the two
                deleted(tetr2)=~(deleted(tetr1)) ;%flag as different
                checked(tetr2)=true;%check
                countchecked=countchecked+1;
                onfront(t2tetr(tetr2,:))=true;%put on front all tetreadrom triangles
            else
                deleted(tetr1)=~(deleted(tetr2)) ;%flag as different
                checked(tetr1)=true;%check
                countchecked=countchecked+1;
                onfront(t2tetr(tetr1,:))=true;%put on front all tetreadrom triangles
            end
            onfront(id)=false;%remove from front


        else
            toll(id)=toll(id)-TOLLDIFF;%tolleraces were too high next time will be lower

        end



    end

    if level==BRUTELEVEL %brute continuation(this may appens when there are almost null volume tetraedroms)
        beep
        warning('Brute continuation necessary')
        onfront(t2tetr(~(checked),:))=true;%force onfront collocation
    end

    %update the queue
    queue=ids(onfront);
    nt=length(queue);

end










%extract boundary triangles
 tbound=BoundTriangles(tetr2t,deleted);


% this is the raw surface and needsimprovements to be used in CAD systems.
% Maybe in my next revision I will add surface post treatments. Anyway for
% grafical purpose this should be good.



%Output Data
numchecked=countchecked/numtetr;
if level==MAXLEVEL
    warning([num2str(level),' th level was reached\n'])
else
    fprintf('%4.0f th level was reached\n',level)
end
fprintf('%4.4f %% of Tetraedroms were checked\n',numchecked*100)



end






%% AddShield
function [pnew,nshield]=AddShield(p)

%adds outside points to the given cloud forming outside tetraedroms

%shield points are very good in detectinf outside tetraedroms. Unfortunatly
%delunany triangulation with these points can be even of 50% slower.

%find the bounding box
maxx=max(p(:,1));
maxy=max(p(:,2));
maxz=max(p(:,3));
minx=min(p(:,1));
miny=min(p(:,2));
minz=min(p(:,3));

%give offset to the bounding box
step=max(abs([maxx-minx,maxy-miny,maxz-minz]));

maxx=maxx+step;
maxy=maxy+step;
maxz=maxz+step;
minx=minx-step;
miny=miny-step;
minz=minz-step;

N=10;%number of points of the shield edge

step=step/(N*N);%decrease step, avoids not unique points



nshield=N*N*6;

%creating a grid lying on the bounding box
vx=linspace(minx,maxx,N);
vy=linspace(miny,maxy,N);
vz=linspace(minz,maxz,N);




[x,y]=meshgrid(vx,vy);
facez1=[x(:),y(:),ones(N*N,1)*maxz];
facez2=[x(:),y(:),ones(N*N,1)*minz];
[x,y]=meshgrid(vy,vz-step);
facex1=[ones(N*N,1)*maxx,x(:),y(:)];
facex2=[ones(N*N,1)*minx,x(:),y(:)];
[x,y]=meshgrid(vx-step,vz);
facey1=[x(:),ones(N*N,1)*maxy,y(:)];
facey2=[x(:),ones(N*N,1)*miny,y(:)];

%add points to the p array
pnew=[p;
    facex1;
    facex2;
    facey1;
    facey2;
    facez1;
    facez2];

% figure(4)
% plot3(pnew(:,1),pnew(:,2),pnew(:,3),'.g')


end



%% BoundTriangles
function tbound=BoundTriangles(tetr2t,deleted)
%extracts boundary triangles from a set tetr2t connectivity and form the
%deleted vector which tells tetraedroms that are marked as out

nt=size(tetr2t,1);%number of totals triangles

tbound=true(nt,2);%inizilize to keep shape in next operation

ind=tetr2t>0;%avoid null index
tbound(ind)=deleted(tetr2t(ind));%mark 1 for deleted 0 for kept tetraedroms

tbound=sum(tbound,2)==1;%bounary triangles only have one tetraedrom

end


%% Intersection factor
function Ifact=IntersectionFactor(tetr2t,cc,r)
nt=size(tetr2t,1);
Ifact=zeros(nt,1);%intersection factor
%it is computed from radius of the tetraedroms circumscribed sphere
% and the distance between their center
i=tetr2t(:,2)>0;
distcc=sum((cc(tetr2t(i,1),:)-cc(tetr2t(i,2),:)).^2,2);%distance between circumcenters
Ifact(i)=(-distcc+r(tetr2t(i,1)).^2+r(tetr2t(i,2)).^2)./(2*r(tetr2t(i,1)).*r(tetr2t(i,2)));

%unvectorized
% for i=1:nt
%     if tetr2t(i,2)>0 %jump boundary tetraedrom
%         distcc=sum((cc(tetr2t(i,1),:)-cc(tetr2t(i,2),:)).^2,2);%distance between circumcenters
%         %intersection factor
%         Ifact(i)=(-distcc+r(tetr2t(i,1))^2+r(tetr2t(i,2))^2)/(2*r(tetr2t(i,1))*r(tetr2t(i,2)));
%     end
% end
end




%% Manifold Extraction

function [t,tnorm]=ManifoldExtraction(t,p)
%Given a set of trianlges,
%Buils a manifolds surface with the ball pivoting method.



% building the etmap

numt = size(t,1);
vect = 1:numt;                                                             % Triangle indices
e = [t(:,[1,2]); t(:,[2,3]); t(:,[3,1])];                                  % Edges - not unique
[e,j,j] = unique(sort(e,2),'rows');                                        % Unique edges
te = [j(vect), j(vect+numt), j(vect+2*numt)];
nume = size(e,1);
e2t  = zeros(nume,2,'int32');

clear vect j
ne=size(e,1);
np=size(p,1);


count=zeros(ne,1,'int32');%numero di triangoli candidati per edge
etmapc=zeros(ne,4,'int32');
for i=1:numt

    i1=te(i,1);
    i2=te(i,2);
    i3=te(i,3);



    etmapc(i1,1+count(i1))=i;
    etmapc(i2,1+count(i2))=i;
    etmapc(i3,1+count(i3))=i;


    count(i1)=count(i1)+1;
    count(i2)=count(i2)+1;
    count(i3)=count(i3)+1;
end

etmap=cell(ne,1);
for i=1:ne

    etmap{i,1}=etmapc(i,1:count(i));

end
clear  etmapc

tkeep=false(numt,1);%all'inizio nessun trinagolo selezionato


%Start the front

%building the queue to store edges on front that need to be studied
efront=zeros(nume,1,'int32');%exstimate length of the queue

%Intilize the front


         tnorm=Tnorm(p,t);%get traingles normals
         
         %find the highest triangle
         [foo,t1]=max( (p(t(:,1),3)+p(t(:,2),3)+p(t(:,3),3))/3);

         if tnorm(t1,3)<0
             tnorm(t1,:)=-tnorm(t1,:);%punta verso l'alto
         end
         
         %aggiungere il ray tracing per verificare se il triangolo punta
         %veramente in alto.
         %Gli altri triangoli possono essere trovati sapendo che se un
         %triangolo ha il baricentro più alto sicuramente contiene il punto
         %più alto. Vanno analizzati tutto i traingoli contenenti questo
         %punto
         
         
            tkeep(t1)=true;%primo triangolo selezionato
            efront(1:3)=te(t1,1:3);
            e2t(te(t1,1:3),1)=t1;
            nf=3;%efront iterato
      

while nf>0


    k=efront(nf);%id edge on front

    if e2t(k,2)>0 || e2t(k,1)<1 || count(k)<2 %edge is no more on front or it has no candidates triangles

        nf=nf-1;
        continue %skip
    end
  
   
      %candidate triangles
    idtcandidate=etmap{k,1};

    
     t1=e2t(k,1);%triangle we come from
    
   
        
    %get data structure
%        p1
%       / | \
%  t1 p3  e1  p4 t2(idt)
%       \ | /  
%        p2
         alphamin=inf;%inizilizza
          ttemp=t(t1,:);
                etemp=e(k,:);
                p1=etemp(1);
                p2=etemp(2);
                p3=ttemp(ttemp~=p1 & ttemp~=p2);%terzo id punto
        
                
         %plot for debug purpose
%          close all
%          figure(1)
%          axis equal
%          hold on
%          
%          fs=100;
%         
%          cc1=(p(t(t1,1),:)+p(t(t1,2),:)+p(t(t1,3),:))/3;
%          
%          trisurf(t(t1,:),p(:,1),p(:,2),p(:,3))
%          quiver3(cc1(1),cc1(2),cc1(3),tnorm(t1,1)/fs,tnorm(t1,2)/fs,tnorm(t1,3)/fs,'b');
%                 
       for i=1:length(idtcandidate)
               t2=idtcandidate(i);
               if t2==t1;continue;end;
                
               %debug
%                cc2=(p(t(t2,1),:)+p(t(t2,2),:)+p(t(t2,3),:))/3;
%          
%                 trisurf(t(t2,:),p(:,1),p(:,2),p(:,3))
%                 quiver3(cc2(1),cc2(2),cc2(3),tnorm(t2,1)/fs,tnorm(t2,2)/fs,tnorm(t2,3)/fs,'r');
%                
%                

               
                ttemp=t(t2,:);
                p4=ttemp(ttemp~=p1 & ttemp~=p2);%terzo id punto
        
   
                %calcola l'angolo fra i triangoli e prendi il minimo
              
                
                [alpha,tnorm2]=TriAngle(p(p1,:),p(p2,:),p(p3,:),p(p4,:),tnorm(t1,:));
                
                if alpha<alphamin
                    
                    alphamin=alpha;
                    idt=t2;  
                    tnorm(t2,:)=tnorm2;%ripristina orientazione   
                     
                    %debug
%                      quiver3(cc2(1),cc2(2),cc2(3),tnorm(t2,1)/fs,tnorm(t2,2)/fs,tnorm(t2,3)/fs,'c');
                    
                end
                %in futuro considerare di scartare i trianoli con angoli troppi bassi che
                %possono essere degeneri
                
       end


   
   
    
    
   %update front according to idttriangle
          tkeep(idt)=true;
        for j=1:3
            ide=te(idt,j);
           
            if e2t(ide,1)<1% %Is it the first triangle for the current edge?
                efront(nf)=ide;
                nf=nf+1;
                e2t(ide,1)=idt;
            else                     %no, it is the second one
                efront(nf)=ide;
                nf=nf+1;
                e2t(ide,2)=idt;
            end
        end
        
     
        

         nf=nf-1;%per evitare di scappare avanti nella coda e trovare uno zero
end

t=t(tkeep,:);
tnorm=tnorm(tkeep,:);

end





%% TriAngle
function  [alpha,tnorm2]=TriAngle(p1,p2,p3,p4,planenorm)

%per prima cosa vediamo se il p4 sta sopra o sotto il piano identificato
%dalla normale planenorm e il punto p3

test=sum(planenorm.*p4-planenorm.*p3);



%Computes angle between two triangles
v21=p1-p2;
v31=p3-p1;

tnorm1(1)=v21(2)*v31(3)-v21(3)*v31(2);%normali ai triangoli
tnorm1(2)=v21(3)*v31(1)-v21(1)*v31(3);
tnorm1(3)=v21(1)*v31(2)-v21(2)*v31(1);
tnorm1=tnorm1./norm(tnorm1);



v41=p4-p1;
tnorm2(1)=v21(2)*v41(3)-v21(3)*v41(2);%normali ai triangoli
tnorm2(2)=v21(3)*v41(1)-v21(1)*v41(3);
tnorm2(3)=v21(1)*v41(2)-v21(2)*v41(1);
tnorm2=tnorm2./norm(tnorm2);
alpha=tnorm1*tnorm2';%coseno dell'angolo
%il coseno considera l'angolo fra i sempipiani e non i traigoli, ci dice
%che i piani sono a 180 se alpha=-1 sono concordi se alpha=1, a 90°

alpha=acos(alpha);%trova l'angolo

%Se p4 sta sopra il piano l'angolo è quello giusto altrimenti va maggiorato
%di 2*(180-alpha);

if test<0%p4 sta sotto maggioriamo
   alpha=alpha+2*(pi-alpha);
end

%         fs=100;
%          cc2=(p1+p2+p3)/3;
%        quiver3(cc2(1),cc2(2),cc2(3),tnorm1(1)/fs,tnorm1(2)/fs,tnorm1(3)/fs,'m');
%        cc2=(p1+p2+p4)/3;
%               quiver3(cc2(1),cc2(2),cc2(3),tnorm2(1)/fs,tnorm2(2)/fs,tnorm2(3)/fs,'m');

%vediamo se dobbiamo cambiare l'orientazione del secondo triangolo
%per come le abbiamo calcolate ora tnorm1 t tnorm2 non rispettano
%l'orientamento
testor=sum(planenorm.*tnorm1);
if testor>0 
    tnorm2=-tnorm2;
end



end


%% Tnorm

function tnorm1=Tnorm(p,t)
%Computes normalized normals of triangles


v21=p(t(:,1),:)-p(t(:,2),:);
v31=p(t(:,3),:)-p(t(:,1),:);

tnorm1(:,1)=v21(:,2).*v31(:,3)-v21(:,3).*v31(:,2);%normali ai triangoli
tnorm1(:,2)=v21(:,3).*v31(:,1)-v21(:,1).*v31(:,3);
tnorm1(:,3)=v21(:,1).*v31(:,2)-v21(:,2).*v31(:,1);

L=sqrt(sum(tnorm1.^2,2));

tnorm1(:,1)=tnorm1(:,1)./L;
tnorm1(:,2)=tnorm1(:,2)./L;
tnorm1(:,3)=tnorm1(:,3)./L;
end
