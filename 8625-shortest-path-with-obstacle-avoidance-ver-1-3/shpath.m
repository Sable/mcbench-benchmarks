function varargout=shpath(MM,ri,ci,rf,cf)
% SHPATH - shortest path with obstacle avoidance
%
% USAGE:
%
% [r,c]    = shpath(M,ri,ci,rf,cf)
% [r,c,da] = shpath(M,ri,ci,rf,cf)
%
% VARIABLES:
%
% M =       terrain grid matrix of ones and zeros, where ones represent
%           grid squares containing obstacles, and zeros represent clear
%           terrain
% (ri,ci) = intial ROW and COLUMN on the terrain grid matrix, where the
%           path is to begin
% (rf,cf) = final ROW and COLUMN on the terrain grid matrix, where the
%           path is to end
% (r,c)   = ROW and COLUMN coordinates along the shortest obstacle-avoiding
%           path. Altough r and c start and end on the (integer) intial and
%           final point coordinates, intermediate points on the path can
%           have fractional coordinate values
% da      = optional matrix of relative distances from each map point to
%           the FINAL point (rf,cf). The ditance units are arbitrary. This
%           is the raw output of the intitial propagation (see below and
%           see example).
%
% NOTES: (1) To avoid confusion over X/Y conventions for grid matrices,
%            the issue is avoided entirely by referring only to the
%            row and column entries in the terrain grid matrix. The user is
%            invited to employ whatever convention he or she is comfortable
%            using for mapping Cartesian coordinates to the grid matrix
%            entries.
%        (2) When multiple equally short paths are available, one is chosen
%            arbitrarily (but consitently from run to run for identical
%            inputs).
%        (3) This algorithm closely approximates a shortest path with
%            reasonable accuracy and CPU time. A clever user may be able
%            to fool the algorithm with a combination of mutiple, equally
%            short paths, together with obstacles designed to "trap" the
%            algorithm before it has chosen one of them; however:
%        (4) If there is a unique shortest path, the algorithm will find
%            it.
%        (5) Unlike previous versions, the algorithm now WILL accommodate
%            pathways through holes or causeways only one pixel wide.
%            Note that obstacles consisting of diagonally joined grid
%            squares will not prevent motion since diagonal moves are
%            allowed. If you need a diagonal or curved obstacle, be sure to
%            eliminate holes for diagonal moves by filling in adjacent
%            squares.
%        (6) If there is sufficient interest, I may mex the calculations to
%            greatly improve the calcuation speed.
%        (7) A two-stage solution is employed. First, a propagation is
%            performed to determine the shortest pathway. Then, the pathway
%            is tightened around corners and through straight-a-ways.
%        (8) No warranty; use at your own risk.
%        (9) Version 1.0, intial writing
%       (10) Version 1.1, input checking and handling of case with no un-
%            obstructed route existing
%       (11) Version 1.2, propagation phase data output
%       (12) Version 1.3, algorithm speedup, one-pixel hole penetration
%       (13) Michael Kleder, Oct 2005
%
% EXAMPLE EXECUTION:
%
% % Intitial coordinates (row,col)
% ri=85;
% ci=95;
% % Final coordinates (row,col):
% rf=5;
% cf=20;
% % create map grid:
% M = zeros(100);
% % create obstacles:
% M(80,90:100)=1;
% M(30,1:70)=1;
% M(30,72:100)=1;
% M(40:100,20)=1;
% M(70:90,70)=1;
% M(70:90,90)=1;
% M(70,70:90)=1;
% M(90,70:90)=1;
% M(10,15:90)=1;
% for n=0:20;
%     M(30-n,30+n)=1; % diagonal line
% end
% for rd=9:.1:10;
%     th = linspace(0,2*pi,1000);
%     r=50+rd*sin(th);
%     c=70+rd*cos(th);
%     r=round(r);
%     c=round(c);
%     M(sub2ind(size(M),r,c))=1;
% end
% hf=figure;
% hold on
% hM=pcolor(M);
% colormap([0 0 .5;1 0 0])
% set(hM,'edgecolor','none','facecolor','flat')
% % make obstacle grid square edge boundaries plot exactly true:
% set(hM,'xdata',linspace(.5,99.5,100),'ydata',linspace(.5,99.5,100))
% axis ij
% axis equal
% axis tight
% plot(ci,ri,'g.')
% plot(cf,rf,'g.')
% xlim([1 size(M,2)])
% ylim([1 size(M,1)])
% set(gca,'color',[0 0 .5])
% xlabel('Column Coordinate')
% ylabel('Row Coordinate')
% title('Computing Shortest Path...','fontsize',12)
% drawnow
% % compute path:
% [r,c,da]=shpath(M,ri,ci,rf,cf);
% % display result:
% plot(c,r,'g.-')
% title('Shortest Obstacle-Avoiding Path','fontsize',12)
% figure
% hs=surf(da);
% set(hs,'edgecolor','none')
% axis ij
% axis square
% axis tight
% view(0,90)
% title('Relative Path Distance from Final Point')
% cm=rand(20,3);
% colormap(cm);
% colormap copper
% colorbar
% set(gcf,'units','pixels')
% p=get(gcf,'pos');
% set(gcf,'pos',[p(1)+50 p(2)-50 p(3:4)])
% figure(hf)

% input handling:

M=logical(MM);
if any([ri ci rf cf] ~= round([ri ci rf cf]))
    error('Initial and final points must have integer row & column coordinates.')
end
if ri>size(M,1) | ci > size(M,2) | rf > size(M,1) | cf > size(M,2) | ...
        any([ri ci rf cf] < 1)
    error('Initial and final points must be within the grid.')
end
if M(ri,ci) >= 1
    error('Initial point is within an obstacle grid square.')
end
if M(rf,cf) >= 1
    error('Destination point is within an obstacle grid square.')
end
if ri == rf & ci == cf & nargout < 3 % no need to solve
    varargout{1}=[ri;rf];
    varargout{2}=[ci;cf];
    return
end

% compute travel time matrix via finite element diffusion:

speed = .5;
W=zeros(size(M));
W(ri,ci)=1;
H=zeros(size(M));
yespop = sum(W(:)>1);
nochangepop = 0;
itercount = 0;
while nochangepop < 20
    itercount = itercount + 1;
    diffconst = 0.1;
    W(1:end-1 ,:) = W(1:end-1 ,:) + diffconst * W(2:end,:);
    W(2:end,:) = W(2:end,:) + diffconst * W(1:end-1 ,:);
    W(:,1:end-1 ) = W(:,1:end-1 ) + diffconst * W(:,2:end );
    W(:,2:end) = W(:,2:end) + diffconst * W(:,1:end-1 );
    W(logical(M)) = 0;
    H(logical(W>1 & ~H))=itercount;
    yespopold = yespop;
    yespop = sum(W(:)>1);
    if abs(yespop-yespopold) < 1
        nochangepop = nochangepop + 1;
    end
end

% reached the end?

if H(rf,cf) == 0
    warning('No unobstructed route exists.')
    varargout{1}=NaN;
    varargout{2}=NaN;
    if nargout>2
        varargout{3}=NaN;
    end
    return
end

% give travel time matrix if requested

H(H==0)=nan;
if nargout > 2
    varargout{3}=H;
end

% encode slightly larger travel time for obstacles
HB = nan*ones(size(H)+2);
HB(2:end-1,2:end-1)=H;
[kr,kc]=find(isnan(H));
% max local value:
HM = max(cat(3,HB(1:end-2,1:end-2),...
    HB(1:end-2,2:end-1),...
    HB(1:end-2,3:end  ),...
    HB(2:end-1,1:end-2),...
    HB(2:end-1,3:end  ),...
    HB(3:end  ,1:end-2),...
    HB(3:end  ,2:end-1),...
    HB(3:end  ,3:end  )),[],3);
H(isnan(H))=HM(isnan(H))+1; % now 1+max of neighbors

% preallocate path storage space
r=ones(prod(size(M)),1)*nan;
c=ones(prod(size(M)),1)*nan;

% start at end and go backwards down the gradient
r(1)=rf;
c(1)=cf;
[GX,GY] = gradient(H);
GX = -GX;
GY = -GY;
iter = 0;
continflag=1;
rmax=size(M,1);
cmax=size(M,2);
while continflag
    iter = iter+1;
    dr = interpn(GY,r(iter),c(iter),'*linear');
    dc = interpn(GX,r(iter),c(iter),'*linear');
    dr = dr * (rand*.002+.999);
    dc = dc * (rand*.002+.999);
    dv = sqrt(dr^2+dc^2);
    dr = speed * dr/dv;
    dc = speed * dc/dv;
    r(iter+1)=r(iter) + dr;
    c(iter+1)=c(iter) + dc;
    if r(iter+1)<1;r(iter+1)=1;end
    if c(iter+1)<1;c(iter+1)=1;end
    if r(iter+1)>rmax;r(iter+1)=rmax;end
    if c(iter+1)>cmax;c(iter+1)=cmax;end
    if ((r(iter+1)-ri)^2+(c(iter+1)-ci)^2)<1;
        continflag=0;
    end
end

% clean up path coordinates:

r=r(~isnan(r));
c=c(~isnan(c));
c=c(end:-1:1);
r=r(end:-1:1);
if c(1) ~= ci
    c=[ci;c];
end
if c(end) ~= cf
    c=[c;cf];
end
if r(1)~=ri
    r=[ri;r];
end
if r(end)~=rf
    r=[r;rf];
end

% rough path done. Now tighten the string:

continflag=1;
iter=0;
while continflag
    iter=iter+1;
    if iter>50000
        continflag=0;
        warning('Max iterations exceeded.')
    end
    rold = r;
    cold = c;
    r2 = [r(1);(r(1:end-2)+r(3:end))/2;r(end)];
    c2 = [c(1);(c(1:end-2)+c(3:end))/2;c(end)];
    dr = r2-r;
    dc = c2-c;
    dn = .5*sqrt(dr.^2+dc.^2);
    k = dn>.1;
    dr(k) = .1*dr(k)./dn(k);
    dc(k) = .1*dc(k)./dn(k);
    r=r+dr;
    c=c+dc;
    k=interpn(M,r,c,'*nearest')>.5;
    r(k)=r(k)-dr(k);
    c(k)=c(k)-dc(k);
    if max(abs([r-rold;c-cold])) < 1e-4 % decrease to 1e-6 for finer precision
        continflag=0;
    end
end

varargout{1}=r;
varargout{2}=c;
