%    Copyright Travis Wiens 2009 travis.mlfx@nutaksas.com

save_results=false;%set to true to save results

f_cpu=2.13e9;%CPU clock rate

method_names=strvcat('Parabola','Gaussian','Modified Gaussian','Cosine','Phase','Iterative');
method_functions=strvcat('k_d_hat(j,k,m)=delayest_3point(y1n,y0n,''parabola'',''xc'');',...
    'k_d_hat(j,k,m)=real(delayest_3point(y1n,y0n,''Gaussian'',''xc''));',...
    'k_d_hat(j,k,m)=delayest_3point(y1n,y0n,''modGaussian'',''xc'',alpha);',...
    'k_d_hat(j,k,m)=real(delayest_3point(y1n,y0n,''cosine'',''xc''));',...
    'k_d_hat(j,k,m)=delayest_fft(y1n,y0n);',...
    '[k_d_hat(j,k,m) N_i]=delayest_iterative(y1n,y0n);');
N_methods=size(method_names,1);%number of methods

N_p=2^8;%signal period

N_repeats=300;%number of repeats at each point

N_SNR=100;%number of SNR points to calculate
SNR_matrix=linspace(-5,25,N_SNR);%signal to noise ratio (dB)

N_fc=100;%number of cutoff frequency points to calculate
f_c_matrix=logspace(-2,log10(0.99),N_fc);%cutoff frequency (relative to Nyquist freq)


N_d=20;%number of delays to calculate at
d_matrix=linspace(-0.5,0.5,N_d+1);%delay values (samples)
d_matrix(end)=[];

sig_s=1;%signal std

N_prefilt=3;%number of times to run data to warm up filter
Nf=2;%filter order


alpha=-1;%tuning parameter for modified gaussian method 
%(only used in the case of negative xc if alpha is negative, otherwise
%always use it. See delayest_3point.m)

t_sum=zeros(1,N_methods);%total time elapsed
t_sumsq=zeros(1,N_methods);%total squared time elapsed

RMSE=zeros(N_SNR,N_fc,N_methods);%root mean squared error
MAE=zeros(N_SNR,N_fc,N_methods);%mean absolute error
MAE_std=zeros(N_SNR,N_fc,N_methods);%standard deviation in MAE
MSE_std=zeros(N_SNR,N_fc,N_methods);%standard deviation in MSE

N_i_sum=0;%total number of iterations
N_i_sumsq=0;%total squared number of iterations

E_zzb=zeros(N_SNR,N_fc);%ziv-zakai bound

for i1=1:N_SNR
    fprintf('SNR %d/%d\n',i1,N_SNR)
    sig_n=sig_s/(10^(SNR_matrix(i1)/20));
    for i2=1:N_fc

        fc=f_c_matrix(i2);%cutoff frequency
        
        [Bf,Af] = butter(Nf,fc);%coefficients for Butterworth filter


        u=[1 zeros(1,N_p-1)];%unit impulse
        U=fft(u);
        y=filter(Bf,Af,repmat(u,1,N_prefilt+1));%apply filter to u (including repetition for warmup)
        y=y((N_prefilt*N_p+1):end);%remove warmup
        G=fft(y)./fft(u);%filter ETFE
        k_d_hat=zeros(N_repeats,N_d,N_methods);%delay estimates
        for j=1:N_repeats
            yn1=sig_n*rand_white(N_p);%Gaussian white noise
            yn1=yn1-mean(yn1);
            yn0=sig_n*rand_white(N_p);%Gaussian white noise
            yn0=yn0-mean(yn0);
            u=rand_white(N_p);%input signal
            u=u-mean(u);
            y0=ifft(fft(u).*G);%input convolved with filter
            y_gain=sig_s/std(y0);%gain to bring y up to signal level
            y0=y0*y_gain;

            for k=1:N_d
                d=d_matrix(k);%delay

                y1=fft_circshift(y0,d);%perform circular shift

                y1n=y1+yn1;%add noise
                y0n=y0+yn0;

                for m=1:N_methods
                    t_start=tic;
                    eval(method_functions(m,:));%do estimation
                    dt=toc(t_start);%elapsed time
                    t_sum(m)=t_sum(m)+dt;
                    t_sumsq(m)=t_sumsq(m)+dt*dt;
                    k_d_hat(j,k,m)=mod(k_d_hat(j,k,m)+N_p/2,N_p)-N_p/2;%change from 0-N_p to -N_p/2:N_p/2
                end
                N_i_sum=N_i_sum+N_i;%sum number of iterations for iterative method
                N_i_sumsq=N_i_sumsq+N_i*N_i;
            end
        end
        for m=1:N_methods
            RMSE(i1,i2,m)=sqrt(mean(reshape((k_d_hat(:,:,m)-repmat(d_matrix,N_repeats,1)).^2,1,[])));%calculate error
            MAE(i1,i2,m)=mean(reshape(abs(k_d_hat(:,:,m)-repmat(d_matrix,N_repeats,1)),1,[]));
            MAE_std(i1,i2,m)=std(reshape(abs(k_d_hat(:,:,m)-repmat(d_matrix,N_repeats,1)),1,[]));
            MSE_std(i1,i2,m)=std(reshape((k_d_hat(:,:,m)-repmat(d_matrix,N_repeats,1)).^2,1,[]));
        end
        E_zzb(i1,i2)=zzb(y0,yn0,yn1)/2;%(half because it's circular correlation instead of xcorr)
    end
end


p=0.95;%Confidence
t_Eu=tinv(p,N_repeats*N_d-1);%Student's t
MAE_U=MAE_std*t_Eu/sqrt(N_repeats*N_d);%uncertainty in the mean absolute error
MSE_U=MSE_std*t_Eu/sqrt(N_repeats*N_d);%uncertainty in the mean squared error
MSE=sqrt(RMSE);
RMSE_U=MSE_U./(2*RMSE);

N_tot=N_SNR*N_fc*N_repeats*N_d;%total number of runs
t_mean=t_sum/N_tot;%mean elapsed time
t_std=sqrt(t_sumsq/N_tot-t_mean.^2);%standard deviation
t_tu=tinv(p,N_tot-1);%Student's t
t_U=t_std*t_tu/sqrt(N_tot);%uncertainty in t_mean

fprintf('Elapsed time:\n')
for i=1:N_methods
    fprintf('%s %f +/- %f us/chunk = %f +/- %f clocks/chunk\n',method_names(i,:), t_mean(i)*1e6,t_U(i)*1e6, t_mean(i)*f_cpu,t_U(i)*f_cpu)
end

N_i_mean=N_i_sum/N_tot;%mean number of iterations
N_i_std=sqrt(N_i_sumsq/N_tot-N_i_mean.^2);%standard deviation
N_i_U=N_i_std*t_tu/sqrt(N_tot);%uncertainty in mean
fprintf('Mean number of iterations =%f +/- %f std=%f\n',N_i_mean,N_i_U,N_i_std);

if save_results
dstring=datestr(now,30) ;
fname=['comparison_data_6_03_' dstring '.mat'];
save(fname,'*')
end


idx_best=zeros(N_SNR,N_fc);
possible_best=zeros(N_SNR,N_fc,N_methods);
probable_best=zeros(N_SNR,N_fc,N_methods);
for i=1:N_SNR
    for j=1:N_fc
        [tmp idx]=sort(squeeze(RMSE(i,j,:)),1,'ascend');
        idx_best(i,j)=idx(1);

        E_max=squeeze(RMSE(i,j,:)+RMSE_U(i,j,:));%Error plus confidence
        E_min=squeeze(RMSE(i,j,:)-RMSE_U(i,j,:));%Error minus confidence
        [E_max_s idx_max]=sort(E_max,1,'ascend');
        [E_min_s idx_min]=sort(E_min,1,'ascend');
        for m=1:N_methods
            possible_best(i,j,m)=E_min(m)-E_max_s(1);%this will be <0 if it is possibly the best
            probable_best(i,j,m)=E_max(m)-E_min_s(2);%this will be <0 if it is probably the best
        end
    end
end

figure(1)
clf
gray_colour=[0.7 0.7 0.7];
%cdepth=64;%colour depth
subplot(1,1,1)
for i=1:N_methods
    subplot(3,2,i)
    c_lim=[1-1e-2 max(max(RMSE(:,:,i)./E_zzb))];
    %colormap(flipud(hot(cdepth)))
    h=pcolor(f_c_matrix,SNR_matrix,20*log10(RMSE(:,:,i)./E_zzb));
    caxis(20*log10(c_lim));
    shading interp
    set(get(h,'Parent'),'XScale','log');
    set(get(h,'Parent'),'TickDir','Out');
    hold on
    contour(f_c_matrix,SNR_matrix,possible_best(:,:,i),[0 0],'color',gray_colour);
    contour(f_c_matrix,SNR_matrix,probable_best(:,:,i),[0 0],'k');
    hold off

    ylabel('SNR (db)')
    xlabel('f_c/f_n')
    title(method_names(i,:))
    h=colorbar;

    set(h,'TickDir','Out');
    ylabel(h,'E/E_{zzb} (dB)')
    axis([f_c_matrix(1) f_c_matrix(end) SNR_matrix(1) SNR_matrix(end)])
    set(gca, 'Layer', 'top')
end

fprintf('\nFigure 1 shows errors relative to Ziv Zakai lower bound.\nBlack lines enclose areas where the method is probably the best.\nGrey lines enclose areas where the method is possibly the best.\n')
