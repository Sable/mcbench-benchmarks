function []=MinimizeLLRateSimVASICEK()

clear all
for i=1:200
    % Inputs for term structure generator, and minimizer
    tau=[3/12,6/12,2,5];
    Ya=RateSimVASICEK(0.06,0.05,0.02,-0.2,1/12,0.06,120,tau);
    Y=Ya;
    [nrow, ncol] = size(Y);
    lb=[0.0001,0.0001,0.0001,-1, 0.00001*ones(1,ncol)];
    ub=[ones(1,8)];
    para0=[0.06,0.05,0.025,-0.2,0.1*rand(1,ncol).*ones(1,ncol)]; % Choose 'good' starting values 
    % Minimizer
    [x,fval]=fmincon(@LLoneVASICEK,para0,[],[],[],[],lb,ub,[],[],Y, tau, nrow, ncol)
    VASICEK200(i,:)=x
    save VASICEK200
end
mean(VASICEK200)
std(VASICEK200)