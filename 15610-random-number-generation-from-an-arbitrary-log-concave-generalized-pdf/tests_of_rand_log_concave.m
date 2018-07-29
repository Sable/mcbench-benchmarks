
% below are tests of function "rand_log_concave.m"
disp(' ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIRST, we test standard beta distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set parameters of normal distribution x~normal(x; mean_par, variance_par)
mean_par=1;
variance_par=10;

% display information
disp(sprintf('Test of random draw from standard normal distribution x~normal(x; %g, %g)',...
             mean_par, variance_par));
disp(sprintf('   Theoretical Results: mean=%g, std=%g', mean_par, sqrt(variance_par)));

% run "rand_log_concave.m"
current_time_0=clock;
N=1e6;
a=mean_par-2*sqrt(variance_par);
b=mean_par+2*sqrt(variance_par);
[x, rate]=rand_log_concave('log_normal_pdf', [mean_par,variance_par], [-Inf,Inf], 100, [a,b], N);
x_mean=sum(x)/numel(x);
x_2moment=sum(x.^2)/numel(x);
x_std=sqrt(x_2moment-x_mean^2);
disp(sprintf('   Results from rand_log_concave(): N=%.0g, mean=%g, std=%g, std/sqrt(N)=%g',...
                          N, x_mean, x_std, x_std/sqrt(N)));
disp(sprintf('                                    acceptance_rate=%g, code execution time = %f',...
                          rate, etime(clock,current_time_0)));
disp(' ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SECOND, we test standard beta distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set parameters of beta-distribution x~betarnd(x; alpha, beta)
alpha=2;
beta=5;

% display information
disp(sprintf('Test of random draw from standard beta-distribution x~betarnd(x; %g, %g)',...
             alpha, beta));
disp(sprintf('   Theoretical Results: mean=%g, std=%g', alpha/(alpha+beta), ...
             sqrt(alpha*beta/((alpha+beta)^2*(alpha+beta+1)))));

% run "rand_log_concave.m"
current_time_0=clock;
N=1e6;
[x, rate]=rand_log_concave('log_beta_pdf', [alpha,beta], [0,1], 100, [0,1], N);
x_mean=sum(x)/numel(x);
x_2moment=sum(x.^2)/numel(x);
x_std=sqrt(x_2moment-x_mean^2);
disp(sprintf('   Results from rand_log_concave(): N=%.0g, mean=%g, std=%g, std/sqrt(N)=%g',...
             N, x_mean, x_std, x_std/sqrt(N)));
disp(sprintf('                                    acceptance_rate=%g, code execution time = %f',...
             rate, etime(clock,current_time_0)));
disp(' ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THIRD, we test truncated beta distribution with large values of parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set parameters of beta-distribution x~betarnd(x; alpha, beta) truncated to interval A<=x<=B
alpha=200;
beta=600;
A=0.3;
B=0.6;

% display information
disp(sprintf('Test of random draw from truncated beta-distribution x~betarnd(x; %g, %g), %g<=x<=%g',...
             alpha, beta, A, B));

% use betarnd()
current_time_0=clock;
x_mean=0;
x_2moment=0;
n_saved=0;
n_accept=0;
n_total=0;
N=3e3;
quit_flag=0;
while n_saved<N
  x=betarnd(alpha, beta, 1, 10000);
  n_total=n_total+10000;
  x=x(find(x>=A & x<=B));
  n=numel(x);
  n_accept=n_accept+n;
  if n>0
    n=min([n, N-n_saved]);
    x=x(1:n);
    x_mean=x_mean+sum(x);
    x_2moment=x_2moment+sum(x.^2);
    n_saved=n_saved+n;
  end
  if n_total>10000*N
    disp('   Acceptance rate in betarnd() is less than 0.01%, as a result, we quit');
    quit_flag=1;
    break;
  end
end
if quit_flag~=1
  N=n_saved;
  x_mean=x_mean/N;
  x_2moment=x_2moment/N;
  x_std=sqrt(x_2moment-x_mean^2);
  disp(sprintf('   Results from betarnd(): N=%.0g, mean=%g, std=%g, std/sqrt(N)=%g',...
               N, x_mean, x_std, x_std/sqrt(N)));
  disp(sprintf('                           acceptance_rate=%g, code execution time = %f',...
               n_accept/n_total, etime(clock,current_time_0)));
end

% run "rand_log_concave.m"
current_time_0=clock;
N=1e6;
[x, rate]=rand_log_concave('log_beta_pdf', [alpha,beta], [A,B], 100, [A,B], N);
x_mean=sum(x)/numel(x);
x_2moment=sum(x.^2)/numel(x);
x_std=sqrt(x_2moment-x_mean^2);
disp(sprintf('   Results from rand_log_concave(): N=%.0g, mean=%g, std=%g, std/sqrt(N)=%g',...
                          N, x_mean, x_std, x_std/sqrt(N)));
disp(sprintf('                                    acceptance_rate=%g, code execution time = %f',...
                          rate, etime(clock,current_time_0)));
disp(' ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

