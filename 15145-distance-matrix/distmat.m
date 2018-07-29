function [dmat,opt] = distmat(xy,varargin)
% DISTMAT Distance matrix for a set of points
%   Returns the point-to-point distance between all pairs of points in XY
%       (similar to PDIST in the Statistics Toolbox)
%
%   DMAT = DISTMAT(XY) Calculates the distance matrix using an automatic option
%   DMAT = DISTMAT(XY,OPT) Uses the specified option to compute the distance matrix
%   [DMAT,OPT] = DISTMAT(XY) Also returns the automatic option used by the function
%
%   Inputs:
%       XY is an NxP matrix of coordinates for N points in P dimensions
%       OPT (optional) is an integer between 1 and 4 representing the chosen
%           method for computing the distance matrix (see note below)
%
%   Outputs:
%       DMAT is an NxN matrix, where the value of DMAT(i,j) corresponds to
%           the distance from XY(i,:) to XY(j,:)
%       OPT (optional) is an integer between 1 and 4 representing the method
%           used to compute the distance matrix (see note below)
%
%   Note:
%       DISTMAT contains 4 methods for computing the distance matrix
%         OPT=1 Usually fastest for small inputs. Takes advantage of the symmetric
%               property of distance matrices to perform half as many calculations
%         OPT=2 Usually fastest for medium inputs. Uses a fully vectorized method
%         OPT=3 Usually fastest for large inputs. Uses a partially vectorized
%               method with relatively small memory requirement
%         OPT=4 Another compact calculation, but usually slower than the others
%
%   Example:
%       % Test computation times for the options
%       n = [10 100 1000];
%       dmat = distmat(10*rand(10,3),1); % First call is always really slow
%       for k=1:3
%           for opt=1:4
%               tic; [dmat,opt] = distmat(10*rand(n(k),3),opt); t=toc;
%               disp(sprintf('n=%d, opt=%d, t=%0.6f', n(k), opt, t))
%           end
%       end
%
%   Example:
%       xy = 10*rand(25,2);  % 25 points in 2D
%       dmat = distmat(xy);
%       figure; plot(xy(:,1),xy(:,2),'.');
%       for k=1:25, text(xy(k,1),xy(k,2),[' ' num2str(k)]); end
%       figure; imagesc(dmat); set(gca,'XTick',1:25,'YTick',1:25); colorbar
%
%   Example:
%       xyz = 10*rand(20,3);  % 20 points in 3D
%       dmat = distmat(xyz);
%       figure; plot3(xyz(:,1),xyz(:,2),xyz(:,3),'.');
%       for k=1:20, text(xyz(k,1),xyz(k,2),xyz(k,3),[' ' num2str(k)]); end
%       figure; imagesc(dmat); set(gca,'XTick',1:20,'YTick',1:20); colorbar
%
% Author: Joseph Kirk
% Email: jdkirk630 at gmail dot com
% Release: 1.0
% Release Date: 5/29/07

% process inputs
error(nargchk(1,2,nargin));
[n,dims] = size(xy);
numels = n*n*dims;
opt = 2; if numels > 5e4, opt = 3; elseif n < 20, opt = 1; end
for var = varargin
    if length(var{1}) == 1
        opt = max(1, min(4, round(abs(var{1}))));
    else
        error('Invalid input argument.');
    end
end

% distance matrix calculation options
switch opt
    case 1 % half as many computations (symmetric upper triangular property)
        [k,kk] = find(triu(ones(n),1));
        dmat = zeros(n);
        dmat(k+n*(kk-1)) = sqrt(sum((xy(k,:) - xy(kk,:)).^2,2));
        dmat(kk+n*(k-1)) = dmat(k+n*(kk-1));
    case 2 % fully vectorized calculation (very fast for medium inputs)
        a = reshape(xy,1,n,dims);
        b = reshape(xy,n,1,dims);
        dmat = sqrt(sum((a(ones(n,1),:,:) - b(:,ones(n,1),:)).^2,3));
    case 3 % partially vectorized (smaller memory requirement for large inputs)
        dmat = zeros(n,n);
        for k = 1:n
            dmat(k,:) = sqrt(sum((xy(k*ones(n,1),:) - xy).^2,2));
        end
    case 4 % another compact method, generally slower than the others
        a = (1:n);
        b = a(ones(n,1),:);
        dmat = reshape(sqrt(sum((xy(b,:) - xy(b',:)).^2,2)),n,n);
end
