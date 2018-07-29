function g = graf(matriks)

n=length(matriks);
theta = 2*pi./n;
angle = theta*(0:(n-1));
radius = n* ones(1,length(angle));
textRadius =  n*( ones(1,length(angle)) + 0.2);
x = radius .* cos(angle);
y = radius .* sin(angle);
textX = textRadius .* cos(angle);
textY =  textRadius .* sin(angle);
fHandle = figure;
figure(fHandle);
dummy = 1:1:n;
edges = combntns(dummy,2);

mat1 = zeros(n,n);
mat2 = zeros(n,n);
for i=1:1:n
    for j=1:1:n
        if matriks(i,j)==1
            mat1(i,j)=1;             % edge yang positif
        end
        if matriks(i,j)==-1
            mat2(i,j)=1;              % edge yang negatif
        end
    end
end

for m = 1:n
    h = rectangle('Position',[x(m)-0.5, y(m)-0.5, 1, 1], 'Curvature', [1,1], 'FaceColor','k');
end

grid off;
axis off;

for j=1:n
    text(textX(j), textY(j), int2str(j),'Color','black');
    nodeUpdated(j).output = [];
    indices = find(mat1(j,:));
    for k=1:length(indices)
        multiplicity(k) = matriks(j,indices(k));    
    end
    
    for m=1:length(indices)
        nodeUpdated(j).output = [nodeUpdated(j).output repmat(indices(m),1,multiplicity(m))];        
        line([x(j) x(indices(m))] , [y(j) y(indices(m))],'LineWidth',3);
    end       
end

for j=1:n
    nodeUpdated(j).output = [];
    indices = find(mat2(j,:));
    for k=1:length(indices)
        multiplicity(k) = matriks(j,indices(k));    
    end
    
    for m=1:length(indices)
        nodeUpdated(j).output = [nodeUpdated(j).output repmat(indices(m),1,multiplicity(m))];        
        line([x(j) x(indices(m))] , [y(j) y(indices(m))],'Color','k','LineStyle',':','LineWidth',3);
    end       
end
