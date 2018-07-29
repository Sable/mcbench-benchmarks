function plotApproxAreaUnderACurve(handles, integrationLimits, coefficients, deltaX)

% Get the handle to the axes
axes(handles.approximationPlotAxes)

% Find the roots of the polynomial
fx = coefficients(end:-1:1);
rootsFx = roots(fx);
realRootsFx = [];
for idx = 1:length(rootsFx)
    if isreal(rootsFx(idx))
        realRootsFx(end+1,1) = rootsFx(idx);
    end
end

% Get the xbar and ybar coordinates
xbar = (integrationLimits(1) + 0.5*deltaX:deltaX:integrationLimits(2));
ybar = coefficients(1)+coefficients(2)*xbar+coefficients(3)*xbar.^2+coefficients(4)*xbar.^3+coefficients(5)*xbar.^4+coefficients(6)*xbar.^5;

prevXbarIdx = 1;
if ~isempty(realRootsFx)
    realRootsFx = sortrows(realRootsFx);
    for idx=1:length(realRootsFx)
        for jdx=prevXbarIdx:length(xbar)-1
            if ((realRootsFx(idx) > xbar(jdx)) && (realRootsFx(idx) < xbar(jdx+1)))
                faceColor = [0 0.5 1];
                if sign(ybar(jdx)) == -1
                    faceColor = [1 0 0];
                end
                bar(xbar(prevXbarIdx:jdx),ybar(prevXbarIdx:jdx),1,'FaceColor',faceColor);
                hold on
                prevXbarIdx = jdx+1;
            end
        end
    end
end

faceColor = [0 0.5 1];
if sign(ybar(end)) == -1
    faceColor = [1 0 0];
end           
bar(xbar(prevXbarIdx:end),ybar(prevXbarIdx:end),1,'FaceColor',faceColor);
hold on

x = (integrationLimits(1):integrationLimits(2));
y = coefficients(1)+coefficients(2)*x+coefficients(3)*x.^2+coefficients(4)*x.^3+coefficients(5)*x.^4+coefficients(6)*x.^5;
plot(x,y,'LineWidth',2.5,'Color',[0 0 0]);
xlabel('x','Fontweight','b');
ylabel('f(x)','Fontweight','b');
title('Approximate Area Using Rectangles');
set(handles.approximationPlotAxes,'XMinorTick','on')
grid on
hold off
