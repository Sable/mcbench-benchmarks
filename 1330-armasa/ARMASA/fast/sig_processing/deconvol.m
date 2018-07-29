function [x,ASAcontrol] = deconvol(z,y,shift1,shift2,last)
%DECONVOL Deconvolution
%   X = DECONVOL(Z,Y) deconvolves vector Y out of vector Z, which means 
%   that if Z = CONVOL(X,Y), then X = DECONVOL(Z,Y). If there is no exact 
%   solution, a remainder will result after deconvolution. The remainder 
%   is not returned.
%   
%   DECONVOL(Z,Y,SHIFT1,SHIFT2) returns only the elements from SHIFT1 up 
%   to SHIFT2.
%   
%   DECONVOL is an ARMASA main function.
%   
%   See also: CONVOL, CONVOLREV, DECONV.

%Header
%=====================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
switch nargin
case 1 
   if isa(z,'struct'), ASAcontrol=z; z=[]; 
   else, error(ASAerr(39))
   end
   y=[]; shift1=[]; shift2=[];
case 2  
   shift1=[]; shift2=[]; ASAcontrol=[];
case 3 
   if isa(shift1,'struct'), ASAcontrol=shift1; shift1=[]; shift2=[];
   else, error(ASAerr(39))
   end
case 4
   ASAcontrol=[];
case 5 
   if isa(last,'struct'), ASAcontrol=last;
   else, error(ASAerr(39))
   end
otherwise
   error(ASAerr(1,mfilename))
end

if isequal(nargin,1) & ~isempty(ASAcontrol)
      %ASAcontrol is the only input argument
   ASAcontrol.error_chk = 0;
   ASAcontrol.run = 0;
end

%ARMASA-function version information
%-----------------------------------

%This ARMASA-function is characterized by
%its current version,
ASAcontrol.is_version = [2000 12 12 12 0 0];
%and its compatability with versions down to,
ASAcontrol.comp_version = [2000 12 11 12 0 0];

%Checks
%------

if ~any(strcmp(fieldnames(ASAcontrol),'error_chk')) | ASAcontrol.error_chk
   %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(z)
      error(ASAerr(11,'z'))
   end
   if ~isnum(y)
      error(ASAerr(11,'y'))
   end
   if ~isempty(shift1) & (~isnum(shift1) | ...
         ~isintscalar(shift1) | shift1<0)
      error(ASAerr(17,'shift1'))
   end
   if ~isempty(shift2) & (~isnum(shift2) | ...
         ~isintscalar(shift2) | shift2<0)
      error(ASAerr(17,'shift2'))
   end
   
   %Input argument value checks
   if ~isavector(z)
      error([ASAerr(14) ASAerr(15,'z')])
   end
   l_z = length(z);
   if ~isavector(y)
      error([ASAerr(14) ASAerr(15,'y')])
   end
   l_y = length(y);
   if y(1)==0
      error(ASAerr(30,'y'))
   end
   if ~(isempty(shift1) & isempty(shift2)) & ...
         (shift1 > shift2 | shift2 > l_z-l_y+1 ...
         | shift1==0)
      error(ASAerr(20,{'shift1','shift2'}))
   end
end

if ~any(strcmp(fieldnames(ASAcontrol),'version_chk')) | ASAcontrol.version_chk
      %Perform version check
   ASAcontrol.version_chk = 1;
      
   %Make sure the requested version of this function
   %complies with its actual version
   ASAversionchk(ASAcontrol);
end

if ~any(strcmp(fieldnames(ASAcontrol),'run')) | ASAcontrol.run
      %Run the computational kernel
   ASAcontrol.run = 1;

%Main   
%=====================================================
s_z = size(z);
l_z = prod(s_z);
s_y = size(y);
l_y = prod(s_y);
if isempty(shift1)
   shift1 = 1;
   shift2 = l_z-l_y+1;
end
if ~(s_z(1)==1 & s_y(1)==1)
   z = z(:);
end

if shift2<l_z-l_y+1
   stop=shift2;
else
   stop=l_z-l_y+1;
end
start=1;
x = filter(1,y,z(start:stop));
x = x(shift1:shift2);

%An approach based on the FFT has been tried and
%proved unreliable

%Footer
%=====================================================

else %Skip the computational kernel
   %Return ASAcontrol as the first output argument
   if nargout>1
      warning(ASAwarn(9,mfilename,ASAcontrol))
   end
   x = ASAcontrol;
   ASAcontrol = [];
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2000 12 12 12 0 0]    W. Wunderink           wwunderink01@freeler.nl
% [2000 12 11 12 0 0]    W. Wunderink           wwunderink01@freeler.nl
