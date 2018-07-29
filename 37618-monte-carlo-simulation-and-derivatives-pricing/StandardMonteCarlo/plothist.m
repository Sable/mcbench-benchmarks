% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function plothist(model,Var,Dates)

switch model
 case 'vg'
    tit = 'Variance Gamma';
    tit2 = '';
    tit3 = '';
    l1 = 'C';
    l2 = 'G';
    l3 = 'M';
    n1 = 3;
    n2 = 0;
    n3 = 0;
  case 'nig'
    tit = 'Normal Inverse Gaussian';
    tit2 = '';
    tit3 = '';
    l1 = '\alpha';
    l2 = '\beta';
    l3 = '\delta';
    n1 = 3;
    n2 = 0;
    n3 = 0;
 case 'vgcir'
    tit = 'Variance Gamma - CIR';
    l1 = 'C';
    l2 = 'G';
    l3 = 'M';
    tit2 = 'VGCIR - Stochastic Vol Parameter';
    m1 = '\kappa';
    m2 = '\eta';
    m3 = '\lambda';
    tit3 = '';
    n1 = 3;
    n2 = 3;
    n3 = 0;
 case 'vggou'
    tit = 'Variance Gamma - GOU';
    l1 = 'C';
    l2 = 'G';
    l3 = 'M';
    tit2 = 'VGGOU - Stochastic Vol Parameter';
    m1 = 'a';
    m2 = 'b';
    m3 = '\lambda';
    tit3 = '';
    n1 = 3;
    n2 = 3;
    n3 = 0;
  case 'nigcir'
    tit = 'NIG - CIR';
    l1 = '\alpha';
    l2 = '\beta';
    l3 = '\delta';
    tit2 = 'VGCIR - Stochastic Vol Parameter';
    m1 = '\lambda';
    m2 = '\kappa';
    m3 = '\eta';
    tit3 = '';
    n1 = 3;
    n2 = 3;
    n3 = 0;
  case 'niggou'
    tit = 'NIG - GOU';
    l1 = '\alpha';
    l2 = '\beta';
    l3 = '\delta';
    tit2 = 'VGGOU - Stochastic Vol Parameter';
    m1 = '\lambda';
    m2 = 'a';
    m3 = 'b';
    tit3 = '';
    n1 = 3;
    n2 = 3;
    n3 = 0;
  case 'heston'
    tit = 'Heston';
    l1 = 'Vinst';
    l2 = 'Vlong';
    l3 = '';
    tit2 = 'Heston - Stochastic Variance Parameter';
    m1 = '\kappa';
    m2 = '\nu';
    m3 = '\rho';
    tit3 = '';
    n1 = 2;
    n2 = 3;
    n3 = 0;
  case 'bates'
    tit = 'Bates';
    l1 = 'Vinst';
    l2 = 'Vlong';
    l3 = '';
    tit2 = 'Bates - Stochastic Variance Parameter';
    m1 = '\kappa';
    m2 = '\nu';
    m3 = '\rho';
    tit3 = 'Bates - Jump Parameter';
    j1 = '\sigma_J';
    j2 = '\mu_J';
    j3 = '\lambda';
    n1 = 2;
    n2 = 3;
    n3 = 3;
  case 'merton'
    tit = 'Merton';
    l1 = '\sigma';
    l2 = '';
    l3 = '';
    tit2 = '';
    m1 = '';
    m2 = '';
    m3 = '';
    tit3 = 'Merton - Jump Parameter';
    j1 = '\mu_J';
    j2 = '\sigma_J';
    j3 = '\lambda';
    n1 = 1;
    n2 = 0;
    n3 = 3;
  case 'black'
    tit = 'Black Scholes';
    l1 = '\sigma';
    l2 = '';
    l3 = '';
    tit2 = '';
    m1 = '';
    m2 = '';
    m3 = '';
    tit3 = '';
    j1 = '';
    j2 = '';
    j3 = '';
    n1 = 1;
    n2 = 0;
    n3 = 0;
end


    figure('Color', [1 1 1]); [a,b] = hist(Var(:,1:n1),100);
    hold on;
        if (n1>=1)
            if (n1==1)
               bar(b,a,1,'r'); 
            else
                bar(b,a(:,1),1,'r');
            end;
        end;
        if (n1>=2)
            bar(b,a(:,2),1,'g'); 
        end;
        if (n1>=3)
            bar(b,a(:,3),1,'b');
        end;
        hold off;
    title(tit);
    legend(l1, l2, l3);
    figure('Color', [1 1 1]); hold on;
    if (n1>=1)
        plot(Dates,Var(:,1),'<','Color',[0.4 0.4 0.4]);
    end
    if (n1>=2)
        plot(Dates,Var(:,2),'o','Color',[0.3 0.3 0.3]);
    end
    if (n1 >=3)
        plot(Dates,Var(:,3),'x','Color',[0.2 0.2 0.2]);
    end
    datetick('x',20);
    hold off;
    title(tit);
    legend(l1, l2, l3);
    if strcmp(tit2,'')
    
    else
        figure('Color', [1 1 1]); [a,b] = hist(Var(:,n1+1:n1+n2),100);
        hold on;
        if (n2>=1)
            bar(b,a(:,1),1,'r'); 
        end;
        if (n2>=2)
            bar(b,a(:,2),1,'g'); 
        end;
        if (n2>=3)
            bar(b,a(:,3),1,'b');
        end;
        hold off;
        title(tit2);
        legend(m1, m2, m3);
        figure('Color', [1 1 1]); hold on;
        if (n1 >= 1)
            plot(Dates,Var(:,n1+1),'<','Color',[0.4 0.4 0.4]);
        end
        if (n2 >= 2)
            plot(Dates,Var(:,n1+2),'o','Color',[0.3 0.3 0.3]);
        end
        if (n2 >= 3)
            plot(Dates,Var(:,n1+3),'x','Color',[0.2 0.2 0.2]);
        end
        datetick('x',20);
        hold off;
        title(tit);
        legend(m1, m2, m3);
    end
    
    if strcmp(tit3,'')
    
    else
        figure('Color', [1 1 1]); [a,b] = hist(Var(:,n1+n2+1:end),100);
        hold on;
        if (n3>=1)
            bar(b,a(:,1),1,'r'); 
        end;
        if (n3>=2)
            bar(b,a(:,2),1,'g'); 
        end;
        if (n3>=3)
            bar(b,a(:,3),1,'b');
        end;
        hold off;
        title(tit3);
        legend(j1, j2, j3);
        figure('Color', [1 1 1]); hold on;
        if (n3>=1)
            plot(Dates,Var(:,n1+n2+1),'<','Color',[0.4 0.4 0.4]);
        end;
        if (n3>=2)
            plot(Dates,Var(:,n1+n2+2),'o','Color',[0.3 0.3 0.3]);
        end;
        if (n3 >=3)
            plot(Dates,Var(:,end),'x','Color',[0.2 0.2 0.2]);
        end;
        datetick('x',20);
        hold off;
        title(tit3);
        legend(j1, j2, j3);
    end