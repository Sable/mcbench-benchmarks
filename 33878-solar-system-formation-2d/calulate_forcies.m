function F=calulate_forcies(r,n,G,idm,al,v)

% all pairwise:
% id inversed distancies
% id2 inversed distancies squared
% nn - normals
% nn(:,:,1) -x components
% nn(:,:,2) -y components

% drx=bsxfun(@minus,r(1,:)',r(1,:));
% dry=bsxfun(@minus,r(2,:)',r(2,:));

% permute(r,[2 1 3]) - transposed
dr=bsxfun(@minus,permute(r,[2 1 3]),r);

id2=1./sum(dr.^2,3); % inverse distancies squared
id2(1:n+1:end)=0; % set 0 at diagonal


id=sqrt(id2);

bi=(id<idm); % logical index for not closer then size balls

id2e=id2.*bi; % effective inverse distance



%nn=dr./id
nn=bsxfun(@times,dr,id); % noirmalized
%nne=bsxfun(@times,dr,ide); % noirmalized, effective


% forcies:
%F=G*nn*.id2
% bsxfun(@times,G*nn,id2); % pairwise forcies   n-by-n-by-2
F=sum(bsxfun(@times,G*nn,id2e),1); % 1-by-n-by-2

% add friction force for overlaped balls:
% bi1=bi;
% bi1(1:n+1:end)=false; % not check for itself
% if any(bi1(:)) % if any distance closeer then ball size
%     bii=any(bi1); % what balls has neighour at least clozer then dball size
%     %F(bi)=F(bi)-al*v
%     dv=bsxfun(@minus,permute(r(bi),[2 1 3]),r(bi));
% end

dv=bsxfun(@minus,permute(v,[2 1 3]),v); % velociti diferencies
%F=F-al*sum(bsxfun(@times,nn,dv),1); - wrong
% iddv2=1./sum(dv.^2,3); % lengths of dv vectors inversed
% iddv2(1:n+1:end)=0; % set 0 at diagonal
% iddv=sqrt(iddv2);
% nnv=bsxfun(@times,dv,iddv); % noirmalized
% nnv(dv==0)=0; % exclude NaNs
%F=F-al*sum(bsxfun(@times,nnv,dv),1);
%F=-al*sum(bsxfun(@times,nnv,dv),1);

%F=F+al*sum(dv,1);
% F=+al*sum(dv,1);
%Ff=+al*sum(dv,1); % frictio force for all
%Ff();
%bi=true; % if far
%bi=false; % if close
%~bi=1; % if close
%~bi=0; % if far
dve=bsxfun(@times,dv,~bi); % effictev velocities diferencies
F=F+al*sum(dve,1);
%F=+al*sum(dve,1);


