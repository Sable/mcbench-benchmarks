function vgc_plot(k,kstar,v,Polc,g, METHOD)
% plot the value function against k 
% plot capital policy for next period against captial this period 
% save variable
% input is the k vector, optimal-- kstar, value --v, capital policy - g
% METHOD=1 if deterministic noninterpolation
% Method=2----Deterministic, continuous state space model, With interpolation
gstar=ppval(spline(k,g),kstar);  % g value at optimal kstar
vstar=ppval(spline(k,v),kstar);  % v value at optimal kstar

T=char( ' No Interpolation, Deterministic',...
        ' With Interpolation, Deterministic');

figure(1);
plot(k,v); hold on; 
plot(kstar,vstar,'ro'); 
text(kstar+.1,vstar-.1,['k*=' num2str(kstar)]);
title(['Value Function--' T(METHOD,:)]);
xlabel('capital k');  ylabel('value');
axis square; hold off;
print('-dpsc',['ValFun' num2str(METHOD)]);

figure(2);
subplot(2,1,1); plot(k,Polc);
title('Policy Function-Consumption');
xlabel('Capital Kt');   ylabel('Consumption');

subplot(2,1,2); plot(k,g,k,k,'-'); hold on;
plot(kstar,gstar,'ro'); 
text(kstar+.1,gstar-.1,['g*=' num2str(gstar) '| k*=' num2str(kstar)]);
title('Policy Function-Capital');
xlabel('Capital Kt');   ylabel('Capital Next Period');
hold off;

print('-dpsc', ['PolFun' num2str(METHOD)]);
save(['growth' num2str(METHOD)]);
