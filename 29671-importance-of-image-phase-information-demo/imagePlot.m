function imagePlot( imageData, plotRowSize, plotColSize, ...
                    plotIndex, titleStr )
%IMAGEPLOT 

subplot(plotRowSize, plotColSize, plotIndex);   
imshow(imageData, []); title(titleStr);

end

