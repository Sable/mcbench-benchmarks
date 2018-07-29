function swap(A,B)
% SWAP - swap contents of two variables
%   SWAP(A,B) puts the contents of variable A into variable B and vice versa.
%   You can use either function syntax 'swap(A,B)' or command syntax 'swap A B'.
%
%   Example:
%     A = 1:4 ; B = 'Hello' ;
%     swap(A,B) ;
%     A % -> Hello
%     B % -> 1  2  3  4
%   
%     SWAP(A,B) is a convenient easy short-cut for other (series of)
%     commands that have the same effect, e.g., 
%       temp=A ; A=B ; B=temp ; clear temp ;
%       [B,A] = deal(A,B) ;
%     The advantage over these two methods is that using SWAP one does not
%     have to declare intermediate variables or worry about output.
%
%     See also DEAL

% Tested in Matlab R13
% version 1.1 (sep 2006)
% (c) Jos van der Geest
% email: jos@jasen.nl

% 1.1 Use <deal> to swap (insight from Urs Schwarz)
%     Added command syntax functionality (suggested by Duane Hanselman)
%     Modified help section 

error(nargchk(2,2,nargin)) ;

if ischar(A) && ischar(B),
    % command syntax: SWAP VAR1 VAR2
    evalstr = sprintf('[%s,%s] = deal(%s,%s) ;',B,A,A,B) ;
elseif ~isempty(inputname(1)) && ~isempty(inputname(2)),    
    % function syntax: SWAP(VAR1,VAR2)
    evalstr = sprintf('[%s,%s] = deal(%s,%s) ;',inputname(2),inputname(1),inputname(1),inputname(2)) ;
else
    % No valid command syntax, force error 
    evalstr = '[:)' ;
end
evalin('caller',evalstr,'error(''Requires two (string names of) existing variables'')') ;        


