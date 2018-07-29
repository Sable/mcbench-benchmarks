function f = identityFcn
%identityFcn Identity function.
%   F = identityFcn returns a function handle F, a function which will
%   return the arguments you pass to it unchanged. 
%  
%   This is useful for setting up default functions that allow code to be
%   written with fewer conditionals.
%
%   Examples
%   --------
%       % Create identity function
%       f = identityFcn;
%       
%       % Use f to return a vector
%       v_in = 1:5;
%       v_out = f(v_in);
%       isequal(v_in,v_out)
%  
%       % Use f to return x and y coordinates in separate variables
%       x_in = [1 10];
%       y_in = [5  9];
%       [x_out,y_out] = f(x_in,y_in);
%       isequal(x_in,x_out)
%       isequal(y_in,y_out)  
  
%   Copyright 2005 The MathWorks, Inc.
%   $Revision $  $Date: 2005/05/27 14:07:22 $
  
f = @(varargin) deal(varargin{:});