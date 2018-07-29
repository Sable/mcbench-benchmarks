function p = dunnett(stats, expt_idx, ctrl_idx)
% p = dunnett(stats, expt_idx, ctrl_idx)
% p is vector of p-values for comparing experimental value(s) (expt_idx) w/ a single
% control value (ctrl_idx), corrected by the Dunnett multiple comparison test
% stats is output from anova1
% idx are indicies of means of interest within stats datastructure
% p = dunnett(stats), then ctrl_idx=1, expt_idx=2:length(stats.means)
% p = dunnett(stats, expt_idx), then ctrl_idx=1
% p = dunnett(stats, [], ctrl_idx), then expt_idx=1:length(stats.means), but NOT ctrl_idx
% p = Dunnett's probability for non-zero difference between ctrl_idx and expt_idx means
% Based on Behavior Research Methods & Instrumentation (1981), vol. 13 (3), 363-366
% Dunlap, Marx, and Agamy Fortran IV source code adapted to Matlab
% The output from this function are consistent w/ the Dunnett test implemented in Prism 5.0a
% 
% % Example
% % generate random data 
% % groups ctrl and one are zero centered
% % groups two, three, and four are 2,3,4 centered respectively
%
% groupnames = {'ctrl','one','two','three','four'};
% datavector = [];
% k=1;
% for(i=1:length(groupnames))
%     len = rand*20;
%     while(len<10)
%         len = rand*20;
%     end
%     if(i>2)
%         datavector = [datavector i*rand(1,len)];
%     else
%         datavector = [datavector rand(1,len)];
%     end
%     for(j=1:len)
%         group{k} = groupnames{i};
%         k=k+1;
%     end
% end
% [p,t,stats] = anova1(datavector,group); % perform one-way ANOVA
% p = dunnett(stats)
%
% p =
%
%       NaN    0.9238    0.1639    0.0106    0.0002
%
%  p(1) = 'ctrl' vs 'ctrl' = NaN p-value
%  p(4) means 'three' is different from 'ctrl' w/ p-value 0.0106
%  p(5) means 'four' is different from 'ctrl' w/ p-value 0.0002
%
% Navin Pokala 2012


if(nargin<1)
    disp('p = dunnett(stats, [expt_idx], [ctrl_idx])')
    return
end

if(nargin<2)
    ctrl_idx=1;
    p=[NaN];
    for(expt_idx=2:length(stats.means))
        p = [p dunnett(stats, expt_idx, ctrl_idx)];
    end
    return;
end

if(nargin<3)
    ctrl_idx=1;
end

if(isempty(expt_idx))
    p=[];
    for(expt_idx=1:length(stats.means))
        if(expt_idx~=ctrl_idx)
            p = [p dunnett(stats, expt_idx, ctrl_idx)];
        else
            p = [p NaN];
        end
    end
    return;
end

if(length(expt_idx)>1)
    p=[];
    for(i=1:length(expt_idx))
        if(expt_idx~=ctrl_idx)
            p = [p dunnett(stats, expt_idx(i), ctrl_idx)];
        else
            p = [p NaN];
        end
    end
    return;
end


DF = stats.df;
n_expt_groups = length(stats.means)-1;

mean_ctrl = stats.means(ctrl_idx);
n_ctrl = stats.n(ctrl_idx);

mean_expt = stats.means(expt_idx);
n_expt = stats.n(expt_idx);

% both are practically zero
if(abs(mean_ctrl)<=eps('single') && abs(mean_expt)<=eps('single'))
    p = 1;
    return;
end

T = (mean_ctrl - mean_expt)/(stats.s*sqrt(1/n_ctrl + 1/n_expt));
Q=abs(T);

R = n_expt/(n_expt+n_ctrl);

BT=sqrt(1-R);
TP=sqrt(R);

if(DF > 2000)
    p = 1 - DUN(Q, n_expt_groups);
    return;
end

% outer integral 0->inf
A1=0;
S=0.14/sqrt(DF);
X0=1;
F0=DUN(Q*X0,n_expt_groups)*SD(X0);

ctr=0;
SUB = 1;
while(A1/SUB < 1e7 || ctr==0)
    Xl=X0+S;
    F1=DUN(Q*Xl,n_expt_groups)*SD(Xl);
    X2=Xl+S;
    F2=DUN(Q*X2,n_expt_groups)*SD(X2);
    SUB=S/3*(F0+4*F1+F2);
    A1=A1+SUB;
    X0=X2;
    F0=F2;
    S=S*1.05;
    ctr=ctr+1;
end

% OUTER INTEGRAL FROM 1 TO 0
A2 = 0;
S = -0.14/sqrt(DF);
XINC = 1.05;
if(DF <= 12)
    S = -0.03125;
    XINC = 1;
end
X0=1;
F0=DUN(Q*X0,n_expt_groups)*SD(X0);

for(KK=1:16)
    X1=X0+S;
    F1=DUN(Q*X1,n_expt_groups)*SD(X1);
    X2=X1+S;
    F2=DUN(Q*X2,n_expt_groups)*SD(X2);
    SUB = -S/3*(F0+4*F1+F2);
    A2 = A2+SUB;
    if(A2/SUB > 1e7)
        break;
    end
    X0 = X2;
    F0 = F2;
    S = S*XINC;
end
p = 1 - A1 - A2;
if(p < 0)
    p=0;
end

    function dn = DUN(Q,n_expt_groups)
        SP = sqrt(1/(2*pi));
        AREA = 0;
        if(Q < 0)
            dn = 0;
            return;
        end
        sig = 0.07;
        x0 = 0;
        f0 = SP*exp(-x0*x0/2)*(ZPRB((TP*x0+Q)/BT)-ZPRB((TP*x0-Q)/BT))^n_expt_groups;
        
        ct=0;
        sub=1;
        while(AREA/sub < 1e7 || ct==0)
            x1=x0+sig;
            f1=SP*exp(-x1*x1/2)*(ZPRB((TP*x1+Q)/BT)-ZPRB((TP*x1-Q)/BT))^n_expt_groups;
            x2=x1+sig;
            f2=SP*exp(-x2*x2/2)*(ZPRB((TP*x2+Q)/BT)-ZPRB((TP*x2-Q)/BT))^n_expt_groups;
            sub=sig/3*(f0+4*f1+f2);
            AREA=AREA+sub;
            x0=x2;
            f0=f2;
            sig=sig*1.05;
            ct=ct+1;
        end
        
        dn=2*AREA;
    end

    function g = SD(S)
        g = ((DF^(DF/2))*(S^(DF-1))*exp(-DF*S*S/2))/(gamma(DF/2)*2^(DF/2-1));
    end

    function zprb = ZPRB(Z)
        %  COMPUTES THE CUMULATIVE PROBABILITY OF NORMAL DEVIATE Z
        % (INTEGRAL OF THE NORMAL DISTRIBUTION FROM -INFINITY TO Z)
        
        x=abs(Z);
        
        zprb=0;
        
        if(x > 12)
            if (Z > 0)
                zprb=1-zprb;
            end
            return
        end
        
        q=sqrt(1/(2*pi))*exp(-x*x/2);
        
        if(x > 3.7)
            zprb=q*(sqrt(4+x*x)-x)/2;
            if (Z > 0)
                zprb=1-zprb;
            end
            return;
        end
        
        t=1/(1.+0.2316419*x);
        P=0.31938153*t;
        P=P-0.356563782*t^2;
        P=P+1.78147937*t^3;
        P=P-1.821255978*t^4;
        P=P+1.330274429*t^5;
        zprb=q*P;
        
        if (Z > 0)
            zprb=1-zprb;
        end
        
    end

return
end
