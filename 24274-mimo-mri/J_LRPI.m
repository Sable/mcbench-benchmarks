function [Yas,J]=J_LRPI(theta,xdata,var)

%--------------------------------------------------------------------------
% Prototype:
% [Yas,J]=J_LRPI(theta,xdata,var)
%
% Description:
% Evaluates the MPC Relevant Identification cost function
%
% Inputs:
% -theta: Matrix of parameters 
% -xdata: Contains Y and X
% -var:   Contains ni, no, nb, na, and N2
%
% Outputs:
% -Yas:   Estimated outputs
% -J:     Value of the MPC Relevant Identification cost index
%  
% Author:       David laurí Pla 
% Date:         12/05/2009   
%
% Reference:        
%       -Title:   Model predictive control relevant identification:
% multiple input multiple output against multiple input single output
%       -Authors: D. Laurí, J.V. Salcedo, S. García-Nieto, M. Martínez
%       -Journal: IET control theory and applications
%       -Year:    2010 
%--------------------------------------------------------------------------

%%
%------------------------------------------
%Input data
ni=var.ni;  
no=var.no;
nb=var.nb;
N2=var.N2;
Y=xdata(:,1:no);
X=xdata(:,no+1:size(xdata,2));
%%
%------------------------------------------
%initializations
Xa=X;
Ya=Y;  
X2=X;
%Expand X, and Y to the prediction horizon defined by N2
for j=2:N2
    %Predictions at k+j
    Ys=X2*theta;  
    %Form the new X2
    Xu=X2(:,1:ni*nb);                           %Depends on inputs
    Xy=X2(:,ni*nb+1:size(X2,2));                %Depends on outputs
    Xu=[Xu(2:size(Xu,1),:) ;zeros(1,size(Xu,2))];
    X2=[ Xu Ys Xy(:,1:size(Xy,2)-no)];
    X2=X2(1:size(X2,1)-1,:);                      
    %Save the estimations in the ampliated matrices
    Xa=[Xa;X2];
    Ya=[Ya;Y(j:size(Y,1),:)];
end
%%
%------------------------------------------
%Evaluate JLRPI
Yas=Xa*theta;
E=Ya-Yas;
J=trace(E'*E);
%------------------------------------------
