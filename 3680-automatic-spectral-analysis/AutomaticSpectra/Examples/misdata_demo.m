%misdata_demo

% S. de Waele, March 2003.

clear
close all

n_spec = 500;

disp('Model inference from measurements containing missing data.')
rca = [1 .4 -.4 .3 .3]
a = rc2arset(rca);
b = 1;
n_obs_org = 1000;
pm = .5;
rcinit = rca(2:end-1);
rc0 = 0;
p = length(a)-1;
lagmax = ceil(2*p/(1-pm)); %see Thesis, p. 154
Lmax = 10;

%Data generation
x_org = gendata(a,b,n_obs_org);
n = find(rand(1,n_obs_org) > pm);
if isempty(n)
   error('None used - try again.')
end
x = x_org(n);

figure
plot(1:n_obs_org,x_org,'x',n,x)

%Second data set
x_org2 = gendata(a,b,n_obs_org);
n2 = find(rand(1,n_obs_org) > pm);
if isempty(n2)
   error('None used - try again.')
end
x2 = x_org(n2);
n = {n n2};
x = {x x2};
n_obs = length(n{1})+length(n{2});

%Estimation
disp('Reference: ARsel on entire data-set')
arh = sig2ar(x_org);
me_using_all = moderr(arh,1,a,b,n_obs)

disp('sig2ar_misd')
[ar_sel, sell] = sig2ar_misd(n,x,Lmax,'pengic',8)
disp(['Selected: ' modeltype(ar_sel,1)])

%Calculate errors
me_sel = moderr(ar_sel,1,a,b,n_obs)
me_using_all
me_ars = [];
orders = 0:Lmax;
for t = 1:length(orders),
    me_ars(t) = moderr(sell.set_ar{t},1,a,b,n_obs);
end
disp(int2str([orders' me_ars' sell.klifit [NaN; diff(sell.klifit)]]))

figure
subplot(2,1,1)
plot(orders,me_ars)
title('Model error')
xlabel('p')
ylabel('ME')

subplot(2,1,2)
plot(orders,[sell.klifit sell.gic])
title('KLI-fit')
legend('KLI-fit',['GIC-' int2str(sell.pengic)])
xlabel('p')
ylabel('KLI')