function plotAreaUnderACurve(handles, integrationLimits, coefficients, plot1_xAxis, plot1_yAxis)

% Get the handle to the axes
axes(handles.integrationPlotAxes)

% Find the roots of the polynomial
fx = coefficients(end:-1:1);
rootsFx = roots(fx);
realRootsFx = [];
for idx = 1:length(rootsFx)
    if isreal(rootsFx(idx))
        realRootsFx(end+1,1) = rootsFx(idx);
    end
end

prevXstart = integrationLimits(1);

if ~isempty(realRootsFx)
    realRootsFx = sortrows(realRootsFx);
    % Plot the shaded area (above x-axis in blue and below x-axis in red)
    for idx = 1:length(realRootsFx)
        if ((realRootsFx(idx) > integrationLimits(1)) && (realRootsFx(idx) < integrationLimits(2)))
            % Set the x and y points
            xiPrec = (realRootsFx(idx) - prevXstart)/20;
            xi = (prevXstart:xiPrec:realRootsFx(idx));
            yi = coefficients(1)+coefficients(2)*xi+coefficients(3)*xi.^2+coefficients(4)*xi.^3+coefficients(5)*xi.^4+coefficients(6)*xi.^5;
            faceColor = [0 0.5 1];
            if sign(yi(end-1)) == -1
                faceColor = [1 0 0];
            end
            area(xi,yi,'FaceColor',faceColor);
            hold on
            prevXstart = realRootsFx(idx);
        end
    end
end

xiPrec = (integrationLimits(2) - prevXstart)/20;
xi = (prevXstart:xiPrec:integrationLimits(2));
yi = coefficients(1)+coefficients(2)*xi+coefficients(3)*xi.^2+coefficients(4)*xi.^3+coefficients(5)*xi.^4+coefficients(6)*xi.^5;
faceColor = [0 0.5 1];
if sign(yi(end-1)) == -1
    faceColor = [1 0 0];
end
area(xi,yi,'FaceColor',faceColor);
hold on

x = (integrationLimits(1):integrationLimits(2));
y = coefficients(1)+coefficients(2)*x+coefficients(3)*x.^2+coefficients(4)*x.^3+coefficients(5)*x.^4+coefficients(6)*x.^5;
plot(x,y,'LineWidth',2.5,'Color',[0 0 0]);
xlabel('x','Fontweight','b');
ylabel('f(x)','Fontweight','b');
axis([plot1_xAxis(1) plot1_xAxis(end) plot1_yAxis(1) plot1_yAxis(end)]);
title('Integration');
grid on
hold off
