function plotgrid(X,Y)

% plotgrid: To plot structured grid.
%
%    plotgrid(X,Y)
%
%    INPUT:
%      X (matrix)    - matrix with x-coordinates of gridpoints
%      Y (matrix)    - matrix with y-coordinates of gridpoints


if any(size(X)~=size(Y))
   error('Dimensions of X and Y must be equal');
end

[m,n]=size(X);

% Plot grid
figure
set(gcf,'color','w') ;
axis equal
axis off
box on
hold on

% Plot internal grid lines
for i=1:m
    plot(X(i,:),Y(i,:),'b','linewidth',1); 
end
for j=1:n
    plot(X(:,j),Y(:,j),'b','linewidth',1); 
end

hold off

