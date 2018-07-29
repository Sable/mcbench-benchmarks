function coordl1bregdemo
%COORDL1BREGDEMO An example of using COORDL1BREG. 

% Construct A as a rand matrix.
N = 512*2;
M = N/2;
A = randn(M,N);

% Construct u_exact as a sparse vector. 
p = floor(0.05*N);
u_exact = zeros(N,1);
% u_exact has spikes at uniformly random locations with amplitudes
% distributed uniformly in [0,1]
a = randperm(N);
% u_exact(a(1:p)) = a(p+1:2*p)*0.08+5; % 0.08 + 5
u_exact(a(1:p)) = rand(p,1)*N;  %randn is fast.

% Construct f = A*u_exact.
f = A*u_exact;

% Precompute B = A'*A. This step is not necessary.
B = A'*A;

% Initialize lambda. 
lambda = 10;

% Call the main function  COORDL1BREG.
[u,Energy] = coordl1breg(A,f,lambda,'B',B,'PlotFun',@myplotfun);

% Plot the Energy function.
figure(2);
semilogy(Energy,'.-');
xlabel('Iteration');
ylabel('Energy');

% COORDL1BREG will call this function every iteration to plot intermediate solutions.
% Show the comparison of the output u and u_exact.
    function myplotfun(u)

        figure(1);
        x = 1:length(u);
        plot(x,u,'.r',x,u_exact,'o');
        xlim([1,length(u)]);
    end

end

