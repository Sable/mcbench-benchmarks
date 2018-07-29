function [rc,var,ASAcontrol] = burg(f,b,max_order,last)
%BURG Burg type AR estimator
%   [RC,VAR] = BURG(SIG,MAX_ORDER) estimates AR-reflectioncoefficients RC 
%   up to order MAX_ORDER from the data vector SIG. VAR is the estimated 
%   variance of SIG.
%   
%   RC = BURG(F,B,ADD_ORDER) estimates ADD_ORDER additional 
%   reflectioncoefficients from vectors of forward and backward residuals 
%   F and B, that have been internally used in a previous Burg estimation 
%   procedure.
%   
%   Since forward and backward residual vectors are internally assigned 
%   to the ASAglob variables 'ASAglob_final_f' and 'ASAglob_final_b', an 
%   appropriate F and B can be retrieved after the program has finished 
%   execution. This is most easily done by typing:
%     F = ASAglobretr('ASAglob_final_f');
%     B = ASAglobretr('ASAglob_final_b');
%   
%   BURG is an ARMASA main function.
%   
%   See also: BURG_S, SIG2AR, ASAGLOB, ASAGLOBRETR.

%   References: S. M. Kay and S. L. Marple, Spectrum Analysis - a Modern
%               Perspective, Proceedings IEEE, Vol. 69, 1981,
%               pp. 1380-1419.
%               W. Wunderink, The Introduction of a Computationally
%               Efficient Burg Estimator Algorithm,
%               Tech. Report SSC-March00-1, Delft University of
%               Technology, Department of Applied Physics, Systems
%               Signals and Control Group, the Netherlands, March 2000.

%Header
%==============================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
switch nargin
case 1 
   if isa(f,'struct'), ASAcontrol=f;
   else, error(ASAerr(39))
   end
   f=[]; b=[]; max_order=[];
case 2 
   if isa(b,'struct'), error(ASAerr(2,mfilename))
   end
   max_order=b; b=[]; ASAcontrol=[];
case 3 
   if isa(max_order,'struct'), ASAcontrol=max_order; max_order=b; b=[];
   else, ASAcontrol=[];
   end
case 4
   if isa(last,'struct'), ASAcontrol=last;
   else, error(ASAerr(39))
   end
otherwise
   error(ASAerr(1,mfilename))
end

state = 0;
if isequal(nargin,1) & ~isempty(ASAcontrol)
      %ASAcontrol is the only input argument
   ASAcontrol.error_chk = 0;
   ASAcontrol.run = 0;
elseif (isequal(nargin,3) & isempty(ASAcontrol)) | ...
      isequal(nargin,4) %f and b have been provided
      %as input arguments (empty b not excluded)
   state = 1;
end

%Declare ASAglob variables 
ASAglob = {'ASAglob_final_f';'ASAglob_final_b'};

%Assign values to ASAglob variables by screening the
%caller workspace
for ASAcounter = 1:length(ASAglob)
   ASAvar = ASAglob{ASAcounter};
   eval(['global ' ASAvar]);
   if evalin('caller',['exist(''' ASAvar ''',''var'')'])
      eval([ASAvar '=evalin(''caller'',ASAvar);']);
   else
      eval([ASAvar '=[];']);
   end
end

%ARMASA-function version information
%-----------------------------------

%This ARMASA-function is characterized by
%its current version,
ASAcontrol.is_version = [2000 12 30 20 0 0];
%and its compatability with versions down to,
ASAcontrol.comp_version = [2000 12 30 20 0 0];

%This function calls other functions of the ARMASA
%toolbox. The versions of these other functions must
%be greater than or equal to:
ASAcontrol.req_version.convolrev = [2000 12 6 12 17 20];

%Checks
%------

if ~any(strcmp(fieldnames(ASAcontrol),'error_chk')) | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(f)
      error(ASAerr(11,'f'))
   elseif ~isavector(f)
      error([ASAerr(14) ASAerr(15,'f')])
   elseif size(f,2)>1
      f = f(:);
      warning(ASAwarn(25,{'row';'f';'column'},ASAcontrol))
   end
   if ~isempty(b)
      if ~isnum(b)
         error(ASAerr(11,'b'))
      elseif ~isavector(b)
         error([ASAerr(14) ASAerr(15,'b')])
      elseif size(b,2)>1
         b = b(:);
         warning(ASAwarn(25,{'row';'b';'column'},ASAcontrol))
      end
   end
   if ~isnum(max_order) | ~isintscalar(max_order) | ...
         max_order<0
      error(ASAerr(17,'max_order'))
   end
   
   %Input argument value checks
   if ~isreal(f) | (~isempty(b) & ~isreal(b))
      error(ASAerr(13))
   end
   if isempty(b)
      if max_order>length(f)-1
         error(ASAerr(21))
      end
   elseif ~isequal(length(f),length(b))
      error(ASAerr(28,{'f','b'}))
   elseif max_order>length(f)-2
      error(ASAerr(29,'max_order'))
   end
end

if ~any(strcmp(fieldnames(ASAcontrol),'version_chk')) | ASAcontrol.version_chk
      %Perform version check
   ASAcontrol.version_chk = 1;
      
   %Make sure the requested version of this function
   %complies with its actual version
   ASAversionchk(ASAcontrol);
   
   %Make sure the requested versions of the called
   %functions comply with their actual versions
   convolrev(ASAcontrol);
end

if ~any(strcmp(fieldnames(ASAcontrol),'run')) | ASAcontrol.run
      %Run the computational kernel
   ASAcontrol.run = 1;
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 0;
   
%Main   
%=======================================================================

N=length(f);
p = max_order;

if p>0
   if ~isempty(b)
      mode = 3;
   elseif N<1024
      mode = 3;
   elseif p<0.1*N
      mode = 1;
   else
      mode = 3;
   end
else
   mode = 0;
end

rc = zeros(1,p+1);

if mode == 1
   p_max = p;
   v = zeros(N+p_max,2);
   a = zeros(N+p_max,2);
   v(1:N,2) = f;
   a(1+p_max:N+p_max,2) = f;
   r1 = p_max+1;
   v1 = [1 1];
   v2 = [N N];
   v3 = [N N];
   a1 = [r1 r1];
   a2 = [r1 r1];
   a3 = [r1+N-1 r1+N-1];
   i1 = 0;
   c = 0;
elseif mode == 3
   if isempty(b)
      v = f(2:N);
      a = f(1:N-1);
      var = f'*f;
      den = 2*var-f(1)^2-f(N)^2;
      var = var/N;
      rc(2) = -2*v'*a/den;
      i1 = 1;
   else
      v = f(2:N);
      a = b(1:N-1);
      den = v'*v+a'*a;
      rc(1) = -2*v'*a/den;
      var = [];
      i1 = 0;
   end
else
   if isempty(b)
      var = f'*f/N;
   else
      var = [];
   end
end

if mode
   i1 = i1+1;
   if mode==3 %SP
      for i1 = i1:p
         f = v+rc(i1)*a;
         b = a+rc(i1)*v;
         v = f(2:end);
         a = b(1:end-1);
         den = (1-rc(i1)^2)*den-f(1)^2-b(end)^2;
         rc(i1+1) = -2*v'*a/den;
      end
   elseif mode==1 %ACC
      i13 = 2*p;
      i14 = p+1;
      i15 = 0;
      i16 = 0;
      i17 = 0;
      jj = zeros(2,i13);
      jjm_h = zeros(2,i14);
      jj_h = zeros(2,i14);
      jj(2,1) = 1;
      jjm_h(2,1) = 1;
      jj_h(2,2) = 1;
      acov_x = convolrev(f,p,ASAcontrol);
      i1 = i1+1;
      var = acov_x(1);
      den = 2*var-v(v1(2),2)^2-a(a3(2),2)^2;
      rc(i1) = -2*acov_x(2)/den;
      var = var/N;
      v1(2) = v1(2)+1;
      a3(2) = a3(2)-1;
      t = 0;
      r5 = v1(2)+p-2;
      r6 = a3(2)-p+2;
      r11 = v2(2)-p+2;
      r12 = a2(2)+p-2;
      i33 = 1;
      r7 = v2(2)+1;
      r8 = a2(2)-1;
      r9 = v1(2);
      r10 = a3(2);
      r13 = r5-r9;
      r14 = r10-r6;
      r15 = r11-r9;
      r16 = r10-r12;
      for i1 = i1:p
         i13 = i1+1;
         i14 = i1-1;
         i15 = 2*i1-1;
         i16 = 2*i1-2;
         i17 = 2*i1-3;
         rc_h1 = rc(i1)^2;
         rc_h2 = 2*rc(i1);
         if c, c0 = 2; c1 = 1;
         else c0 = 1; c1 = 2;
         end        
         jj(c0,1:2) = jj(c1,1:2);
         jj(c0,3:i15) = jj(c1,3:i15)+rc_h1*jj(c1,i17:-1:1);
         jj(c0,i1:i16) = jj(c0,i1:i16)+rc_h2*jjm_h(c1,1:i14);
         jj(c0,2:i14) = jj(c0,2:i14)+rc_h2*jjm_h(c1,i14:-1:2);
         jjm_h(c0,1:i1) = rc(i1)*jj_h(c1,1:i1);
         jjm_h(c0,1:i14) = jjm_h(c0,1:i14)+(1+rc(i1)^2)*jjm_h(c1,1:i14);
         jj_h(c0,1:i13) = jj(c0,i13:-1:1);
         jj_h(c0,1:i14) = jj_h(c0,1:i14)+jj(c0,i13:i15);
         va(1) = jj(c0,1:i1)*acov_x(i13:-1:2);
         va(2) = jj(c0,i13:i15)*acov_x(1:i14);
         v1(c0) = v1(c1)+1; v3(c0) = v3(c1)+1;
         a1(c0) = a1(c1)-1; a3(c0) = a3(c1)-1;
         t = t+i33;
         v(r9:r5,c0) = v(r9:r5,c1)+...
            rc(i1)*a(a1(c1):a1(c1)+r13,c1);
         v(r11+t:v3(c1),c0) = v(r11+t:v3(c1),c1)+...
            rc(i1)*a(a1(c1)+r15+t:r10,c1);
         v(v3(c0),c0) = rc(i1)*f(N,:);
         a(r6:r10,c0) = a(r6:r10,c1)+...
            rc(i1)*v(v3(c1)-r14:v3(c1),c1);
         a(a1(c1):r12-t,c0) = a(a1(c1):r12-t,c1)+...
            rc(i1)*v(r9:v3(c1)-r16-t,c1);
         a(a1(c0),c0) = rc(i1)*f(1,:);            
         omega_va(c0) = v(r9:v1(c1),c0)'*a(a1(c0):r8,c0)+...
            v(r7:v3(c0),c0)'*a(a3(c1):r10,c0);
         den = den*(1-rc_h1)-v(v1(c1),c0)^2-a(a3(c1),c0)^2;
         rc(i13) = -2*(sum(va)-omega_va(c0))/den;
         c=~c;
      end
   end
end

if state %f and b have been provided as input 
   %arguments (empty b not excluded)
   if ~isempty(b)
      rc = rc(2:end);
   end
else
   rc(1) = 1;
end

ASAglob_final_f = [];
ASAglob_final_b = [];
if mode==3
   ASAglob_final_f = f;
   ASAglob_final_b = b;
elseif isequal(p,0)
   ASAglob_final_f = f;
end

%Footer
%=====================================================

else %Skip the computational kernel
   %Return ASAcontrol as the first output argument
   if nargout>1
      warning(ASAwarn(9,mfilename,ASAcontrol))
   end
   rc = ASAcontrol;
   ASAcontrol = [];
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% former version         S. de Waele            waele@tn.tudelft.nl
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl
