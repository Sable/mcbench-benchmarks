function [out,Wc,Wo] = hankelsv(SYS)
%HANKELSV Compute Hankel singular values and grammians.
%
% [OUT,Wc,Wo] = HANKELSV(SYS) computes controllability and observability
%    grammians Wc, Wo, and the Hankel singular values OUT of an LTI 
%    model SYS (created with either TF, ZPK, SS, or FRD). The model
%    SYS can be either continuous-time or discrete-time. However, only
%    in continuous-time case that SYS is allowed to be unstable. 
%    The computed Hankel singular values are sorted in ascending order. 
%
%    For unstable continuous-time system, state-space stable/anti-stable 
%    decomposition is used instead, and OUT=[OUT_stable;OUT_anti-stable].
%    In addition, Wc={Wc_stable,Wc_anti-stable} and Wo is either. 

%    The former version of HKSV employs an obsolete fashion in using the 
%    Matlab function GRAM, i.e., instead of using GRAM(SYS,'c') and 
%    GRAM(SYS,'o'), it uses GRAM(A,B) and GRAM(A',C'), respectively.  
%    This restricts the computation of gramians to continuous-time case,
%    only, since GRAM(A,B) and GRAM(A',C') solve LYAP, not DLYAP. 
%   
%    This improved version also correct some other bugs in the former  
%    version, for example, HKSV does not return gramians when SYS is 
%    unstable, but not anti-stable. 

%    Developer: Wathanyoo Khaisongkram
%    Date Developed: Oct 20, 2004
%    Email: sunboom15@yahoo.com 
%    Improved version of HKSV by R. Y. Chiang & M. G. Safonov March, 1986
% -----------------------------------------------------------------------

SYS=ss(SYS);                            % convert to state-space model

% Discrete-time LTI model
if get(SYS,'Ts')~=0                     % discrete-time LTI model
   if max(abs(pole(SYS))) > 1           % unstable discrete system
      error('For discrete LTI model, system must be stable')
   end
   Wc = gram(SYS,'c');                  % controllability matrix
   Wo = gram(SYS,'o');                  % observability matrix
   out = sqrt(eig(Wc*Wo));              % Hankel singular values
   [no_use,index] = sort(out);          % index for sorting 
   out = out(index);                    % sorted singular values
   return                               % end function
end   

% Continuous-time LTI model 
[A,B,C,D]=ssdata(SYS);                  % extract the system matrices
   mode = eig(A);                       % the eigen values of 'a'
   nrow = size(A,1);                    % the number of rows in 'a'
   nsta = length(find(real(mode) < 0)); % the number of unstable modes
if isequal(nsta,nrow),                  % completely stable
   Wc = gram(SYS,'c');                  % controllability matrix
   Wo = gram(SYS,'o');                  % observability matrix
   out = sqrt(eig(Wc*Wo));              % Hankel singular values
   [no_use,index] = sort(out);          % index for sorting 
   out = out(index);                    % sorted singular values
elseif isequal(nsta,0),                 % completely unstable
   SYS=ss(-A,-B,C,D,SYS);               % change the dynamic and the input matrices to '-a' and '-b', 
                                        % respectively with all LTI properties inherited from 
                                        % original SYS, e.g., discrete or continuous domain.   
   Wc = gram(SYS,'c');                  % controllability matrix
   Wo = gram(SYS,'o');                  % observability matrix
   out = sqrt(eig(Wc*Wo));              % Hankel singular values
   [no_use,index] = sort(out);          % index for sorting 
   out = out(index);                    % sorted singular values
else, % 0 < nsta < nrow
   [SYSs,SYSu] = stabproj(SYS);         % decompose stable/anti-stable parts
   % Stable part 
   Wcs = gram(SYSs,'c');                % controllability matrix
   Wos = gram(SYSs,'o');                % observability matrix
   outl = sqrt(eig(Wcs*Wos));           % Hankel singular values1
   [no_use,index] = sort(outl);         % index for sorting 
   outl = outl(index);                  % sorted singular values
   % Anti-stable part 
   [Au,Bu,Cu,Du]=ssdata(SYSu);          % obtain the system matrices of SYSu
   SYSu=ss(-Au,-Bu,Cu,Du,SYSu);         % change the dynamic and the input matrices to '-ar' and '-br'. 
   Wcu = gram(SYSu,'c');                % controllability matrix
   Wou = gram(SYSu,'o');                % observability matrix
   outr = sqrt(eig(Wcu*Wou));           % Hankel singular values
   [no_use,index] = sort(outr);         % index for sorting 
   outr = outr(index);                  % sorted singular values
   out = [outl;outr];                   % gather two cases
   Wc={Wcs,Wcu};                        % controllability gramian
   Wo={Wos,Wou};                        % observability gramian
end

% end of HKSV_MOD