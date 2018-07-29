function data=clust_normalize(data,method);

%   method     description
%   'var'      Variance is normalized to one (linear operation).
%   'range'    Values are normalized between [0,1] (linear operation).

data.Xold=data.X;
if strcmp(method,'range')
     data.min=min(data.X);
     data.max=max(data.X);
     data.X=(data.X-repmat(min(data.X),size(data.X,1),1))./(repmat(max(data.X),...
         size(data.X,1),1)-repmat(min(data.X),size(data.X,1),1));
 elseif strcmp(method,'var')
     data.X=(data.X-repmat(mean(data.X),size(data.X,1),1))./(repmat(std(data.X),size(data.X,1),1));
     data.mean=mean(data.X);
     data.std=std(data.X);
 else
     error('Unknown method given')
end
