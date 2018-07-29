function [delete]=PlotInitialStateMatrix3D(ToPlotOrNot)

if ToPlotOrNot==1
    for k=1:size(state,3)    
        for j=1:size(state,2)
            for i=1:size(state,1)
                if state(i,j,k)==1
                    plot3(x(i,j,k),y(i,j,k),z(i,j,k),'k.');hold on;
                end
            end
        end
    end
end
axis square;box on