function [VecTot, TOT, timei] = ierm(P, Mat, NumDesc)

%ierm returns a matrix containing the best models for all the paths of the
%Enhanced Replacement Method using an initial set of descriptors with a
%very high S, given by an inverse RM.
%TOT contains all the relative results of each step showing the evolution of the method.
%
%           
%	   Input: 
%             P             Property vector
%             Mat           Descriptors matrix with descriptors pool
%             NumDesc       Number of descriptors that the model will have
%
%     Returns:
%          
%            VecTot           vector containing the best model for all the
%                               paths of the Replacement Method
%            TOT               contains all the relative results
%                               showing the evolution of the method. 
%           
% Andrew G. Mercader, Pablo R. Duchowicz
% INIFTA, La Plata, Argentina
% Created: 12 Nov 2007


timei=cputime;

if (nargin < 3)
   error('the function requires at least 5 input variables. Type ''help ierm''.');
end




[c_m, r_m] = size(Mat);


NTot=r_m;

VecI=1:NumDesc;
lindep = ld(P, VecI,Mat);

if lindep==100
    for j=1:1000000000000000000000000000000000000
     VecI = randint(1,NumDesc,[1, NTot]);
     lindep = ld(P, VecI,Mat);
        if lindep==0
            break;
        end
    end
end

[VecT] = rmt_inv(P, VecI, Mat);
VecJ=VecT(NumDesc,3:end);

[VecTot, TOT, time] = erm(P, VecJ, Mat);


timei=cputime-timei
end

%End