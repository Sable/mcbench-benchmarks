pointcolor=[rand rand rand];
figure
for count=1:size(AGS,2)
    plot(count,AGS(1,count),'o','MarkerSize',2.5,'MarkerEdgeColor',[pointcolor(1,1) pointcolor(1,2) pointcolor(1,3)],...
        'MarkerFaceColor',[pointcolor(1,1) pointcolor(1,2) pointcolor(1,3)]);axis square;box on;grid on;hold on
end
title('Average Grain Size Vs. MCS')
xlabel('Monte - Carlo Steps')
ylabel('Unit Normalized Average Grain Size')
pause(0.5)