%% Snake Demo
%
% An example using a SNAKETOY function.
%
% This function creates a snake toy graphic.  Each block
% in the snake is an hgtransform object.  A vector of angles (in
% radians) can be passed in to create a new shape by twisting the
% snake.  Twisting occurs using the hgtransform's 'Matrix'
% property.
%
% <snaketoy.m>

% Copyright (C) 2005-2011 The MathWorks Inc.

% Create a snake
snake = snaketoy;

%% Transform the snake
%
% By passing in a list of angles, you can transform the snake into
% a new shape.
snaketoy(snake,[ 0 0 0 pi pi 0 0 0 pi 0 pi pi ...
                   0 pi 0 pi pi 0 pi 0 pi pi 0 pi]);
camzoom(2)
%% Named Shapes
%
% Some shapes have pre-defined names encoded in the file.
% You can reference these by name.
snaketoy(snake, 'box');

%% Transformation Methods
%
% You can cause a shape to transform in different ways by moving
% linearly through the pattern from one of the snake to the other,
% choosing random joints to twist, or twisting all joints at the
% same time.
snaketoy(snake, 'dog','once');

%% Demonstration Mode
%
% You can run the script in demo mode by calling SNAKETOY
% with no arguments.  This feature runs infinitly, constantly
% transforming the snake into new shapes using arbitrary
% transformation methods.

% snaketoy
