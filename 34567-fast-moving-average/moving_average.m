function [X,Zf] = moving_average(N,X,Zi,dim)
% Like filter() for the special case of moving-average kernels.
% [Y,Zf] = moving_average(N,X,Zi,Dim)
%
% This is an overall very fast implementation whose running time does now grow with N (beyond
% N=500). The algorithm does not run into numerical problems for large data sizes unlike the usual
% cumsum-based implementations.
%
% In:
%   N : filter length in samples
%
%   X : data matrix
%
%   Zi : initial filter conditions (default: [])
%
%   Dim : dimension along which to filter (default: first non-singleton dimension)
%
% Out:
%   X : the filtered data
%
%   Zf : final filter conditions
%
% See also:
%   filter
%
%                           Christian Kothe, Swartz Center for Computational Neuroscience, UCSD
%                           2012-01-10

% determine the dimension along which to filter
if nargin <= 3
    if isscalar(X)
        dim = 1;
    else
        dim = find(size(X)~=1,1); 
    end
end

% empty initial state
if nargin <= 2
    Zi = []; end

lenx = size(X,dim);
if lenx == 0
    % empty X
    Zf = Zi;
else
    if N < 500
        % short N: use filter
        [X,Zf] = filter(ones(N,1)/N,1,X,Zi,dim);
    else
        % we try to avoid permuting dimensions below as this would increase the running time by ~3x
        if ndims(X) == 2
            if dim == 1
                % --- process along 1st dimension ---
                if isempty(Zi)
                    % zero initial state
                    Zi = zeros(N,size(X,2));
                elseif size(Zi,1) == N-1
                    % reverse engineer filter's initial state (assuming a moving average)
                    tmp = diff(Zi(end:-1:1,:),1,1);
                    Zi = [tmp(end:-1:1,:); Zi(end,:)]*N;
                    Zi = [-sum(Zi,1); Zi];
                elseif ~isequal(size(Zi),[N,size(X,2)])
                    error('These initial conditions do not have the correct format.');
                end
                
                % pre-pend initial state & get dimensions
                Y = [Zi; X]; M = size(Y,1);
                % get alternating index vector (for additions & subtractions)
                I = [1:M-N; 1+N:M];
                % get sign vector (also alternating, and includes the scaling)
                S = [-ones(1,M-N); ones(1,M-N)]/N;
                % run moving average
                X = cumsum(bsxfun(@times,Y(I(:),:),S(:)),1);
                % read out result
                X = X(2:2:end,:);
                
                % construct final state
                if nargout > 1
                    Zf = [-(X(end,:)*N-Y(end-N+1,:)); Y(end-N+2:end,:)]; end
            else
                % --- process along 2nd dimension ---
                if isempty(Zi)
                    % zero initial state
                    Zi = zeros(N,size(X,1));
                elseif size(Zi,1) == N-1
                    % reverse engineer filter's initial state (assuming a moving average)
                    tmp = diff(Zi(end:-1:1,:),1,1);
                    Zi = [tmp(end:-1:1,:); Zi(end,:)]*N;
                    Zi = [-sum(Zi,1); Zi];
                elseif ~isequal(size(Zi),[N,size(X,1)])
                    error('These initial conditions do not have the correct format.');
                end
                
                % pre-pend initial state & get dimensions
                Y = [Zi' X]; M = size(Y,2);
                % get alternating index vector (for additions & subtractions)
                I = [1:M-N; 1+N:M];
                % get sign vector (also alternating, and includes the scaling)
                S = [-ones(1,M-N); ones(1,M-N)]/N;
                % run moving average
                X = cumsum(bsxfun(@times,Y(:,I(:)),S(:)'),2);
                % read out result
                X = X(:,2:2:end);
                
                % construct final state
                if nargout > 1
                    Zf = [-(X(:,end)*N-Y(:,end-N+1)) Y(:,end-N+2:end)]'; end
            end
        else
            % --- ND array ---
            [X,nshifts] = shiftdim(X,dim-1);
            shape = size(X); X = reshape(X,size(X,1),[]);
            
            if isempty(Zi)
                % zero initial state
                Zi = zeros(N,size(X,2));
            elseif size(Zi,1) == N-1
                % reverse engineer filter's initial state (assuming a moving average)
                tmp = diff(Zi(end:-1:1,:),1,1);
                Zi = [tmp(end:-1:1,:); Zi(end,:)]*N;
                Zi = [-sum(Zi,1); Zi];
            elseif ~isequal(size(Zi),[N,size(X,2)])
                error('These initial conditions do not have the correct format.');
            end
            
            % pre-pend initial state & get dimensions
            Y = [Zi; X]; M = size(Y,1);
            % get alternating index vector (for additions & subtractions)
            I = [1:M-N; 1+N:M];
            % get sign vector (also alternating, and includes the scaling)
            S = [-ones(1,M-N); ones(1,M-N)]/N;
            % run moving average
            X = cumsum(bsxfun(@times,Y(I(:),:),S(:)),1);
            % read out result
            X = X(2:2:end,:);
            
            % construct final state
            if nargout > 1
                Zf = [-(X(end,:)*N-Y(end-N+1,:)); Y(end-N+2:end,:)]; end
            
            X = reshape(X,shape);
            X = shiftdim(X,ndims(X)-nshifts);
        end
    end
end
