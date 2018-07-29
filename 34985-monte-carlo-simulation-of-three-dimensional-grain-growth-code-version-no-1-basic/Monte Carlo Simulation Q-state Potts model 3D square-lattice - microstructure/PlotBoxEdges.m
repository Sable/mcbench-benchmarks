function PlotBoxEdges
factor=1.00;
plot3(factor*[0 1],factor*[0 0],factor*[0 0],'k','LineWidth',5),hold on
plot3(factor*[0 0],factor*[0 0],factor*[0 1],'k','LineWidth',5)
plot3(factor*[0 0],factor*[0 1],factor*[0 0],'k','LineWidth',5)
plot3(factor*[0 1],factor*[1 1],factor*[1 1],'k','LineWidth',5)
plot3(factor*[1 1],factor*[1 1],factor*[1 0],'k','LineWidth',5)
plot3(factor*[1 1],factor*[0 1],factor*[1 1],'k','LineWidth',5)
plot3(factor*[0 0],factor*[0 1],factor*[1 1],'k','LineWidth',5)
plot3(factor*[1 1],factor*[0 1],factor*[0 0],'k','LineWidth',5)
plot3(factor*[0 1],factor*[1 1],factor*[0 0],'k','LineWidth',5)
plot3(factor*[0 1],factor*[0 0],factor*[1 1],'k','LineWidth',5)
plot3(factor*[0 0],factor*[1 1],factor*[0 1],'k','LineWidth',5)
plot3(factor*[1 1],factor*[0 0],factor*[1 0],'k','LineWidth',5)