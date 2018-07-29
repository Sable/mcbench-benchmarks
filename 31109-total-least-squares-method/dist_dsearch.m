function [min_dist,CP]=dist_dsearch(points,M,graph)
%
% Search minimum distance between the points
%
% Author: Tomas Skovranek (tomas.skovranek@tuke.sk)
%
% Date: 11/06/2007
%
if (nargin < 3) 
    graph = 'off';
end
    [k,min_dist] = dsearchn(points,M);
    CP=points(k,:);
    %  
    if strcmp(graph,'on') == 1
        set(gcf,'Name','Minimum distance between a set of points and a point',...
                'NumberTitle','off','Resize','off');         
           
        if size(M,2)==3
            X = points(:,1);  Y = points(:,2); Z = points(:,3);  
            A = [M(1) CP(1)]; B = [M(2) CP(2)]; C = [M(3) CP(3)];
            plot3(X,Y,Z,'o')
            hold on
            line(A,B,C,'marker','o','color','r')
            grid on
        elseif size(M,2)==2
            X = points(:,1);  Y = points(:,2); 
            A = [M(1) CP(1)]; B = [M(2) CP(2)];
            plot(X,Y,'o')
            hold on
            line(A,B,'marker','o','color','r')
            grid on
         else error('Point M has to have 2 or 3 dimensions!')
        end
        
    elseif strcmp(graph,'off') == 1
    % check the input value for the variable graph
    else error('Value for variable graph has to be "on" or "off"')
    end
    %