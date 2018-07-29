figureTitle = ['Observation on ' ...
    ' the importance of image phase']; 

% figure(figureIndex), 
figure('Name', figureTitle,'NumberTitle','off'),

plotIndex = 0;
plotRowSize = 1;
plotColSize = 3;

titleStr = ['image1 amplitude' newline 'With Image2 phase realOnly'];
plotIndex = plotIndex + 1;
imagePlot(image1_amplitudeWithImage2_phase_realOnly, plotRowSize, plotColSize, ...
                    plotIndex, titleStr );

titleStr = ['image2 amplitude' newline 'With Image1 phase realOnly'];
plotIndex = plotIndex + 1;
imagePlot(image2_amplitudeWithImage1_phase_realOnly, plotRowSize, plotColSize, ...
                    plotIndex, titleStr );
                
                
titleStr = ['image1 recovered' newline ''];
plotIndex = plotIndex + 1;
imagePlot(imageInGray_InSpatialDomain, plotRowSize, plotColSize, ...
                    plotIndex, titleStr );
