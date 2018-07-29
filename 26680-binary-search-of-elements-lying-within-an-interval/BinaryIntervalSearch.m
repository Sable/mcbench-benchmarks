% % Search the elements that are lying within a specified interval.
% % Search the indexes of all elements in x (sorted vector of n elements) that 
% % lie within the interval.
% % The algorithm uses binary searches, thus it runs in log(n)
% %
% % INPUT:
% % x: vector of numeric values sorted in ascending order
% %    (e.g. 2,7,20,...120)
% % ref: numeric value of the reference point (center of the interval)
% % tol: numeric value corresponding to 1/2 of the width of the interval
% % The fourth input argument: numeric value (optional). Allows to define the maximum 
% % number of elements of x that can lie within the specified interval. This is useful
% % in order to speed up the search.
% %
% % OUTPUT:
% % indexes: indexes of elements of x which lie within the interval 
% % [ref-tol ref+tol]
% % If ref is not found in x then indexes is empty.
% %
% % Revisions:
% % 14-jun-2010: - Added lines 38-55 in order to consider the case in which lower bound 
% %                is less than the minimum value of x or the upper bound is more than 
% %                the max value of x 
% %              - Reinforced the conditions in line 93 and in line 117 in order to avoid 
% %                an error when (to-1)==0 or (from+1)>length(x)
% % 15/apr/2011: - A bug with uint values of input array has been fixed. 
% %                Thanks to Igor Varfolomeev

% % % --------------------------------
% % % Author: Dr. Roberto Olmi
% % % Email : robertoolmi at gmail.com
% % % --------------------------------

function indexes = BinaryIntervalSearch(x,ref,tol,varargin)
lbound = ref-tol;
ubound = ref+tol;
from=1;
to=length(x);

if lbound <= x(1)
    if ubound < x(1)
        indexes=[];
        return
    end
    lindex=1;
else
    lindex=0;
end
if ubound >= x(end)
    if lbound > x(end)
        indexes=[];
        return
    end
    uindex=length(x);
else
    uindex=0;
end

go=uindex==0 || lindex==0;
while go
    mid = ceil(from+(to-from)/2);
    %diff = x(mid)-ref;  15/apr/2011
    if x(mid) < ref %diff < 0  15/apr/2011
        if x(mid) >= lbound
            go=false;
        else
            from=mid+1;
            if x(from) >= lbound
                lindex=from;
                go=false;
            end
        end
    else       % x(mid) > ref
        if x(mid) <= ubound
            go=false;
        else
            to=mid-1;
            if x(to) <= ubound
                uindex=to;
                go=false;
            end
        end
    end
end

%remove this if at least one element of x is always in the interval:
if (lindex > 0 && x(lindex) > ubound)...
        || (uindex > 0 && x(uindex) < lbound)
    indexes=[];
    return
end

%search upper index
cfrom=from;
if from==length(x) || x(from+1) > ubound
    uindex=from;
end
if nargin == 4
    to=min([to mid+varargin{1}]);
end
while uindex == 0
    mid = ceil(from+(to-from)/2);
    if x(mid) <= ubound
        from=mid+1;
        if x(from) > ubound 
            uindex=mid;
        end
    else 
        to=mid-1;
        if x(to) < ubound
            uindex=to;
        end
    end
end

%search lower index
from=cfrom;
to=uindex; 
if to==1 || x(to-1) < lbound
    lindex=to;
end
if nargin == 4
    from=max([from uindex-varargin{1}]); 
end
while lindex == 0
    mid = ceil(from+(to-from)/2);
    if x(mid) < lbound
        from=mid+1;
        if x(from) > lbound
            lindex=from;
        end
    else 
        to=mid-1;
        if x(to) < lbound
            lindex=mid;
        end
    end
end

indexes=lindex:uindex;

% % --------------------------------------------
% % Example code for Testing
% % tol=2;
% % ref=12;
% % maxi=10000;
% % numel=1000;
% % for i=1:maxi
% %     x = sort(randint(1,numel,[0,400]));
% %     indexes = BinaryIntervalSearch(x,ref,tol);
% %     if isempty (indexes)
% %         if any(abs(x-ref) < tol)
% %             disp('Doh!')
% %             break
% %         else
% %             continue
% %         end
% %     end
% %     if indexes(1)>1 && ~(x(indexes(1)-1) < x(indexes(1)))...
% %             || indexes(end)<numel && ~(x(indexes(end)) < x(indexes(end)+1))...
% %             || any(abs(x(indexes)-ref) > tol)
% %         disp('Doh!')
% %         break
% %     end
% %     if i==maxi
% %         disp('OK!!!')
% %     end
% % end
% % --------------------------------------------

% % % --------------------------------
% % % Author: Dr. Roberto Olmi
% % % Email : robertoolmi at gmail.com
% % % --------------------------------


