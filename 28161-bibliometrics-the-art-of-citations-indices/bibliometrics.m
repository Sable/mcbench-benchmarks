function bibliometrics(varargin)
% BIBLIOMETRICS - Compute pratically all bibliometric indices actually known.
% Actually, every researcher come to terms with his/her bibliometric
% performance. There are many software to compute these indices, like
% Publish or Perish or Google Scholar. Anyway, these softwares require an
% additional work like to identify the proper papers to exclude papers by
% authors with the same name and surname. More over, Google Scholar is not
% efficient to list all the authors of a papers (it cuts the list), so some
% metrics are inaccurate.
% So I decided to set-up this algorithm to compute these metrics without web
% data-mining.
% 
% Syntax: 	bibliometrics(C,Y,A)
%      
%     Inputs:
%           C - an array with the number of Citations of published papers
%           (mandatory). These data can be obtained using several databases
%           as ISI, Researcher ID, Google Scholar, Scopus, Citeseeker,...
%           Y - an array with the Years of publication of the papers
%           (optional). Everybody know when an own paper was published...
%           A - an array with the number of Authors of published papers.
%           Everybody know the number of co-authors of an own paper...
%     Outputs (if all vectors were given):
%           - Descriptive statistics:
%               ° Total number of papers
%               ° Total number of citations
%               ° Min, Max, Mode, Median and Mean citations per papers (with 95% confidence intervals)
%               ° Variation Coefficient (normal and adjusted)
%		° Gini's Coefficient
%               ° Years of activity, first and last year of publication
%               ° Min, Max, Mode, Median and Mean papers per year (with 95% confidence intervals)
%               ° Mean number of citations per year
%               ° Min, Max, Mode, Median and Mean Authors per paper (with 95% confidence intervals)
%               ° Citations per author
%           - Bibliometrics indices
%               ° Citations indices
%                   * Hirsch's h-index with a and m parameters, delta-h
%                   * Egghe's g-index, delta-g
%                   * Jin's A-index
%                   * Kosmulski's h2-index
%                   * Zhang's e-index
%                   * Sidiropoulos'es normalized h-Index 
%               ° Years weighted indices
%                   * Sidiropoulos'es Contemporary h-Index (hc-index)
%                   * Jin's Age weighted citation rate (AWCR) and AR-index
%                   * Harzing's Age weighted citation rate (AWCR) and AR-index
%               ° Authors weighted indices
%                   * Batista's Individual h-index (hI-index)
%                   * Harzing's Individual h-index (hI,norm-index)
%                   * Schreiber's Multi-authored h-index (hm-index)
%               ° Years and Authors weighted indices
%                   * Jin's Age weighted citation rate (AWCR) and AR-index
%                   * Harzing's Age weighted citation rate (AWCR) and AR-index
% 
%               Several plots
% 
%   Example:
%               C=[12 8 1 0 5 3 0 0];
%               Y=[2004 2007 2008 2008 2008 2009 2009 2010];
%               A=[8 9 10 7 11 11 7 5];
%               bibliometrics(C,Y,A)
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2010) Bibliometrics: the art of citations indices
% http://www.mathworks.com/matlabcentral/fileexchange/28161

args=cell(varargin);
default.values = {[];[];[]};
default.values(1:length(args)) = args;
[C,Y,A] = deal(default.values{:});
if ~isempty(C)
    if ~isvector(C) || ~all(isnumeric(C)) || ~all(isfinite(C))
        error('The Citations argument must be a numeric and finite vector')
    end
else
    error('Almost the C vector is mandatory')
end
if ~isempty(Y)
    if ~isvector(Y) || ~all(isnumeric(Y)) || ~all(isfinite(Y))
        error('The Years argument must be a numeric and finite vector')
    end
end
if ~isempty(A)
    if ~isvector(A) || ~all(isnumeric(A)) || ~all(isfinite(A))
        error('The Authors argument must be a numeric and finite vector')
    end
end
clear args default

tr=repmat('-',1,80);

disp('BIBLIOMETRICS'); disp(tr)
%Descriptive statistics
disp('Descriptive statistics'); disp(tr)
n=length(C); Ctot=sum(C); 
fprintf('Total number of papers: %i\n',n)
fprintf('Total number of citations: %i\n',Ctot)
fprintf('Min: %i -  Max: %i\n',min(C),max(C))
fprintf('Mode of citations per paper: %i\n',mode(C))
fprintf('Median of citations per paper: %0.1f\n',median(C))
if n<=20
    I=binoinv(0.05,n,0.5);
else
    I=round((n-1.96*realsqrt(n))/2);
end
fprintf('95%% confidence interval: %0.1f - %0.1f\n',C(n-I+1),C(I))
M=mean(C); D=std(C); SEM=D/sqrt(n); MCI=M+[-1 1].*1.96.*SEM; CV=D/M*100;
fprintf('Mean number of citations per paper: %0.1f\n',M)
fprintf('Standard error of mean (SEM): %0.2f\n',SEM)
fprintf('95%% confidence interval: %0.1f - %0.1f\n',MCI)
fprintf('Variation coefficient (CV): %0.2f%%\n',CV)
fprintf('Adjusted Variation coefficient (CV''): %0.2f%%\n',CV*(1+1/(4*n)))
clear M SEM MCI CV
disp(' ')
%The Lorenz Curve
[Csorted idx]=sort(C);
x=1:1:n; cC=cumsum(Csorted);
F=x./max(x);
L=cC/Ctot; 
Gcoeff=1-2*trapz(F,L);
fprintf('Gini''s coefficient: %0.2f\n',Gcoeff')
hold on
patch([0 1 1 0],[0 1 0 0],[192 192 192]./255)
patch([0 F 1 0],[0 L 0 0],'w')
Le1=plot([0 1],[0 0],'g','LineWidth',2);
plot([1 1],[0 1],'g','LineWidth',2)
Le2=plot([0 1],[0 1],'b--','LineWidth',2);
Le3=plot(F,L,'r-','LineWidth',2);
hold off
title('Lorenz curve of citations'); xlabel('% of papers'); ylabel('% of citations')
legend([Le1 Le2 Le3],'Line of perfect inequality','Line of perfect equality','Lorenz curve','Location','NorthEastOutside')
axis square
disp(tr)
if ~isempty(Y)
    Ny=(str2double(datestr(now,'yyyy'))-Y);
    %Harzing in her Publish or Perish add 1 to Ny. I don't know why. If we
    %are in 2010 and I have just published a paper in 2010 it haven't 1
    %year, but only few months....
    my=max(Ny); cty=sort(crosstab(Y)); lcty=length(cty);
    fprintf('Years: %i\n',my)
    fprintf('Years of publications\t first: %i \t last: %i\n',min(Y),max(Y))
    fprintf('Papers per year\t Min: %i \t Max: %i\n',min(cty),max(cty))
    fprintf('Mode of papers per year: %i\n',mode(cty))
    fprintf('Median of papers per year: %i\n',median(cty))
    if lcty<=20
        I=binoinv(0.05,n,0.5);
    else
        I=round((n-1.96*realsqrt(n))/2);
    end
    fprintf('95%% confidence interval: %0.1f - %0.1f\n',cty(lcty-I+1),cty(I))
    M=mean(cty); SEM=std(cty)/sqrt(lcty); MCI=M+[-1 1].*1.96.*SEM;
    fprintf('Mean number of papers per year: %0.1f\n',M)
    fprintf('Standard error of mean (SEM): %0.2f\n',SEM)
    fprintf('95%% confidence interval: %0.1f - %0.1f\n',MCI)
    disp(' ')
    fprintf('Mean number of citations per year: %0.1f\n',Ctot/my)
    disp(tr)
end
if ~isempty(A)
    fprintf('Authors\tMin: %i -  Max: %i\n',min(A),max(A))
    fprintf('Mode of Authors per paper: %i\n',mode(A))
    As=sort(A);
    fprintf('Median of Authors per paper: %0.1f\n',median(A))
    fprintf('95%% confidence interval: %0.1f - %0.1f\n',As(n-I+1),As(I))
    M=mean(A); SEM=std(A)/sqrt(n); MCI=M+[-1 1].*1.96.*SEM;
    fprintf('Mean number of Authors per paper: %0.1f\n',M)
    fprintf('Standard error of mean (SEM): %0.2f\n',SEM)
    fprintf('95%% confidence interval: %0.1f - %0.1f\n',MCI)
    clear As M SEM MCI
    disp(' ')
    fprintf('Citations per Author: %0.1f\n',sum(C./A))
    disp(tr)
end
disp(' ');

disp('Bibliometric indices'); disp(' ')
disp('Citations indices'); disp(tr)
%Hirsch, J.E. (2005) An index to quantify an individual's scientific
%research output, arXiv:physics/0508025 v5 29 Sep 2006.
%[...] The h-index is defined as follows:
%A scientist has index h if h of his/her Np papers have at least h
%citations each, and the other (Np-h) papers have no more than h citations
%each. [...] The relation between Ctot and h will depend on the detailed
%form of the particular distribution, and it is useful to define the
%proportionality constant a as Ctot=ah^2. I find empirically that a ranges 
%between 3 and 5. 
Csorted=fliplr(Csorted); idx=fliplr(idx);
Hidx=sum(Csorted>=x); H2=Hidx^2; 
fprintf('Hirsch''s h-index: %i \t a: %0.2f',Hidx,Ctot/H2)
if ~isempty(Y)
    %One way to facilitate comparisons between academics with different
    %lengths of academic careers is to divide the h-index by the number of
    %years the academic has been active (measured as the number of years
    %since the first published paper). Hirsch (2005) proposed this measure
    %and called it m.
    fprintf('\t m: %0.2f',Hidx/my)
else
    fprintf('\n')
end
%dH measures the minimum number of citations missing in order to increment
%the current h-index by 1. 
if Hidx<n
    dH=Hidx+1-Csorted(Hidx+1);
    fprintf('\tDelta-h: %i\n',dH); 
else
    fprintf('\tThis is the max possible h-index\n')
end

%Egghe, L. (2006) Theory and practice of the g-index, Scientometrics, vol.
%69, No 1, pp. 131-152.
%The g-index is defined as follows:
%[Given a set of articles] ranked in decreasing order of the number of
%citations that they received, the g-index is the (unique) largest number
%such that the top g articles received (together) at least g2 citations.
%Although the g-index has not yet attracted much attention or empirical
%verification, it would seem to be a very useful complement to the h-index. 
x2=x.^2; cC=cumsum(Csorted);
Gidx=sum(cC>=x2);
fprintf('Egghe''s g-index: %i\t',Gidx)
%dG measures the minimum number of citations missing in order to increment the
%current g-index by 1. 
if Gidx<n
    dG=(Gidx+1)^2-sum(Csorted(1:Gidx+1));
    fprintf('Delta-g: %i\n',dG); 
else
    fprintf('This is the max possible g-index\n')
end

%delta-H and delta-G should be a measure of how difficult would be for the
%author at hand to increase his/her h and g-index. Note however that the
%range of delta-h is relatively small (in the worst case, delta-h= 2h+1).
%Note that a value of delta-H equal to, e.g., 2, does not mean 2 more
%generic citations are needed for increasing the h-index, but 2 more
%citation on *particular* papers (usually the one in position h+1, and some
%other paper right in the positions previous to h+1). 

%Jin, B. H. (2006). h-Index: An evaluation indicator proposed by scientist.
%Science Focus, 1(1), 8–9.
%The A-index is the "A"verage number of citations of the papers in the
%h-core
Aidx=mean(Csorted(1:Hidx));
fprintf('Jin''s A-index: %0.2f\n',Aidx); 

%Kosmulski, M. (2006). A new Hirsch-type index saves time and works equally
%well as the original h-index. ISSI Newsletter, 2(3), 4–6.
%A scientist’s h(2) index is defined as the highest natural number such
%that his h(2) most-cited papers received each at least [h(2)]2 citations.
H2idx=sum(Csorted>=x2);
fprintf('Kosmulski''s h2-index: %i\n',H2idx);

%Zhang, C.T. The e-index, complementing the h-index for excess citations,
%PLoS ONE, Vol 5, Issue 5 (May 2009), e5429. The e-index is the square
%root of the surplus of citations in the h-set beyond h2, i.e., beyond the
%theoretical minimum required to obtain a h-index of 'h'. The aim of the
%e-index is to differentiate between scientists with similar h-indices but
%different citation patterns. 
Eidx=realsqrt(sum(Csorted(1:Hidx))-H2);
fprintf('Zhang''s e-index: %0.1f\n',Eidx);

%The Contemporary h-index was proposed by Antonis Sidiropoulos, Dimitrios
%Katsaros, and Yannis Manolopoulos in their paper Generalized h-index for
%disclosing latent facts in citation networks, arXiv:cs.DL/0607066  v1 13
%Jul 2006. It adds an age-related weighting to each cited article, giving
%(by default; this depends on the parametrization) less weight to older
%articles. The weighting is parametrized; I used gamma=4 and delta=1, like
%the authors did for their experiments. This means that for an article
%published during the current year, its citations account four times. For
%an article published 4 years ago, its citations account only one time. For
%an article published 6 years ago, its citations account 4/6 times, and so
%on.
%In the same paper the authors proposed the normalized h-index defined as
%follow: A researcher has normalized h-index hn = h/Np, if h of its Np 
%articles have received at least h citations each, and the rest (Np - h)
%articles received no more than h citations.
fprintf('Sidiropoulos''es normalized h-index: %0.2f\n',Hidx/n)
disp(tr); disp(' '); 
if ~isempty(Y)
    disp('Years weighted indices'); disp(tr)
    Ny=Ny+1; %add 1 to avoid n/0
    Sc=sort(4.*Ny.^-1.*C,'descend');
    Hcidx=sum(Sc>=x); Hc2=Hcidx^2;
    fprintf('Sidiropoulos''es Contemporary h-index (hc-index): %i \t a: %0.2f\n',Hcidx,sum(Sc)/Hc2);

%The age-weighted citation rate was inspired by Bihui Jin's note The
%AR-index: complementing the h-index, ISSI Newsletter, 2007, 3(1), p. 6.
%The AWCR measures the number of citations to an entire body of work,
%adjusted for the age of each individual paper. It is an age-weighted
%citation rate, where the number of citations to a given paper is divided
%by the age of that paper. Jin defines the AR-index as the square root of
%the sum of all age-weighted citation counts over all papers that
%contribute to the h-index.
    Nys=Ny(idx);
    JAWCR=sum(Csorted(1:Hidx)./Nys(1:Hidx));
    fprintf('Jin''s Age-weighted citation rate (AWCR): %0.2f\n',JAWCR);
%The AW-index is defined as the square root of the AWCR to allow comparison
%with the h-index; it approximates the h-index if the (average) citation
%rate remains more or less constant over the years.
    fprintf('Jin''s AR-index (AR-index): %0.2f\n',realsqrt(JAWCR));
%However, Harzing sum over all papers instead, because she feels that this
%represents the impact of the total body of work more accurately. (In
%particular, it allows younger and as yet less cited papers to contribute
%to the AWCR, even though they may not yet contribute to the h-index.)
    HAWCR=sum(Csorted./Nys);
    fprintf('Harzing''s Age-weighted citation rate (AWCR): %0.2f\n',HAWCR);
    fprintf('Harzing''s AR-index (AR-index): %0.2f\n',realsqrt(HAWCR));
    disp(tr); disp(' '); 
end

if ~isempty(A)
    disp('Authors weighted indices'); disp(tr)
%The Individual h-index was proposed by Pablo D. Batista, Monica G.
%Campiteli, Osame Kinouchi, and Alexandre S. Martinez in their paper Is it
%possible to compare researchers with different scientific interests?,
%Scientometrics, Vol 68, No. 1 (2006), pp. 179-189. It divides the standard
%h-index by the average number of authors in the articles that contribute
%to the h-index, in order to reduce the effects of co-authorship; the
%resulting index is called hI.    
    AS=A(idx);
    HIidx=Hidx/mean(AS(1:Hidx));
    fprintf('Batista''s Individual h-index (hI-index): %0.2f\n',HIidx)
%Harzing also implements an alternative individual h-index,
%hI,norm, that takes a different approach: instead of dividing the total
%h-index, she first normalizes the number of citations for each paper by
%dividing the number of citations by the number of authors for that paper,
%then calculates hI,norm  as the h-index of the normalized citation counts.
%This approach is much more fine-grained than Batista et al.'s; she
%believes that it more accurately accounts for any co-authorship effects
%that might be present and that it is a better approximation of the
%per-author impact, which is what the original h-index set out to provide.
    SAH=sort(C./A,'descend');
    HHIidx=sum(SAH>=x);
    fprintf('Harzing''s Individual h-index (hI,norm-index): %0.2f\n',HHIidx)
%The third variation is due to Michael Schreiber and first described in his
%paper To share the fame in a fair way, hm modifies h for multi-authored
%manuscripts, New Journal of Physics, Vol 10 (2008), 040201-1-8.
%Schreiber's method uses fractional paper counts instead of reduced
%citation counts to account for shared authorship of papers, and then
%determines the multi-authored hm  index based on the resulting effective
%rank of the papers using undiluted citation counts.
    xS=x./AS;
    Hmidx=sum(Csorted>=xS);
    fprintf('Schreiber''s Multi-authored h-index (hm-index): %0.2f\n',Hmidx)
    disp(tr); disp(' '); 
end

if ~isempty(Y) && ~isempty(A)
    disp('Years and Authors weighted indices'); disp(tr)
    %The per-author age-weighted citation rate is similar to the plain
    %AWCR, but is normalized to the number of authors for each paper.
    JAWCRN=sum(Csorted(1:Hidx)./Nys(1:Hidx)./A(1:Hidx));
    fprintf('Jin''s Age-weighted citation rate (AWCR) normalized per authors: %0.2f\n',JAWCRN);
    fprintf('Jin''s AR-index (AR-index) normalized per authors: %0.2f\n',realsqrt(JAWCRN));
    HAWCRN=sum(Csorted./Nys./AS);
    fprintf('Harzing''s Age-weighted citation rate (AWCR) normalized per authors: %0.2f\n',HAWCRN);
    fprintf('Harzing''s AR-index (AR-index) normalized per authors: %0.2f\n',realsqrt(HAWCRN));
    disp(tr)
end
figure
subplot(2,3,2); plot(x2,Csorted,'b.',x2,Csorted,'r-',x2,x2,'k-')
title('Kosmulski''s h2-index plot'); xlabel('Squared Paper Rank'); ylabel('Citations'); 
subplot(2,3,3); plot(x2,cC,'b.',x2,cC,'r-',x2,x2,'k-')
title('Egghe''s g-index plot'); xlabel('Squared Paper Rank'); ylabel('Cumulative sum of Citations'); 
subplot(2,3,4); plot(x,Sc,'b.',x,Sc,'r-',x,x,'k-')
title('Sidiropoulos''s hc-index plot'); xlabel('Paper Rank'); ylabel('Age weighted citations'); 
subplot(2,3,5); plot(x,SAH,'b.',x,SAH,'r-',x,x,'k-'); 
title('Harzing''s hI,norm-index plot'); xlabel('Paper Rank'); ylabel('Authors weighted Citations'); 
subplot(2,3,6); plot(xS,Csorted,'b.',xS,Csorted,'r-',xS,xS,'k-'); 
title('Schreiber''s hm-index plot'); xlabel('Authors weighted Paper Rank'); ylabel('Citations'); 

TC=sum(Csorted>0);
X=zeros(Ctot,1);
M=1:1:Csorted(1);
send=cumsum(Csorted(1:TC));
sstart=[1 send(1:TC-1)+1];
for I=1:sum(Csorted>0)
    X(sstart(I):send(I))=M(1:Csorted(I));
end
Y=rldecode(Csorted,x)';
Xs=[X;Y];
Ys=[Y;X];
subplot(2,3,1);
scatter(Xs,Ys,4)
Xs=repmat(1:1:Hidx,1,Hidx);
Ys=rldecode(repmat(Hidx,1,Hidx),1:1:Hidx);
hold on
scatter(Xs,Ys,4,'r')
hold off
title('Hirsch''s h-index as Durfee''s square on a Ferrers''es diagram');  


function x = rldecode(len, val)
%RLDECODE Run-length decoding of run-length encode data.
%
%   X = RLDECODE(LEN, VAL) returns a vector XLEN with the length of each run
%   and a vector VAL with the corresponding values.  LEN and VAL must have the
%   same lengths.
%
%   Example: rldecode([ 2 3 1 2 4 ], [ 6 4 5 8 7 ]) will return
%
%      x = [ 6 6 4 4 4 5 8 8 7 7 7 7 ];
%
%   See also RLENCODE.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:50:38 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % keep only runs whose length is positive
   k = len > 0;
   len = len(k);
   val = val(k);

   % now perform the actual run-length decoding
   i = cumsum(len);             % LENGTH(LEN) flops
   j = zeros(1, i(end));
   j(i(1:end-1)+1) = 1;         % LENGTH(LEN) flops
   j(1) = 1;
   x = val(cumsum(j));          % SUM(LEN) flops
