function[z] = joinmat(x,y,type)
% JOIN     Single-key equality join of two matrices
% Inputs : x - matrix with join key in column 1
%          y - matrix with join key in column 1
%          type - join type, string 'inner', 'left outer', 'full outer'
% Outputs: z - matrix with join key in column 1
% Notes  : NaN/Inf values are not matched, and excluded from inner join.
%          Output rows are sorted by join key, NaN/Inf values listed last.
%          Within any row of z, columns of x are listed first. Unmatched
%          rows are padded with NaNs
% Example: x = [[unidrnd(5,4,1); nan; inf] [10 20 30 40 50 60]']
%          y = [[unidrnd(5,4,1); nan; inf] [15 25 25 45 55 55]']
%          inner      = joinmat(x,y,'inner')
%          left_outer = joinmat(x,y,'left outer')
%          full_outer = joinmat(x,y,'full outer')
% Dimitri Shvorob, dimitri.shvorob@gmail.com, 8/18/08

rows = @(x) size(x,1);
tile = @(x,n) repmat(x,n,1);

[vx,ix] = keys(x(:,1));
[vy,iy] = keys(y(:,1));

xnan = x(~isfinite(x(:,1)),:);
ynan = y(~isfinite(y(:,1)),:);

x(:,1) = [];
y(:,1) = [];

p = size(x,2); xp = nan(1,p);
q = size(y,2); yp = nan(1,q);
z = nan(0,p + q + 1);

switch type
    case 'inner'
        for i = 1:length(vx)
            j = find(vy == vx(i));
            if ~isempty(j)
               m = ix{i};
               n = iy{j};
               xi = tile(x(m,:),rows(n));
               yi = tile(y(n,:),rows(m));
               vi = tile(vx(i) ,rows(xi));
               z  = [z; [vi xi yi]];             %#ok
            end
        end
    case 'left outer'
        for i = 1:length(vx)
            xi = x(ix{i},:);
            j = find(vy == vx(i));
            if ~isempty(j)
                yi = y(iy{j},:);
            else
                yi = yp;
            end
            rx = rows(xi);
            ry = rows(yi);
            xi = tile(xi,ry);
            yi = tile(yi,rx);
            vi = tile(vx(i),rows(xi));
            z  = [z; [vi xi yi]];                %#ok
        end
        z = [z; ...
             [xnan tile(yp,rows(xnan))]];        %#ok
  case 'full outer'
      v = union(vx,vy);
      for i = 1:length(v)
          j = find(vx == v(i));
          if ~isempty(j)
              xi = x(ix{j},:);
          else
              xi = xp;
          end
          j = find(vy == v(i));
          if ~isempty(j)
              yi = y(iy{j},:);
          else
              yi = yp;
          end
          rx = rows(xi);
          ry = rows(yi);
          xi = tile(xi,ry);
          yi = tile(yi,rx);
          vi = tile(v(i),rows(xi));
          z  = [z; [vi xi yi]];                  %#ok
      end
      z = [z; ...
           [xnan      tile(yp,rows(xnan))]; ...
           [ynan(:,1) tile(xp,rows(ynan)) ynan(:,2:end)]];    %#ok
    otherwise
      error('??? Join type not recognized.')
end
end

function[key,ind] = keys(x)
    key = unique(x(isfinite(x)));
    ind = cellfun(@(k) find(x == k),num2cell(key),'UniformOutput',false);
end