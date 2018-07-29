function [pred,signal] = nnpiter(x,window,d, n, thresh)

persistent xv X N r
signal = 0; pred=0;

if isempty(X) || (size(X,1) ~= window)
    xv=zeros(window+d,1);
    X=zeros(window,d);
    r = zeros(window-1,d);
    N=1; 
end
% fill out the matrix until we have a full data set
if N < window+d
    xv(N)=x;
    % form the X matrix only once
    if N == window+d-1
        for i=1:d
            X(:,i)=xv(i:N-d+i);
        end
        % now create sum of squares residuals
        r = ( (X(1:window-1,:)-repmat( X(window,:),window-1,1 )).^2 );
    end
    N=N+1;
else
    % now update point by point iteratively
    X = [X(2:window,:);[X(window,2:d),x] ];
    r = [r(:,2:d),(X(1:window-1,d)-x).^2 ];
    y =X(2:window,d);
    % find the minimum error
    [rmin, ind]= sort( sum(r,2) );
    % compute the prediction from n images, y
    pred=0;
    for i=1:n
        pred=pred+y(ind(i));
    end
    pred=pred/n;
    % if pred > threshold then give a signal
    signal=0;
    if abs(pred) > thresh
        signal = sign(pred);
    end
end
