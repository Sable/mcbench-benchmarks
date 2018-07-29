function [fitness x]=fitness_function(x, opts)
%example fitness function to fit a neural network surface to
%  z= 0.5*sin(pi*y(1,:).^2).*sin(2*pi*y(2,:));

if nargin<2
	N_neurons=5;
else
	N_neurons=opts.N_neurons;
end

N_p=10;%number of points in each dimension
y=[reshape(linspace(0,1,N_p)'*ones(1,N_p),1,[]);reshape((linspace(0,1,N_p)'*ones(1,N_p))',1,[])];%make mesh

N_in=size(y,1);

z= 0.5*sin(pi*y(1,:).^2).*sin(2*pi*y(2,:));

W1=reshape(x(1:N_neurons*N_in),N_neurons,N_in);%extract weights for first layer
B1=reshape(x((N_neurons*N_in+1):N_neurons*(N_in+1)),N_neurons,1);
W2=reshape(x((N_neurons*(N_in+1)+1):N_neurons*(N_in+2)),1,N_neurons);
B2=x(N_neurons*(N_in+2)+1);


z_hat=W2*(tanh(W1*y+B1*ones(1,size(y,2))))+B2; %neural calculation

E=sqrt(mean((z-z_hat).^2));%root mean squared error

fitness=-E;%minimize error by maximizing fitness
