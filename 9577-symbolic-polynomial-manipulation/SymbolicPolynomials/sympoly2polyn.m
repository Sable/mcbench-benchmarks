function Pn = sympoly2polyn(sp)
% sympoly2polyn: converts a sympoly to something that polyvaln can evaluate efficiently
% usage: Pn = sympoly2polyn(sp)
%
% arguments: (input)
%  sp - any sympoly object, as created by the sympoly toolbox
%
% arguments: (output)
%  Pn  - a struct that polyvaln can use
%
% Example:
%  sympoly x y z
%  sp = x + x^2 + 5*y*z - 2*z^3;
%
% % Convert to be useable by polyvaln
%  Pn = sympoly2polyn(sp)
%
% % Pn = 
% %      ModelTerms: [4x3 double]
% %    Coefficients: [-2 5 1 1]
% %        VarNames: {'x'  'y'  'z'}
%
% % Efficient evaluation at a list of points
%  xyz = rand(5,3);
%  polyvaln(Pn,xyz)
% % ans =
% %       2.8421
% %       1.2473
% %      0.67012
% %       2.8207
% %       0.1257
%
% % Verify that the evaluation is correct compared to subs
%
%  subs(sp,'x',xyz(1,1),'y',xyz(1,2),'z',xyz(1,3))
%
% % A scalar sympoly object
% %     2.8421
%
%
% CAVEAT: The varables will be in the order decided by the sympoly tools.
% This order will generally be an alphabetical one.
% 
%
% See also: sympoly/subs, polyvaln, polyfitn, sympoly2sym
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 3/25/08

% verify its a sympoly
if ~isa(sp,'sympoly')
  error('sp must be a sympoly object')
end

sps = struct(sp);

Pn.ModelTerms = sps.Exponent;
Pn.Coefficients = sps.Coefficient(:).';
Pn.VarNames = sps.Var;

