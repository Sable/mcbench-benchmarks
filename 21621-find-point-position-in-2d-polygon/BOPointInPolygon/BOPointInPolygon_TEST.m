%   AUTHOR:
%       Boguslaw Obara, http://boguslawobara.net/
%% Create a polygon
clc;
t = 0:0.6:6.28;
seedx = 100; seedy = 100;
scalefactor = 20; P = [];
P(:,1) = (seedx(1) + scalefactor*cos(t))';
P(:,2) = (seedy(1) + scalefactor*sin(t))';
PP = [P; P(1,:)];
%% Plot
plot(PP(:,1),PP(:,2),'-bs'); hold on
%% Query
q = PP(10,:);
plot(q(:,1),q(:,2),'r*');hold on
stage = BOPointInPolygon(PP,q);
disp(['Stage: ' stage]);
for i=1:5
    [pointx, pointy] = ginput(1);    
    q = [pointx pointy];
    plot(q(:,1),q(:,2),'r*');hold on
    %q = P(13,:)
    stage = BOPointInPolygon(PP,q);
    disp(['Stage: ' stage]);
end
%%