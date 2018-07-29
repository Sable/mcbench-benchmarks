%--------------------------------------------------------------------------
% File description:
% This File implements MPC Relevant Identification (MRI) for a given
% identification data set. The process to identify is a PEMFC (Proton
% Exchange Membrane Fuel Cell). The data has been centered and scaled. 
% The assumed linear model is:
%       Y=X*theta + F
%
% Author:       David laurí Pla 
% Date:         12/05/2009   
%
% Notes:
% This example needs The Matlab Optimization Toolbox. 
% This file has been tested on Matlab 2008b
%
% Reference:        
%       -Title:   Model predictive control relevant identification:
% multiple input multiple output against multiple input single output
%       -Authors: D. Laurí, J.V. Salcedo, S. García-Nieto, M. Martínez
%       -Journal: IET control theory and applications
%       -Year:    2010 
%--------------------------------------------------------------------------
%%
%load identification and validation data
load data   %The data set has been mean-centered and scaled

%Design parameters
na=3;       %number of lagged outputs in the model
nb=3;       %number of lagged inputs in the model
N2=10;      %Prediction horizon
%%
%MRI: Fit theta to the identification data set (MIMO identification)
theta_MRI=LM_MIMO(u,y,na,nb,N2);

%LS: Identification (MIMO identification)
[X Y]=getXY(u,y,na,nb);
theta_LS=(X'*X)^-1*X'*Y;
%%
%Evaluate JLRPI for a validation data set (In the given example the mean of 30 validation data sets is obtained)
for i=1:size(uv,3)
    [X Y]=getXY(uv(:,:,i),yv(:,:,i),na,nb);
    var=[];     var.ni=size(u,2);  var.no=size(y,2);  var.na=na;  var.nb=nb;  var.N2=N2;    
    [Yas_MRI,J_MRI(i)]=J_LRPI(theta_MRI,[Y X],var);
    [Yas_LS,J_LS(i)]=J_LRPI(theta_LS,[Y X],var);
end
J_MRI=mean(J_MRI);
J_LS=mean(J_LS);
disp('Cost index for theta fitted with MRI and LS (Mean of 30 external validation data sets)')
disp(sprintf('MRI: J_LRPI=%g',J_MRI))
disp(sprintf('LS:  J_LRPI=%g',J_LS))
%%
%Plot prediction results for both models

%Obtain the indices to extract data from Yas
m=size(Y,1);
range=[];
offset=0;
for i=1:N2
    range=[range;[offset+1,offset+m-i+1]];
    offset=offset+m-i+1;
end

for s=1:size(Y,2)
    %One-step ahead
    figure('Name',sprintf('Predictions for the validation data set (y_%d)',s))
    subplot(1,3,1)
    n=1;
    plot(Y(1:m-n+1,s),'k');hold on
    plot(Yas_LS(range(n,1):range(n,2),s),'b')
    plot(Yas_MRI(range(n,1):range(n,2),s),'r')
    title(sprintf('Predictions at k+%d with output data up to k',n))


    %Midlle point between 1 and N2
    n=round(N2/2);
    subplot(1,3,2)
    plot(Y(1:m-n+1,s),'k');hold on
    plot(Yas_LS(range(n,1):range(n,2),s),'b')
    plot(Yas_MRI(range(n,1):range(n,2),s),'r')
    title(sprintf('Predictions at k+%d with output data up to k',n))
    legend('Real','LS','MRI')

    %N2-step ahead
    n=N2;
    subplot(1,3,3)
    plot(Y(1:m-n+1,s),'k');hold on
    plot(Yas_LS(range(n,1):range(n,2),s),'b')
    plot(Yas_MRI(range(n,1):range(n,2),s),'r')
    title(sprintf('Predictions at k+%d with output data up to k',n))
end



