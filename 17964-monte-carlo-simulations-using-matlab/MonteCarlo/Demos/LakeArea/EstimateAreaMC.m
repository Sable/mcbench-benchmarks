function [Area] = EstimateAreaMC(xpoly,ypoly,maxsize,NbPoints,Method,VerboseOutput)

switch Method
    case 'Halton'
        P = haltonset(2);
        RandomPoints = maxsize .* net(P,NbPoints);
        k = 0;
    case 'Sobol'
        P = sobolset(2);
        RandomPoints = maxsize .* net(P,NbPoints);
    case 'Standard'
        RandomPoints = maxsize .* rand(NbPoints,2);
    otherwise
        error('Invalid Method');
end


IN = inpolygon(RandomPoints(:,1),RandomPoints(:,2),xpoly,ypoly);
Area = maxsize .* maxsize * sum(sum(IN)) ./ NbPoints;





hold on;

if (VerboseOutput)
    h = gcf;
    plot(RandomPoints(IN(:,end),end-1),RandomPoints(IN(:,end),end),'g.','LineWidth',1.5);
    plot(RandomPoints(~IN(:,end),end-1),RandomPoints(~IN(:,end),end),'rx','LineWidth',1.5);
    set(h,'WindowStyle','Docked');
    disp(['Area of the Polygon -> ' num2str(polyarea(xpoly,ypoly))]);
    disp(['Estimated Area of the Polygon  -> ' num2str( Area)]);
end





