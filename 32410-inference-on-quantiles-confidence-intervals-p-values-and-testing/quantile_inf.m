function [pval_or_rej,methname,CI_lo,CI_hi] = ...
    quantile_inf(X,Y,qtl,type,H0,alpha)
% QUANTILE_INF  Quantile inference based on Hutson (1999),
%    Kaplan (2011), and Kaplan and Goldman (2012).
% 
%    REJ=QUANTILE_INF(X,[],QTL,TYPE,H0,ALPHA) returns 1 if the specified
%    hypothesis test rejects the null hypothesis and 0 if it does not
%    reject.  X is a vector containing (continuous) data.  QTL is the
%    quantile, e.g. 0.5 for the median or 0.01 for the first percentile.
%    TYPE specifies one of three alternative hypotheses: 0 corresponds to
%    H1:b~=H0 (two-sided); -1 to H1:b<H0 (1-sided); 1 to H1:b>H0 (1-sided),
%    where H0 is the input parameter specified.
%    ALPHA is the nominal size (or "level") of the test, e.g. 0.05 for a 5%
%    test.
% 
%    [REJ,METHNAME]=QUANTILE_INF(...) additionally returns the name of the
%    method used: 'Hutson' for Hutson (1999), 'KaplanGoldman' for Kaplan
%    and Goldman (2012), and 'Kaplan' for Kaplan (2011).
% 
%    [REJ,METHNAME,CI_LOW,CI_HIGH]=QUANTILE_INF(...) additionally returns
%    the lower and upper endpoints of the (1-ALPHA) confidence interval
%    (e.g., ALPHA=0.05 is a 95% CI).  Note that TYPE=-1 means CI_LOW=-Inf,
%    TYPE=1 means CI_HIGH=Inf, and TYPE=0 gives a two-sided CI.
% 
%    PVAL=QUANTILE_INF(X,[],QTL,TYPE,H0,[]) alternatively returns the
%    p-value.  As before, TYPE specifies the alternative hypothesis; X, 
%    QTL, and H0 are also the same as before.
% 
%    PVAL=QUANTILE_INF(X,Y,QTL,TYPE,H0,[]) calculates the p-value for a
%    two-sample test, where X and Y are vectors of data with possibly
%    different lengths.  QTL and TYPE are the same as before.  H0 now
%    specifies the difference between the QTL-quantile of X and Y (the X
%    value minus the Y value); H0=0 tests equality of that quantile of the
%    X and Y distributions.
% 
%    [REJ,METHNAME,CI_LOW,CI_HIGH]=QUANTILE_INF(X,Y,QTL,TYPE,H0,ALPHA)
%    returns REJ=1 when the level-ALPHA two-sample hypothesis test rejects
%    and REJ=0 when it does not reject, along with the corresponding
%    confidence interval endpoints and the method name.  The difference
%    with the one-sample case is that instead of testing whether the
%    quantile of X is equal to H0, it is the difference between the
%    quantile of X and Y (QTL-quantile of X minus QTL-quantile of Y) being
%    tested for equality to H0.
% 
% Example: calculate one-sample 2-sided p-value from simulated normal data
% under correct null hypothesis.  Note that under null, p-values will have
% Uniform(0,1) distribution.
%    F='norm'; par1=0; par2=1;  n=21;  p=0.9;
%    data = icdf(F,rand(n,1),par1,par2);
%    [pval,methodname] = quantile_inf(data,[],p,0,icdf(F,p,par1,par2),[])
% 
% Example: calculate one-sample 2-sided 95% CI (and null rejection) from
% simulated normal data under correct null hypothesis.  Note that test
% should still reject a fraction alpha of the time in this case; true value
% should be included in CI (1-alpha) fraction of the time.  Also note that
% for n=21, Hutson equal-tail method can be used for .17<=p<=0.83, Kaplan
% used when further into tails.
%    F='norm'; par1=0; par2=1;  n=21;  p=0.85;  alpha=0.05;
%    data = icdf(F,rand(n,1),par1,par2);
%    [rej,mname,CI_low,CI_high] = ...
%           quantile_inf(data,[],p,0,icdf(F,p,par1,par2),alpha)
% 
% Example: calculate one-sample 1-sided 95% CI (and null rejection) from
% simulated normal data under correct null hypothesis.  With TYPE=1, the
% upper end of the CI is infinity (Inf).
%    F='norm'; par1=0; par2=1;  n=21;  p=0.9;  alpha=0.05;  sidetype=1;
%    data = icdf(F,rand(n,1),par1,par2);
%    [rej,mname,CI_low,CI_high] = ...
%       quantile_inf(data,[],p,sidetype,icdf(F,p,par1,par2),alpha)
% 
% Example: calculate two-sample 2-sided 95% CI (and null rejection) from
% simulated normal data under correct null hypothesis.
%    F='norm'; par1=0; par2=1;  n=21;  p=0.85;  alpha=0.05;  sidetype=0;
%    data = icdf(F,rand(n,2),par1,par2);
%    [rej,mname,CI_low,CI_high] = ...
%       quantile_inf(data(:,1),data(:,2),p,sidetype,0,alpha)
% 
% Coded by: David M. Kaplan, dkaplan@alumni.princeton.edu
% References:
% 'Calculating nonparametric confidence intervals for quantiles using
%  fractional order statistics' by Alan D. 
%  <a href="matlab:web('http://dx.doi.org/10.1080/02664769922458')">Hutson, 1999</a>.
% 'Improved One- and Two-sample Population Quantile Inference via 
%  Fixed-smoothing Asymptotics and Edgeworth Expansion' by David M. 
%  <a href="matlab:web('http://econ.ucsd.edu/~dkaplan/personalResearch.html')">Kaplan, 2011</a>.
% 'Two-sample nonparametric quantile inference using fractional order
%  statistics' by <a href="matlab:web('http://econ.ucsd.edu/~dkaplan/personalResearch.html')">David M. Kaplan</a>
%  and <a href="matlab:web('http://econ.ucsd.edu/~mrgoldman/research.html')">Matt Goldman</a>, 2012.
% 
% See also QUANTILE

%% Check arguments: ERRORS
% nargin: includes empty inputs []
% nargout: includes ~ outputs
if nargin<5
    error(['Need at least 5 inputs: X, Y (can be empty, []), QTL, '...
           'TYPE, and either H0 or ALPHA.']);
elseif nargin>6
    warning('MATLAB:quantile_inf:NumInputs', ...
            'Only 5 or 6 inputs supported; ignoring seventh onward.');
elseif nargin==5 && nargout>2
    error(['Need ALPHA (sixth input arg) to get confidence interval;'...
           ' with only five inputs, only one output (p-value) is'...
           ' returned, along with METHNAME.']);
elseif isempty(H0)
    error(['Even if PVAL_OR_REJ is not needed, please specify H0=0 instead' ...
           ' of H0=[].']);
end
if ~isnumeric(X) || ~isnumeric(Y) || ~isnumeric(qtl) ...
        || ~isnumeric(type) || ~isnumeric(H0) ...
        || (exist('alpha','var') && ~isnumeric(alpha))
    error('All inputs must be numeric types.  [] is numeric.');
end
%
if qtl<0 || qtl>1
    error('QTL must be between 0 and 1; e.g., 0.5 for the median.');
elseif qtl<1/size(X,1) || qtl>=1-1/size(X,1)
    error(['For this function, 1/n<=quantile<1-1/n is required.  '...
           'For values nearer to 0 or 1, '...
           'use methods based on extreme value theory.']);
elseif min(size(X))>1 || min(size(Y))>1
    error('X and Y must be vectors (one-dimensional)');
elseif ~isempty(H0) && ~isequal(size(H0),[1,1])
    error(['H0 must either be empty (for computing only confidence' ...
           ' interval) or scalar (for hypothesis test).']);
elseif type~=-1 && type~=0 && type~=1
    error(['TYPE must be one of three values: 0 for two-sided inference;'...
           ' -1 for one-sided with alternative hypothesis H1:xi<xi_0'...
           ' where confidence interval is of form (-Inf,b];'...
           ' and 1 for one-sided with alternative hypothesis H1:xi>xi_0'...
           ' where confidence interval is of form [a,Inf).']);
elseif type~=0 && exist('alpha','var') && ~isempty(alpha) && alpha>=0.5
    error(['ALPHA must be less than 0.5 for one-sided inference.']);
end

%% Check arguments: WARNINGS
if alpha>0.2
    warning('MATLAB:quantile_inf:UnusualAlpha',...
           ['ALPHA is usually 0.01, 0.05, or 0.10; e.g., 0.05 gives'...
             ' a test with significance level (nominal size) 5%,'...
             ' or a 95% confidence interval.']);
end


%% Call appropriate subroutine
nx=length(X);  %sample size for X
X=sort(X);  %sorted so that X(i) is order statistic i
PDFMIN=1e-4; %avoid dividing by zero for 2-sample Hutson
EXT=false; %for 2-sided 1-sample Hutson, don't extend (keep equal-tail)
if EXT, TMIN=0.02; else TMIN=1/2; end;
Hutopts = optimset('fmincon'); %options for calling fmincon later
Hutopts = optimset(Hutopts,'Display','off','Algorithm','sqp');
%
if isempty(Y) %one-sample
  if     type==  0   %two-sided
    if ~exist('alpha','var') || isempty(alpha)  %calculate p-value -->
        %what is smallest alpha that Hutson can do?
        %does Hut reject for this smallest alpha?
        U1MIN = 1/(nx+1); %smallest possible u1 for Hutson method
        U2MIN = (nx-.01)/(nx+1); %smallest possible u2
        p1    = betainc(qtl,1,nx);
        p2    = betainc(qtl,(nx+1)*U2MIN,(nx+1)*(1-U2MIN));
        %want to min alpha s.t. t*a>=p2 and 1-(1-t)*a<=p1, so try to set
        %p2/t=(1-p1)/(1-t) and solve for t (tmp):
        tmp   = p2/(1-p1+p2);
        if tmp<TMIN %qtl much closer to min than max
            t=TMIN; %starts to be inaccurate <0.01 (TMIN to be safe)
            alphamin=(1-p1)/(1-t); %solve for alpha given t, p1
            %and in turn solve for Hutu2
            fun8a = @(x2) (betainc(qtl,(nx+1)*x2,(nx+1)*(1-x2)) - t*alphamin)^2;
            u20=icdf('beta',1-alphamin*t,(nx+1)*qtl,(nx+1)*(1-qtl)); 
            Hutu2 = fmincon(fun8a,u20,[],[],[],[],0,1,[],Hutopts);
            Hutu1=U1MIN;
        elseif tmp>1-TMIN %similar to "if" but now qtl much closer to max
            t=1-TMIN;
            alphamin=p2/t;
            fun7b = @(x1) (betainc(qtl,(nx+1)*x1,(nx+1)*(1-x1)) ...
                           - (1-alphamin*(1-t)))^2;
            u10=icdf('beta',(1-t)*alphamin,(nx+1)*qtl,(nx+1)*(1-qtl)); 
            Hutu1 = fmincon(fun7b,u10,[],[],[],[],0,1,[],Hutopts);
            Hutu2 = U2MIN;
        else
            t=tmp; Hutu1=U1MIN; Hutu2=U2MIN; alphamin=p2/t; %p2/t=(1-p1)/(1-t)
        end
        %does Hut reject for this smallest alpha?
        %Use Hutson (1999) interpolated order statistics
        Hutepsilon1 = (nx+1)*Hutu1-floor((nx+1)*Hutu1);
        Hutepsilon2 = (nx+1)*Hutu2-floor((nx+1)*Hutu2);
        Clo = (1-Hutepsilon1)*X(max(1,floor((nx+1)*Hutu1)))...
              +Hutepsilon1*X(max(1,floor((nx+1)*Hutu1)+1));
        Chi = (1-Hutepsilon2)*X(min(nx,floor((nx+1)*Hutu2)))...
              +Hutepsilon2*X(min(nx,floor((nx+1)*Hutu2)+1));
        minrej = (H0<Clo || H0>Chi);
        if minrej==1 %if yes-->Kaplan-p-val w/ gridmax=smallestAlpha
            methname='Kaplan';
            pval_or_rej = sub_pval_1s_Kaplan(X,qtl,type,H0,alphamin);
        else         %if not-->Hut-p-val w/ gridmin=smallestAlpha
            methname='Hutson';
            Huteps=(nx+1)*qtl-floor((nx+1)*qtl);
            %depending which side of qtl H0 is on, only keep track of one
            %  CI endpoint.
            if (1-Huteps)*X(floor((nx+1)*qtl))+Huteps*X(1+floor((nx+1)*qtl))<H0
                pval_or_rej = sub_pval_1s_Hutson(X,qtl,-1,H0,alphamin)*2;
            else
                pval_or_rej = sub_pval_1s_Hutson(X,qtl, 1,H0,alphamin)*2;
            end
        end
        pval_or_rej=max(0,min(1,pval_or_rej));  return;
    else %reject; maybe CI also
      %check if running out of room on lower end (if ta<1/2) or upper end
      %  (tb>1/2).  Note TMIN=1/2 unless using extension.
      fun7a = @(t) (betainc(qtl,1,nx) - (1-alpha*(1-t)))^2;
      ta = fmincon(fun7a,1/2,[],[],[],[],-2,2,[],Hutopts);
      Hutu2=(nx-.01)/(nx+1);
      fun8b = @(t) (betainc(qtl,(nx+1)*Hutu2,(nx+1)*(1-Hutu2)) - t*alpha)^2;
      tb = fmincon(fun8b,1/2,[],[],[],[],-2,2,[],Hutopts);
      if ta<TMIN || tb>(1-TMIN), methname='Kaplan'; else methname='Hutson'; end;
      eval(['[pval_or_rej,CI_lo,CI_hi] = ' ... %call subroutine w/ methname
            'sub_rejCI_1s_' methname '(X,qtl,type,H0,alpha,[]);']);
      return;
    end
    
  elseif type== -1   %one-sided lower (H1:xi<xi_0)
    if ~exist('alpha','var') || isempty(alpha) %p-value
        if X(1)<=H0 && H0<=X(end) %H0 is within sample range, can use Hut
            methname='Hutson';
            Huteps=(nx+1)*qtl-floor((nx+1)*qtl);
            if H0<(1-Huteps)*X(floor((nx+1)*qtl))+Huteps*X(1+floor((nx+1)*qtl))
                pval_or_rej = 1 - sub_pval_1s_Hutson(X,qtl, 1 ,H0,[]);
            else
                pval_or_rej = sub_pval_1s_Hutson(X,qtl, -1 ,H0,[]);
            end
            return;
        else %Kaplan; unless constrained Hutson is smaller p-value
          if H0<X(1) %calc type==1 p-values, subtract from 1
            fun7 = @(a) (betainc(qtl,1,nx) - a)^2;
            alphamin = fmincon(fun7,.1,[],[],[],[],0,1,[],Hutopts);
            methname='Kaplan';
            pval_or_rej = sub_pval_1s_Kaplan(X,qtl, 1 ,H0,alphamin);
            if pval_or_rej==alphamin, methname='Hutson'; end;
            pval_or_rej = 1-pval_or_rej;  return;
          else %H0>X(end)
            Hutu2=(nx-.01)/(nx+1);
            fun8 = @(a) (betainc(qtl,(nx+1)*Hutu2,(nx+1)*(1-Hutu2)) - a)^2;
            alphamin = fmincon(fun8,.1,[],[],[],[],0,1,[],Hutopts);
            methname='Kaplan';
            pval_or_rej = sub_pval_1s_Kaplan(X,qtl, -1 ,H0,alphamin);
            if pval_or_rej==alphamin, methname='Hutson'; end;
            return;
          end
        end
    else %calculate CI (and rejection)
      fun8 = @(x2) (betainc(qtl,(nx+1)*x2,(nx+1)*(1-x2)) - alpha)^2;
      u20=icdf('beta',1-alpha,(nx+1)*qtl,(nx+1)*(1-qtl)); 
      Hutu2 = fmincon(fun8,u20,[],[],[],[],0,1,[],Hutopts);
      if floor((nx+1)*Hutu2)+1>nx,methname='Kaplan';else methname='Hutson';end;
      eval(['[pval_or_rej,CI_lo,CI_hi] = ' ...
            'sub_rejCI_1s_' methname '(X,qtl,type,H0,alpha,Hutu2);']);
      return;
    end
    
  elseif type==  1   %one-sided upper (H1:xi>xi_0)
    if ~exist('alpha','var') || isempty(alpha) %p-value
        if X(1)<=H0 && H0<=X(end)
            methname='Hutson';
            Huteps=(nx+1)*qtl-floor((nx+1)*qtl);
            if H0<(1-Huteps)*X(floor((nx+1)*qtl))+Huteps*X(1+floor((nx+1)*qtl))
                pval_or_rej = sub_pval_1s_Hutson(X,qtl, 1 ,H0,[]);
            else
                pval_or_rej = 1 - sub_pval_1s_Hutson(X,qtl, -1 ,H0,[]);
            end
            return;
        else %Kaplan; unless constrained Hutson is smaller p-value
          if H0<X(1) %calc type==1 p-values, subtract from 1
            fun7 = @(a) (betainc(qtl,1,nx) - a)^2;
            alphamin = fmincon(fun7,.1,[],[],[],[],0,1,[],Hutopts);
            methname='Kaplan';
            pval_or_rej = sub_pval_1s_Kaplan(X,qtl, 1 ,H0,alphamin);
            if pval_or_rej==alphamin, methname='Hutson'; end;
            return;
          else %H0>X(end)
            Hutu2=(nx-.01)/(nx+1);
            fun8 = @(a) (betainc(qtl,(nx+1)*Hutu2,(nx+1)*(1-Hutu2)) - a)^2;
            alphamin = fmincon(fun8,.1,[],[],[],[],0,1,[],Hutopts);
            methname='Kaplan';
            pval_or_rej = sub_pval_1s_Kaplan(X,qtl, -1 ,H0,alphamin);
            if pval_or_rej==alphamin, methname='Hutson'; end;
            pval_or_rej = 1-pval_or_rej;  return;
          end
        end
    else %reject; maybe CI also
      fun7 = @(x1) (betainc(qtl,(nx+1)*x1,(nx+1)*(1-x1)) - (1-alpha))^2;
      u10=icdf('beta',alpha,(nx+1)*qtl,(nx+1)*(1-qtl)); 
      Hutu1 = fmincon(fun7,u10,[],[],[],[],0,1,[],Hutopts);
      if floor((nx+1)*Hutu1)<1,methname='Kaplan';else methname='Hutson';end;
      eval(['[pval_or_rej,CI_lo,CI_hi] = ' ...
            'sub_rejCI_1s_' methname '(X,qtl,type,H0,alpha,Hutu1);']);
      return;
    end
  else error('TYPE must be -1, 0, or 1. This error should have been caught already.');
  end
  
else %two-sample
  Y=sort(Y);  ny=length(Y);  %Y(j) is order statistic j now; ny sample size
  p=qtl; %p and qtl are synonymous
  if ~(~exist('alpha','var') || isempty(alpha)) %calculate alpha-tilde
    %Estimate delta & theta from Kaplan and Goldman (2012)
    xeps = (nx+1)*p-floor((nx+1)*p);
    xeval= (1-xeps)*X(max(1,floor((nx+1)*p)))...
          +xeps*X(max(1,floor((nx+1)*p)+1));
    fxest=max(PDFMIN,ksdensity(X,xeval,'kernel','epanechnikov'));
    %Note: ksdensity uses Silverman bandwidth w/ robust sigma-hat
    yeps = (ny+1)*p-floor((ny+1)*p);
    yeval= (1-yeps)*Y(max(1,floor((ny+1)*p)))...
          +yeps*Y(max(1,floor((ny+1)*p)+1));
    fyest=max(PDFMIN,ksdensity(Y,yeval,'kernel','epanechnikov'));
    delta_est = (sqrt(nx)*fxest)/(sqrt(ny)*fyest);
    thetastar_est = (1+delta_est)/sqrt(1+delta_est^2);
    alphaHut = 2*normcdf(norminv(alpha/2)/thetastar_est);
    if type~=0, alphaHut=normcdf(norminv(alpha)/thetastar_est);end;
  end
  if     type==  0   %two-sided
    if ~exist('alpha','var') || isempty(alpha) %p-value
      error(['To implement: 2-sample, 2-sided p-value calls.' ...
             '  (Can calculate your own by searching for the largest' ...
             ' ALPHA for which this hypothesis test doesn''t reject.)']);
    else %CI and rej
      %Calculate endpoints, call Hutson if valid, Kaplan or Bootstrap o/w
      warning('off','MATLAB:quantile_inf:UnusualAlpha');
      [~,mnameX,CIlx,CIux] = quantile_inf(X,[],qtl,type,0,alphaHut);
      [~,mnameY,CIly,CIuy] = quantile_inf(Y,[],qtl,type,0,alphaHut);
      warning('on','MATLAB:quantile_inf:UnusualAlpha');
      if strcmp(mnameX,'Hutson') && strcmp(mnameY,'Hutson')
          %Both 1-sample CIs (for X and Y, level alphaHut) were computable
          %using Hutson (1999), so proceed with Kaplan-Goldman approach.
          methname='KaplanGoldman';
          CI_lo = CIlx-CIuy;    CI_hi = CIux-CIly;
          pval_or_rej = (H0<CI_lo || H0>CI_hi);
          return;
      elseif abs((nx-ny)/nx)<.05 %If sample sizes similar, use Kaplan 2011
          methname='Kaplan';
          [pval_or_rej,CI_lo,CI_hi] = sub_CIrej_2s_Kaplan(X,Y,qtl,type,H0,alpha);
          return;
      else %in simulations, the bootstrap percentile-t also worked well
          methname='bootstrap-perc-t';
          [pval_or_rej,CI_lo,CI_hi] = sub_CIrej_2s_BSt(X,Y,qtl,type,H0,alpha);
          return;
      end
    end
  elseif type== -1   %one-sided lower (H1:xi<xi_0)
      error(['Not yet implemented: 2-sample, 1-sided-lower calls.' ...
             '  Try 2-sided with 2*alpha.']);
  elseif type==  1   %one-sided upper (H1:xi>xi_0)
      error(['Not yet implemented: 2-sample, 1-sided-upper calls.' ...
             '  Try 2-sided with 2*alpha.']);
  else error('TYPE must be -1, 0, or 1. This error should have been caught already.');
  end
end
return;
end %of function


%% One-sample null rejection and CI, Hutson
function [rej,CI_lo,CI_hi] = sub_rejCI_1s_Hutson(X,qtl,type,H0,alpha,Hutu)
    %Assume: X already sorted (ascending)
    Hutopts = optimset('fmincon');
    Hutopts = optimset(Hutopts,'Display','off','Algorithm','sqp');
    n=length(X);  
    if type==-1 %one-sided "lower"
        CI_lo=-Inf;
        if isempty(Hutu)
            fun8 = @(x2) (betainc(qtl,(n+1)*x2,(n+1)*(1-x2)) - alpha)^2;
            u20=icdf('beta',1-alpha,(n+1)*qtl,(n+1)*(1-qtl)); 
            Hutu2 = fmincon(fun8,u20,[],[],[],[],0,1,[],Hutopts);
        else Hutu2=Hutu;
        end
    elseif type==1 %one-sided "upper"
        CI_hi=Inf;
        if isempty(Hutu)
          fun7 = @(x1) (betainc(qtl,(n+1)*x1,(n+1)*(1-x1)) - (1-alpha))^2;
          u10=icdf('beta',alpha,(n+1)*qtl,(n+1)*(1-qtl)); 
          Hutu1 = fmincon(fun7,u10,[],[],[],[],0,1,[],Hutopts);
        else Hutu1=Hutu;
        end
    end
    if type==0 %calculate Hutu1,Hutu2; already done for 1-sided
      t=(type+1)/2; %just 1/2 when type==0
      %Proceed with two-sided Hutson (1999) CI
      fun7 = @(x1) (betainc(qtl,(n+1)*x1,(n+1)*(1-x1)) - (1-alpha*(1-t)))^2;
      fun8 = @(x2) (betainc(qtl,(n+1)*x2,(n+1)*(1-x2)) - t*alpha)^2;
      u10=icdf('beta',alpha*(1-t),(n+1)*qtl,(n+1)*(1-qtl)); 
      u20=icdf('beta',1-alpha*t,(n+1)*qtl,(n+1)*(1-qtl)); 
      if type>=0, Hutu1 = fmincon(fun7,u10,[],[],[],[],0,1,[],Hutopts);end;
      if type<=0, Hutu2 = fmincon(fun8,u20,[],[],[],[],0,1,[],Hutopts);end;
      %IF TOO BIG/SMALL, TRY TO ADJUST.  If EXT=false in the main function,
      %this will never be necessary.
      if floor((n+1)*Hutu1)<1  && type==0
        %Ran out of room at lower end of sample.  Instead of equal-tail
        %test, shift more probability mass to lower tail.  Calculate how
        %much is needed if CI_lo=min(X), and adjust CI_hi accordingly.
        Hutu1=1/(n+1);
        fun7a = @(t) (betainc(qtl,1,n) - (1-alpha*(1-t)))^2;
        t = fmincon(fun7a,1/2,[],[],[],[],0,1,[],Hutopts);
        fun8a = @(x2) (betainc(qtl,(n+1)*x2,(n+1)*(1-x2)) - t*alpha)^2;
        u20=icdf('beta',1-alpha*t,(n+1)*qtl,(n+1)*(1-qtl));
        Hutu2 = fmincon(fun8a,u20,[],[],[],[],0,1,[],Hutopts);
      elseif floor((n+1)*Hutu2)+1>n  && type==0
        %Similar to above, but ran out of room at max of sample.
        Hutu2=(n-.01)/(n+1);
        fun8b = @(t) (betainc(qtl,(n+1)*Hutu2,(n+1)*(1-Hutu2)) - t*alpha)^2;
        t = fmincon(fun8b,1/2,[],[],[],[],0,1,[],Hutopts);
        fun7b = @(x1) (betainc(qtl,(n+1)*x1,(n+1)*(1-x1)) - (1-alpha*(1-t)))^2;
        u10=icdf('beta',alpha*(1-t),(n+1)*qtl,(n+1)*(1-qtl)); 
        Hutu1 = fmincon(fun7b,u10,[],[],[],[],0,1,[],Hutopts);
      end
    end
    %
    %Calculate the linearly interpolated fractional order statistics.
    if type>=0, Hutepsilon1 = (n+1)*Hutu1-floor((n+1)*Hutu1); end;
    if type<=0, Hutepsilon2 = (n+1)*Hutu2-floor((n+1)*Hutu2); end;
    if type>=0
      CI_lo = (1-Hutepsilon1)*X(max(1,floor((n+1)*Hutu1)))...
              +Hutepsilon1*X(max(1,floor((n+1)*Hutu1)+1));
    end
    if type<=0
      CI_hi = (1-Hutepsilon2)*X(min(n,floor((n+1)*Hutu2)))...
              +Hutepsilon2*X(min(n,floor((n+1)*Hutu2)+1));
    end
    if isempty(H0), rej=[]; else rej=(H0<CI_lo || H0>CI_hi); end;
    return;
end


%% One-sample null rejection and CI, Kaplan (2011)
function [rej,CI_lo,CI_hi,m] = sub_rejCI_1s_Kaplan(X,qtl,type,H0,alpha,~)
    %Load critical values simulated ahead of time for small values of m.
    [simalphas,~,simCVs_uni] = sub_simcv();
    %Initialize depending on type.
    if type==-1,    CI_lo=-Inf; zz = norminv(1-alpha,0,1);
    elseif type==1, CI_hi=Inf;  zz = norminv(alpha,0,1);
    elseif type==0,             zz = norminv(1-alpha/2,0,1);
    else error('TYPE can only be -1, 0, or 1.');
    end
    nx = length(X);    sqrtnx = sqrt(nx);     sqrtp1p = sqrt(qtl*(1-qtl));
    rx = floor(nx*qtl)+1;  %order statistic index for the sample quantile
    Xnr = X(rx);  %order statistic, and estimator of quantile
    mmax = min([rx-1,nx-rx]);      %smoothing parameter m can't be larger than this
    if mmax<1, error('Can''t have QTL as close to zero or one as %4.2f is for n=%d',qtl,nx); end;
    %
    localpwr = 0.5; %1st-order power of alternative against which to max power
    C = fzero(@(x) normcdf(x+zz,0,1)-normcdf(x-zz,0,1)-(1-localpwr),1); 
    m=nx^(2/3)*(C*zz)^(1/3)*(3/4)^(1/3)...
      *(((normpdf(norminv(qtl)))^2)/(2*(norminv(qtl))^2+1))^(1/3)...
      *((normpdf(zz-C)-normpdf(zz+C))/(normpdf(zz-C)+normpdf(zz+C)))^(1/3);
    m = max(1,min(mmax,floor(m))); %make sure not <1 or >mmax
    Smn = (nx/(2*m)) * (X(rx+m)-X(rx-m));  %SBG sparsity estimator
    ccv = abs(zz + (zz^3)/(4*m));  %+ (zz^5+8*zz^3)/(96*m^2); %2nd-order works fine, no need for 3rd-order
      %use absolute value; eqn holds for 1- or 2-sided (TYPE=-1,0,1)
   if m<=size(simCVs_uni,1); %For small m, ccv approx is inaccurate=>use simulated ccv
    if type~=0, alpha=2*alpha; end;
    if sum(simalphas==alpha)>0
      ccv = simCVs_uni(m,simalphas==alpha); 
    else
      %INTERPOLATE BTWN CONSECUTIVE ALPHAS
      tmp = find(simalphas>=alpha,1);
      if alpha>max(simalphas)
          ccv=simCVs_uni(m,end);
      elseif alpha<min(simalphas)
          ccv=simCVs_uni(m,1);
      else
          tmp2=(simalphas(tmp)-alpha)/(simalphas(tmp)-simalphas(tmp-1));
          ccv = tmp2*simCVs_uni(m,tmp-1) + (1-tmp2)*simCVs_uni(m,tmp);
      end
    end
   end
   %
   %Usual calculation of CI endpoints given critical value & std error.
   if type>=0, CI_lo = Xnr - ccv*Smn*sqrtp1p/sqrtnx; end;
   if type<=0, CI_hi = Xnr + ccv*Smn*sqrtp1p/sqrtnx; end;
   if isempty(H0), rej=[];  else rej=(H0<CI_lo || H0>CI_hi); end;
   return;
end


%% Two-sample CI and null rejection, Kaplan (2011)
function [rej,CI_lo,CI_hi] = sub_CIrej_2s_Kaplan(X,Y,qtl,type,H0,alpha)
    %Assume: X and Y already sorted (ascending)
    PDFMIN=1e-4; %Make sure don't divide by zero later.
    [simalphas,simCVs_bi,simCVs_uni] = sub_simcv(); %Load simulated critical values.
    nx=length(X); ny=length(Y);  rx=floor(nx*qtl)+1; ry=floor(ny*qtl)+1;
    Xnr=X(rx); Ynr=Y(ry); %sample quantiles for X, Y
    sqrtp1p=sqrt(qtl*(1-qtl));  sqrtnx=sqrt(nx);  %sqrtny=sqrt(ny);
    zz = norminv(1-alpha/2,0,1);  %standard normal critical value, 2-sided
    localpwr = 0.5; %1st-order power of alternative against which to max power
    C = fzero(@(x) normcdf(x+zz,0,1)-normcdf(x-zz,0,1)-(1-localpwr),1); 
    if type~=0, zz=norminv(1-alpha,0,1); end;
    %
    xeval=X(rx);  yeval=Y(ry); %where to evaluate PDFs when calculating theta
    %Note: ksdensity uses Silverman bandwidth w/ robust sigma-hat
    fxest=max(PDFMIN,ksdensity(X,xeval,'kernel','epanechnikov'));
    fyest=max(PDFMIN,ksdensity(Y,yeval,'kernel','epanechnikov'));
    theta_est = (fxest^(-2)+(nx/ny)*fyest^(-2))^(-2) * (fxest^(-4)+(nx^2/ny^2)*fyest^(-4));
    mmax = min(min(rx-1,nx-rx),min(ry-1,ny-ry)); 
    m = max(nx,ny)^(2/3)*(3/4)^(1/3)... 
        *((1-theta_est)+theta_est*(C*zz)*(normpdf(zz-C)-normpdf(zz+C)) ...
                        /(normpdf(zz-C)+normpdf(zz+C)))^(1/3) ...
        *(((normpdf(norminv(qtl)))^2)/(2*(norminv(qtl))^2+1))^(1/3);
    m = max(1,min(mmax,floor(m))); %make sure not <1 or >mmax
    Smn=sqrt((nx/(2*m)*(X(rx+m)-X(rx-m)))^2+(nx/ny)*(ny/(2*m)*(Y(ry+m)-Y(ry-m)))^2);
    theta_est = ...
        ((nx/(2*m)*(X(rx+m)-X(rx-m)))^4+(nx^2/ny^2)*(ny/(2*m)*(Y(ry+m)-Y(ry-m)))^4)...
        / (Smn^4) ; %shrink a little toward 1 by adding (.1+...)/(.1+...)?
    ccv = abs(zz + (theta_est*zz^3-(1-theta_est)*zz)/(4*m));
    %Again, if m is small, more accurate to use simulated critical values.
    if m<=size(simCVs_uni,1);
      if type~=0, alpha=2*alpha; end;
      tmpw1=2*theta_est-1; tmpw2=2-2*theta_est; %weight btwn uni and "bi" sim'd ccvs
      %remember theta is between 1/2 and 1, hence not just tmpw1=theta
      if sum(simalphas==alpha)>0
         ccv = tmpw1*simCVs_uni(m,simalphas==alpha) ...
               +tmpw2*simCVs_bi(m,simalphas==alpha) ; %now vector, nreplic x 1
      else
         %INTERPOLATE BTWN CONSECUTIVE ALPHAS
         tmp = find(simalphas>=alpha,1);
         if alpha>max(simalphas)
             ccv = tmpw1*simCVs_uni(m,end) ...
                   +tmpw2*simCVs_bi(m,end);
         elseif alpha<min(simalphas)
             ccv = tmpw1*simCVs_uni(m,1)...
                   +tmpw2*simCVs_bi(m,1);
         else
             tmp2=(simalphas(tmp)-alpha)/(simalphas(tmp)-simalphas(tmp-1));
             ccv = tmpw1*(tmp2*simCVs_uni(m,tmp-1) + (1-tmp2)*simCVs_uni(m,tmp))...
                   +tmpw2*(tmp2*simCVs_bi(m,tmp-1) + (1-tmp2)*simCVs_bi(m,tmp));
         end
      end
    end
   %
   %Usual CI endpoint calculation based on critical value, std error.
   CI_lo=-Inf; CI_hi=Inf;
   if type>=0, CI_lo = Xnr-Ynr - ccv*Smn*sqrtp1p/sqrtnx; end;
   if type<=0, CI_hi = Xnr-Ynr + ccv*Smn*sqrtp1p/sqrtnx; end;
   if isempty(H0), rej=[];  else rej=(H0<CI_lo || H0>CI_hi); end;
   return;
end


%% Two-sample CI and null rejection, bootstrap percentile-t
function [rej,CI_lo,CI_hi] = sub_CIrej_2s_BSt(X,Y,qtl,type,H0,alpha)
    BREP1=99;  BREP2=100; %Kaplan (2011) found these best in simulations.
    %BREP1 is outer replications, BREP2 is for calculating std deviation.
    nx=length(X); ny=length(Y); sqrtnx=sqrt(nx); %sqrtp1p=sqrt(qtl*(1-qtl));
    rx=floor(nx*qtl)+1; ry=floor(ny*qtl)+1;  
    Xnr=X(rx); Ynr=Y(ry); %Sample quantiles for X and Y. Could also use quantile(X,qtl).
    %
    T0stub = sqrtnx*(Xnr-Ynr) ; %Test statistic "stub"
    %Use bootstrap to calculate standard error, to Studentize test
    %  statistic with.
    diffstars2=zeros(BREP2,1);
    for iBS2=1:BREP2
        starindx2 =randi(nx,nx,1); %from uniform integers 1:n, nx1 mtx
        starindy2 =randi(ny,ny,1); %from uniform integers 1:n, nx1 mtx
        Xstar2 = X(starindx2);        Ystar2 = Y(starindy2);
        Xstarsort2 = sort(Xstar2);    Ystarsort2 = sort(Ystar2);
        Xnrstar2 = Xstarsort2(rx);     Ynrstar2 = Ystarsort2(ry);
        diffstars2(iBS2) = Xnrstar2-Ynrstar2;
    end
    stdstar=std(sqrtnx*diffstars2);
    if BREP2==0,  stdstar = 1; end;
    BST0 = T0stub / stdstar ;   %This is the test statistic.
    %
    %Now bootstrap to get dist'n of (pivotal) test statistic.
    Tstars=zeros(BREP1,1);
    for iBS=1:BREP1
        starindx = randi(nx,nx,1); %from uniform integers 1:n, nx1 mtx
        starindy = randi(ny,ny,1); %from uniform integers 1:n, nx1 mtx
        Xstar = X(starindx);        Ystar = Y(starindy);
        Xstarsort = sort(Xstar);    Ystarsort = sort(Ystar);
        Xnrstar = Xstarsort(rx);     Ynrstar = Ystarsort(ry);
        diffstars2=zeros(BREP2,1);
        for iBS2=1:BREP2
            starindx2 =randi(nx,nx,1); %from uniform integers 1:n, nx1 mtx
            starindy2 =randi(ny,ny,1); %from uniform integers 1:n, nx1 mtx
            Xstar2 = Xstar(starindx2);       Ystar2 = Ystar(starindy2);
            Xstarsort2 = sort(Xstar2);       Ystarsort2 = sort(Ystar2);
            Xnrsort2 = Xstarsort2(rx);        Ynrsort2 = Ystarsort2(ry);
            diffstars2(iBS2) = Xnrsort2-Ynrsort2;
        end
        stdstar=std(sqrtnx*diffstars2);
        if BREP2==0,   stdstar=1;  end;
        Tstars(iBS) = sqrtnx*((Xnrstar-Ynrstar)-(Xnr-Ynr))/(stdstar); 
    end
    %
    %Take critical value from bootstrap distribution.
    Tstars_abssort = sort(abs(Tstars)); Tstars_sort = sort(Tstars);
    if type==0, cv=Tstars_abssort(1+floor((1-alpha)*BREP1)); %symmetric performs best for 2-sided
    elseif type==-1, cv=Tstars_sort(1+floor(alpha*BREP1));
    elseif type== 1, cv=Tstars_sort(1+floor((1-alpha)*BREP1));
    end
    %
    %Usual CI endpoint calculation given critical value and std error.
    CI_lo=-Inf; CI_hi=Inf;
    if type>=0, CI_lo = Xnr-Ynr - cv*stdstar/sqrtnx; end;
    if type<=0, CI_hi = Xnr-Ynr + cv*stdstar/sqrtnx; end;
    if isempty(H0), rej=[];  else rej=(H0<CI_lo || H0>CI_hi); end;
    return;
end


%% One-sample p-value, Hutson
function pval = sub_pval_1s_Hutson(X,qtl,type,H0,alphamin)
    % Assume: X already sorted
    % Assume: Hut already failed to reject with alphamin => pval>alphamin
    % Assume: if 1-sided, H0 on relevant side of Xnr
    Hutopts = optimset('fmincon');
    Hutopts = optimset(Hutopts,'Display','off','Algorithm','sqp');
    n=length(X);
    %Reverse-solve for value of alpha that makes H0 exactly
    %  coincide with an endpoint of the CI.  Which endpoint depends on type
    if type==-1
        tmp=find(X>H0,1);  
        Huteps = (H0-X(tmp-1))/(X(tmp)-X(tmp-1));
        Hutu2 = (tmp-1+Huteps)/(n+1);
        fun8 = @(a) (betainc(qtl,(n+1)*Hutu2,(n+1)*(1-Hutu2)) - a)^2;
        pval = fmincon(fun8,mean([repmat(alphamin,1,9),.1]),[],[],[],[],0,1,[],Hutopts);
    elseif type==1
        tmp=find(X>H0,1);  
        Huteps = (H0-X(tmp-1))/(X(tmp)-X(tmp-1));
        Hutu1 = (tmp-1+Huteps)/(n+1);
        fun7 = @(a) (betainc(qtl,(n+1)*Hutu1,(n+1)*(1-Hutu1)) - (1-a))^2;
        pval = fmincon(fun7,mean([repmat(alphamin,1,9),.1]),[],[],[],[],0,1,[],Hutopts);
    else
        error('Type should be -1 or 1 for sub_pval_1s_Hutson');
    end
    return;
end


%% One-sample p-value, Kaplan (2011)
function pval = sub_pval_1s_Kaplan(X,qtl,type,H0,alphamin)
    %Assume: Hutson (1999) rejected H0 at level alphamin
    %Assume: X sorted (ascending)
    %Try alphamin first: if don't reject, return alphamin (rejected w/ Hut)
    if sub_rejCI_1s_Kaplan(X,qtl,type,H0,alphamin,[])==0,pval=alphamin;return;end;
    if alphamin<0.002, pval=alphamin;return;end;
    %
    %Global search for p-val<alphamin, largest such that do not reject test
    gridstart=0.001;
    %note: in Matlab, && stops evaluating if first false, so this is efficient.
    if sub_rejCI_1s_Kaplan(X,qtl,type,H0,gridstart,[])==1 && ...
            (alphamin>=0.01 && sub_rejCI_1s_Kaplan(X,qtl,type,H0,0.01,[])==1) && ...
            (alphamin>=0.05 && sub_rejCI_1s_Kaplan(X,qtl,type,H0,0.05,[])==1)
        pval = gridstart;
        return;
    end
    pregrid=.05:.05:alphamin; %Start w/ coarser grid.
    for i=1:length(pregrid)
        if sub_rejCI_1s_Kaplan(X,qtl,type,H0,pregrid(i),[])==0
            gridstart=pregrid(i);
        end
    end
    grid = gridstart:0.001:alphamin;  %Now use finer grid. Hopefully gridstart is close to alphamin.
    max_norej=gridstart; cur_rej_m=[]; rej_flag=0;
    for i=1:length(grid)
        [rej,~,~,m] = sub_rejCI_1s_Kaplan(X,qtl,type,H0,grid(i),[]);
        if rej==0,  max_norej=grid(i); rej_flag=0;
        else
            if rej_flag==1 && cur_rej_m~=m, pval=max_norej; return; end;
            rej_flag=1; cur_rej_m=m;
        end
    end
    pval=max_norej;    return;
end


%% Pre-calculated simulated critical values from Kaplan (2011)
function [simalphas,simCVs_bi,simCVs_uni] = sub_simcv()
simalphas = [0.001,0.002,0.003,0.004,0.005,0.006,0.007,0.008,0.009,...
             0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.11,0.12,...
             0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.2,0.21,0.22,0.23,0.24,...
             0.25,0.26,0.27,0.28,0.29,0.3,0.31,0.32,0.33,0.34,0.35,0.36,...
             0.37,0.38,0.39,0.4,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48,...
             0.49,0.5,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,0.59,0.6,...
             0.61,0.62,0.63,0.64,0.65,0.66,0.67,0.68,0.69,0.7,0.71,0.72,...
             0.73,0.74,0.75,0.76,0.77,0.78,0.79,0.8,0.81,0.82,0.83,0.84,...
             0.85,0.86,0.87,0.88,0.89,0.9,0.91,0.92,0.93,0.94,0.95,0.96,...
             0.97,0.98,0.99];
simCVs_bi = zeros(2,length(simalphas));
simCVs_bi(1,:) =...
   [10.9435,8.8905,7.8981,7.2232,6.7377,6.351,6.0229,5.7584,...
    5.5418,5.3417,4.1981,3.6015,3.2189,2.9354,2.714,2.535,2.3849,2.2609,...
    2.149,2.0503,1.9611,1.8804,1.8057,1.7389,1.6765,1.6177,1.5631,...
    1.5123,1.4647,1.4196,1.3779,1.3379,1.2998,1.2629,1.2281,1.1953,...
    1.1624,1.1308,1.1012,1.0723,1.0442,1.0169,0.99113,0.96603,0.94104,...
    0.91779,0.8943,0.8723,0.85036,0.82907,0.80833,0.7879,0.76856,...
    0.74943,0.73068,0.7125,0.69448,0.67636,0.65898,0.64175,0.62518,...
    0.60846,0.59187,0.57614,0.56043,0.54512,0.53009,0.51467,0.49973,...
    0.48494,0.47025,0.45579,0.44124,0.42726,0.4134,0.3995,0.38613,...
    0.37253,0.35938,0.34629,0.33318,0.32009,0.30725,0.29457,0.28195,...
    0.26964,0.25698,0.24456,0.23229,0.22018,0.20801,0.19615,0.18394,...
    0.17234,0.16065,0.14903,0.13742,0.12555,0.11394,0.10242,0.090718,...
    0.079071,0.067377,0.055898,0.04451,0.033114,0.021501,0.010147];
simCVs_bi(2,:) =...
   [5.9696,5.2541,4.8539,4.5537,4.3365,4.1601,4.0172,3.8932,3.7904,...
    3.6945,3.1109,2.7768,2.5495,2.3795,2.2387,2.1231,2.0241,1.9387,...
    1.8618,1.7919,1.7286,1.6696,1.6155,1.5656,1.5192,1.4756,1.4325,...
    1.3925,1.3547,1.3189,1.2847,1.2522,1.2219,1.1917,1.1633,1.1353,...
    1.1082,1.0819,1.0566,1.032,1.0086,0.98543,0.96225,0.94023,0.91818,...
    0.89684,0.87671,0.85666,0.83658,0.81765,0.79923,0.78084,0.76276,...
    0.74445,0.72695,0.70947,0.69251,0.67591,0.65949,0.64369,0.62773,...
    0.6121,0.59668,0.58137,0.56623,0.55174,0.53661,0.52165,0.50672,...
    0.49258,0.47876,0.46438,0.45022,0.43646,0.42261,0.40875,0.39521,...
    0.38141,0.36817,0.35498,0.34185,0.3288,0.31576,0.30296,0.29003,...
    0.27721,0.26461,0.25188,0.23945,0.2274,0.21519,0.20266,0.19044,...
    0.17843,0.16643,0.15419,0.14254,0.13036,0.11814,0.10607,0.094184,...
    0.08209,0.069939,0.057994,0.046069,0.034169,0.0224,0.010453];
simCVs_uni = zeros(2,length(simalphas));
simCVs_uni(1,:) = ...
[44.8943,31.1802,25.2111,21.6883,19.2587,17.4917,16.1646,14.8876,...
 13.9785,13.1943,8.939,7.0955,5.9917,5.226,4.6791,4.2355,3.8938,3.6012,...
 3.3534,3.1435,2.9647,2.8014,2.6569,2.5254,2.4059,2.2988,2.1986,2.1045,...
 2.0205,1.9421,1.8691,1.8022,1.7373,1.6756,1.617,1.5641,1.5122,1.4644,...
 1.4184,1.3736,1.3299,1.289,1.249,1.2112,1.1749,1.1398,1.107,1.0753,...
 1.044,1.0146,0.98538,0.95693,0.92908,0.90212,0.87608,0.85127,0.82678,...
 0.80332,0.78023,0.75758,0.7353,0.71397,0.69282,0.67244,0.65224,0.63245,...
 0.61313,0.5938,0.57494,0.55698,0.5391,0.52137,0.50417,0.4875,0.47138,...
 0.45488,0.43891,0.42298,0.40778,0.39269,0.37756,0.3624,0.34747,0.33319,...
 0.3183,0.30394,0.2894,0.27537,0.26169,0.24795,0.23425,0.22045,0.20687,...
 0.19345,0.18045,0.16714,0.15436,0.14132,0.12855,0.11578,0.1028,...
 0.090287,0.077914,0.064961,0.052481,0.040066,0.027524,0.014898];
simCVs_uni(2,:) = ...
[11.8392,9.6368,8.5465,7.7846,7.2393,6.8183,6.502,6.2144,5.9611,5.7361,...
4.531,3.8996,3.4738,3.1766,2.942,2.7496,2.5918,2.4522,2.3315,2.2232,...
2.1273,2.0418,1.9634,1.8916,1.8254,1.7632,1.7051,1.6499,1.5986,1.5497,...
1.5024,1.4595,1.4175,1.3791,1.3411,1.3046,1.27,1.2356,1.2038,1.1726,...
1.1425,1.1137,1.0863,1.059,1.0322,1.0064,0.98103,0.9573,0.93325,0.91049,...
0.88797,0.86565,0.84382,0.82256,0.80216,0.78183,0.76214,0.74232,0.72384,...
0.705,0.6862,0.66792,0.64977,0.63206,0.61481,0.598,0.58103,0.56456,...
0.54839,0.53288,0.51723,0.50117,0.4856,0.47051,0.45574,0.44051,0.42602,...
0.41153,0.39682,0.38232,0.36861,0.35478,0.34084,0.32665,0.313,0.29897,...
0.28536,0.27191,0.25866,0.24548,0.23193,0.21882,0.20566,0.19261,0.17974,...
0.16659,0.15379,0.14096,0.12814,0.11529,0.10286,0.090379,0.077713,...
0.064897,0.052336,0.040043,0.027465,0.014858];
return;
end

%% EOF