function dum = plotpe(sellog)
% plotpe plots the information about the model accuracy
% that is stored in sellog
% The argument sellog is the name of the log file in ARMAsel
%

figure
plot(sellog.ar.cand_order,sellog.ar.pe_est)
title('Estimated model accuracies as a function of model order and type')
xlabel('\rightarrow model order \itr')
ylabel('\rightarrow normalized model accuracy')
minar=min(sellog.ar.pe_est); 
minma=min(sellog.ma.pe_est);
minarma=min(sellog.arma.pe_est); 
mints=min([minar,minma,minarma]);
as2=axis; 
as2(3)=.995*mints; 
as2(4)=1.01*sellog.ar.pe_est(end);
axis(as2);
hold on, 
plot(sellog.ma.cand_order,sellog.ma.pe_est,'r')
plot(sellog.arma.cand_ar_order,sellog.arma.pe_est,'g')
legend('AR(\itr\rm)','MA(\itr\rm)','ARMA(\itr,r\rm-1)',4), 
hold off 
