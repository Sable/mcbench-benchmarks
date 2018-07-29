function PlotDistributions(X,p,Mu,Sigma,p_,Mu_,Sigma_)

[J,N]=size(X);
NBins=round(10*log(J));
for n=1:N

    figure 
    
    % set ranges
    xl=min(X(:,n));
    xh=max(X(:,n));
    x=[xl : (xh-xl)/100 : xh];
    
    % posterior numerical
    h3=pHist(X(:,n),p_,NBins);

    % posterior analytical
    hold on
    h4=plot(x,normpdf(x,Mu_(n),sqrt(Sigma_(n,n))));
    set(h4,'linewidth',2,'color','r')
    
    % prior analytical
	hold on
    h2=plot(x,normpdf(x,Mu(n),sqrt(Sigma(n,n))));
    set(h2,'linewidth',2,'color','b')

    xlim([xl xh])
    legend([h3 h4 h2],'numerical', 'analytical', 'prior')
end