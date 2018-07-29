function vaa=vangle(pos,v,az,ts,plt)

% vaa=vangle(pos,v,az,ts,plt), vertical acceptance angle
% the function calculates the vertical acceptance angle
% of a shot from position pos, initial speed v,
% azimuth az (default = 0), topspin ts (default = 0).
% If the last argument is present and is greater 
% than zero a plot is shown.
% Examples :
% vaa=vangle([0 1 0.9906],27,0,0,1);
% vaa=vangle([0 1 0.9906],27);

if nargin<5, plt=0; end
if nargin<4, ts=0; end
if nargin<3, az=0; end
if nargin<2, disp('please read help'); vaa=-1; return; end

ER=0:pi/90:pi/2;Y=zeros(size(ER));

for i=1:size(ER,2),
        [pL,tL,ncl]=tnsstroke(pos,[v ER(i) az],ts);
        Y(i)=min([ncl 23.7744-pL(1) pL(2) 8.2296-pL(2)]);
end

if plt,
figure;plot(ER,Y);grid
xlabel('Elevation (rad)');zlabel('min([ncl 23.7744-pL(1) pL(2) 8.2296-pL(2)])');title('Inside Likelyhood');
end

I=find(Y>0);

if isempty(I),
    vaa=-1;
elseif length(I)==length(Y),
    vaa=ER(end);
else
    
    % down up transitions
    du=I.*(Y(I-1)<0);du=du(find(du>0));
    if isempty(du), 
        xdu=ER(1);
    else
        [xdu,ydu]=findzero(ER(du(1)-1),Y(du(1)-1),ER(du(1)),Y(du(1)),pos,v,az,ts);
    end
    
    % up down transitions
    ud=I.*(Y(I+1)<0);ud=ud(find(ud>0));
    if isempty(ud), 
        xud=ER(end);
    else
        [xud,yud]=findzero(ER(ud(1)),Y(ud(1)),ER(ud(1)+1),Y(ud(1)+1),pos,v,az,ts);
    end
    
    vaa=xud-xdu;
    
end

%%%%%%%%%%%%%%%%% findzero function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x3,y3]=findzero(x1,y1,x2,y2,pos,v,az,ts)

y3=inf;
for i=1:5,
    ab=inv([x1 1;x2 1])*[y1;y2];
    x3=-ab(2)/ab(1);
    
    [pL,tL,ncl]=tnsstroke(pos,[v x3 az],ts);
    y3=min([ncl 23.7744-pL(1) pL(2) 8.2296-pL(2)]);
    
    % keep on looping
    if sign(y1)==sign(y3) & abs(y3)<abs(y1), y1=y3;x1=x3; end
    if sign(y2)==sign(y3) & abs(y3)<abs(y2), y2=y3;x2=x3; end
end

