function ynew=smoothdiff(dados,xnew,sdx,q,nmin)
%
% function ynew=smoothdiff(dados,xnew,sdx,q,nmin)
%
% This function smooths and differentiates a sequence of numbers based on
% an algorithm similar to Savistky and Golay. There are no restrictions
% however, on the number of points or on their spacing.
% This function also calculates the first derivative at the xnew points
%
% INPUT:
% dados - data in a two column matrix (first column x; second column y)
% xnew - is a vector where new ordinates are to be computed
%
% sdx - is the range of data to be used in the interpolation
% nmin - is the minimum data points to be used in the interpolation.
% q - is the degree of the polynomial to be used in the interpolation
%
% When sdx range includes fewer points than nmin the range is
% enlarged to include at least nmin points. This occurs mainly at the edges
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


if q+1>nmin
    error('Polynomial degree should not be lower than min. no. of points');
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
    
    %TREATMENT OF END EFFECTS
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
    
    %ACTUAL CALCULATION
    [p,s,mu]=polyfit(x(JJ),y(JJ),q);
    
    %RECALCULATING VALUES USING THE FITTED POLYNOMIAL
    JJ=find (xnew>=min(x(JJ)) & xnew<=max(x(JJ)));
    
    [ynew1(JJ,2),ynew1(JJ,3)]=polyval(p,xnew(JJ),s,mu);
    ynew1(JJ,3)=ynew1(JJ,3).^2;
    ynew1(JJ,4)=polyval(polyder(p)/mu(2),xnew(JJ),[],mu);
    ynew(JJ,5)=ynew(JJ,5)+1;
    
    figure(1);plot(x,y,xnew(JJ),ynew1(JJ,2),'.');

    ynew(JJ,2)=ynew1(JJ,2)./ynew1(JJ,3)+ynew(JJ,2)./ynew(JJ,3);
    ynew(JJ,4)=ynew1(JJ,4)./ynew1(JJ,3)+ynew(JJ,4)./ynew(JJ,3);
    
    ynew(JJ,3)=1./(1./ynew1(JJ,3)+1./ynew(JJ,3));
    
    ynew(JJ,2)=ynew(JJ,2).*ynew(JJ,3);
    ynew(JJ,4)=ynew(JJ,4).*ynew(JJ,3);
            
end

ynew(:,3)=sqrt(ynew(:,3));
figure(1)
subplot(2,1,1);plot(x,y,xnew,ynew(:,2),'r');grid
title('Smoothed and Unsmoothed function');
subplot(2,1,2);plot(xnew,ynew(:,4));grid
title('First derivative');
%subplot(3,1,3);errorbar(xnew,ynew(:,2),ynew(:,3));grid
end
