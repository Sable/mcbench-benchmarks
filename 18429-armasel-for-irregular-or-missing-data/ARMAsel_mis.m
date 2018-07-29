function [asel,bsel,sellog]=ARMAsel_mis(ti,xi,Larmax)
%
%  Author P.M.T. Broersen, August 2004
%                          November 2007
%  Acknowledgment: The first version of the software 
%  has been written by Stijn de Waele
%
%  function [asel,bsel,sellog]=ARMAsel_mis(ti,xi,Larmax)
%
%  ti     : 1*N vector of time instants where an observation has been made
%  xi     : 1*N vector of observations at ti
%  Larmax : highest AR order for ML estimation
%
%  ti are integer numbers 1,2, ...
%
%  asel, bsel :  parameters of model with selected type and order
%  sellog     :  additional output data
%
%  requires ARMASA toolbox of Piet Broersen
%  requires armasel_rs toolbox of Stijn de Waele
%  both availble at http://www.mathworks.com/matlabcentral/fileexchange
%  requires MATLAB optim toolbox
%
%  additional programs called in ARMAsel_mis
%     ARfil.m
%     ARMA_MLfit.m
%     ARJones.m
%     Jonesfit.m

N=length(xi)
gamma=(N-1)/(ti(end)-ti(1))

ASAtime = clock;
ASAdate = now;

Neff=N*gamma;
Larmax=min(Larmax , fix(Neff/5));  % set limits to maximum AR order
Larmax=max(Larmax , 3);            % set limits to maximum AR order
Lmamax=Larmax;                     % maximum MA order is equal to maximum AR order
Larmamax=fix((Larmax+1)/2);        % maximum ARMA order is half of maximum AR order

%  penalty in order selection criterion depends on missing fraction
if gamma >= 0.75,
    penalty=3;
elseif gamma <= 0.25,
    penalty=5;
else
    penalty=4;
end

muxi=mean(xi);
xi=xi-muxi;      % Mean is subtracted automatically

% AR parameters are estimated with a ML method
% Jonesfit and ARjones are chosen for less than 90 % missing data
% ARMA_MLfit and ARfil are chosen for less than 10 % remaining data
% Both algorithms give almost identical answers, 
% but the computing time is optimized with this choice

rcestar=[];
GICAR=NaN*ones(1,Larmax);
if gamma < .099,
    GIC0 = ARMA_MLfit([],{ti'},{xi'},ceil(2*Larmax/gamma),0)
else 
    GIC0=Jonesfit([],ti,xi,0)
end
GICmin=GIC0;
arorde=0;
asel_ar=1;
disp(' ')
for io=1:Larmax,
    rcinit=[rcestar 0];
    if gamma < .099,
        [rcestar, maxlh_AR, it] = ARfil({ti'},{xi'},rcinit,ceil(2*io/gamma),io);
    else 
        [rcestar, maxlh_AR, it] = ARjones(ti,xi,rcinit,io);
    end
    if any(~isreal(rcestar)),maxlh_AR = +Inf; rcestar=rcinit; end 
    rc_ar{io}=rcestar;
    GICAR(io)=maxlh_AR + penalty*io
    if io==1, GIC1=maxlh_AR + 3*io; end
    if GICAR(io)<GICmin,
        GICmin=GICAR(io);
        arorde=io;
        asel_ar=rc2arset([1 rcestar]);
    end 
end

disp(' ')
disp('The selected AR model with the smallest GICAR has the parameters:')
disp(asel_ar)

if (nargout) == 1, % simple run with only AR candidates
    asel=asel_ar;
    return
end

% MA and ARMA models are estimated from long AR models with Durbin's method.
% If many data are missing, high order AR models can become very inaccurate.
% Therefore, the intermediate AR order is chosen as the highest order with
% a spectrum that is close to the spectrum of the selected AR model.

if arorde==0, arorde=1;end
arordedurb=arorde;
for ii=arorde:Larmax
    met=moderr(rc2arset([1 rc_ar{ii}]),1,rc2arset([1 rc_ar{arorde}]),1,N);
    if met < 2*(ii-arorde),
        arordedurb=ii;
    end
end

% A number of very small reflection coefficients is added to the selected
% AR model. The longer AR parameter vectors give the same results for MA and
% ARMA models, but prevent numerical difficulties.

ARint=rc2arset([ 1 rc_ar{arordedurb} 10^-8*(rand(1,5*Larmax)-0.5)]);
ARmax=rc2arset([ 1 rc_ar{Larmax}     10^-8*(rand(1,5*Larmax)-0.5)]);

% compute parameters for MA models with reduced statistics algorithm
disp(' ')
disp('Compute parameters for MA models with reduced statistics algorithm')
GICma=NaN*ones(1,Lmamax);
GICmamin=GIC0;
maorde=0;
bsel_ma=1;
for io=1:Lmamax,
    mapar=arh2ma(ARint,N,io);
    [dummy mat]=ar2arset(mapar);
    mat(1)=[];
    if gamma < .099,
        lh = ARMA_MLfit(tan(.5*pi*mat),{ti'},{xi'},ceil(2*Larmax/gamma),0);
    else 
        lh=Jonesfit(tan(.5*pi*mat),ti,xi,0);
    end
    GICma(io)=lh+3*io;
    if GICma(io)<GICmamin,
        GICmamin=GICma(io);
        maorde=io;
        bsel_ma=mapar;
    end 
end
disp(' ')
disp('The selected MA model has the parameters:')
disp(bsel_ma)

% compute parameters for ARMA models with reduced statistics algorithm
disp(' ')
disp('Compute parameters for ARMA models with reduced statistics algorithm')
GICarma=NaN*ones(1,Larmax);
GICarma(1)=GIC1+.00001;
GICarmamin=GICarma(1); 
asel_arma=[1 rc_ar{1}];
bsel_arma=1;
for io=2:Larmamax,
    [armaar armama]=arh2arma(ARint,N,io,1);
    [dummy armatar]=ar2arset(armaar);
    armatar(1)=[];
    [dummy armatma]=ar2arset(armama);
    armatma(1)=[];
    armat=[armatar armatma];
    lh=Jonesfit(tan(.5*pi*armat),ti,xi,io);
    if gamma < .099,
        lh = ARMA_MLfit(tan(.5*pi*armat),{ti'},{xi'},ceil(2*Larmax/gamma),io);
    else 
        lh = Jonesfit(tan(.5*pi*armat),ti,xi,io);
    end
    GICarma(io)=lh+3*(2*io-1);
    if GICarma(io)<GICarmamin,
        GICarmamin=GICarma(io);
        asel_arma=armaar;
        bsel_arma=armama;
    end 
end
disp(' ')
disp('The selected ARMA model has the parameters:')
disp(asel_arma)
disp(bsel_arma)

% selection of model type
% a correction is made for AR models where the penaly could be 3, 4 or 5
% the penalty for MA and ARMA models was always 3
% the penalty for the selected AR model is also set to 3
if gamma >= 0.75,
    GICminar=GICmin;
elseif gamma <= 0.25,
    GICminar=GICmin-2*arorde;
else
    GICminar=GICmin-arorde;
end

% selection of model type, based on penalty 3 for all types
[GICmin type]=min([GICminar GICmamin GICarmamin]);

asel = 1;
bsel = 1;
if type == 1,
    asel = asel_ar;
elseif type == 2,
    bsel = bsel_ma;
elseif type == 3,
    asel = asel_arma;
    bsel = bsel_arma;
end

disp(' ')
disp('The  ARMAsel_mis model with selected type and order has the parameters:')
disp(asel)
disp(bsel)

disp(' ')
if nargout > 2  % means that the call of the program asked for a log file
   sellog.date_time   = [datestr(ASAdate,8) 32 datestr(ASAdate,0)];
   sellog.comp_time   = etime(clock,ASAtime);
   sellog.N           = N;
   sellog.gamma       = gamma;
   sellog.ar          = asel_ar;
   sellog.arset       = rc_ar;
   sellog.arlongorder = arordedurb;
   sellog.ma          = bsel_ma;
   sellog.armaar      = asel_arma;
   sellog.armama      = bsel_arma;
   sellog.GIC0        = GIC0;
   sellog.GICmin      = [GICminar GICmamin GICarmamin];
   sellog.GIC         = [GICAR;GICma;GICarma];
end
