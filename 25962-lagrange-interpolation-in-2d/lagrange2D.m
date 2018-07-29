function lagrange2D
%% STARTVARIABLES
[X,Y]=meshgrid(-1:1:5,-1:1:5);
Z = sin(Y)*sin(X);

step = 0.2;
%% INTERPOLATION
% erst kurven in x richtung ausrechnen
xCurves={};
for i=1:size(X,1)
    % x vector must be a column vector for the lagrange function
    x = X(i,:)';
    % z vector must be a column vector for the lagrange function
    z = Z(i,:)';
    p=[];
    for j = x(1):step:x(end)
        % interpolate for every parameter value j and add it to p
        p = [p,lagrange(x,z,j)];
    end
    % save curves in x direction
    xCurves{i} = p;
end

y = Y(:,1);
% matrix for the graphical outpu
A=[];
% interpolate in y-direction
for i=1:length(xCurves{1})
    p=[];
    z=[];
    for l=1:length(y)
        z = [z;xCurves{l}(i)];
    end
    for j = y(1):step:y(end)
         % interpolate for every parameter value j and add it to p
        p = [p;lagrange(y,z,j)];
    end
    A = [A,p];
end

%% GRAPHICAL OUTPUT
% plot surface
surf(x(1):(x(end)-x(1))/(size(A,1)-1):x(end),y(1):(y(end)-y(1))/(size(A,1)-1):y(end),A);
hold on;
% plot points
for i=1:size(X,1)
    for j=1:size(Y,1)
        p = plot3(X(i,j),Y(i,j),Z(i,j));
        set(p,'Marker','.');
        set(p,'MarkerSize',30);
    end
end

end
%% nested functions
function res = lagrange(x,z,t)
% lagrange interpolation in 1d
% input: x...vektor, welcher die x (bzw. y) Werte beinhaltet

res = 0;
for i=1:length(x)
    % delete the component not needed
    temp = [x(1:i-1);x(i+1:end)];
    
    denominator = x(i)-temp;
    
    numerator = t-temp;
    res = res + z(i)*(prod(numerator))/(prod(denominator));
end
end