%points2contour
%Tristan Ursell
%Sept 2013
%
%[Xout,Yout]=points2contour(Xin,Yin,P,direction)
%[Xout,Yout]=points2contour(Xin,Yin,P,direction,dlim)
%[Xout,Yout,orphans]=points2contour(Xin,Yin,P,direction,dlim)
%[Xout,Yout,orphans,indout]=points2contour(Xin,Yin,P,direction,dlim)
%
%Given any list of 2D points (Xin,Yin), construct a singly connected
%nearest-neighbor path in either the 'cw' or 'ccw' directions.  The code 
%has been written to handle square and hexagon grid points, as well as any
%non-grid arrangement of points. 
%
%'P' sets the point to begin looking for the contour from the original
%ordering of (Xin,Yin), and 'direction' sets the direction of the contour, 
%with options 'cw' and 'ccw', specifying clockwise and counter-clockwise, 
%respectively. 
%
%The optional input parameter 'dlim' sets a distance limit, if the distance
%between a point and all other points is greater than or equal to 'dlim',
%the point is left out of the contour.
%
%The optional output 'orphans' gives the indices of the original (Xin,Yin)
%points that were not included in the contour.
%
%The optional output 'indout' is the order of indices that produces
%Xin(indout)=Xout and Yin(indout)=Yout.
%
%There are many (Inf) situations where there is no unique mapping of points
%into a connected contour -- e.g. any time there are more than 2 nearest 
%neighbor points, or in situations where the nearest neighbor matrix is 
%non-symmetric.  Picking a different P will result in a different contour.
%Likewise, in cases where one point is far from its neighbors, it may be
%orphaned, and only connected into the path at the end, giving strange
%results.
%
%The input points can be of any numerical class.
%
%Note that this will *not* necessarily form the shortest path between all
%the points -- that is the NP-Hard Traveling Salesman Problem, for which 
%there is no deterministic solution.  This will, however, find the shortest
%path for points with a symmetric nearest neighbor matrix.
%
%see also: bwtraceboundary
%
%Example 1:  continuous points
%N=200;
%P=1;
%theta=linspace(0,2*pi*(1-1/N),N);
%[~,I]=sort(rand(1,N));
%R=2+sin(5*theta(I))/3;
%
%Xin=R.*cos(theta(I));
%Yin=R.*sin(theta(I));
%
%[Xout,Yout]=points2contour(Xin,Yin,P,'cw');
%
%figure;
%hold on
%plot(Xin,Yin,'b-')
%plot(Xout,Yout,'r-','Linewidth',2)
%plot(Xout(2:end-1),Yout(2:end-1),'k.','Markersize',15)
%plot(Xout(1),Yout(1),'g.','Markersize',15)
%plot(Xout(end),Yout(end),'r.','Markersize',15)
%xlabel('X')
%ylabel('Y')
%axis equal tight
%title(['Black = original points, Blue = original ordering, Red = new ordering, Green = starting points'])
%box on
%
%
%Example 2:  square grid
%P=1;
%
%Xin=[1,2,3,4,4,4,4,3,2,1,1,1];
%Yin=[0,0,0,0,1,2,3,3,2,2,1,0];
%
%[Xout,Yout]=points2contour(Xin,Yin,P,'cw');
%
%figure;
%hold on
%plot(Xin,Yin,'b-')
%plot(Xout,Yout,'r-','Linewidth',2)
%plot(Xout(2:end-1),Yout(2:end-1),'k.','Markersize',15)
%plot(Xout(1),Yout(1),'g.','Markersize',15)
%plot(Xout(end),Yout(end),'r.','Markersize',15)
%xlabel('X')
%ylabel('Y')
%axis equal tight
%box on
%
%Example 3:  continuous points, pathological case
%N=200;
%P=1;
%theta=linspace(0,2*pi*(1-1/N),N);
%[~,I]=sort(rand(1,N));
%R=2+sin(5*theta(I))/3;
%
%Xin=(1+rand(1,N)/2).*R.*cos(theta(I));
%Yin=(1+rand(1,N)/2).*R.*sin(theta(I));
%
%[Xout,Yout]=points2contour(Xin,Yin,P,'cw');
%
%figure;
%hold on
%plot(Xin,Yin,'b-')
%plot(Xout,Yout,'r-','Linewidth',2)
%plot(Xout(2:end-1),Yout(2:end-1),'k.','Markersize',15)
%plot(Xout(1),Yout(1),'g.','Markersize',15)
%plot(Xout(end),Yout(end),'r.','Markersize',15)
%xlabel('X')
%ylabel('Y')
%axis equal tight
%title(['Black = original points, Blue = original ordering, Red = new ordering, Green = starting points'])
%box on
%
%Example 4:  continuous points, distance limit applied
%N=200;
%P=1;
%theta=linspace(0,2*pi*(1-1/N),N);
%[~,I]=sort(rand(1,N));
%R=2+sin(5*theta(I))/3;
%R(2)=5; %the outlier
%
%Xin=(1+rand(1,N)/16).*R.*cos(theta(I));
%Yin=(1+rand(1,N)/16).*R.*sin(theta(I));
%
%[Xout,Yout,orphans,indout]=points2contour(Xin,Yin,P,'cw',1);
%
%figure;
%hold on
%plot(Xin,Yin,'b-')
%plot(Xin(orphans),Yin(orphans),'kx')
%plot(Xin(indout),Yin(indout),'r-','Linewidth',2)
%plot(Xout(2:end-1),Yout(2:end-1),'k.','Markersize',15)
%plot(Xout(1),Yout(1),'g.','Markersize',15)
%plot(Xout(end),Yout(end),'r.','Markersize',15)
%xlabel('X')
%ylabel('Y')
%axis equal tight
%title(['Black = original points, Blue = original ordering, Red = new ordering, Green = starting points'])
%box on
%

function [Xout,Yout,varargout]=points2contour(Xin,Yin,P,direction,varargin)

%check to make sure the vectors are the same length
if length(Xin)~=length(Yin)
    error('Input vectors must be the same length.')
end

%check to make sure point list is long enough
if length(Xin)<2
    error('The point list must have more than two elements.')
end

%check distance limit
if ~isempty(varargin)
    dlim=varargin{1};
    if dlim<=0
        error('The distance limit parameter must be greater than zero.')
    end
else
    dlim=-1;
end

%check direction input
if and(~strcmp(direction,'cw'),~strcmp(direction,'ccw'))
    error(['Direction input: ' direction ' is not valid, must be either "cw" or "ccw".'])
end

%check to make sure P is in the right range
P=round(P);
npts=length(Xin);

if or(P<1,P>npts)
    error('The starting point P is out of range.')
end

%adjust input vectors for starting point
if size(Xin,1)==1
    Xin=circshift(Xin,[0,1-P]);
    Yin=circshift(Yin,[0,1-P]);
else
    Xin=circshift(Xin,[1-P,0]);
    Yin=circshift(Yin,[1-P,0]);
end

%find distances between all points
D=zeros(npts,npts);
for q1=1:npts
    D(q1,:)=sqrt((Xin(q1)-Xin).^2+(Yin(q1)-Yin).^2);
end

%max distance
maxD=max(D(:));

%avoid self-connections
D=D+eye(npts)*maxD;

%apply distance contraint by removing bad points and starting over
if dlim>0
    D(D>=dlim)=-1;
    
    %find bad points
    bad_pts=sum(D,1)==-npts;
    orphans=find(bad_pts);
    
    %check starting point
    if sum(orphans==P)>0
        error('The starting point index is a distance outlier, choose a new starting point.')
    end
    
    %get good points
    Xin=Xin(~bad_pts);
    Yin=Yin(~bad_pts);
    
    %number of good points
    npts=length(Xin);
    
    %find distances between all points
    D=zeros(npts,npts);
    for q1=1:npts
        D(q1,:)=sqrt((Xin(q1)-Xin).^2+(Yin(q1)-Yin).^2);
    end
    
    %max distance
    maxD=max(D(:));
    
    %avoid self-connections
    D=D+eye(npts)*maxD;
else
    orphans=[];
    bad_pts=zeros(size(Xin));
end

%tracking vector (has this original index been put into the ordered list?)
track_vec=zeros(1,npts);

%construct directed graph
Xout=zeros(1,npts);
Yout=zeros(1,npts);
indout0=zeros(1,npts);

Xout(1)=Xin(1);
Yout(1)=Yin(1);
indout0(1)=1;

p_now=1;
track_vec(p_now)=1;
for q1=2:npts 
    %get current row of distance matrix
    curr_vec=D(p_now,:);
    
    %remove used points
    curr_vec(track_vec==1)=maxD;
    
    %find index of closest non-assigned point
    p_temp=find(curr_vec==min(curr_vec),1,'first');
    
    %reassign point
    Xout(q1)=Xin(p_temp);
    Yout(q1)=Yin(p_temp);
    
    %move index
    p_now=p_temp;
    
    %update tracking
    track_vec(p_now)=1;
    
    %update index vector
    indout0(q1)=p_now;
end

%undo the circshift
temp1=find(~bad_pts);
indout=circshift(temp1(indout0),[P,0]);

%%%%%%% SET CONTOUR DIRECTION %%%%%%%%%%%%
%contour direction is a *global* feature that cannot be determined until
%all the points have been sequentially ordered.

%calculate tangent vectors
tan_vec=zeros(npts,3);
for q1=1:npts
    if q1==npts
        tan_vec(q1,:)=[Xout(1)-Xout(q1),Yout(1)-Yout(q1),0];
        tan_vec(q1,:)=tan_vec(q1,:)/norm(tan_vec(q1,:));
    else
        tan_vec(q1,:)=[Xout(q1+1)-Xout(q1),Yout(q1+1)-Yout(q1),0];
        tan_vec(q1,:)=tan_vec(q1,:)/norm(tan_vec(q1,:));
    end
end

%determine direction of contour
local_cross=zeros(1,npts);
for q1=1:npts
    if q1==npts
        cross1=cross(tan_vec(q1,:),tan_vec(1,:));
    else
        cross1=cross(tan_vec(q1,:),tan_vec(q1+1,:));
    end
    local_cross(q1)=asin(cross1(3));
end

%figure out current direction
if sum(local_cross)<0
    curr_dir='cw';
else
    curr_dir='ccw';
end
    
%set direction of the contour
if and(strcmp(curr_dir,'cw'),strcmp(direction,'ccw'))
    Xout=fliplr(Xout);
    Yout=fliplr(Yout);
end

%varargout
if nargout==3
    varargout{1}=orphans;
end

if nargout==4
    varargout{1}=orphans;
    varargout{2}=indout;
end

disp('finished')








