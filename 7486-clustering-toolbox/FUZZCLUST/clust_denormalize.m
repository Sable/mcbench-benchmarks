function data = clust_denormalize(data)

%   method     description
%   'var'      denormalization from a data whitch variation was normalized to one (linear operation).
%   'range'    denormalization from a data whitch values were normalized between [0,1] (linear operation).
if isempty(data.min)==0
%if exist('data.min')==1
    data.X = (repmat(data.max,size(data.X,1),1) - repmat(data.min,size(data.X,1),1)).*data.X + ...
        repmat(data.min,size(data.X,1),1);
elseif isempty(data.mean)==0
%elseif exist('data.mean')==1
    data.X = (repmat(data.std,size(data.X,1),1)).*data.X + repmat(data.mean,size(data.X,1),1);
else
    error('Not normalized data or unknown normalization method.')
end