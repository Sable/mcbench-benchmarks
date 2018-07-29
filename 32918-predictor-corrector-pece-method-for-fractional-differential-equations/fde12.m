function [t, y] = fde12(alpha,fdefun,t0,tfinal,y0,h,param,mu,mu_tol)
%FDE12  Solves an initial value problem for a non-linear differential
%       equation of fractional order (FDE). The code implements the
%       predictor-corrector PECE method of Adams-Bashforth-Moulton type
%       described in [1].
%
%   [T,Y] = FDE12(ALPHA,FDEFUN,T0,TFINAL,Y0,h) integrates the initial value
%   problem for the FDE, or the system of FDEs, of order ALPHA > 0
%      D^ALPHA Y(t) = FDEFUN(T,Y(T))
%      Y^(k)(T0) = Y0(:,k+1), k=0,...,m-1
%   where m is the smallest integer grater than ALPHA and D^ALPHA is the 
%   fractional derivative according to the Caputo's definition. FDEFUN is a
%   function handle corresponding to the vector field of the FDE and for a
%   scalar T and a vector Y, FDEFUN(T,Y) must return a column vector. The
%   set of initial conditions Y0 is a matrix with a number of rows equal to
%   the size of the problem (hence equal to the number of rows of the
%   output of FDEFUN) and a number of columns depending on ALPHA and given
%   by m. The step-size H>0 is assumed constant throughout the integration.   
%
%   [T,Y] = FDE12(ALPHA,FDEFUN,T0,TFINAL,Y0,H,PARAM) solves as above with 
%   the additional set of parameters for the FDEFUN as FDEFUN(T,Y,PARAM).
%
%   [T,Y] = FDE12(ALPHA,FDEFUN,T0,TFINAL,Y0,H,PARAM,MU) solves the FDE with
%   the selected number MU of multiple corrector iterations. The following
%   values for MU are admissible:
%   MU = 0 : the corrector is not evaluated and the solution is provided 
%   just by the predictor method (the first order rectangular rule);
%   MU > 0 : the corrector is evaluated by the selected number MU of times;
%   the classical PECE method is obtained for MU=1;
%   MU = Inf : the corrector is evaluated for a certain number of times
%   until convergence of the iterations is reached (for convergence the
%   difference between two consecutive iterates is tested).
%   The defalut value for MU is 1
%
%   [T,Y] = FDE12(ALPHA,FDEFUN,T0,TFINAL,Y0,H,PARAM,MU,MU_TOL) allows to
%   specify the tolerance for testing convergence when MU = Inf. If not
%   specified, the default value MU_TOL = 1.E-6 is used.
%
%   FDE12 is an implementation of the predictor-corrector method of
%   Adams-Bashforth-Moulton studied in [1]. Convergence and accuracy of
%   the method are studied in [2]. The implementation with multiple
%   corrector iterations has been proposed and discussed for multiterm FDEs
%   in [3]. In this implementation the discrete convolutions are evaluated
%   by means of the FFT algorithm described in [4] allowing to keep the
%   computational cost proportional to N*log(N)^2 instead of N^2 as in the
%   classical implementation; N is the number of time-point in which the
%   solution is evaluated, i.e. N = (TFINAL-T)/H. The stability properties
%   of the method implemented by FDE12 have been studied in [5].
%
%   [1] K. Diethelm, A.D. Freed, The Frac PECE subroutine for the numerical
%   solution of differential equations of fractional order, in: S. Heinzel,
%   T. Plesser (Eds.), Forschung und Wissenschaftliches Rechnen 1998,
%   Gessellschaft fur Wissenschaftliche Datenverarbeitung, Gottingen, 1999,
%   pp. 57-71.
%
%   [2] K. Diethelm, N.J. Ford, A.D. Freed, Detailed error analysis for a
%   fractional Adams method, Numer. Algorithms 36 (1) (2004) 31-52.
%
%   [3] K. Diethelm, Efficient solution of multi-term fractional
%   differential equations using P(EC)mE methods, Computing 71 (2003), pp.
%   305-319.
%
%   [4] E. Hairer, C. Lubich, M. Schlichte, Fast numerical solution of
%   nonlinear Volterra convolution equations, SIAM J. Sci. Statist. Comput.
%   6 (3) (1985) 532-541.
%
%   [5] R. Garrappa, On linear stability of predictor-corrector algorithms
%   for fractional differential equations, Internat. J. Comput. Math. 87
%   (10) (2010) 2281-2290.
%
%   Copyright (c) 2011-2012, Roberto Garrappa, University of Bari, Italy
%   garrappa at dm dot uniba dot it
%   Revision: 1.2 - Date: July, 6 2012 

% Check inputs
if nargin < 9
    mu_tol = 1.0e-6 ; 
    if nargin < 8
        mu = 1 ;
        if nargin < 7
            param = [] ;
        end
    end
end

% Check order of the FDE 
if alpha <= 0
    error('MATLAB:fde12:NegativeOrder',...
        ['The order ALPHA of the FDE must be positive. The value ' ...
         'ALPHA = %f can not be accepted. See FDE12.'], alpha);
end 

% Check the step--size of the method
if h <= 0
    error('MATLAB:fde12:NegativeStepSize',...
        ['The step-size H for the method must be positive. The value ' ...
         'H = %e can not be accepted. See FDE12.'], h);
end 

% Structure for storing initial conditions
ic.t0 = t0 ;
ic.y0 = y0 ;
ic.m_alpha = ceil(alpha) ;
ic.m_alpha_factorial = factorial(0:ic.m_alpha-1) ;

% Structure for storing information on the problem 
Probl.ic = ic ;
Probl.fdefun = fdefun ;
Probl.problem_size = size(y0,1) ;
Probl.param = param ;

% Check number of initial conditions
if size(y0,2) < ic.m_alpha
    error('MATLAB:fde12:NotEnoughInputs', ...
        ['A not sufficient number of assigned initial conditions. ' ...
        'Order ALPHA = %f requires %d initial conditions. See FDE12.'], ...
        alpha,ic.m_alpha);
end

% Check compatibility size of the problem with size of the vector field
f_temp = f_vectorfield(t0,y0(:,1),Probl) ;
if Probl.problem_size ~= size(f_temp,1)
    error('MATLAB:fde12:SizeNotCompatible', ...
        ['Size %d of the problem as obtained from initial conditions ' ...
         '(i.e. the number of rows of Y0) not compatible with the ' ...
         'size %d of the output of the vector field FDEFUN. ' ...
         'See FDE12.'], Probl.problem_size,size(f_temp,1));
end

% Number of points in which to evaluate weights and solution 
r = 16 ;
N = ceil((tfinal-t0)/h) ;
Nr = ceil((N+1)/r)*r ;
Q = ceil(log2(Nr/r)) - 1 ;
NNr = 2^(Q+1)*r ;

% Preallocation of some variables
y = zeros(Probl.problem_size,N+1) ;
fy = zeros(Probl.problem_size,N+1) ;
zn_pred = zeros(Probl.problem_size,NNr+1) ;
if mu > 0
    zn_corr = zeros(Probl.problem_size,NNr+1) ;
else
    zn_corr = 0 ;
end

% Evaluation of coefficients of the PECE method
nvett = 0 : NNr+1 ;
nalpha = nvett.^alpha ;
nalpha1 = nalpha.*nvett ;
PC.bn = nalpha(2:end) - nalpha(1:end-1) ;
PC.an = [ 1 , (nalpha1(1:end-2) - 2*nalpha1(2:end-1) + nalpha1(3:end)) ] ;
PC.a0 = [ 0 , nalpha1(1:end-2)-nalpha(2:end-1).*(nvett(2:end-1)-alpha-1)] ;
PC.halpha1 = h^alpha/gamma(alpha+1) ;
PC.halpha2 = h^alpha/gamma(alpha+2) ;
PC.mu = mu ; PC.mu_tol = mu_tol ;

% Initializing solution and proces of computation
t = t0 + (0 : N)*h ;
y(:,1) = y0(:,1) ;
fy(:,1) = f_temp ;
[y, fy] = Triangolo(1, r-1, t, y, fy, zn_pred, zn_corr, N, PC, Probl ) ;

% Main process of computation by means of the FFT algorithm
ff = [0 2 ] ; nx0 = 0 ; ny0 = 0 ;
for q = 0 : Q
    L = 2^q ; 
    [y, fy] = DisegnaBlocchi(L, ff, r, Nr, nx0+L*r, ny0, t, y, fy, ...
                             zn_pred, zn_corr, N, PC, Probl ) ;
    ff = [ff ff]  ; ff(end) = 4*L ;
end

% Evaluation solution in TFINAL when TFINAL is not in the mesh
if tfinal < t(N+1) 
    c = (tfinal - t(N))/h ;
    t(N+1) = tfinal ;
    y(:,N+1) = (1-c)*y(:,N) + c*y(:,N+1) ;
end
t = t(1:N+1) ; y = y(:,1:N+1) ;

end


% =========================================================================
% =========================================================================
% r : dimension of the basic square or triangle
% L : factor of resizing of the squares
function [y, fy] = DisegnaBlocchi(L, ff, r, Nr, nx0, ny0, t, y, fy, ...
                                  zn_pred, zn_corr, N , PC, Probl)

nxi = nx0 ; nxf = nx0 + L*r - 1 ;
nyi = ny0 ; nyf = ny0 + L*r - 1 ;
is = 1 ;
s_nxi(is) = nxi ; s_nxf(is) = nxf ; s_nyi(is) = nyi ; s_nyf(is) = nyf ;

i_triangolo = 0 ; stop = 0 ;
while ~stop
    
    stop = nxi+r-1 == nx0+L*r-1 | (nxi+r-1>=Nr-1) ; % Ci si ferma quando il triangolo attuale finisce alla fine del quadrato
    
    [zn_pred, zn_corr] = Quadrato(nxi, nxf, nyi, nyf, fy, zn_pred, zn_corr, PC, Probl) ;
    
    [y, fy] = Triangolo(nxi, nxi+r-1, t, y, fy, zn_pred, zn_corr, N, PC, Probl) ;
    i_triangolo = i_triangolo + 1 ;
    
    if ~stop
        if nxi+r-1 == nxf   % Il triangolo finisce dove finisce il quadrato -> si scende di livello
            i_Delta = ff(i_triangolo) ;
            Delta = i_Delta*r ;
            nxi = s_nxf(is)+1 ; nxf = s_nxf(is)  + Delta ;
            nyi = s_nxf(is) - Delta +1; nyf = s_nxf(is)  ;
            s_nxi(is) = nxi ; s_nxf(is) = nxf ; s_nyi(is) = nyi ; s_nyf(is) = nyf ;
        else % Il triangolo finisce prima del quadrato -> si fa un quadrato accanto
            nxi = nxi + r ; nxf = nxi + r - 1 ; nyi = nyf + 1 ; nyf = nyf + r  ;
            is = is + 1 ;
            s_nxi(is) = nxi ; s_nxf(is) = nxf ; s_nyi(is) = nyi ; s_nyf(is) = nyf ;
        end
    end
    
end

end

% =========================================================================
% =========================================================================
function [zn_pred, zn_corr] = Quadrato(nxi, nxf, nyi, nyf, fy, zn_pred, zn_corr, PC, Probl)

coef_beg = nxi-nyf ; coef_end = nxf-nyi+1 ;
funz_beg = nyi+1 ; funz_end = nyf+1 ;

% Evaluation convolution segment for the predictor
vett_coef = PC.bn(coef_beg:coef_end) ;
vett_funz = [fy(:,funz_beg:funz_end) , zeros(Probl.problem_size,funz_end-funz_beg+1) ] ;
zzn_pred = real(FastConv(vett_coef,vett_funz)) ;
zn_pred(:,nxi+1:nxf+1) = zn_pred(:,nxi+1:nxf+1) + zzn_pred(:,nxf-nyf+1-1:end-1) ; 

% Evaluation convolution segment for the corrector
if PC.mu > 0
    vett_coef = PC.an(coef_beg:coef_end) ;
    if nyi == 0 % Evaluation of the lowest square
        vett_funz = [zeros(Probl.problem_size,1) , fy(:,funz_beg+1:funz_end) , zeros(Probl.problem_size,funz_end-funz_beg+1) ] ;
    else % Evaluation of any square but not the lowest
        vett_funz = [ fy(:,funz_beg:funz_end) , zeros(Probl.problem_size,funz_end-funz_beg+1) ] ;
    end
    zzn_corr = real(FastConv(vett_coef,vett_funz)) ;
    zn_corr(:,nxi+1:nxf+1) = zn_corr(:,nxi+1:nxf+1) + zzn_corr(:,nxf-nyf+1:end) ;
else
    zn_corr = 0 ;
end

end



% =========================================================================
% =========================================================================
function [y, fy] = Triangolo(nxi, nxf, t, y, fy, zn_pred, zn_corr, N, PC, Probl)

for n = nxi : min(N,nxf)
    
    % Evaluation of the predictor
    Phi = zeros(Probl.problem_size,1) ;
    if nxi == 1 % Case of the first triangle
        j_beg = 0 ;
    else % Case of any triangle but not the first
        j_beg = nxi ;
    end
    for j = j_beg : n-1
        Phi = Phi + PC.bn(n-j)*fy(:,j+1) ;
    end
    
    St = StartingTerm(t(n+1),Probl.ic) ;
    y_pred = St + PC.halpha1*(zn_pred(:,n+1) + Phi) ;
    f_pred = f_vectorfield(t(n+1),y_pred,Probl) ; 
    
    if PC.mu == 0
        y(:,n+1) = y_pred ;
        fy(:,n+1) = f_pred ;
    else
        j_beg = nxi ;
        Phi = zeros(Probl.problem_size,1) ;
        for j = j_beg : n-1
            Phi = Phi + PC.an(n-j+1)*fy(:,j+1) ;
        end
        Phi_n = St + PC.halpha2*(PC.a0(n+1)*fy(:,1) + zn_corr(:,n+1) + Phi) ;
        yn0 = y_pred ; fn0 = f_pred ;
        stop = 0 ; mu_it = 0 ;
        while ~stop
            yn1 = Phi_n + PC.halpha2*fn0 ;
            mu_it = mu_it + 1 ;
            if PC.mu == Inf
                stop = norm(yn1-yn0,inf) < PC.mu_tol ;
                if mu_it > 100 && ~stop
                    warning('MATLAB:fde12:NonConvegence',...
                        strcat('It has been requested to run corrector iterations until convergence but ', ...
                        'the process does not converge to the tolerance %e in 100 iteration'),PC.mu_tol) ;
                    stop = 1 ;
                end
            else
                stop = mu_it == PC.mu ;
            end
            fn1 = f_vectorfield(t(n+1),yn1,Probl) ;             
            yn0 = yn1 ; fn0 = fn1 ;
        end
        y(:,n+1) = yn1 ;
        fy(:,n+1) = fn1 ;
    end
end

end


% =========================================================================
% =========================================================================
function z = FastConv(x, y)

r = length(x) ; problem_size = size(y,1) ;

z = zeros(problem_size,r) ; 
X = fft(x,r) ;
for i = 1 : problem_size
    Y = fft(y(i,:),r) ;
    Z = X.*Y ;
    z(i,:) = ifft(Z,r) ;
end

end


% =========================================================================
% =========================================================================
function f = f_vectorfield(t,y,Probl)

if isempty(Probl.param)
    f = feval(Probl.fdefun,t,y) ;
else
    f = feval(Probl.fdefun,t,y,Probl.param) ;
end

end


% =========================================================================
% =========================================================================
function ys = StartingTerm(t,ic)

ys = zeros(size(ic.y0,1),1) ;
for k = 1 : ic.m_alpha
    ys = ys + (t-ic.t0)^(k-1)/ic.m_alpha_factorial(k)*ic.y0(:,k) ;
end

end