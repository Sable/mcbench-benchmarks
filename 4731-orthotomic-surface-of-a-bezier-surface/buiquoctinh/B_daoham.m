%====================================================
%Practise problem for the course of CAO
%Prof P.Beckers 
%====================================================
%Porpose :Drawing the orthotomic surface of a Bezier surface  %
% Student: BUI QUOC TINH
% European Master Mechanices of Contructions	(EMMC)					     				 
% University the Liege. Belgium										    		     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%====================================================

%The function calculation BernsTein polynomial derivation
function Bepoly=B_daoham(i,n,u)
% Calculation combination
if i==n|i==0
   c=1;
elseif i<n & i>=0
   c=factorial(n)/(factorial(i)*factorial(n-i));
else
   c=0;
end
%BernsTein polynomial
Bepoly=c*u^i*(1-u)^(n-i)*(i-n*u)/((1-u)*u);


%%%%%%%%%%%%%%%%%%%%%%%%