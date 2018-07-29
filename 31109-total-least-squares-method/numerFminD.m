function [Err, min_param]=numerFminD(fun, p, LBa, UBa, xdata, ydata, FTime, Tvz)
%
% [Err, min_param]=numerFminS(fun, p, LBa, UBa, xdata, ydata)
%
% Orthogonal regression method for a 2D dynamical model 
% defined in file 'Model.m', which is an input as a 'fun'.
%     
% This function is based on optimization algorithm created
% by John D'Errico in 2006 and named as: 'fminsearchbnd'.
%
% Input parameters:
%  - fun: name of file where is the model defined
%  - p: number of optimized parameters (same as in the file 'fun')
%  - LBa: lower bound vector or array for parameters 
%  - UBa: upper bound vector or array for parameters 
%  - xdata: input data block -- x: axis
%  - ydata: input data block -- y: axis
%  - FTime: final time of computation [0, Tfinal]
%  - Tvz: sampling period
% 
% Return parameters:
%  - Err: error - sum of squared orthogonal distances 
%  - min_param: vector of model parameters  
%
% Authors:
% Ivo Petras (ivo.petras@tuke.sk)
% Tomas Skovranek (tomas.skovranek@tuke.sk)
% Dagmar Bednarova (dagmar.bednarova@tuke.sk)
%
% Date: 25/01/2009
%
% Example:
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [dy] = dmodel2D(t,y,a)
% dy = zeros(2,1);
% dy(1) = y(2);
% dy(2) = (1 - a(2)*y(2)-a(1)*y(1))/a(3);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data.txt
% XData=data(:,1);
% YData=data(:,2);
% FTime = 600;
% Tvz=5;
% LBa=[1 100 550]; UBa=[2 140 630];
% [Err, min_param]=numerFminD(@dmodel2D, 3, LBa, UBa, XData, YData, FTime, Tvz)
% [time, Yhat] = ode45(@(time, Yhat)dmodel2D(time,Yhat,min_param),[0:Tvz:FTime],[XData(1,1) YData(1,1)]);
% plot(XData,YData,'*');
% hold on
% plot(Yhat(:,1),Yhat(:,2),'k');
%
%

if ~(exist('fminsearchbnd', 'file') == 2)
    P = requireFEXpackage(8277);  
    % fminsearchbnd is part of 8277 at MathWorks.com
end 
warning off all
options1 = odeset('RelTol',1e-6,'AbsTol',1e-6);
options = optimset('MaxIter',1e+4,'MaxFunEvals',1e+4,'TolX',1e-6,'TolFun',1e-6); 
%
xo=xdata;
yo=ydata;
Mpoints=[xo yo];
sum=0;
a0=zeros(1,p);
%
[a,fval,exitflag,output] = fminsearchbnd(@calculation,a0,LBa,UBa,options);
%calculating with optimized parameters:
min_param=a;
[tt,yy] = ode45(@(tt,yy)fun(tt,yy,a),[0:Tvz:FTime],[Mpoints(1,1) Mpoints(1,2)],options1);
x=yy(:,1); y=yy(:,2);       
%some output information about the minimization:
algoritm=output.algorithm;
funcCount=output.funcCount;
iter=output.iterations;
output.message;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function for evaluating the set of differencial equations with optimized parameters
    function [sum] = calculation (a0)
    sum=0;
    [tt,yy] = ode45(@(tt,yy)fun(tt,yy,a0),[0:Tvz:FTime],[Mpoints(1,1) Mpoints(1,2)],options);
    x=yy(:,1); y=yy(:,2);      
    points=[x y];
            for m=1:size(Mpoints,1)
            [min_dist,IP]=dist_dsearch(points,Mpoints(m,:),'off');
            sum=sum+(min_dist.^2);
        end
        Err=sum;
    end
end
%