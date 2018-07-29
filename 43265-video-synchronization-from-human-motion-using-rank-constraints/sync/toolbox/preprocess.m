function [ref,tgt] = preprocess(tempref,temptgt,varargin)
% function [ref,tgt] = preprocess(tempref,temptgt,{wnd,noise})
%
% Normalize feature trajectories to have zero mean and approximately unit
% standard deviation. This is important when projection is perspective (as
% noted in Hartley's "In defence of the eight-point algorithm").

% read in variable arguments
wnd = 1;
	if (length(varargin)>0), wnd = varargin{1}; end
noise = 0;
	if (length(varargin)>1), noise = varargin{2}; end

ref = normalize(tempref,noise,wnd);
tgt = normalize(temptgt,noise,wnd);


function [Wout] = normalize(W,noise,wnd)

% add noise
W = W + noise*randn(size(W));

% collect wnd frames into a single 'window' for the whole sequence to make
% synchronization more robust
temp = [];
for f = 1:wnd, temp = [temp W(f:size(W,1)-wnd+f,:)]; end

% reshape from [x1 y1 x2 y2 ...] to [x1 x2 ...; y1 y2 ...] and translate
% to origin (zero mean)
W			= reshape(temp,[size(temp,1)*2,size(temp,2)/2]);
What	= W - mean(W,2)*ones(1,size(W,2));

% reshape back to [x1 y1 x2 y2 ...] and scale to give a standard deviation
% on the order of unity for a well-conditioned matrix during the SVD
What	= reshape(What,[size(What,1)/2,size(What,2)*2]);
norms	= sqrt(What(:,1:2:end).^2 + What(:,2:2:end).^2);
scls	= sqrt(2) ./ mean(norms,2);
Wout	= What .* scls(:,ones(1,size(What,2)));
