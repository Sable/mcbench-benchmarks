function [asel,bsel,sellog]=ARMAsel_irreg(ti,xi,Larmax,Tr,w)
%
%  Author P.M.T. Broersen, August 2004
%
%  [asel,bsel,sellog]=ARMAsel_irreg(ti,xi,Larmax,Tr,w)
%
%  ti     : 1*N vector of irregular time instants
%  xi     : 1*N vector of observations at ti
%  Larmax : highest AR order for quasi ML estimation
%  Tr     : resampling time for nearest neighbor
%           generally computed as a fraction 1/K of the mean sampling time
%  w      : slot width, as a fraction of Tr
%
%  asel, bsel :  parameters of model with selected type and order
%  sellog     :  additional output data
%
%  requires ARMASA toolbox available at
%       http://www.mathworks.com/matlabcentral/fileexchange/
%       then select Signal Processing and Spectral Analysis
%          and ARMASA of Piet M.T. Broersen 
%  requires armasel_rs toolbox available at
%       http://www.mathworks.com/matlabcentral/fileexchange/
%       then select Signal Processing and Spectral Analysis
%          and Automatic Spectral Analysis of Stijn de Waele 
%  requires MATLAB optim toolbox
%
%  additional programs called in ARMAsel-irreg
%     ARfil_irreg.m
%     ARJones_irreg.m
%     ARMLfit_irreg.m
%     Jonesfit_irreg.m
%     mssnnr.m
%

set(0,'DefaultTextFontname','Arial')
set(0,'DefaultAxesFontname','Arial')

N=length(xi);
T0 = (ti(end)-ti(1))/(N-1);  % Mean irregular sampling time, f0 = 1/T0 = mean data rate
f0= 1/T0

ASAtime = clock;
ASAdate = now;

Larmax=max(Larmax, 2)
Lmamax=Larmax;
Larmamax=fix((Larmax+1)/2);

gamma=Tr*w/T0

if gamma >= 0.75,
    penalty=3;
elseif gamma <= 0.25
    penalty=5;
else
    penalty=4;
end

mux=mean(xi);
xi=xi-mux;

% Multi shift slotted Nearest Neighbor Resampling
tx=mssnnr(ti,xi,Tr,w);
[dum K]=size(tx);
N_used=0;   % number of observations used in different slots
N_pair=0;   % number of contiguous pairs at distance Tr
N_pair_2=0; % number of contiguous pairs at distance 2Tr
for k=1:K
   N_used = N_used+length(tx{1,k});
   ia=find(diff(tx{1,k})==1); 
   N_pair=N_pair+length(ia);   
   ib=find(diff(tx{1,k})==2); 
   ic=find(diff(ia)==1); 
   N_pair_2=N_pair_2+length(ib)+length(ic);    
end

% parameters estimated with AR ML
rcestar=[];
CICAR=NaN*ones(1,Larmax);
LH_AR=NaN*ones(1,Larmax);
if gamma < .15
    CIC0=ARMLfit_irreg([],tx,ceil(2*Larmax/gamma),0)
else
    CIC0=Jonesfit_irreg([],tx,0)
end
CICmin=CIC0;
arorde=0;
asel_ar=1;

for io=1:Larmax,
    rcinit=[rcestar .0];
    if gamma < .15,
        fil=ceil(2*io/gamma); 
        %fil=ceil(2*Larmax/0.15); % limited if gamma is less than 0.15
        [rcestar, maxlh_AR, it] = ARfil_irreg(tx,rcinit,fil,N_used,io)
    else 
        [rcestar, maxlh_AR, it] = ARJones_irreg(tx,rcinit,io,N_used)
    end
    if any(~isreal(rcestar)),maxlh_AR = +Inf; rcestar=rcinit; end 
    rc_ar{io}=rcestar;
    CICAR(io)=maxlh_AR + penalty*io
    LH_AR(io)=maxlh_AR;
    if io==1, CIC1=maxlh_AR + 3*io; end
    if CICAR(io)<CICmin,
        CICmin=CICAR(io);
        arorde=io;
        asel_ar=rc2arset([1 rcestar]);
        asel=asel_ar;
    end 
    if nargout > 2,
        if io == 1,
            arpar=rc2arset([1 rcestar]);
            [psdarii fas]=arma2psd(arpar,1,500,Tr);
            figure
            loglog(fas,psdarii,'r:')
            as=axis;
            as(1)=fas(1);
            as(2)=fas(end);
            as(4)=10*max(psdarii);
            as(3)=min(psdarii)/2^(Larmax);
            axis(as);
            title(['Shifted spectra of all AR models with \it{T_r}\rm = ' ...
                , num2str(Tr),' s, \itw\rm = ',num2str(w),' *\it{T_r}\rm s'])
            xlabel('\rightarrow frequency axis until 1 / ( 2\it{T_r}\rm ) Hz')
            ylabel('\rightarrow Shifted logarithm of spectra')
            hold on
        else
            arpar=rc2arset([1 rcestar]);
            psdarii=arma2psd(arpar,1,500,Tr);
            loglog(fas,psdarii*2^(1-io))
            as(3)=0.99*min(psdarii)/2^(io-1);
            axis(as);
        end
    end
end
if nargout > 2,
    legend('AR(1)','AR(\itk\rm) shifted',3)
    hold off
end

% Select AR order for MA - Durbin algorithm
if arorde==0, arorde=1;end
arordedurb=arorde;
for ii=arorde:Larmax
    met=moderr(rc2arset([1 rc_ar{ii}]),1,rc2arset([1 rc_ar{arorde}]),1,N);
    if met < 2*(ii-arorde),
        arordedurb=ii;
    end
end
disp('Selected AR order and intermediate order for MA - Durbin algorithm')
disp([arorde arordedurb])
% Elongate AR model with insignificant parameters to facilitate 
% MA and ARMA computations
ARint=rc2arset([ 1 rc_ar{arordedurb} 10^-8*(rand(1,5*Larmax)-0.5)]);
ARmax=rc2arset([ 1 rc_ar{Larmax}     10^-8*(rand(1,5*Larmax)-0.5)]);
 
% parameters for AR model
CICma=NaN*ones(1,Lmamax);
CICmamin=CIC0;
maorde=0;
bsel_ma=1;
for io=1:Lmamax,
    mapar=arh2ma(ARint,N_used,io);
    [dummy mat]=ar2arset(mapar);
    mat(1)=[];
    if gamma < .15
        lh=ARMLfit_irreg(tan(.5*pi*mat),tx,fil,0);
    else
        lh=Jonesfit_irreg(tan(.5*pi*mat),tx,0);
    end
    CICma(io)=lh+3*io
    if CICma(io)<CICmamin,
        CICmamin=CICma(io);
        maorde=io;
        bsel_ma=mapar;
    end 
end

% parameters for ARMA model
CICarma=NaN*ones(1,Larmax);
CICarma(1)=CIC1+.00001;
CICarmamin=CICarma(1); 
asel_arma=[1 rc_ar{1}];
bsel_arma=1;
for io=2:Larmamax,
    [armaar armama]=arh2arma(ARint,N_used,io,1);
    [dummy armatar]=ar2arset(armaar);
    armatar(1)=[];
    [dummy armatma]=ar2arset(armama);
    armatma(1)=[];
    armat=[armatar armatma];
    if gamma < .15
        lh=ARMLfit_irreg(tan(.5*pi*armat),tx,fil,io)
    else
        lh=Jonesfit_irreg(tan(.5*pi*armat),tx,io);
    end
    CICarma(io)=lh+3*(2*io-1)
    if CICarma(io)<CICarmamin,
        CICarmamin=CICarma(io);
        asel_arma=armaar;
        bsel_arma=armama;
    end 
end

% selection of model type
if gamma >= 0.75,
    CICminar=CICmin;
elseif gamma <= 0.25,
    CICminar=CICmin-2*arorde;
else
    CICminar=CICmin-arorde;
end
[minCIC type]=min([CICminar CICmamin CICarmamin])
disp(' ')

% output 
if type == 1,
    asel=asel_ar;
    bsel=1;
    textt='AR';
elseif type == 2,
    asel=1;
    bsel=bsel_ma;
    textt='MA';
elseif type == 3,
    asel=asel_arma;
    bsel=bsel_arma;
    textt='ARMA';
end

if nargout > 2,
   sellog.date_time = ...
      [datestr(ASAdate,8) 32 datestr(ASAdate,0)];
   sellog.comp_time = etime(clock,ASAtime);
   sellog.N = N;
   sellog.N_used = N_used;
   sellog.N_pair_distance_1 = N_pair;
   sellog.N_pair_distance_2 = N_pair_2;
   sellog.gamma = gamma;
   sellog.mean_sampling_time_T0 = T0;
   sellog.mean_data_rate_f0 = f0;
   sellog.resampling_time_Tr = Tr;
   sellog.slotwidth_w = w;
   sellog.type = textt;
   sellog.ar = asel_ar;
   sellog.arset = rc_ar;
   sellog.ma = bsel_ma;
   sellog.arma_ar = asel_arma;
   sellog.arma_ma = bsel_arma;
   sellog.CIC_penalty = penalty;
   sellog.CIC0 = CIC0;
   sellog.CICmin = [CICminar CICmamin CICarmamin];
   sellog.CIC = [CICAR;CICma;CICarma];
   sellog.LH_AR = LH_AR;
end

output_correction = 'Y'; % 'Y' for removal of poles
% 'Y' for removal of poles with real part less than cos(0.5 * pi)
% Hence, poles in the last 50 % of the current frequency range are removed
% The AR order of the model is reduced if poles are removed

if nargout > 2 & output_correction == 'Y' & length(asel_ar) > 1 ,
    k = 0;
    zepo = roots(asel_ar)
    bselx=1;
    for ii=1:length(asel_ar)-1
        if real(zepo(ii)) < cos(0.5*pi), 
            zepo(ii)= 0;
            k=k+1
        end
    end
    aselnew = asel_ar;
    if k > 0
        aselnew = poly(zepo)
    end
    sellog.AR_sel_corrected = aselnew;
    [dummy art] = ar2arset(aselnew);
    art(1)=[];
    if gamma < .15
        lh = ARMLfit_irreg(tan(.5*pi*art),tx,fil,length(art));
    else
        lh = Jonesfit_irreg(tan(.5*pi*art),tx,length(art));
    end
    sellog.LH_AR_sel_corrected = lh;
end

if nargout > 2 & output_correction == 'Y' & length(asel_ar) == 1 ,
    sellog.AR_sel_corrected = 1;
end