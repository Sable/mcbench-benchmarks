function PointList_reduced = DouglasPeucker(PointList, epsilon, drawdata)
%DOUGLASPEUCKER Reduce density of points in vector data using the 
%    Ramer-Douglas-Peucker algorithm. 
%   The Ramer–Douglas–Peucker algorithm is an algorithm for reducing the 
%    number of points in a curve that is approximated by a series of points.
%   References:
%    http://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm

%  Phymhan (Email: phymhan@126.com)
%   Date: 28-May-2013 17:48:56
%

if nargin < 3
    drawdata = true;
    if nargin < 2
        epsilon = 'AUTO';
    end
end
[n, nn] = size(PointList);
if min(n,nn) ~= 2
    fprintf('Incorrect point list format.\n');
    PointList_reduced = [];
    return;
end
if nn > n
    PointList = PointList';
    n = nn;
end
if ischar(epsilon)
    switch upper(epsilon)
        case 'AUTO'
            epsilon = 0.01*...
                sqrt((PointList(1,1)-PointList(n,1)).^2+(PointList(1,2)-PointList(n,2)).^2);
        case 'DEFAULT'
            epsilon = 0.1;
        otherwise
            fprintf('''%s'' is not a property value of "epsilon(\epsilon)".\n',epsilon);
    end
end
PointList_reduced = RDP_recs(PointList, n);
if drawdata
    h_f = figure('name','Ramer-Douglas-Peucker algorithm',...
        'color',[1 1 1],'menubar','none','numbertitle','off');
    h_a = axes('parent',h_f,'box','on','dataaspectratio',[1 1 1]);
    %Original data
    line(PointList(:,1),PointList(:,2),'parent',h_a,...
        'color',[1 0.5 0],'linestyle','-','linewidth',1.5,...
        'marker','o','markersize',4.5);
    %Reduced data
    line(PointList_reduced(:,1),PointList_reduced(:,2),'parent',h_a,...
        'color',[0 0 1],'linestyle','-','linewidth',2,...
        'marker','o','markersize',5);
end

    function ptList_reduced = RDP_recs(ptList, n)
        %n = size(ptList,1);
        if n <= 2
            ptList_reduced = ptList;
            return;
        end
        %Find the point with the maximum distance
        dmax = -inf;
        idx = 0;
        for k = 2:n-1
            d = PerpendicularDistance(ptList(k,:), ptList([1,n],:));
            if d > dmax
                dmax = d;
                idx = k;
            end
        end
        %If max distance is greater than epsilon, recursively simplify
        if dmax > epsilon
            %Recursive call
            recList1 = RDP_recs(ptList(1:idx,:), idx);
            recList2 = RDP_recs(ptList(idx:n,:), n-idx+1);
            %Build the result list
            ptList_reduced = [recList1;recList2(2:end,:)];
        else
            ptList_reduced = ptList([1,n],:);
        end
    end

    function d = PerpendicularDistance(pt, lineNode)
        %lineNode: [NodeA[Ax,Ay];NodeB[Bx,By]]
        Ax = lineNode(1,1);
        Ay = lineNode(1,2);
        Bx = lineNode(2,1);
        By = lineNode(2,2);
        d_node = sqrt((Ax-Bx).^2+(Ay-By).^2);
        if d_node > eps
            d = abs(det([1 1 1;pt(1) Ax Bx;pt(2) Ay By]))/d_node;
        else
            d = sqrt((pt(1)-Ax).^2+(pt(2)-Ay).^2);
        end
    end

end
