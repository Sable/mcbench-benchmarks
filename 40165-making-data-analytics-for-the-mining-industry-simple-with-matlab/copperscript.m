%% Making Data Analytics Simple for the Mining Industry
% Demonstrates the technical computing workflow for mining through a case study of Copper Assay (survey) Data
%
% It highlights:
%
% * Access datasets from data sources including Excel, text filesases and devices
% * Easily re-structure and manipulate data
% * Automate analysis and custom visualisation of your data
% * Share results and reports quickly and easily with your colleagues
%
% David Willingham February 2013
% Copyright 2013 The MathWorks, Inc
%% Importing Data
importcopper %generating using the Import Wizard
%% 3D Scatter Plot
% show scatter 3 on plot bar - then customize it below
scatter3(x,y,z,20,c,'filled')
xlabel('East');ylabel('North');zlabel('Elevation')
title('Copper Mine Assay Data')


%% Looking at 1 drill hole
iX = find(x == 2005); %inspect interactively to find this x value
x1 = x(iX);
y1 = y(iX);
z1 = z(iX);
c1 = c(iX);
figure
plot(z1,c1)
xlabel('depth');
ylabel('Cu Perc')
znew = [min(z1):1:max(z1)];
% cnew = interp1(z1,c1,znew,'cubic');
fitresult = createFit(z1, c1); %created using curve fitting toolbox
cnew = feval(fitresult,znew);
hold on
plot(znew,cnew,'r')
%% Slicing just one Z intersection 
% In this case where the MAX Cu is

% Finding the Max Cu value
[Mc,I] = max(c);
% Extracting the x,y,z data
Mx = x(I);
My = y(I);
Mz = z(I);
MzI = Mz == z;
MxZ = x(MzI);
MyZ = y(MzI);
MzZ = z(MzI);
McZ = c(MzI);
% Visualizing the plane
figure
scatter(MxZ,MyZ,25,McZ)
title(['Elevation: ',num2str(Mz)])
xlabel('East')
ylabel('North')
h = colorbar;
title(h,'Cu Perc');
hold on
% Creating a finer grid
[XX,YY] = meshgrid(1600:5:3000,4500:5:5400);
% Using interpolation to fill in the gaps
CC = griddata(MxZ,MyZ,McZ,XX,YY);
% Contour plot of the plane
contour(XX,YY,CC)


%% Identifying Drill Holes

% given the length of each hole is different using "cell arrays" as the 
% data container
lx = unique(x);
for i = 1:length(lx)
    I = lx(i) == x;
    data{i} = [x(I),y(I),z(I),c(I)]; 
end

%% Statistics on Drill Holes
% Identifying holes max min and med Cu Perc
for j = 1:length(data)
    M(j,1) = max(data{j}(:,4));
    m(j,1) = min(data{j}(:,4));
    Med(j,1) = median(data{j}(:,4));
end

%% Maximum Drill Holes
figure
bar(M) %Inspecting the max to identify threshold for Drill Holes to inspect
xlabel('drill hole number')
ylabel('Max Cu Perc')
title('Max Cu Perc of each Drill Hole')
dhmI = M>2; % 2perc is threshold for high cu
drill_holes_max = find(dhmI);

%Creating a histogram of Cu for Max drill holes
figure
for k = 1:length(drill_holes_max)
    subplot(length(drill_holes_max),1,k)
    hist(data{drill_holes_max(k)}(:,4))
    m(k) = mean(data{drill_holes_max(k)}(:,4));
    title(['Drill Hole: ',num2str(drill_holes_max(k)),...
        ' Mean Cu: ',num2str(m(k))]) 
end

% Highlighting Max Drill holes on a plot.
figure
scatter3(x,y,z,8,c)
xlabel('East');ylabel('North');zlabel('Elevation')
title('Copper Mine - Max Drill Holes Highlighted')
hold on
for k = 1:length(drill_holes_max)
    xyzcm = data{drill_holes_max(k)};
    scatter3(xyzcm(:,1),xyzcm(:,2),xyzcm(:,3),25,xyzcm(:,4),'filled')
end
hold on
%% Creating Volumetric Data (4D data interpolation)
[X,Y,Z] = meshgrid(1600:5:3000,4500:5:5500,3500:5:4200);
% griddata interpolates the data into the 4D space
C = griddata(x,y,z,c,X,Y,Z);

%% Visualization of Volumetric Data
xslice = [1600,3000]; yslice = [4500,5500]; zslice = [3500:25:4200];

% uncomment if you wish to see a slice only
% h = slice(X,Y,Z,C,xslice,yslice,zslice);
% set(h,'FaceColor','interp','EdgeColor','none','FaceAlpha',0.2)
% contourslice(X,Y,Z,C,[],[],zslice);
hold on

%Highlighting hi grade Cu areas (indexes 520 and above of 538 unique cu vector)
for i = 520:5:535
    cu = unique(c);
    val = cu(i);
    [faces,verts,colors] = isosurface(X,Y,Z,C,val,C);
    patch('Vertices', verts, 'Faces', faces, ...
        'FaceVertexCData', colors, ...
        'FaceColor','interp', ...
        'edgecolor', 'none',...
        'FaceAlpha',0.1);
end
h = colorbar;
title(h,'Cu %')
%% Copper Percentage - Not to replace Kriging but just a basic example
TotalVolume = (max(X(:)) - min(X(:)))*(max(Y(:)) - min(Y(:)))*(max(Z(:)) - min(Z(:)));
val = cu(530) % choosing Cu perc 
[faces,verts,colors] = isosurface(X,Y,Z,C,val,C);
VCu = alphavol(verts) %downloaded from File Exchange
Vperc = (VCu/TotalVolume) * 100

%% Writing to Excel
dataexcel = num2cell([[1:length(m)]',M,m,Med,double(dhmI)]);
header = {'Drill Hole','Max','Min','Median','High Cu'};
xlswrite('coppermine.xlsx',[header;dataexcel])
