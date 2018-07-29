% 10.12.99
%
% Alternating Conditional Expectation algorithm (ACE) to calculate optimal transformations
% by fast boxcar averaging of rank-ordered data.
%
% The program ace_main.m performs a calculation of optimal transformations from a data set.
% The algorithm has been invented by L. Breiman and J.H. Friedman [1]
% and the program follows it closely, besides two differences:
% 1. The output is not normalized with respect to the mean values of the
% optimal transformations, so the mean values may not necessarily be zero.
% 2. The data are rank ordered before the calculation of the optimal
% transformations. This leads to a simpler computation of conditional expectation values.
% The algorithm (but not the particular subroutine of estimating the
% conditional expectation values) is also described in [2],[3],[4]. An application 
% to fitting the complex Ginzburg-Landau equation to binary fluid data is provided in [5].
%
% Usage:
%
% The program ace_main.m contains the definition of the data, the call of ace.m, and the display of the results.
% This function is the one that has to be modified for applications to
% other than the example data; the other subroutines do not need to be modified then.
%
% The function ace.m is defined as
% 'function [psi,phi]=ace(x,ll,dim,wl,oi,ii,ocrit,icrit,shol,shil)'.
% Therefore, the outputs are psi (the maximal correlation)
% and phi (the set of optimal transformations).
%
% The input parameters are defined as follows:
% x:     The data set of size (dim+1) X ll.
% ll:    The number of data points of each of the dim+1 terms, e.g. 1000, if the
%        regression analysis is performed on 1000 data tuples.
% dim:   The number of terms for the rhs, can be 1,2,3, etc.
%        The 0th term corresponds to the lhs of the regression equation,
%        the 1st to dimth terms correspond to the rhs of the regression equation.
% wl:    Half of the length of the boxcar window, i.e., 2*wl+1=width of filter.
%        wl=0,1,2...
% oi:    Maximum number of iterations of outer loop, e.g. 10
% ii:    Maximum number of iterations of inner loop, e.g. 10
% ocrit: Outer iteration stop criterion, should be a small number like 1e-12
% icrit: The same for the inner loop, should be the same value or larger than osc
% shol, shil: If 1, ace.m prints the iteration result during calculations for
%        outer and inner loop. If set to 0, no effect.
%
% When the program is done, two output variables are produced:
% 1. psi contains the maximal correlation.
% 2. phi contains the transformed x-values in the same order as the inputs. 
% Therefore, to display the result, one has to plot the input variables pointwise against the output.
%
% If you use this program in publications and want to cite it, please do it as:
% H. Voss and J. Kurths, Reconstruction of nonlinear time delay models from data by the
% use of optimal transformations, Phys. Lett. A 234,  336-344 (1997).
% I will be happy to email this paper on request. 
%
% For commercial use and questions, please contact me.
%
% ++++++++++++++++++++++++++++++++++++++++++++++
% Henning U. Voss, Ph.D.
% Associate Professor of Physics in Radiology
% Citigroup Biomedical Imaging Center
% Weill Medical College of Cornell University
% 516 East 72nd Street
% New York, NY 10021
% Tel. 001-212 746-5216
% Email: hev2006@med.cornell.edu
% ++++++++++++++++++++++++++++++++++++++++++++++
%
% References:
%
% [1] L. Breiman and J.H. Friedman,
% Estimating optimal transformations for multiple regression and correlation,
% J. Am. Stat. Assoc. 80 (1985) 580-619.
%
% [2] W. Haerdle, Applied Nonparametric Regression,
% Cambridge Univ. Press, Cambridge, 1990.
%
% [3] H. Voss and J. Kurths,
% Reconstruction of nonlinear time delay models from data by the
% use of optimal transformations,
% Phys. Lett. A 234,  336-344 (1997).
%
% [4] H. Voss and J. Kurths,
% Reconstruction of nonlinear time delay models from optical data,
% Chaos, Solitons & Fractals 10, 805-809 (1999).
%
% [5] H.U. Voss, P. Kolodner, M. Abel, and J. Kurths,
% Amplitude equations from spatiotemporal binary-fluid convection data,
% Phys. Rev. Lett.  83, 3422-3425 (1999).

function ace_main()

% Example data ---------------------------------------------
% Demonstration of how ACE finds logarithmic transformations
% Results in blue; green is exp(phi)

ll=500; % number of data points
dim=2;  % number of terms on right hand side
wl=5;   % width of smoothing kernel
oi=100; % maximum number of outer loop iterations
ii=10;  % maximum number of inner loop iterations
ocrit=10*eps; % numerical zeroes for convergence test
icrit=1e-4;
shol=0; % 1-> show outer loop convergence, 0-> do not
shil=0; % same for inner loop

x1=rand(ll,1); x2=rand(ll,1);
y=x1.*x2;
x=[y x1 x2]';

% call ace.m  ---------------------------------------------

[psi,phi]=ace(x,ll,dim,wl,oi,ii,ocrit,icrit,shol,shil);

% results -------------------------------------------------

disp(['Estimate of Maximal Correlation = ' num2str(psi)]);

figure(1)
for d=1:dim+1;
    subplot(2,2,d);
    plot(x(d,:),phi(d,:),'.');
    hold on;
    plot(x(d,:),exp(phi(d,:)),'g.');
    hold off;
    axis tight;
end;

figure(2);
if dim==1; sum0=phi(2,:); else sum0=sum(phi(2:dim+1,:)); end;
plot(phi(1,:),sum0,'.');
xlabel('\Phi_0'); ylabel('\Sigma \Phi_i'); title('Regression');


% subroutines --------------------------------------------------

function [psi,phi]=ace(x,ll,dim,wl,oi,ii,ocrit,icrit,shol,shil)
ind=zeros(dim+1,ll);
ranks=zeros(dim+1,ll);
for d=1:dim+1; [~,ind(d,:)]=sort(x(d,:)); end;
for d=1:dim+1; ranks(d,ind(d,:))=1:ll; end;
phi=(ranks-(ll-1)/2.)/ sqrt(ll*(ll-1)/12.);
ieps=1.; oeps=1.; oi1=1; ocrit1=1;
while oi1<=oi && ocrit1>ocrit
    ii1=1; icrit1=1;
    while ii1<=ii && icrit1>icrit
        for d=2:dim+1; sum0=0;
            for dd=2:dim+1; if dd ~=d; sum0=sum0+phi(dd,:); end; end;
            phi(d,:)=cef(phi(1,:)-sum0,ind(d,:),ranks(d,:),wl,ll);
        end;
        icrit1=ieps;
        if dim==1; sum0=phi(2,:); else sum0=sum(phi(2:dim+1,:)); end;
        ieps=sum((sum0-phi(1,:)).^2)/ll;
        icrit1=abs(icrit1-ieps);
        if shil; disp(num2str([ii1 ieps icrit1])); end;
        ii1=ii1+1;
    end;
    phi(1,:)=cef(sum0,ind(1,:),ranks(1,:),wl,ll);
    phi(1,:)=(phi(1,:)-mean(phi(1,:)))/std(phi(1,:));
    ocrit1=oeps; oeps=sum((sum0-phi(1,:)).^2)/ll; ocrit1=abs(ocrit1-oeps);
    if shol; disp(num2str([oi1 oeps ocrit1])); end;
    oi1=oi1+1;
end;
psi=corrcoef(phi(1,:),sum0); psi=psi(1,2);

function r=cef(y,ind,ranks,wl,ll)
cey=win(y(ind),wl,ll);
r=cey(ranks);

function r=win(y,wl,ll)
% wl=0,1,2...
r=conv(y,ones(2*wl+1,1));
r=r(wl+1:ll+wl)/(2*wl+1);
r(1:wl)=r(wl+1); r(ll-wl+1:ll)=r(ll-wl);

