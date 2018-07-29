function  checkout()
%Commit Checkout the currect directory to TortoiseSVN
% See also: svn
svn('checkout',pwd)
