function lin=intersectPlaneSurf(fv,p0,n)
% Intersection of a plane with an arbitrary surface data. The surface must
% be in the form of faces and vertices strcture such as patch function and
% the faces of the surface must be defined with triangles. fv = 
% fv =
%        faces: [number of faces x 3 double]
%     vertices: [number of vertices x 3 double]
% "p0" and "n" is used to define the plane. "p0" is a point that lies on
% the plane and "n" is the normal vector of the plane.
%
% The function actually calculates intersection segments of triangels of
% the surface with the plane and finally all the calculated segments is 
% linked to each other to form a continuous intersection region
% Mehmet ÖZTÜRK 2011

% % EXAMPLE
% % create some surface data
% [exx1 eyy1 ezz1]=sphere(100);
% fv1 = surf2patch(exx1,eyy1,ezz1,'triangles');
% [exx2 eyy2 ezz2]=cylinder(0:3,100);
% fv2 = surf2patch(exx2,eyy2,ezz2-1.25,'triangles');% convert patches to triangels
% 
% fv.faces=[fv1.faces; fv2.faces+length(fv1.vertices)];
% fv.vertices=[fv1.vertices; fv2.vertices];
% 
% p0=[1 0 0]; v=[1 1 1]; % a plane that parallel to the xy plane and passes the point [0 0 0]
% v=v./norm(v);
% 
% intersectPlaneSurf(fv,p0,n)

% input argument checking
if nargin==0
    error('ÝntersectPlaneSurf: not enough input arguments')
elseif nargin==1
    if size(fv.faces,1)~=3
        error('ÝntersectPlaneSurf: surface data must be defined with triangels')
    end
    error('ÝntersectPlaneSurf: The plane must be defined with a point p0 and a normal vector of the plane n')
elseif nargin==2
    error('ÝntersectPlaneSurf: The plane must be defined with 2 arguemnts')
end

% normalized the normal vector of the plane if necessary
if norm(n)~=1
    n=n./norm(n);
end

% allocate memory for coordinates of the segments
segment_start=nan(3,round(length(fv.faces)/2));
segment_finish=segment_start;

count=1; % counter for segments
thr=1e-9; % threshold value for zero checking

for s=1:size(fv.faces,1)
    % define vertices of the triangle
    P1=fv.vertices(fv.faces(s,1),:)';
    P2=fv.vertices(fv.faces(s,2),:)';
    P3=fv.vertices(fv.faces(s,3),:)';
    
    % is there any intersection?
    [ num_int, pi ] = IntersectPlaneTriangle ( n, p0, P1, P2, P3);
    % IntersectPlaneTriangle function returns (first outout argument) 0 if there is no intersection
    % and 2 if there is intersection segment. The second output is the
    % start and end point coordinates (3x2 matrix) of intersection segment if any
    % Check for intersection and also a test for seperate points (only one intersection)
    if num_int==2 && sqrt(sum((pi(:,1)-pi(:,2)).^2,1))>thr
        segment_start(:,count)=pi(:,1);
        segment_finish(:,count)=pi(:,2);
        count=count+1;
    end
end

segment_start(:,all(isnan(segment_start),1))=[]; % remove unused memory portions
segment_finish(:,all(isnan(segment_finish),1))=[]; % remove unused memory portions

% Begin to classify segments
% Classification process is based on euclidean distances of segments
nol=1; % initial number of line
while ~isempty(segment_start)
    lin{nol}=[segment_start(:,1) segment_finish(:,1)]; % start from the first segment remained
    if sqrt(sum((lin{nol}(:,end)-lin{nol}(:,end-1)).^2,1))<=thr % they are the same points?
        lin{nol}(:,end)=[]; % if so remove one
    end
    segment_start(:,1)=[]; % remove also used segments
    segment_finish(:,1)=[];
    while ~isempty(segment_start) % start to search nearby segments
        distEnd2Start=sqrt(sum(bsxfun(@minus,lin{nol}(:,end),segment_start).^2,1));
        distEnd2End=sqrt(sum(bsxfun(@minus,lin{nol}(:,end),segment_finish).^2,1));
        distStart2Start=sqrt(sum(bsxfun(@minus,lin{nol}(:,1),segment_start).^2,1));
        distStart2End=sqrt(sum(bsxfun(@minus,lin{nol}(:,1),segment_finish).^2,1));
        
        distMat=[distEnd2Start;distEnd2End;distStart2Start;distStart2End];
        
        [row col]=find(distMat<=thr);
        if ~isempty(row)
            row=row(1); col=col(1);
            switch row
                case 1
                    lin{nol}=[lin{nol} segment_finish(:,col)];
                    if sqrt(sum((lin{nol}(:,end)-lin{nol}(:,end-1)).^2,1))<=thr
                        lin{nol}(:,end)=[];
                    end
                    segment_start(:,col)=[];
                    segment_finish(:,col)=[];
                case 2
                    lin{nol}=[lin{nol} segment_start(:,col)];
                    if sqrt(sum((lin{nol}(:,end)-lin{nol}(:,end-1)).^2,1))<=thr
                        lin{nol}(:,end)=[];
                    end
                    segment_start(:,col)=[];
                    segment_finish(:,col)=[];
                case 3
                    lin{nol}=[segment_finish(:,col) lin{nol}];
                    if sqrt(sum((lin{nol}(:,1)-lin{nol}(:,2)).^2,1))<=thr
                        lin{nol}(:,1)=[];
                    end
                    segment_start(:,col)=[];
                    segment_finish(:,col)=[];
                case 4
                    lin{nol}=[segment_start(:,col) lin{nol}];
                    if sqrt(sum((lin{nol}(:,1)-lin{nol}(:,2)).^2,1))<=thr
                        lin{nol}(:,1)=[];
                    end
                    segment_start(:,col)=[];
                    segment_finish(:,col)=[];
            end
        else
            nol=nol+1;
            break
        end
    end
end

if nargout==0 % if no output is wanted, then visualize the final situation :)
    fig=patch(fv);
    set(fig,'FaceColor',[.8 .8 .8],'EdgeColor','none');
    camlight,lighting gouraud

    plane=createPlane(p0,n(:).'); % createPlane function si from geom3d toolbox
    hold on, hpl=drawPlane3d(plane,'b','FaceAlpha', 0.7); % and also drawPlane3d
    set(hpl,'FaceAlpha',0.7)
    daspect([1 1 1]); axis('vis3d')
    set(gcf,'Renderer','OpenGL')

    for m=1:size(lin,2)
        hold on,plot3(lin{m}(1,:),lin{m}(2,:),lin{m}(3,:),'k','Linewidth',2)
    end
    hold off
end
