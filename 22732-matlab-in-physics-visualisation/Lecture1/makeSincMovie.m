function M = makeSincMovie

%   Copyright 2008-2009 The MathWorks, Inc. 

% Make suitable X and Y matricies to plot the sinc function over
[X, Y] = meshgrid(linspace(-3*pi, 3*pi, 50), linspace(-3*pi, 3*pi, 50));
% From X & Y make the matrix R of radius
R = sqrt(X.^2 + Y.^2);
% Calculate the sinc function from R
F = sin(R)./R;
% Make an amplitude vector that represents the various amplitudes we will
% movie the function over
A = linspace(-1, 1, 30);
% Iterate over each amplitude
for j = 1:numel(A)    
    % Plot the surface with colouring defined by the function with no
    % amplitude modification
    surf(X, Y, A(j)*F, F);
    % Always use the same axis otherwise the movie will look funny
    axis([-10 10 -10 10 -1 1]);
    % Then turn off the axis - don't want tosee them in the movie. Also
    % remove the lines around each face of the surface
    axis off
    shading flat
    % Finally get this frame and the symmetric one so that when we show the
    % whole movie it ends at the same point it began
    M(j) = getframe; %#ok<AGROW>
    M(2*numel(A) - j) = M(j); %#ok<AGROW>
end
