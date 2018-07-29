%this examples fits a simple neural network to the function 
%z= 0.5*sin(pi*y(1,:).^2).*sin(2*pi*y(2,:));

N_neurons=15;%number of neurons
N_in=2;%number of inputs

N_params=N_neurons*(N_in+2)+1;%number of parameters

N_pop_min=N_params+1;%minimum population

N_pop=round(N_pop_min*1.5);%population used

fcn_name='fitness_function';%name of function to maximize

bounds=[-20*ones(1,N_params); 20*ones(1,N_params)];

gen_max=100000;%number of times to evaluate fcn_name;

x_start=[];%let the complex function initialize the population randomly

fit_start=[];%let the complex funciton initialize the fitness;

fcn_opts.N_neurons=N_neurons;%this parameter is passed to the fitness function

%%%%%%%%%%%%crunch numbers!%%%%%%%%%%
tic;
[x_best, fit_best, x_pop, fit_pop stats]=complexmethod(fcn_name,bounds,gen_max,x_start,fit_start,fcn_opts);
timtoc=toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Total time=%f s. Time per generation=%f s\n',timtoc,timtoc/gen_max);
fprintf('Final RMSE=%f\n',-fit_best)

%%%%the rest is plotting results%%%%%%
figure(1)
loglog(-stats.trace_fitness,'.')
xlabel('Generation')
ylabel('RMSE')

N_p=10;%number of points in each dimension
y=[reshape(linspace(0,1,N_p)'*ones(1,N_p),1,[]);reshape((linspace(0,1,N_p)'*ones(1,N_p))',1,[])];%make mesh

N_in=size(y,1);
z= 0.5*sin(pi*y(1,:).^2).*sin(2*pi*y(2,:));

W1=reshape(x_best(1:N_neurons*N_in),N_neurons,N_in);%extract weights for first layer
B1=reshape(x_best((N_neurons*N_in+1):N_neurons*(N_in+1)),N_neurons,1);
W2=reshape(x_best((N_neurons*(N_in+1)+1):N_neurons*(N_in+2)),1,N_neurons);
B2=x_best(N_neurons*(N_in+2)+1);
z_hat=W2*(tanh(W1*y+B1*ones(1,size(y,2))))+B2; %neural calculation

figure(2);
clf
surf(linspace(0,1,N_p),linspace(0,1,N_p),reshape(z_hat,N_p,N_p));
shading interp;
hold on
plot3(y(2,:),y(1,:),z,'kx')
hold off

