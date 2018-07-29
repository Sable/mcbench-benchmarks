function  varargout=sphere_wp(varargin)
% plot sphere or return geometry info
% use as matlab built in function "shere"
% it makes sphere without poles
% shere consist of triangles
% usage:
% sphere_wp    plot sphere use 500 vertexes radius=1
% sphere_wp(n)  plot sphere use n vertexes
% sphere_wp(n,true) plot sphere use n vertexes, vertecies uniformly distributed
% sphere_wp(n,false) plot sphere use n vertexes, vertecies not uniformly distributed
% by default it always makes uniformly distributed vertecies
% uniformly distributed vertecies takes longer time to calulate
% [K u]=sphere_wp(...) works the same but not plot shere
% and return data:
% K  triangles defined in the m-by-3 face matrix K as a surface
% m - number of trangles
% u is n-by-3 matrix with vertex coordinaties 
% use it as in example:
% [K u] = sphere_wp;
% trisurf(K,u(:,1),u(:,2),u(:,3));


ifu=true; % if need to make uniform point
% when distance between nearest points almost equal
switch nargin
    case 0
        n=500;
    case 1
        n=varargin{1};
    case 2
        n=varargin{1};
        ifu=varargin{2};
        
end
% n number of vertecies

u=random_unit_vector(n)';


if ifu
    
    % adjust parameters of iteration process
    cc=0.5;
    if n>30
        itm=40; % maximal number of iterations
        r=1; % rate
        if n>50
            cc=0.95*sqrt(1-50/n);
        else
            cc=0.95*sqrt(1-30/n);
        end
    else
        itm=100;
        r=0.2;
        cc=0;
    end
    if n>1500
        itm=15;
    end

    for it=1:itm % iterations
        
         % make more uniform point distribution over sphere
        sp=u*u'; % scalar products each with each, nxn matrix 
        % scalar product = cos(angle)

        sp(1:n+1:end)=-2; % to not chose itself
        
        un=zeros(size(u)); % new u
        for nc=1:n
            ind=find(sp(:,nc)>cc); % if al~1 => anlge^2~=(1-cos(anlge))/2
            % angle^2=distance^2
            spc=sp(ind,nc); % get onle closest points
            al2=(1-spc)/2; % angle^2
            %length(ind)
            
            % wheighted mean used, weights is 1/distance^2:
            % r0=r0+sum((r0-ri)/al_i^2)/sum(1/al_i^2)
            % if r0 very close to some ri that is rk then
            % al_k is much bigger then rest al_i
            % r0~r0+(r0-rk)  - go away from rk
            % the idea is come from repulsion of simular charges
            du=bsxfun(@minus,u(nc,:),u(ind,:));
            dua=bsxfun(@rdivide,du,al2);
            un(nc,:)=u(nc,:)+r*sum(dua)./sum(1./al2);
        end
        
        % normalization:
        unn=sqrt(sum(un.^2,2)); % lengths
        u=bsxfun(@rdivide,un,unn);


        if n<30
            nani=isnan(u(:,1));
            ind=find(nani);
            lng=length(ind);
            if lng>0
                u(ind,:)=random_unit_vector(lng)';
            end
        end

        

            
    end
    
end



K = convhulln(u);
if  nargout==0
    h=trisurf(K,u(:,1),u(:,2),u(:,3));
    set(h,'FaceColor',[1 1 1]);
    axis equal;
else
    varargout{1}=K;
    varargout{2}=u;
end