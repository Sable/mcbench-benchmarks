%this is an example, demonstrating a Radial Basis Function method of vector
%acoustic tomography, using acoustic time-of-flight tomography as an
%example.
%This involves sending a sonic signal across a measurement area and timing
%how long it takes to travel.  A number of transducers are situated around
%the measurement area to achieve this.  Since the absolute sonic speed is
%effected by temperature and wind speed, so is the time of flight.  It is
%possible to reconstruct the temperature and wind velocity from the
%collection of time-of-flight data.
%For more information, please see ref [1] or http://blog.nutaksas.com
%
%References
%Wiens, Travis "Sensing of Turbulent Flows Using Real-Time Acoustic 
%Tomography." X1Xth Biennial Conference of the NewZealand Acoustical 
%Society, 2008.

%    Copyright Travis Wiens 2008
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%    If you would like to request that this software be licensed under a less
%    restrictive license (i.e. for commercial closed-source use) please
%    contact Travis at travis.mlfx@nutaksas.com

N_xd=16;%number of transducers
sig_dt=1e-6;%(s) std of error to add to dt
N_r=25;%number of radial basis functions
    
recalculate=true;%set this to false to skip recalculating
rbf_data_fname='gerris_rbf_data.mat';
if recalculate
    
    fprintf('Calculating forward problem...')
    gerris_fname='simsave-5.0.gfs';
    %this data was calculated using the Gerris Flow Solver
    %(http:gfs.sourceforge.net), from the Karman vortex street example
    
    %since Gerris data is not regular, we'll fit a RBF to the temperature
    %and velocity data, then use that to calculate the flight times
    data=load(gerris_fname);%load [x y z u v]

    N_rbf_f=300;%number of rbf centers for forward problem
    X_scale=10;%rescale data
    Sc_G=[3 3]*X_scale;%scale factor for gerris
    OS_G=[1 0];%(m) offset for gerris data

    X_limits=[-2 2;-2 2]*X_scale;%limits for training
    Xc_fu=[X_limits(1,1)+diff(X_limits(1,:))*rand(1,N_rbf_f);X_limits(2,1)+diff(X_limits(2,:))*rand(1,N_rbf_f)]';%model rbf centres
    Xc_fv=[X_limits(1,1)+diff(X_limits(1,:))*rand(1,N_rbf_f);X_limits(2,1)+diff(X_limits(2,:))*rand(1,N_rbf_f)]';
    Xc_fT=[X_limits(1,1)+diff(X_limits(1,:))*rand(1,N_rbf_f);X_limits(2,1)+diff(X_limits(2,:))*rand(1,N_rbf_f)]';

    x_G=(data(:,1)-OS_G(1))*Sc_G(1);%x for Gerris data
    y_G=(data(:,2)-OS_G(2))*Sc_G(2);%x for Gerris data
    U_idx=find((x_G>X_limits(1,1))&(x_G<X_limits(1,2))&(y_G>X_limits(2,1))&(y_G<X_limits(2,2)));
    x_G=x_G(U_idx);
    y_G=y_G(U_idx);

    k_fu=1*ones(N_rbf_f,1)/X_scale^2;%prescalar
    k_fv=1*ones(N_rbf_f,1)/X_scale^2;
    k_fT=4*ones(N_rbf_f,1)/X_scale^2;
    k_fu(1)=0;%allow for bias
    k_fv(1)=0;
    k_fT(1)=0;

    u0=mean(data(U_idx,4));%(m/s) base velocity
    v0=mean(data(U_idx,5));%(m/s) base velocity
    T=293+data(U_idx,6);%(K)  temperature
    T0=mean(T);%(K) base temperature
    [W_fu]=train_rbf([x_G y_G],data(U_idx,4)-u0,Xc_fu,k_fu);
    [W_fv]=train_rbf([x_G y_G],data(U_idx,5)-v0,Xc_fv,k_fv);
    [W_fT]=train_rbf([x_G y_G],T-T0,Xc_fT,k_fT);

    %set up transducers in a square
    N_dim=2;%number of dimensions
    X_xd=zeros(N_xd,N_dim);%XD positions
    phi=linspace(0,2*pi,N_xd+1);%angle of XD
    phi=phi+0.01*randn(size(phi));%move the xducers a bit
    r_xd=1*X_scale;%radius of circle inscribed in square
    X_xd_c=mean(X_limits,2)';%centre of circle
    for i=1:N_xd;
        if abs(tan(phi(i)))<1%intersects with verical lines
            X_xd(i,:)=X_xd_c+r_xd*[sign(cos(phi(i))) tan(phi(i))*sign(cos(phi(i)))];%set XD on a square
        else
            X_xd(i,:)=X_xd_c+r_xd*[ sign(sin(phi(i)))*tan(phi(i)).^-1 sign(sin(phi(i)))];%set XD on a square
        end
    end

    %now calculate pairs of XD to make paths
    X_xd0=[];
    X_xd1=[];
    idx=[];
    count=1;
    for i=1:N_xd
        for j=1:N_xd
            if i~=j%ignore path from XD to itself
                X_xd0(count,:)=X_xd(i,:);
                X_xd1(count,:)=X_xd(j,:);
                idx(count,:)=[i j];
                count=count+1;
            end
        end
    end
    N_paths=count-1;%number of paths

    X_limits_plot=(repmat(X_xd_c,2,1)+[-r_xd -r_xd;+r_xd +r_xd])';%limits to plot
    N_plot1=[25 25];%number of points to plot [x y]
    x_plot1=linspace(X_limits_plot(1,1),X_limits_plot(1,2),N_plot1(1))';
    y_plot1=linspace(X_limits_plot(2,1),X_limits_plot(2,2),N_plot1(2))';
    [x_mesh1 y_mesh1]=meshgrid(x_plot1,y_plot1);
    X_plot1=[reshape(x_mesh1,[],1) reshape(y_mesh1,[],1)];

    N_plot2=[100 100];%%higher resolution
    x_plot2=linspace(X_limits_plot(1,1),X_limits_plot(1,2),N_plot2(1))';
    y_plot2=linspace(X_limits_plot(2,1),X_limits_plot(2,2),N_plot2(2))';
    [x_mesh2 y_mesh2]=meshgrid(x_plot2,y_plot2);
    X_plot2=[reshape(x_mesh2,[],1) reshape(y_mesh2,[],1)];

    [u_rbf]=sim_rbf(Xc_fu,X_plot1,W_fu,k_fu);%simulate rbf fields
    [v_rbf]=sim_rbf(Xc_fv,X_plot1,W_fv,k_fv);
    [T_rbf]=sim_rbf(Xc_fT,X_plot1,W_fT,k_fT);

    [u_rbf2]=sim_rbf(Xc_fu,X_plot2,W_fu,k_fu);
    [v_rbf2]=sim_rbf(Xc_fv,X_plot2,W_fv,k_fv);
    [T_rbf2]=sim_rbf(Xc_fT,X_plot2,W_fT,k_fT);

    %calculate flight times analytically from RBF networks
    c0=340;%(m/s) sonic speed
    
    u_int=rbfn_integral(Xc_fu,X_xd0,X_xd1,W_fu,k_fu);%line integrals across rbfn
    v_int=rbfn_integral(Xc_fv,X_xd0,X_xd1,W_fv,k_fv);
    T_int=rbfn_integral(Xc_fT,X_xd0,X_xd1,W_fT,k_fT);
    theta=atan2(X_xd1(:,2)-X_xd0(:,2),X_xd1(:,1)-X_xd0(:,1));%(rad) angle of lines
    l=sqrt(sum((X_xd1-X_xd0).^2,2));%(m) path length
    dt0=l./c0.*(1-(u0*cos(theta)+v0*sin(theta))/c0)-...
            1/c0*(T_int/(2*T0)+u_int.*cos(theta)/c0+v_int.*sin(theta)/c0);%(s) time of flight
    
    save(rbf_data_fname,'dt0','l','theta','c0','T0','u_rbf','v_rbf','T_rbf','u_rbf2','v_rbf2','T_rbf2','X_plot1',...
        'X_plot2','x_plot1','x_plot2','y_plot1','y_plot2','N_plot1','N_plot2','N_paths','N_dim','X_xd','X_xd0',...
        'X_xd1','r_xd','u0','v0','X_xd_c','X_limits','X_scale','X_limits_plot')
    fprintf('done\n')
else
    load(rbf_data_fname)
end



%%%%%%%%%%%%%
%%%%%%%%%%%
%inversion
%%%%%%%%%%
%%%%%%%%%%%%

fprintf('Initializing inversion...')

basisfunction='gaussian';
k_scale=1/X_scale^2;%prescaler for basis function
alpha_scale=1.0e-6;%parameter for regularization alpha

dt=dt0+sig_dt*randn(size(dt0));%add noise to time of flight measurements

Xc_i=[X_limits(1,1)+diff(X_limits(1,:))*rand(1,N_r);X_limits(2,1)+diff(X_limits(2,:))*rand(1,N_r)]';%inversion rbf centres
k_i=k_scale*ones(N_r,1);
Omegapsi=Omegapsi_rbf(Xc_i,X_xd0,X_xd1,k_i,c0,basisfunction);
OmegaT=rbf_integral(Xc_i,X_xd0,X_xd1,k_i,basisfunction )/(c0*2*T0);
Omega=[OmegaT Omegapsi];
alpha_reg=alpha_scale*norm(Omega'*Omega);%regulatization parameter
A_rbf=pinv(Omega'*Omega+alpha_reg*eye(size(Omega,2)))*Omega';%solve!

%calculate matrices to get fields from weights
[zeta_u1 zeta_v1]=zeta_uv(Xc_i,X_plot1,k_i,basisfunction);
[zeta_u2 zeta_v2]=zeta_uv(Xc_i,X_plot2,k_i,basisfunction);
W_T_tmp=zeros(N_r,1);%placeholder 
[tmp zeta_T1]=sim_rbf(Xc_i,X_plot1,W_T_tmp,k_i,basisfunction);
[tmp zeta_T2]=sim_rbf(Xc_i,X_plot2,W_T_tmp,k_i,basisfunction);

fprintf('done\n')

fprintf('Solving for weights...')
d_rbf=-dt+l/c0.*(1-(u0*cos(theta)+v0*sin(theta))/c0);%data vector
W=A_rbf*d_rbf;%weights
W_T=W(1:N_r);
W_U=W((N_r+1):end);
fprintf('done\n')



fprintf('Calculating fields...')
%calculate fields
u_hat1=zeta_u1*W_U;
v_hat1=zeta_v1*W_U;
u_hat2=zeta_u2*W_U;
v_hat2=zeta_v2*W_U;
T_hat1=zeta_T1*W_T;
T_hat2=zeta_T2*W_T;
fprintf('done\n')


EU_rms=sqrt(mean((u_rbf2-u_hat2).^2+(v_rbf2-v_hat2).^2));
ET_rms=sqrt(mean((T_rbf2-T_hat2).^2));


fprintf('EU_rms=%f m/s ET_rms=%f K\n',EU_rms,ET_rms)
fprintf('Cond(Omega^T*Omega)=%0.2e, Cond(Omega^T*Omega+alpha*eye)=%0.2e\n',cond(Omega'*Omega),cond(Omega'*Omega+alpha_reg*eye(size(Omega,2))))
fprintf('%d data, %d parameters, ratio=%f\n',size(Omega,1),size(Omega,2),size(Omega,2)/size(Omega,1))



figure(1)
clim=[min([T_rbf2; T_hat2]) max([T_rbf2; T_hat2])];
clf
subplot(2,1,1)
plot(nan,nan)
hold on
imagesc(x_plot2,y_plot2,reshape(T_rbf2,N_plot2(1),[]),clim)
plot([X_xd0(:,1) X_xd1(:,1)]',[X_xd0(:,2) X_xd1(:,2)]','wx:')
hold off
h=colorbar;
ylabel(h,'dT (K)')
axis tight
xlabel('x (m)')
ylabel('y (m)')
title('Target')

subplot(2,1,2)
plot(nan,nan)
hold on
imagesc(x_plot2,y_plot2,reshape(T_hat2,N_plot2(1),[]),clim)
plot([X_xd0(:,1) X_xd1(:,1)]',[X_xd0(:,2) X_xd1(:,2)]','wx:')
hold off
h=colorbar;
ylabel(h,'dT_{hat} (K)')
axis tight
xlabel('x (m)')
ylabel('y (m)')
title('Reconstruction')

figure(2)
plot(nan,nan)
hold on
imagesc(x_plot2,y_plot2,reshape(sqrt((T_hat2-T_rbf2).^2),N_plot2(1),[]))
%plot([X_xd0(:,1) X_xd1(:,1)]',[X_xd0(:,2) X_xd1(:,2)]','kx-')
hold off
h=colorbar;
ylabel(h,'RMSE (K)')
axis tight
xlabel('x (m)')
ylabel('y (m)')

figure(3)
plot(nan,nan)
hold on
imagesc(x_plot2,y_plot2,reshape(sqrt((u_hat2-u_rbf2).^2+(v_hat2-v_rbf2).^2),N_plot2(1),[]))
h=colorbar;
h1=quiver(x_plot1,y_plot1,reshape(u_rbf,N_plot1(1),[]),reshape(v_rbf,N_plot1(1),[]),'k');
h2=quiver(x_plot1,y_plot1,reshape(u_hat1,N_plot1(1),[]),reshape(v_hat1,N_plot1(1),[]));
hold off
axis tight
xlabel('x (m)')
ylabel('y (m)')
ylabel(h,'E (m/s)')
legend([h1;h2],'Target','Reconstruction')
