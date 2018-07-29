function [id id2 nn]=invers_distancies(r,n)

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

%nn=dr./id
nn=bsxfun(@times,dr,id); % noirmalized