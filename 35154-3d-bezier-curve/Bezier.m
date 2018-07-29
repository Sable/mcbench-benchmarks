% % % --------------------------------
% % % Author: begtostudy
% % % Email : begtostudy@gmail.com
% % % --------------------------------
function Q=Bezier(P,t)
% Bezier interpolation for given points.
%
%Example:
% P=[292 280 321 356;
% 196 153 140 148;
% -56 75 140 248];
% 
% t=linspace(0,1,100);
% Q3D=Bezier(P,t);
% 
% figure
% plot3(Q3D(1,:),Q3D(2,:),Q3D(3,:),'b','LineWidth',2),
% hold on
% plot3(P(1,:),P(2,:),P(3,:),'g:','LineWidth',2)        % plot control polygon
% plot3(P(1,:),P(2,:),P(3,:),'ro','LineWidth',2)     % plot control points
% view(3);
% box;
 
for k=1:length(t)
    Q(:,k)=[0 0 0]';
    for j=1:size(P,2)
        Q(:,k)=Q(:,k)+P(:,j)*Bernstein(size(P,2)-1,j-1,t(k));
    end
end
end
 
function B=Bernstein(n,j,t)
    B=factorial(n)/(factorial(j)*factorial(n-j))*(t^j)*(1-t)^(n-j);
end

