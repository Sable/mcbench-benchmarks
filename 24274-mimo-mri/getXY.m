function [X,Y]=getXY(U,Y,na,nb)
%--------------------------------------------------------------------------
% Prototype:
% [X,Y]=getXY(U,Y,na,nb)
%
% Description:
% Obtains the regression matrix
%
% Inputs:
% -U:   Process inputs m x ni (m:samples, ni: inputs)
% -Y:   Process outputs m x no (m:samples, no: outputs)
% -na:  Number of lagged outputs in the model
% -nb:  Number of lagged inputs in the model
%
% Outputs:
% -X:   The regression matrix
% -Y:   Outputs matrix
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
%-----------------------------------------------
%X
X=[];
[f,c]=size(U);
for i=1:nb
    X=[X [zeros(i,c); U(1:f-i,:)]]; 
end

[f,c]=size(Y);
for i=1:na
    X=[X [zeros(i,c); Y(1:f-i,:)]];
end
%Y
Y=Y;
%Remove the empty rows
n=max(na,nb);
m=size(X,1);
Y=Y(n+1:m,:);
X=X(n+1:m,:);
%-----------------------------------------------