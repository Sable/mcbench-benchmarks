display('Plotting the Grain Boundary')
pause(0.5)
for count=1:size(GrainBoundaryX,2)
    plot(GrainBoundaryX(1,count),GrainBoundaryY(1,count),...
        's','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',3.5),hold on,axis([0 1 0 1])
    box on;axis square
    if mod(count,5000)==0
        pause(0.001);
    end
end