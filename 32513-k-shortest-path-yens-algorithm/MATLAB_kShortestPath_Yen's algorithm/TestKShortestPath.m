function [] =  TestKShortestPath(case_number)
% Tests the function kShortestPath(case_number) for one of the 3 basic test cases
% specified by case_number. Then it displays the reults.
%==============================================================
% Meral Shirazipour
% DATE :           December 9 decembre 2009                                 
% Last Updated:    April 2 2010 ; August 2 2011
%==============================================================
switch case_number
    case 1
        netCostMatrix = [inf 1 inf 1 ; 1 inf 1 1 ;inf 1 inf inf ;inf inf inf inf ];
        source=3;
        destination=4;
        k = 5;          
    case 2
        netCostMatrix = [inf 5 10 15 20 inf; 5 inf 10 inf inf 5;10 10 inf 15 inf 10; 15 inf 15 inf 20 15;20 inf inf 20 inf 20; inf 5 10 15 20 inf];
        source=1;
        destination=6;
        k = 20; 
    case 3
        netCostMatrix = [inf 10 50 15 inf; 10 inf 10 inf 10; 50 10 inf 5 5; 15 inf 5 inf 15; inf 10 5 15 inf];
        source=1;
        destination=5;
        k = 20; 
    otherwise
        error('The only case options available are 1, 2 or 3');
end

%------Show case selected:------:
fprintf('You selected case #%d, a %dx%d network:\n',case_number,size(netCostMatrix,1),size(netCostMatrix,1));
disp(netCostMatrix);
fprintf('The path request is from source node %d to destination node %d, with K = %d \n',source,destination, k);

%------Call kShortestPath------:
[shortestPaths, totalCosts] = kShortestPath(netCostMatrix, source, destination, k);

%------Display results------:
fprintf('\nResult of Function call: kShortestPath(netCostMatrix, source, destination, k)  = \n\n');

if isempty(shortestPaths)
    fprintf('No path available between these nodes\n\n');
else
    for i = 1: length(shortestPaths)
        fprintf('Path # %d:\n',i);
        disp(shortestPaths{i})
        fprintf('Cost of path %d is %5.2f\n\n',i,totalCosts(i));
    end
end

end

