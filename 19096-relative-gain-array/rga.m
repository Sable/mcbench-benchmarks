function [R,S]=rga(G)
% RGA   Relative Gain Array
% 
% R=rga(G) returns the Relative Gain Array, R based on the gain matrix, G.
%
% For square matrix, G, R is the normal RGA, defined as follows:
%   R = inv(G') .* G 
% If G is nonsquare, R is the so called General RGA:
%   R = pinv(G') .* G
% 
% The RGA is a very useful tool for control structure design. For a square
% system (the number of inputs equals to the number of output), the RGA can
% be used to find input-output pairs (one input to control one output).
% There are many publications on how to pair input and output using the
% RGA. The basic rule is:
% 1. Avoid input and output pairs which have negative relative gains.
% 2. Avoid input and output pairs which have large relative gains.
% 3. Select input and output pairs which have the relative gain close to 1.
% 
% Interestingly, if the RGA is repeatedly calculated based on R, i.e.
%
% R = rga(R);
% 
% Eventualy, the RGA will converge to a selection (0,1)-matrix. With the
% second output, 
%
% [R,S] = rga(G) produces a selection matrix, S based on the repeated RGA.
%
% where S is (0,1) matrix with the same dimension as G. Each row and each
% column of S have only one element of 1, but all others are 0. The element
% of 1 indicates which input (column) should be used to pair which output
% (row).
% Note: The selection matrix, S, is only a recommendation. It may not
% satisfy the rules stated above and may not be appropriate for some
% systems.
%
% For nonsquare systems, the general RGA can also be used to select inputs
% if the number of inputs is larger than the number of outputs, or to
% choose outputs, if the system has more outputs than inputs. The second
% output in this case gives the input (output) effectiveness, E.
%
% [R,E] = rga(G)
%
% Where E is a column vector corresponding to the input (output). Inputs
% (outputs) with largest input (output) effectiveness are recommented to be
% selected for the control system.
%
% By Yi Cao at Cranfield University on 7th March 2008
%
% References:
%
% 1. Bristol, E.H., On a new measure of interactions for multivariable process
% control. IEEE Trans. Automatic Control, AC-11:133-134, 1966.
% 2. Cao, Y and Rossiter, D, An input pre-screening technique for control
% structure selection, Computers and Chemical Engineering, 21(6), pp.
% 563-569, 1997.
 
% Examples:
%
% Example 1: A random 5 x 5 matrix
%{
G = randn(5);
[R,S] = rga(G)
%}
% Example 2: A random 5 x 10 matrix for input selection
%{
G = randn(5,10);
[R,IE] = rga(G)
%}
% Example 3: A random 10 x 5 matrix for output selection
%{
G = randn(10,5);
[R,OE] = rga(G)
%}
%


% Check input and output
error(nargchk(1,1,nargin));
error(nargoutchk(0,2,nargout));

% The RGA
R=pinv(G.').*G;
if nargout<2
    return
end

[m,n]=size(G);
% The square case
if n==m
    S=R;
    while norm(round(S)-S)>1e-9
        S(S<0)=0;
        S = inv(S.').*S;
    end
    return
end

% The nonsquare case
S = sqrt(sum(R))';
if m>n
    S = sqrt(sum(R,2));
end
