function show_state_estimated(X, Y_k)

X_mean = mean(X, 2);

figure(1)
image(Y_k)
title('+++ Showing mean value +++')

hold on
plot(X_mean(2,:), X_mean(1,:), 'h', 'MarkerSize', 16, 'MarkerEdgeColor', 'y', 'MarkerFaceColor', 'y')
hold off

drawnow
