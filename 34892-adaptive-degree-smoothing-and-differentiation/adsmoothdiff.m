function ynew=adsmoothdiff(dados,xnew,sdx,isdx,q,nmin)
%
% function ynew=adsmoothdiff(dados,xnew,sdx,isdx,q,nmin)
% written by Carlos J Dias
%
% ADAPTIVE DEGREE SAVISTZKY-GOLAY SMOOTHING AND DIFFERENTIATION
% This function smooths and differentiates a sequence of numbers based on
% an algorithm drawn on the ideas of Savistky and Golay and Barak.
% There are no restrictions however, on the number of points 
% or on their spacing.
% This function also calculates the first derivative at the xnew points
%
% INPUT:
% dados - data in a two column matrix (first column x; second column y)
% xnew - is a vector where new ordinates are to be computed
%
% sdx - is the abscissa range of data to be used to find the least squares
% polynomial
% isdx - is a fraction of the sdx range between [0 1] where new y_values
% for xnew will be calculated. It usually is 0.8 (i.e. 80%) of the sdx range.
% q - is the highest degree of the polynomial to be used in the interpolation
% nmin - is the minimum data points to be used in the interpolation.
%
% ALGORITHM:
% For each point xnew_i of the xnew vector, this function finds the least
% squares polynomial (with polyfit) passing through the experimental points
% lying between [xnew_i - sdx, xnew_i + sdx]. The program checks for the
% Using this polynomial it calculates, with polyval, the values for
% y and its derivative in that same interpolating window.
%
% All calculated values for each abscissa are used to compute an average
% value of the smoothed function and its derivative.
% When sdx range includes fewer points than nmin, the range is enlarged to
% include at least nmin points. This may occur more often at the edges
% of the data.
% Note that we should have nmin>q
%
% OUTPUT (ynew - 5 column matrix)
% column 1- new abscissas
% column 2- new ordinates
% column 3- their standard error
% column 4- first derivative
% column 5- no. of values that were calculated for the ith point
%
% DEMO SCRIPT (SMOOTHING OF 1000 POINTS)
% x=linspace(-10,10,1000)';
% y=1./(1+((x-2)/0.5).^2)+2./(1+((x+2)/0.5).^2);%two lorenztians
% noise=0.5*(rand(length(y),1)-0.5);
% y=y+noise;
% ynew=adsmoothdiff([x y+noise],x,1.1,0.7,5,15);
% plot(x,y,x,ynew(:,2));grid; title('Original and smoothed function');
% %(it takes about 30 s to run this script in my computer)
%
% P Barak, Analytical Chemistry 1995, 67 2758-2762
% A Savitzky, MJE Golay, Analytical Chemistry 1964, 36(8) 1627-1638
% I also acknowledge Jianwen Luo for drawing my attention to adaptive
% strategies.

clf
if q+1>nmin
    error('Polynomial degree should not be lower than min. no. of points');
end

if (isdx>1 || isdx<0.01)
    error('Error in the interpolating range');
end

x=dados(:,1);
y=dados(:,2);
clear dados

if max(xnew)>max(x) || min(xnew)<min(x)
    error('New data outside data range. Please remove extrapolation points.');
end

N=length(x);
Nnew=length(xnew);

% [x y delta^2 y' N]
ynew=[xnew zeros(Nnew,1) Inf*ones(Nnew,1) zeros(Nnew,2)];
% [yi delta(i)^2 y'(i)]
ynew1=zeros(Nnew,3);

for ii=1:Nnew
    JJ=find (x>=xnew(ii)-sdx & x<=xnew(ii)+sdx);

    % DEALING WITH END EFFECTS
    if length(JJ)<nmin
        mn=ceil((nmin-length(JJ))/2);
        JJ=JJ(1)-mn:JJ(1)-mn+nmin;
        if min(JJ)<1
            JJ=JJ-min(JJ)+1;
        end
        if max(JJ)>N
            JJ=JJ-max(JJ)+N;
        end
    end
    
    % FINDING THE BEST POLYNOMIAL. STARTING FROM q=1
    NJ=length(JJ);
    [p,s,mu]=polyfit(x(JJ),y(JJ),1);
    chi1=( sum((y(JJ)-polyval(p,x(JJ),s,mu)).^2) );
    q1=1;
    for iii=3:2:q
        [p,s,mu]=polyfit(x(JJ),y(JJ),iii);
        chi=sum((y(JJ)-polyval(p,x(JJ),s,mu)).^2);
        xF=(NJ-iii-1)*(chi1/chi-1);
        cF= fcdf(xF,2,NJ-iii-1);
        if cF>0.98 % 98% significance to switch to a higher polynomial
            q1=q1+2;
            chi1=chi;
        else
            break
        end
    end
    
    %ACTUAL COMPUTATION OF THE POLYNOMIAL
    [p,s,mu]=polyfit(x(JJ),y(JJ),q1);

    %RECALCULATING Y_VALUES USING THE FITTED POLYNOMIAL
    JJ=find (xnew>=xnew(ii)-sdx*isdx & xnew<=xnew(ii)+sdx*isdx);

    [ynew1(JJ,2),ynew1(JJ,3)]=polyval(p,xnew(JJ),s,mu);
    ynew1(JJ,3)=ynew1(JJ,3).^2;
    ynew1(JJ,4)=polyval(polyder(p)/mu(2),xnew(JJ),[],mu);
    ynew(JJ,5)=ynew(JJ,5)+1;

    figure(1);plot(x,y,xnew(JJ),ynew1(JJ,2),'.');
    title(['polynomial= ' num2str(q1)]);

    ynew(JJ,2)=ynew1(JJ,2)./ynew1(JJ,3)+ynew(JJ,2)./ynew(JJ,3);
    ynew(JJ,4)=ynew1(JJ,4)./ynew1(JJ,3)+ynew(JJ,4)./ynew(JJ,3);

    ynew(JJ,3)=1./(1./ynew1(JJ,3)+1./ynew(JJ,3));

    ynew(JJ,2)=ynew(JJ,2).*ynew(JJ,3);
    ynew(JJ,4)=ynew(JJ,4).*ynew(JJ,3);

end

ynew(:,3)=sqrt(ynew(:,3));

%SHOW FINAL RESULTS
figure(1)
subplot(2,1,1);plot(x,y,xnew,ynew(:,2),'r');grid
title(['Smoothed and Unsmoothed function, range= ' num2str(sdx) ', qmax= ' num2str(q) ', nmin= ' num2str(nmin)]);
subplot(2,1,2);plot(xnew,ynew(:,4));grid
title('First derivative');pause(2)
%subplot(3,1,3);errorbar(xnew,ynew(:,2),ynew(:,3));grid
end
