function [squared_distances_to_segments I t]=csmv(P,R,Q,varargin)

%CSMV calculates distances from a given set of points to a set of linear segments
%
% SYNOPSIS: [squared_distances_to_segments I t]=csmv(P,R,Q,to_plot)
%           [squared_distances_to_segments I t]=csmv(P,R,Q,...)
%
% INPUT P,R : arrays of coordinates of 2n segment endpoints 
%       (i.e., if there are n segments considered in p-dimensional 
%       Euclidean space, than P and R are n-by-p matrices); the sizes of P
%       and R should coincide; p should be greater or equal than unity.
%       Q   : an array of coordinates corresponding to the set of m points
%       from which distances to the segments PR are calculated 
%       (Q should therefore be an m-by-p matrix).
%       to_plot : (optional) graphical output. 
%       Any non-zero value would cause the graphical output. There will be
%       no graphical output by default (if this parameter is not passed).
%
% OUTPUT squared_distances_to_segments : an n-by-m matrix whose j-th column 
% contains n squared distance from the j-th point of Q to the segments PR.
%       I : a vector of m elements representing indices of the segments PR
%       which are the closest to points from Q.
%       t : an n-by-m matrix whose ij-th element is a real number between 0
%       and 1 equal to |P(i,:)Qi*(j,:)|/|P(i,:)R(i,:)|, where Qi*(j,:) is the
%       point on the segment P(i,:)R(i,:) closest to Q(j,:). Thus, for example, if
%       P(i,:) is closest to Q(j,:), then t(i,j)=0; if R(i,:) is closest to
%       Q(j,:), then t(i,j)=1.
%
% NOTE: (i)  the dimensions of P and R should coincide! 
%       (ii) you may encounter an error if some points P and R coincide;
%       this can be easily avoided by suitably changing the code - feel
%       free to do so.
%
% AUTHOR: Andrei Bejan (firstname.secondname@cl.cam.ac.uk)

% EXAMPLES (1-D, 2-D and 3-D cases with graphical outputs)
% 
%  1) segments and points on the line
%  PR_segments = [10,-10; -1,0; 2.3,1; 5,9; 10,10.2]; % note that PR do not have
%  to be defined as directed segments! E.g. the third segment [2.3,1] in
%  PR_segments is defined as an undirected segment.
%  P = PR_segments(:,1); R = PR_segments(:,2);
%  [squared_distances_to_segments I t]=csmv(P,R,Q);
%  
%  2) plane
%  P =[1     3;
%      4     6;
%      8    -1;
%      3     7]
% 
%  R = [0   -1;
%       2    2;
%       3    1;
%       0.1  2]
% 
%  Q =[4     1;
%      5     5;
%     -1     3.5;
%     -10    2;
%      10   -2]
%
%  to_plot=1; [squared_distances_to_segments I t]=csmv(P,R,Q,to_plot)
% 
%  3) 3-D space
%  P =[
%      1     3  5;
%      4     6  9;
%      8    -1  -9;
%      3     7  0]
% 
%  R = [
% 
%          0   -1.0000 -1;
%     2.0000    2.0000 2;
%     3.0000    1.0000 4;
%     0.1000    2.0000 7]
% 
%  Q =[
% 
%     4.0000    1.0000 0;
%     5.0000    5.0000 8;
%    -1.0000    3.5000 3;
%   -10.0000    2.0000 -1;
%    10.0000   -2.0000 -1]
% 
% 
% [squared_distances_to_segments I t] = csmv(P,R,Q,1);

% REMARKS
%
%
% created with MATLAB ver.: 7.8.0.347 (R2009a)
%
% created by: Andrei Bejan (firstname.secondname@cl.cam.ac.uk)
% DATE: 11-May-2009
% LAST MODIFIED: 13-December-2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



optargin = size(varargin,2);

if ~optargin
    to_plot = 0;
else
    if varargin{1}~=0
        to_plot = 1;
    else to_plot = 0;
    end
end


% we assume that P and R are of the same size and that Q represents points
% from the space of the same dimension that P and R do!

[n,p] = size(P); 
[m,p] = size(Q);

Q_shuffled = kron(Q,ones(n,1));
P_shuffled = repmat(P,m,1);
R_shuffled = repmat(R,m,1);

if p>1
    

W = Q_shuffled-P_shuffled;
V = R_shuffled-P_shuffled;

t = dot(W',V')./dot(V',V');

ind = find(t<0);

if not(isempty(ind))
t(ind) = 0;
end

ind=find(t>1);
if not(isempty(ind))
t(ind) = 1;
end

for w = 1:p
coords(:,w) = P_shuffled(:,w)+t'.*V(:,w);
end

VECT = Q_shuffled-coords;

squared_distances_to_segments = dot(VECT',VECT')';
squared_distances_to_segments = reshape(squared_distances_to_segments,n,m);
t = reshape(t,n,m);

[minimal I] = min(squared_distances_to_segments);

else % p=1 


dL = Q_shuffled-P_shuffled;
dR = Q_shuffled-R_shuffled;

f=find(sign(dL).*sign(dR)-1);

range=setdiff(1:n*m,f);

distances=min(abs([dL(range) dR(range)])')';
squared_distances_to_segments=zeros(n*m,1);
t = zeros(n*m,1);

t(f) = abs( dL(f)./(R_shuffled(f)-P_shuffled(f)) );

squared_distances_to_segments(range)=distances.^2;

squared_distances_to_segments=reshape(squared_distances_to_segments,n,m);
t = reshape(t,n,m);

[minimal I] = min(squared_distances_to_segments);

end

if (to_plot)
   
switch p
    case 1 % on the line
    delta=(max([P',R',Q'])-min([P',R',Q']))/10;
    plot([min([P',R',Q'])-delta/2,max([P',R',Q'])+delta/2],[0, 0],'k-'); hold all;
    
for i = 1:n
    plot([P(i),R(i)],[i,i],'-b');
end

for i = 1:m
    plot(Q(i),0,'or');
    plot([Q(i) Q(i)],[0,n],'--c');
end

ylim([-1,n+1]);

    case 2 % planar plot
for i = 1:m*n
    plot(P_shuffled(i,1),P_shuffled(i,2),'.g'); hold all;
    plot(R_shuffled(i,1),R_shuffled(i,2),'.g');
    plot([P_shuffled(i,1),R_shuffled(i,1)],[P_shuffled(i,2),R_shuffled(i,2)],'-b'); 
    plot(Q_shuffled(i,1),Q_shuffled(i,2),'or');
    plot(coords(i,1),coords(i,2),'xr');
    plot([Q_shuffled(i,1),coords(i,1)],[Q_shuffled(i,2),coords(i,2)],'--c');
    axis equal;
end

    case 3 % 3D plot
for i = 1:m*n
    plot3(P_shuffled(i,1),P_shuffled(i,2),P_shuffled(i,3),'.g'); hold all;
    plot3(R_shuffled(i,1),R_shuffled(i,2),R_shuffled(i,3),'.g');
    plot3([P_shuffled(i,1),R_shuffled(i,1)],[P_shuffled(i,2),R_shuffled(i,2)],[P_shuffled(i,3),R_shuffled(i,3)],'-b'); 
    plot3(Q_shuffled(i,1),Q_shuffled(i,2),Q_shuffled(i,3),'or');
    plot3(coords(i,1),coords(i,2),coords(i,3),'xr');
    plot3([Q_shuffled(i,1),coords(i,1)],[Q_shuffled(i,2),coords(i,2)],[Q_shuffled(i,3),coords(i,3)],'--c');
    axis equal;
end    
end

if p>3 % no graphical output can be produced
    fprintf('\n Cannot plot for dimensions other than 2 and 3, sorry!')
end

end