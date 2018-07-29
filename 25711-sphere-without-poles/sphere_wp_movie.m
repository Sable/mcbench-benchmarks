function  varargout=sphere_wp(varargin)

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
                    
                    clear F;
                    fc=1;
                    tsc=1;
                    for n=[40 500 2000]

u=random_unit_vector(n)';

hf=figure('position',[30 30  900 650]);
K = convhulln(u);
h=trisurf(K,u(:,1),u(:,2),u(:,3));
ht=title(['test ' num2str(tsc) ', number of vortex: ' num2str(n) ', iteration ' num2str(1)],'fontsize',14);
axis equal;

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

   %itm=100;

   F(fc)=getframe(hf);
   fc=fc+1;
   itm=20;
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

%         [sps ind]=sort(sp,'descend');
%         ind3=ind(1:3,:); % only 3 closest
% 
%         un=zeros(size(u)); % new u
%         
%         for nc=1:n
%             ind=ind3(:,nc);
%             un(nc,:)=mean(u(ind,:),1);
%         end
%         
%         % normalization:
%         unn=sqrt(sum(un.^2,2)); % lengths
%         u=bsxfun(@rdivide,un,unn);

        if n<30
            nani=isnan(u(:,1));
            ind=find(nani);
            lng=length(ind);
            if lng>0
                u(ind,:)=random_unit_vector(lng)';
            end
        end

        K = convhulln(u);
       
%         set(h,'Vertices',u,'Faces',K);
%         drawnow;
        delete(h);
        %hf=figure('position',[30 30  900 650]);
        h=trisurf(K,u(:,1),u(:,2),u(:,3));
        axis equal;
        ht=title(['test ' num2str(tsc) ', number of vortex: ' num2str(n) ', iteration ' num2str(it)],'fontsize',14);
        for fc1=1:5
           drawnow;
            F(fc)=getframe(hf);
            fc=fc+1;
        end
%         pause(0.2);
            
    end
    
end
                    
                    tsc=tsc+1;

                    delete(h );  delete(hf);
                    hf=figure('position',[30 30  900 650]);
                    K = convhulln(u);
                    h=trisurf(K,u(:,1),u(:,2),u(:,3));
                    axis equal;
                    delete(h );
                    for fc1=1:4
                       drawnow;
                        F(fc)=getframe(hf);
                        fc=fc+1;
                    end
                     delete(hf);
                    
                    end

movie2avi(F,'sphere_iterations','compression','none','fps',10); % uncoment this to save the movie to avi file

% K = convhulln(u);
% if  nargout==0
%     h=trisurf(K,u(:,1),u(:,2),u(:,3));
%     axis equal;
% else
%     varargout{1}=K;
%     varargout{2}=u;
% end