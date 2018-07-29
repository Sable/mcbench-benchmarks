function h = beagle(varargin)
% BEAGLE Establish connection with BeagleBoard hardware.
% 
% C = beagle creates a connection object, C, for communicating with 
% BeagleBoard hardware.
%
% C = beagle(hostname, username, password, builddir) allows specification
% of non-default values for the IP address, user name, password, and the
% build directory on the BeagleBoard hardware.
%
% Methods:
% 
% [status, msg] = C.connect tests SSH connection to the BeagleBoard
% hardware. If connection is successful, the return value for status is
% zero. Otherwise an error has occurred during connection. The output
% argument msg provides diagnostic messages if the connection fails.
%
% [status, msg] = C.execute('command') executes the Linux command on the
% BeagleBoard hardware and returns the resulting status and standard output. 
%
% C.execute('command', true) executes the Linux command on the BeagleBoard
% hardware and forces the output to the MATLAB command window.
%
% C.run(modelName) runs the previously compiled Simulink model on the
% BeagleBoard hardware.
%
% C.stop(modelName) stops the execution of the Simulink model on the
% BeagleBoard hardware.
%
% C.openShell('ssh') launches a SSH terminal session. Once the terminal
% session is started, you can execute commands on the BeagleBoard hardware
% interactively.
% 
% C.openShell('serial') launches a serial terminal session. You must have a
% serial connection between your host computer and the BeagleBoard hardware.
% The parameters of the serial connection must be set to the following:
% 
% Baud Rate   : 115200
% Data bits   : 8
% Stop bits   : 1
% Parity      : None
% Flow control: None
%
% Examples:
%
%    C = beagle;
%    C.execute('ls -al ~', true);
%
%  lists the contents of the home directory for the current user on the
%  BeagleBoard hardware.
%
%    [st, msg] = C.connect
%
%  tests the SSH connection to the BeagleBoard hardware. 
%
%    C.run('beagleboard_gettingstarted') 
%
%  runs the model 'beagleboard_gettingstarted' on the BeagleBoard hardware.
%  The model must have run previously on the BeagleBoard hardware for this
%  method to work properly.
%
%    C.openShell('ssh') 
%
%  launches a SSH terminal session. You must enter the user name and the
%  password to login to the Linux shell running over SSH. Once logged in,
%  you can execute interactive shell commands.


%   Copyright 2012 The MathWorks, Inc.

narginchk(0, 4);
if nargin > 0
    h = realtime.internal.getLinuxServicesHandle('BeagleBoard', varargin{:});
else
    h = realtime.internal.getLinuxServicesHandle('BeagleBoard');
end

end
