function [theta]=LM_MIMO(U,Y,na,nb,N2)
%--------------------------------------------------------------------------
% Prototype:
% [theta]=LM_MIMO(X,Y,na,nb,N2)
%
% Description:
% Implements MPC Relevant Identification for the SISO, MISO, and MIMO cases.
% Uses lsqcurvefit to minimize JLRPI and provides theta:
%           Y=X*theta + F
%
% Inputs:
% -U:   Process inputs m x ni (m:samples, ni: inputs)
% -Y:   Process outputs m x no (m:samples, no: outputs)
% -na:  Number of lagged outputs in the model
% -nb:  Number of lagged inputs in the model
% -N2:  Prediction horizon
%
% Outputs:
% -theta: Matrix of parameters  
%  
% Note:
% Samples in U and Y must have been obtained consecutevely:
% U(i,:) was captured before U(i+1,:), for all i in [1,m-1]
% Y(i,:) was captured before Y(i+1,:), for all i in [1,m-1]
% Otherwise the cost function JLRPI is not properly evaluated 
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
%--------------------------------------------------------------------------
%Regression and output matrices
[X Y]=getXY(U,Y,na,nb);
%Initializations
no=size(Y,2);
ni=(size(X,2)-no*na)/nb;
m=size(Y,1);
%Expanded outputs considering N2 
Ya=Y;  
for j=2:N2
    Ya=[Ya;Y(j:m,:)];
end
%Minimize JLRPI using lsqcurvefit
xdata = [Y X];
ydata = Ya;
theta0=(X'*X)^-1*X'*Y;
var=[];     var.ni=ni;  var.no=no;  var.na=na;  var.nb=nb;  var.N2=N2;
options = optimset('LevenbergMarquardt','on','MaxFunEvals',1000);
theta = lsqcurvefit(@(x,xdata) J_LRPI(x,xdata,var), theta0, xdata, ydata,[],[],options);
%--------------------------------------------------------------------------
end


%%
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
% Reference:        (Currently under review)        
%       Title:      MPC Relevant Identification: MIMO versus MISO
%       Authors:    D. Laurí, J.V. Salcedo, S. García-Nieto, M. Martínez
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
end