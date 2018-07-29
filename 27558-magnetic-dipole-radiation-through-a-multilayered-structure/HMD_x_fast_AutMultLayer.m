function HMD_x_fast_AutMultLayer(M,x0,y0,z0,freq,what)
%
% function HMD_x_fast_AutMultLayer(M,x0,y0,z0,freq,what)
%
% The function implements the horizontal magnetic dipole (along the
% x-axis) and shows Hz and Hx on the plane zx, i.e. for y=0. The script
% allows to set a wanted value of multiple layers, with their own eps, mu,
% sigma and position (see the LAYERS PARAMETERS section below).
%
% Typical call --> HMD_x_fast_AutMultLayer(1,0,0,0.3,1e9,3);
%
% INPUT
%   M = M*l, impulsive value of the magnetic dipole [A*m^2]
%   x0,y0,z0 = coordinates of the dipole [m]
%   f = frequency [Hz]
%   what = 1 --> only primary field
%          2 --> only secondary field
%          3 --> primary + secondary field
%
% OUTPUT
%   Hx(z,x) = Hx in the point with coordinates z and y
%   Hy(z,x) = Hy in the point with coordinates z and y
%   Hz(z,x) = Hz in the point with coordinates z and y
%
% By: L.Luini
% Release: 10.V.2010

%%%%%%%%%%%%%%%%%%%%%%%%%%%% LAYERS PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input all parameters of the media
er=[1 2 1];   % relative dielectric permettivity (EPSR)

mr=[1 1 1];   % relative magnetic permeability (MUR)

sigma=[0 0.0001 0];  % conductivity [S/m]: perfect dielectric --> 0

% position [m]: the first value of Zlay indicates the position of the
% dipole (it must be z0>0). The first discontinuity is in z=0
% (medium 1/medium2) and therefore the second value of Zlay indicates
% that (fixed). The third value of Zlay defines the discontinuity
% medium2/medium3 and so on. Layers are added in the z-negative direction,
% therefore Zlay must be a vector of decreasing negative numbers.
Zlay=[z0 0 -z0];

% last layer type: 1) indefinite dielectric or conductor --> 0
%                  2) PMC -->  1
%                  3) PEC --> -1
LastLay=0;   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


dk_int=0;   % imaginary part for integration path
Npt=500;   % number of points for each linear integration path
nkmed=6;   % for integration



Nl=length(er);   % number of layers

th=0.01;   % threshold for figure colours

delta=0.006;   % spatial sampling [m]
ns=200;   % number of samples in a semispace
x=[-ns*delta:delta:x0-delta x0+delta:delta:ns*delta];
y=zeros(1,2*ns);
z=[-ns*delta:delta:z0-delta z0+delta:delta:ns*delta];

if what==1|what==3
    disp(['Calculating primary field...'])
    clear J;
    J=find(z>=0);
    % primary field (only on plane xz, with z >= 0)
    for a=1:length(x)
        for c=1:length(J)
            H=MDexact(M,x0,y0,z0,x(a),0,z(J(c)),er(1),mr(1),sigma(1),freq);
            Hzp(J(c),a)=H(3,1);
            Hyp(J(c),a)=H(2,1);
            Hxp(J(c),a)=H(1,1);
        end
    end
    clear J;
    J=find(z<0);   % set to zero the space in the media where the dipole is NOT placed
    Hzp(J,:)=0;
    Hyp(J,:)=0;
    Hxp(J,:)=0;
    
    if what==1
        % plot results
        figure
        imagesc(x,z,abs(Hzp))
        colorbar
        set(gca,'Clim',[-th th])
        colorbar
        hold on;
        for q=2:Nl
            h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
            set(h,'Color','k')
        end
        xlabel('x [m]')
        ylabel('z [m]')
        set(gca,'YDir','normal')
        title('Primary field - abs(H_z)')

        figure
        imagesc(x,z,real(Hzp))
        colorbar
        set(gca,'Clim',[-th th])
        colorbar
        hold on;
        for q=2:Nl
            h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
            set(h,'Color','k')
        end
        xlabel('x [m]')
        ylabel('z [m]')
        set(gca,'YDir','normal')
        title('Primary field - real(H_z)')

        figure
        imagesc(x,z,abs(Hxp))
        colorbar
        set(gca,'Clim',[-th th])
        colorbar
        hold on;
        for q=2:Nl
            h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
            set(h,'Color','k')
        end
        xlabel('x [m]')
        ylabel('z [m]')
        set(gca,'YDir','normal')
        title('Primary field - abs(H_x)')

        figure
        imagesc(x,z,real(Hxp))
        colorbar
        set(gca,'Clim',[-th th])
        colorbar
        hold on;
        for q=2:Nl
            h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
            set(h,'Color','k')
        end
        xlabel('x [m]')
        ylabel('z [m]')
        set(gca,'YDir','normal')
        title('Primary field - real(H_x)')
    end
end

if what==2|what==3
    % secondary field (uses Fourier-Bessel transformation: reflection and
    % refraction on a dielectric surfaces) (only on plane xz)
    h=abs(z0);   % position of the dipole in z
    x=x-x0;   % shift dipole
    rho=abs(x);

    v0=2.997925e8;
    mu0=pi*4e-7;
    eps0=1/(v0^2*mu0);
    omega=2*pi*freq;
    eps=eps0*er;
    mu=mu0*mr;
    kq=omega^2.*mu.*(eps+i.*sigma/omega);
    lambda=real(1./(freq.*sqrt(mu.*eps)));
    kmed=real(sqrt(kq(2)));
    maxkrho=nkmed*kmed;
    % find krho for integration
%     [krho,dkrho]=linIntegr(0,maxkrho,Npt);
    [krho1,dkrho1]=linIntegr(0,kmed-i*dk_int,Npt);
    [krho2,dkrho2]=linIntegr(kmed-i*dk_int,maxkrho,Npt);
    krho=[krho1 krho2];
    dkrho=[dkrho1 dkrho2];
    disp(['Calculating secondary fields: integrating ',num2str(length(krho)),' waves...'])
        
    for q=1:Nl   % for all layers
        if real(er(q))<0&real(mr(q))<0
            if sigma(q)==0
                clear I;
                I=find(krho.^2<kq(q));
                kz(q,I)=-sqrt(kq(q)-krho(I).^2);
                clear I;
                I=find(krho.^2>kq(q));
                kz(q,I)=+sqrt(kq(q)-krho(I).^2);
            else
                kz(q,:)=-sqrt(kq(q)-krho.^2);
            end
        else
            kz(q,:)=sqrt(kq(q)-krho.^2);
        end
        yTE(q,:)=kz(q,:)./(omega.*mu(q));
        yTM(q,:)=(omega.*(eps(q)+i*sigma(q)/omega))./kz(q,:);
    end
    if LastLay==0   % the last layer is an indefinite dielectric/conductor
        gammaTEdx(Nl-1,:)=(yTE(end,:)-yTE(end-1,:))./(yTE(end,:)+yTE(end-1,:));
        gammaTMdx(Nl-1,:)=(yTM(end,:)-yTM(end-1,:))./(yTM(end,:)+yTM(end-1,:));
    elseif LastLay==-1   % the last layer is a PEC (magnetic gamma=1)
        gammaTEdx(Nl-1,:)=ones(1,length(krho));
        gammaTMdx(Nl-1,:)=ones(1,length(krho));
    elseif LastLay==1   % the last layer is a PMC (magnetic gamma=-1)
        gammaTEdx(Nl-1,:)=-1.*ones(1,length(krho));
        gammaTMdx(Nl-1,:)=-1.*ones(1,length(krho));
    end
    for q=Nl-1:-1:2   % for all layers
        gammaTEsx(q,:)=gammaTEdx(q,:).*exp(i.*2.*kz(q,:).*(-(Zlay(q+1)-Zlay(q))));
        gammaTMsx(q,:)=gammaTMdx(q,:).*exp(i.*2.*kz(q,:).*(-(Zlay(q+1)-Zlay(q))));
        yTEL(q,:)=yTE(q,:).*(1+gammaTEsx(q,:))./(1-gammaTEsx(q,:));
        yTML(q,:)=yTM(q,:).*(1+gammaTMsx(q,:))./(1-gammaTMsx(q,:));
        gammaTEdx(q-1,:)=(yTEL(q,:)-yTE(q-1,:))./(yTEL(q,:)+yTE(q-1,:));
        gammaTMdx(q-1,:)=(yTML(q,:)-yTM(q-1,:))./(yTML(q,:)+yTM(q-1,:));
    end
    
    % functions common functions for fields
    KRHO=meshgrid(krho,ones(1,length(rho)));
    RHO=meshgrid(rho,ones(1,length(krho)));
    BES0=besselj(0,krho.'*rho);
    BES1=besselj(1,krho.'*rho);
    
    % reflected field for layer 1 (pay attention to Hz which behaves as Etg
    % --> gammaTE must be the one of E)
    clear J;
    J=find(z>=0);
    znow=z(J);
    
    % Hzs
    ApHzsDx=krho.^2.*exp(i*kz(1,:)*h).*dkrho;
    fk=ApHzsDx.*(-gammaTEdx(1,:));
    FK=meshgrid(fk,ones(1,length(znow)));
    Hzs(J,:)=-i*(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.')*kz(1,:)))*BES1;
    
    % HrhoTE
    ApHrhoTEDx=kz(1,:).*exp(i*kz(1,:)*h).*dkrho;
    fk=ApHrhoTEDx.*gammaTEdx(1,:);
    FK=meshgrid(fk,ones(1,length(znow)));
    HrhoTE(J,:)=-(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.')*kz(1,:)))*(KRHO.'.*BES0-BES1./RHO);    
    
    % HphiTE
    ApHphiTEDx=kz(1,:).*exp(i*kz(1,:)*h).*dkrho;;
    fk=ApHphiTEDx.*gammaTEdx(1,:);
    FK=meshgrid(fk,ones(1,length(znow)));
    HphiTE(J,:)=(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.')*kz(1,:)))*(BES1./RHO);
    
    % HrhoTM
    ApHrhoTMDx=(1./kz(1,:)).*exp(i*kz(1,:)*h).*dkrho;
    fk=ApHrhoTMDx.*gammaTMdx(1,:);
    FK=meshgrid(fk,ones(1,length(znow)));
    HrhoTM(J,:)=-(M*kq(1))/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.')*kz(1,:)))*(BES1./RHO);
    
    % HphiTM
    ApHphiTMDx=(1./kz(1,:)).*exp(i*kz(1,:)*h).*dkrho;
    fk=ApHphiTMDx.*gammaTMdx(1,:);
    FK=meshgrid(fk,ones(1,length(znow)));
    HphiTM(J,:)=(M*kq(1))/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.')*kz(1,:)))*(KRHO.'.*BES0-BES1./RHO);    
    
    for q=2:Nl-1   % progressive and regressive fields for layers 2 --> N-1
        clear J;
        J=find(z<Zlay(q)&z>=Zlay(q+1));
        znow=z(J);
        
        % Hzs
        ApHzsSx=ApHzsDx.*(mu(q-1)./mu(q)).*(1-gammaTEdx(q-1,:))./(1-gammaTEsx(q,:));
        FK=meshgrid(ApHzsSx,ones(1,length(znow)));
        Hzs(J,:)=-i*(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(q))*kz(q,:)))*BES1;
        
        ApHzsDx=ApHzsSx.*exp(i*kz(q,:)*abs(Zlay(q+1)-Zlay(q)));
        AmHzsDx=ApHzsDx.*(-gammaTEdx(q,:));
        FK=meshgrid(AmHzsDx,ones(1,length(znow)));
        Hzs(J,:)=Hzs(J,:)-i*(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(q+1))*kz(q,:)))*BES1;
        
        % HrhoTE
        ApHrhoTESx=ApHrhoTEDx.*(1+gammaTEdx(q-1,:))./(1+gammaTEsx(q,:));
        FK=meshgrid(ApHrhoTESx,ones(1,length(znow)));
        HrhoTE(J,:)=-(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(q))*kz(q,:)))*(KRHO.'.*BES0-BES1./RHO);
        
        ApHrhoTEDx=ApHrhoTESx.*exp(i*kz(q,:)*abs(Zlay(q+1)-Zlay(q)));
        AmHrhoTEDx=ApHrhoTEDx.*gammaTEdx(q,:);
        FK=meshgrid(AmHrhoTEDx,ones(1,length(znow)));
        HrhoTE(J,:)=HrhoTE(J,:)-(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(q+1))*kz(q,:)))*(KRHO.'.*BES0-BES1./RHO);

        % HphiTE
        ApHphiTESx=ApHphiTEDx.*(1+gammaTEdx(q-1,:))./(1+gammaTEsx(q,:));
        FK=meshgrid(ApHphiTESx,ones(1,length(znow)));
        HphiTE(J,:)=(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(q))*kz(q,:)))*(BES1./RHO);
        
        ApHphiTEDx=ApHphiTESx.*exp(i*kz(q,:)*abs(Zlay(q+1)-Zlay(q)));
        AmHphiTEDx=ApHphiTEDx.*gammaTEdx(q,:);
        FK=meshgrid(AmHphiTEDx,ones(1,length(znow)));
        HphiTE(J,:)=HphiTE(J,:)+(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(q+1))*kz(q,:)))*(BES1./RHO);

        % HrhoTM
        ApHrhoTMSx=ApHrhoTMDx.*(1+gammaTMdx(q-1,:))./(1+gammaTMsx(q,:));
        FK=meshgrid(ApHrhoTMSx,ones(1,length(znow)));
        HrhoTM(J,:)=-(M*kq(1))/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(q))*kz(q,:)))*(BES1./RHO);
        
        ApHrhoTMDx=ApHrhoTMSx.*exp(i*kz(q,:)*abs(Zlay(q+1)-Zlay(q)));
        AmHrhoTMDx=ApHrhoTMDx.*gammaTMdx(q,:);
        FK=meshgrid(AmHrhoTMDx,ones(1,length(znow)));
        HrhoTM(J,:)=HrhoTM(J,:)-(M*kq(1))/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(q+1))*kz(q,:)))*(BES1./RHO);

        % HphiTM
        ApHphiTMSx=ApHphiTMDx.*(1+gammaTMdx(q-1,:))./(1+gammaTMsx(q,:));
        FK=meshgrid(ApHphiTMSx,ones(1,length(znow)));
        HphiTM(J,:)=(M*kq(1))/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(q))*kz(q,:)))*(KRHO.'.*BES0-BES1./RHO);
        
        ApHphiTMDx=ApHphiTMSx.*exp(i*kz(q,:)*abs(Zlay(q+1)-Zlay(q)));
        AmHphiTMDx=ApHphiTMDx.*gammaTMdx(q,:);
        FK=meshgrid(AmHphiTMDx,ones(1,length(znow)));
        HphiTM(J,:)=HphiTM(J,:)+(M*kq(1))/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(q+1))*kz(q,:)))*(KRHO.'.*BES0-BES1./RHO);
    end
    
    % only progressive field in the last layer
    clear J;
    J=find(z<Zlay(end));
    znow=z(J);
    
    if LastLay==1|LastLay==-1
        Hzs(J,:)=0;
        HrhoTE(J,:)=0;
        HphiTE(J,:)=0;
        HrhoTM(J,:)=0;
        HphiTM(J,:)=0;
    else
        % Hzs
        ApHzsSx=ApHzsDx.*(mu(end-1)./mu(end)).*(1-gammaTEdx(end,:));
        FK=meshgrid(ApHzsSx,ones(1,length(znow)));
        Hzs(J,:)=-i*(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(end))*kz(end,:)))*BES1;

        % HrhoTE
        ApHrhoTESx=ApHrhoTEDx.*(1+gammaTEdx(end,:));
        FK=meshgrid(ApHrhoTESx,ones(1,length(znow)));
        HrhoTE(J,:)=-(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(end))*kz(end,:)))*(KRHO.'.*BES0-BES1./RHO);

        % HphiTE
        ApHphiTESx=ApHphiTEDx.*(1+gammaTEdx(end,:));
        FK=meshgrid(ApHphiTESx,ones(1,length(znow)));
        HphiTE(J,:)=(M)/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(end))*kz(end,:)))*(BES1./RHO);

        % HrhoTM
        ApHrhoTMSx=ApHrhoTMDx.*(1+gammaTMdx(end,:));
        FK=meshgrid(ApHrhoTMSx,ones(1,length(znow)));
        HrhoTM(J,:)=-(M*kq(1))/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(end))*kz(end,:)))*(BES1./RHO);

        % HphiTM
        ApHphiTMSx=ApHphiTMDx.*(1+gammaTMdx(end,:));
        FK=meshgrid(ApHphiTMSx,ones(1,length(znow)));
        HphiTM(J,:)=(M*kq(1))/(4*pi*omega*mu(1)).*(FK.*exp(i*abs(znow.'-Zlay(end))*kz(end,:)))*(KRHO.'.*BES0-BES1./RHO);
    end
    
    % sinphi and cosphi dependence
    cosphi=x./rho;
    COSPHI=meshgrid(cosphi,ones(1,length(z)));
    sinphi=y./rho;
    SINPHI=meshgrid(sinphi,ones(1,length(z)));
    
    Hzs=COSPHI.*Hzs;
    HrhoTE=COSPHI.*HrhoTE;
    HphiTE=SINPHI.*HphiTE;
    HrhoTM=COSPHI.*HrhoTM;
    HphiTM=SINPHI.*HphiTM;
    
    % Hxs and Hys
    Hxs=((HrhoTM+HrhoTE).*COSPHI)-((HphiTM+HphiTE).*SINPHI);
    Hys=((HrhoTM+HrhoTE).*SINPHI)+((HphiTM+HphiTE).*COSPHI);
    
    x=x+x0;   % shift dipole back
    % plot results
    figure
    imagesc(x,z,abs(Hzs))
    colorbar
    hold on;
    for q=2:Nl
        h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
        set(h,'Color','k')
    end
    xlabel('x [m]')
    ylabel('z [m]')
    set(gca,'YDir','normal')
    title('Secondary field - abs(H_z)')

    figure
    imagesc(x,z,real(Hzs))
    colorbar
    set(gca,'Clim',[-th th])
    colorbar
    hold on;
    for q=2:Nl
        h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
        set(h,'Color','k')
    end
    xlabel('x [m]')
    ylabel('z [m]')
    set(gca,'YDir','normal')
    title('Secondary field - real(H_z)')

    figure
    imagesc(x,z,abs(Hxs))
    colorbar
    set(gca,'Clim',[-th th])
    colorbar
    hold on;
    for q=2:Nl
        h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
        set(h,'Color','k')
    end
    xlabel('x [m]')
    ylabel('z [m]')
    set(gca,'YDir','normal')
    title('Secondary field - abs(H_x)')

    figure
    imagesc(x,z,real(Hxs))
    colorbar
    set(gca,'Clim',[-th th])
    colorbar
    hold on;
    for q=2:Nl
        h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
        set(h,'Color','k')
    end
    xlabel('x [m]')
    ylabel('z [m]')
    set(gca,'YDir','normal')
    title('Secondary field - real(H_x)')
end

if what==3
    % sum fields
    Hzt=Hzp+Hzs;
    Hxt=Hxp+Hxs;
    
    % plot results
    figure
    imagesc(x,z,abs(Hzt))
    colorbar
    set(gca,'Clim',[-th th])
    colorbar
    hold on;
    for q=2:Nl
        h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
        set(h,'Color','k')
    end
    xlabel('x [m]')
    ylabel('z [m]')
    set(gca,'YDir','normal')
    title('Total field - abs(H_z)')

    figure
    imagesc(x,z,real(Hzt))
    colorbar
    set(gca,'Clim',[-th th])
    colorbar
    hold on;
    for q=2:Nl
        h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
        set(h,'Color','k')
    end
    xlabel('x [m]')
    ylabel('z [m]')
    set(gca,'YDir','normal')
    title('Total field - real(H_z)')

    figure
    imagesc(x,z,abs(Hxt))
    colorbar
    set(gca,'Clim',[-th th])
    colorbar
    hold on;
    for q=2:Nl
        h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
        set(h,'Color','k')
    end
    xlabel('x [m]')
    ylabel('z [m]')
    set(gca,'YDir','normal')
    title('Total field - abs(H_x)')

    figure
    imagesc(x,z,real(Hxt))
    colorbar
    set(gca,'Clim',[-th th])
    colorbar
    hold on;
    for q=2:Nl
        h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
        set(h,'Color','k')
    end
    xlabel('x [m]')
    ylabel('z [m]')
    set(gca,'YDir','normal')
    title('Total field - real(H_x)')
    
    % movie
    risp=input('Movie? [1-->YES, 0-->NO] ');
    if risp==1
        close all;
        tv=[0.1:0.05:1]/freq;
        for p=1:length(tv)
            t=tv(p);
            Field=Hxt.*exp(-i.*omega.*t);
            k=figure;
            imagesc(x,z,real(Field))
            colorbar
            set(gca,'Clim',[-th th])
            set(gca,'FontSize',12)
            set(gcf,'Color',[1 1 1])
            colorbar
            hold on;
            for q=2:Nl
                h=line([x(1) x(end)],[Zlay(q) Zlay(q)]);
                set(h,'Color','k')
            end
            xlabel('x [m]')
            ylabel('z [m]')
            set(gca,'YDir','normal')
            title('Total field')
            gif_add_frame(gcf,'Dipole.gif',5);
            Frame(p)=getframe;
            close(k)
        end
        movie(Frame,10,8);
        risp=input('Play again? [1-->YES, 0-->NO] ');
        while risp==1
            movie(Frame,10,8);
            risp=input('Play again? ');
        end
        close all
    end
end

return


function [z,deltaz]=linIntegr(a,b,N)

% a = starting point
% b = ending point
% N = number of pooints

dz=(b-a)/N;

zp=a+dz*[0:N];   % get delta z
z=(zp(1:N)+zp(2:(N+1)))/2;   % get mean points where the function has to be evaluated

deltaz=diff(zp);
return


function out=sqrt2(in,what)

% The script accounts for the branch cut crossing

% in: complex number in input
% what: 0 --> ordinary material (real(in) & imag(in) must be > 0)
%       1 --> ordinary material (real(in) & imag(in) must be < 0)

if what==0
    I=find(imag(in)<0);
    out=in;
    out(I)=-out(I);
elseif what==1
    I=find(imag(in)>0);
    out=in;
    out(I)=-out(I);
end
return


% GIF_ADD_FRAME: adds a current figure snapshot to a gif animation
%
% SYNTAX
%   gif_add_frame(h,filename,fps,...)
% 
% INPUT:
%   - h:        handle to the axis that you want to take the snapshot from (use gca)
%   - filename: filename of gif to create or append frames to
%   - fps:      the number of frame per seconds the gif is gonna be displayed at (OPTIONAL)
%   - ...:      any other GIF arguement you might require to have
%               (NOT ONE OF: 'delaytime', 'loopcount' or 'writemode')
% 
% OUTPUT:
% If a file with name 'filename' exist, a frame from the axis 'h' is taken 
% and added to the movie, otherwise, a new gif-movie is created.
% 
% EXAMPLE:
% The following script creates some 3D surface data and rotates view 
% recording every rotation in a GIF frame in the file. The file can 
% be opened with any web-browser for inspection.
%  
% >> clc, clear, close all;
% >> % create data
% >> k = 5;
% >> n = 2^k-1;
% >> [x,y,z] = sphere(n);
% >> c = hadamard(2^k);
% >> h=surf(x,y,z,c);
% >> colormap([1  1  0; 0  1  1])
% >> axis equal
% >> % change view angle and record
% >> for i=1:50
% >>    rotate(h,[0 0 1],1);
% >>    gif_add_frame(gca,'video.gif');
% >> end
%
% See also:
% IMWRITE
%

% Copyright (c) 2008 Andrea Tagliasacchi
% All Rights Reserved
% email: ata2@cs.sfu.ca 
% $Revision: 1.0$  Created on: 2008/09/11
function gif_add_frame(h,filename,fps,varargin)

% default argument - fps
if ~exist('fps','var') || isempty(fps)
    fps = 25;
end

% retrieve the frame
A = getframe(h);
% convert it in a colormap
[IND, map] = rgb2ind(A.cdata(:,:,:),256);

% crete if needed or just append if exist already
if ~exist(filename,'file')
    imwrite(IND,map,filename,'gif','WriteMode','overwrite','delaytime',1/fps,'LoopCount',inf, varargin{:});
else
    imwrite(IND,map,filename,'gif','WriteMode','append','delaytime',1/fps,varargin{:});    
end
return
