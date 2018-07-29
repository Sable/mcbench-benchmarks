function CheckForJVM()
%CHECKFORJVM Throws an error if the JVM is not available.
% 
% CHECKFORJVM() throws an error if the Java Virtual Machine is not
% available.

% $Author: rcotton $	$Date: 2010/10/01 13:58:35 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

if ~usejava('jvm')
   error('CheckForJVM:JVMNotAvailable', ...
      'The Java Virtual Machine is not available');
end

end
