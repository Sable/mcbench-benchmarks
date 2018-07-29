%The aim of this simple benchmark is to illustrate the interest of restarting
%Nelder-Mead locally, from the last solution found, until no improvement is
%reached (to a given accuracy).
%Moreover, it shows that fminsearch has great difficulties at minimizing
%the most simple, smooth quadractic, objective function used. But
%restarting it locally corrects that.
%On the other hand, Nick Higham implementation of Nelder-Mead works fine,
%and the accuracy reached is also further improved by restarting it
%locally. Note that it may still happen that fminsearch performs better on
%other problems.

%Anyhow in theory, amongst direct search methods, one should not use even
%the restarted NM but rather MADS (C. Audet, J.E. Dennis, S. Le Digabel), which has 
%guaranteed convergence even on non-smooth Clarke subdifferentiable objective functions.
%The restarted NM will also lead in practice to locally optimal solutions,
%although this is not theoretically guaranteed. It may fail in very
%particular of difficult situations. The reason for its good convergence
%properties in practice is that restarting it regenerates its search
%simplex and in the end many search directions are covered, which is a crude 
%alternative to the POLL step of MADS (which is the step ensuring
%convergence). So the restarted NM will perform well even on non-smooth or
%discontinuous objective functions (not illustrated with this benchmark, 
%other benchmarks are available on http://arxiv.org/abs/1104.5369).
%We put forward the restarted NM since it is easily available, and simple
%to use and will already work well enough in practice. But again, in
%theory, MADS should be used instead (to get a convergence certificate).

%For related works on optimization in systems and control, see the Matlab
%files http://www.mathworks.com/matlabcentral/fileexchange/33022 and
%http://www.mathworks.com/matlabcentral/fileexchange/33219 (and hyperlinked papers).

%Emile Simon, 18th october 2011

clear all
close all
clc

%Choice of the accuracies
precf = 10^-4;%'Objective' accuracy
precx = 10^-4;%'Simplex' accuracy
precs = 10^-4;%'Restarting' accuracy
Nmax = 20;%Number of variables tried% To be changed.
ntests = 10;%Number of tests for each N
disp = 0; %Turn to 1 to display the detail of the iterations of Nelder-Mead
if(disp==1) Disp = 'iter'; else Disp = 'off'; end

Objectif = @(x)sum(x.^2);%The objective function to be minimized, smooth quadratic. Perhaps the simplest objective function possible.
%func='sq';

options = optimset('TolF',precf,'TolX',precx,'MaxFunEvals',inf,'MaxIter',inf,'Display','off');%,'GradObj','on');%,'TolCon',precx

for s=2:Nmax
    for i =1:ntests

        x0=randn(s,1)./rand(s,1);%Difficult starting point

        tic
        [Sol1,Obj1(s,i)] = fminsearch(Objectif,x0,optimset('TolF',precf,'TolX',precx,'MaxFunEvals',inf,'MaxIter',inf,'Display',Disp));
        T1(s,i) = toc;

        acc = 1; Obj2(s,i) = Obj1(s,i); Sol2=Sol1;
        while (acc>precs)
            Objp(s,i) = Obj2(s,i);
            [Sol2,Obj2(s,i)] = fminsearch(Objectif,Sol2,optimset('TolF',precf,'TolX',precx,'MaxFunEvals',inf,'MaxIter',inf,'Display',Disp));
            acc = abs(abs(Objp(s,i)/Obj2(s,i))-1);
        end
        T2(s,i) = toc;

        %Nick Higham's implementation of Nelder-Mead
        tic
        [Sol3,Obj3(s,i),N3(s,i)]=nmsmax(@(x)-sum(x.^2),x0,[precx inf inf 0 disp]);
        T3(s,i) = toc;
        Obj3(s,i) = -Obj3(s,i);

        acc = 1; Obj4(s,i) = Obj3(s,i); Sol4=Sol3;
        while (acc>precs)
            Objp = Obj4(s,i);
            [Sol4,Obj4(s,i)] = nmsmax(@(x)-sum(x.^2),Sol4,[precx inf inf 0 disp]);
            T4(s,i)=toc;
            Obj4(s,i) = -Obj4(s,i);
            acc = Objp/Obj4(s,i)-1;
        end

        

    end
    s
end

figure
subplot(2,1,1)
semilogy(mean(Obj1'))
hold on
errorbar(mean(Obj1'),std(Obj1'))
errorbar(mean(Obj2'),std(Obj2'),'g')
errorbar(mean(Obj3'),std(Obj3'),'r')
errorbar(mean(Obj4'),std(Obj4'),'c')
legend('fminsearch','fminsearch','restarted fminsearch','nmsmax','restared nmsmax','Location','NorthWest')
title('Performance comparison of different versions of Nelder-Mead on \bf{min \Sigma_{i=1}^nx_i^2}')
ylabel('Avg. objective value')
subplot(2,1,2)
semilogy(mean(T1'))
hold on
errorbar(mean(T1'),std(T1'))
errorbar(mean(T2'),std(T2'),'g')
errorbar(mean(T3'),std(T3'),'r')
errorbar(mean(T4'),std(T4'),'c')
ylabel('Avg. computational time required (s)')
xlabel('Number of variables (n)')

