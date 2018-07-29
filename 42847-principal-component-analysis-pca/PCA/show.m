function show(X, XRecovered, dispFaces)

% This function is used to display the Original and Recovered Data

subplot(1, 2, 1);
displayData(X(1:dispFaces,:));
title('Original faces');
axis square;

% Display reconstructed data from only k eigenfaces
subplot(1, 2, 2);
displayData(XRecovered(1:dispFaces,:));
title('Recovered faces');
axis square;