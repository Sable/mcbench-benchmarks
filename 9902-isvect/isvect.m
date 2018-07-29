function [tf, type] = isvect(A,guess,varargin)
%ISVECT(A,GUESS) Returns logical true if A is a vector of type GUESS.
% A is an array.  The alternative second input, GUESS, is either:  
%          1 or 'r' or 'row' (inquire if A is a row vector) or  
%          2 or 'c' or 'col' or 'column' (inquire if A is a column vector).
% [TF, TYPE] = isvect(A,GUESS) will also return a value (TYPE) representing
% the type of vector given by A .  If TYPE is returned as a:
%                 0 - this means A is not a vector
%                 1 - this means A is a row vector
%                 2 - this means A is a column vector
%
% Examples:       A=[1 2 3];
%                 isvect(A)  % Returns true
%                 isvect(A,1)  % Returns true (A is a row vector)
%                 isvect(A,'r')  % Returns true (A is a row vector)
%                 isvect(A,2)  % Returns false (A is not a column vector)
%                 [TF TYPE] = isvect(A,1)  % Returns TF = 1, TYPE = 1 (row)
%
% If A is scalar, isvect(A) returns true for any GUESS and TYPE=1.
%
%    See also  isnumeric, islogical, ischar, isempty.
%
% Author:  Matt Fig
% Contact: popkenai@yahoo.com
% Date:  feb 2006
                                                                    
tf = false;
type = false;         % A false type should always go only with tf = false.

if ndims(A)>2, return, end     % (Dimension higher than 2) => not a vector.

siz = size(A)~=1;
s_siz = sum(siz);

if s_siz>1, return, end                                     % A is a matrix.

tf = true;                             % If we made it here, A is a vector.
type = sum(siz & [true,false])+1;                         % 1=>row, 2=>col.

if nargin==1; return; end;

switch guess
    case {'r','row',1}
        if type~=1, tf = false; end 
    case {'c','col','column',2}
        if type~=2 && s_siz~=0 
            tf = false; 
        else
             type=2;            % When passed a scalar, any GUESS is right!
        end
    otherwise
        error('Second input must be 1 or 2 or ''r'' or ''c''.  See help.')
end