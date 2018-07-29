function [ResSW] = stepwise(P, Mat, MaxDesc)

% stepwise finds the solution with lower S_err for one descriptor, then for
% two keeping the first and so on.           
%	   Input: 
%             P             Property vector
%             Mat           Matrix with descriptors pool
%             MaxDesc       Maximum number of descriptors
%
%     Returns:
%          
%             ResSW        Matrix with S_err and the number of the
%                           descriptors in the models found by the stepwise method
%
%
% Andrew G. Mercader, Pablo R. Duchowicz
% INIFTA, La Plata, Argentina
% Created: 7 March 2007

time=cputime;
warning off
if (nargin < 3)
   error('stepwise requires at least 3 input variables. Type ''help stepwise''.');
end

[k, n_m] = size(Mat);

VecJ=[];
ResSW=[];



for i=1:MaxDesc    
    Smin=1000000;   % A very big number compared to a normal S necessary just to start the program
    for j=1:n_m;
    VecI=[VecJ,j];
    Ser=rms(P,VecI,Mat);
        if (Ser<Smin)
            Smin=Ser;
            VecK=VecI;
        end
    end
VecJ=VecK;
ResSW(i,1)=Smin;
    for k=2:MaxDesc+1
      [n_v m_v]=size(VecK);
        if k-1>m_v
        ResSW(i,k)=NaN;
        else
        ResSW(i,k)=VecK(k-1);
        end
    end
end
time=cputime-time
warning on

%End