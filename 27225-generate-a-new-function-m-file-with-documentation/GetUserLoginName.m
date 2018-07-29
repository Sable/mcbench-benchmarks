function name = GetUserLoginName()
%GETUSERLOGINNAME Returns the login name of the current user.
% 
% NAME = GETUSERLOGINNAME() returns the login name of the current user.

% $Author: rcotton $  $Date: 2010/04/12 10:36:31 $ $Revision: 1.3 $
% Copyright: Health and Safety Laboratory 2010

if ispc
   envVar = 'UserName';
else
   envVar = 'USER';
end
name = getenv(envVar);

if isempty(name)
   warning('GetUserLoginName:EmptyName', 'NAME is empty');
end

end