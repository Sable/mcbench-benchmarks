%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BPSO and VPSO source codes version 1.0                           %
%                                                                   %
%  Developed in MATLAB R2011b(7.13)                                 %
%                                                                   %
%  Author and programmer: Seyedali Mirjalili                        %
%                                                                   %
%         e-Mail: ali.mirjalili@gmail.com                           %
%                 seyedali.mirjalili@griffithuni.edu.au             %
%                                                                   %
%       Homepage: http://www.alimirjalili.com                       %
%                                                                   %
%   Main paper: S. Mirjalili and A. Lewis, "S-shaped versus         %
%               V-shaped transfer functions for binary Particle     %
%               Swarm Optimization," Swarm and Evolutionary         %
%               Computation, vol. 9, pp. 1-14, 2013.                %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [o] = DrawConvergenceCurves(p,Max_iteration)

semilogy(p(1,(1:50:Max_iteration)),'DisplayName','BPSO1','Marker','+', 'Color', 'y');
hold on
semilogy(p(2,(1:50:Max_iteration)),'DisplayName','BPSO2','Marker','*', 'Color', 'm');
semilogy(p(3,(1:50:Max_iteration)),'DisplayName','BPSO3','Marker','x', 'Color', 'c');
semilogy(p(4,(1:50:Max_iteration)),'DisplayName','BPSO4','Marker','.', 'Color', 'g');
semilogy(p(5,(1:50:Max_iteration)),'DisplayName','BPSO5','Marker','v', 'Color', 'b');
semilogy(p(6,(1:50:Max_iteration)),'DisplayName','BPSO6','Marker','s', 'Color', 'k');
semilogy(p(7,(1:50:Max_iteration)),'DisplayName','BPSO7','Marker','d', 'Color', [1,0.5,0]);
semilogy(p(8,(1:50:Max_iteration)),'DisplayName','BPSO8','Marker','o', 'Color', 'r', 'Xdata', [1:10] );


set(gca, 'XTickMode', 'manual'); 
set(gca,'xtick',1:4.5:10);
set(gca,'XTickLabel',{'1','250','500'});

title(['\fontsize{12}\bf Convergence curves']);
 xlabel('\fontsize{12}\bf Iteration');ylabel('\fontsize{12}\bf Average Best-so-far');
 legend('\fontsize{10}\bf BPSO1','\fontsize{10}\bf BPSO2','\fontsize{10}\bf BPSO3'...
     ,'\fontsize{10}\bf BPSO4','\fontsize{10}\bf BPSO5','\fontsize{10}\bf BPSO6'...
     ,'\fontsize{10}\bf BPSO7','\fontsize{10}\bf BPSO8',1);
 grid on
 axis tight
 
end