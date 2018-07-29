function stage = BOPointInPolygon( P, q )
%% BOPointInPolygon - find point in polygon
%   
%   REFERENCE:
%       This code is described in "Computational Geometry in C", Chapter 7.  
%       The Matlab version is based on C code written by Joseph O'Rourke, 
%       contributions by Min Xu, June 1997.   
%
%   INPUT:
%       P       - input vector Nx2
%       q       - input query vector 1x2
%
%   OUTPUT:
%       stage   - output stage:
%                   'v' - q is a vertex
%                   'i' - q is inside
%                   'o' - q is outside
%                   'e' - q on the edge
%   USAGE:
%       t = 0:0.6:6.28;
%       seedx = 100; seedy = 100; scalefactor = 20;
%       P(:,1) = (seedx(1) + scalefactor*cos(t))';
%       P(:,2) = (seedy(1) + scalefactor*sin(t))';
%       PP = [P; P(1,:)];
%       plot(PP(:,1),PP(:,2),'-bs'); hold on
%       q = PP(10,:);
%       plot(q(:,1),q(:,2),'r*');
%       stage = BOPointInPolygon(PP,q);
% 
%   AUTHOR:
%       Boguslaw Obara, http://boguslawobara.net/
%
%   VERSION:
%       0.1 - 25/05/2008 First implementation
% 

%% 
% i, i1     - point index; i1 = i-1 mod n
% d         - dimension index
% x         - x intersection of e with ray
% Rcross    - number of right edge/ray crossings
% Lcross    - number of left edge/ray crossings
%%
Rcross = 0; Lcross = 0;
n = length(P);
%%
% Shift so that q is the origin. Note this destroys the polygon.
for i=1:n
    for d=1:2
      P(i,d) = P(i,d) - q(d);
    end
end
%%	
% For each edge e=(i-1,i), see if crosses ray.
for i=1:n
    % First see if q=(0,0) is a vertex.
    if P(i,1)==0 && P(i,2)==0 
        stage = 'v';
        return; 
    end
    i1 = mod((i + n - 2), n) + 1;
    
    % if e "straddles" the x-axis... 
    % The commented-out statement is logically equivalent to the one following. 
    % if( ((P(i,2)>0) && (P(i1,2)<=0)) || ((P(i1,2)>0) && (P(i,2)<=0)) 

    if (P(i,2)>0) ~= (P(i1,2)>0)
      % e straddles ray, so compute intersection with ray.
        x = (P(i,1) * P(i1,2) - P(i1,1) * P(i,2)) / (P(i1,2) - P(i,2));
      
      % crosses ray if strictly positive intersection.
      if x>0
          Rcross = Rcross + 1; 
      end
    end
    
    % if e straddles the x-axis when reversed...
    % if ((P(i,2)<0) && (P(i1,2)>=0)) || ((P(i1,2)<0) && (P(i,2)>=0)    
    
    if (P(i,2) < 0) ~= (P(i1,2) < 0)  
      % e straddles ray, so compute intersection with ray.
      x = (P(i,1) * P(i1,2) - P(i1,1) * P(i,2)) / (P(i1,2) - P(i,2));
      % crosses ray if strictly positive intersection.
      if (x < 0) 
          Lcross = Lcross + 1;
      end
    end
end	
%%   
% q on the edge if left and right cross are not the same parity.
if mod(Rcross,2) ~= mod(Lcross,2)
    stage = 'e';
    return;
end
% q inside if an odd number of crossings.
if mod(Rcross,2) == 1
    stage = 'i';
    return;
else
    stage = 'o';
    return;
end
%%
end