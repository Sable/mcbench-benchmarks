function [r v n]=delete_far_points(r,v,rmx,n)

dr=bsxfun(@minus,permute(r,[2 1 3]),r);

r1=shiftdim(r);


dd2=sum(r1.^2,2);

ind=find(dd2<(rmx^2));

% if any(dd2>(rmx^2))
%     'here'
% end

r=r(:,ind,:);
v=v(:,ind,:);
n=size(r,2);


v=bsxfun(@minus,v,(mean(v,2))); % go to centroid
r=bsxfun(@minus,r,(mean(r,2)));