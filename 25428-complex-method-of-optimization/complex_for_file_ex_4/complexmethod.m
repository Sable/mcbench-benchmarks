function [x_best, fit_best, x_pop, fit_pop stats]=complexmethod(fcn_name,bounds,gen_max,x_start,fit_start,fcn_opts,complex_opts)
%[x_best, fit_best, x_pop, fit_pop stats]=complexmethod(fcn_name,bounds,gen_max,x_start,fit_start,fcn_opts,complex_opts)
%
% Implements the Complex Method of Contrained Optimization, as proposed by Box (1965), 
% improved by Guin (1968) and Krus (1992), and following the method in Andresson (2001). 
%
% Takes inputs of:
% fcn_name: string including a function to maximize.  This function must give outputs of
%   [fitness x] and take inputs of (x,fcn_opts)
% bounds: 2 by n_params matrix of the minimum and maximum bounds for each parameter
% gen_max; number of times to calculate fitness before stopping (this includes the 
%    initialization calculations if fit_start is not given
% x_start: a n_population by n_params matrix of initial parameters
% fit_start: a n_params vector of fitnesses of x_start params
% fcn_opts: a variable (or structure) that may be passed to the fcn_name function
% complex_opts: a variable including some options for the optimization (you probably won't need this)
%
% References
%
%Andersson J, "Multiobjective Optimization in Engineering Design - Application to fluid Power %Systems." Doctoral thesis, Division of Fluid and Mechanical Engineering Systems, Department %of Mechanical Engineering, Linkping University, 2001 %http://citeseer.ist.psu.edu/562279.html	
%
%Box, M.J., "A new method of constrained optimization and a comparison with other method," %Computer Journal, Vol. 8, No. 1, pp. 42-52, 1965.	
%	
%Guin J. A., "Modification of the Complex method of constraint optimization," Computer Jornal, %vol. 10, pp. 416-417, 1968. 32(34)
%
%KRUS P., JANSON A., PALMBERG J.-O., “Optimization Based on Simulation for Design of Fluid %Power Systems, in Proceedings of ASME Winter Annual Meeting, Anaheim, USA, 1992.
%
%    Copyright Travis Wiens 2008
%


if nargin<2
	error('Insufficient arguements')
end
if nargin<3
	gen_max=1000;
elseif isempty(gen_max)
    gen_max=1000;
end

if nargin<4
	x_start=[];
end
if nargin<5
	fit_start=[];
end
if nargin<6
	fcn_opts=[];
end
if nargin<7
	complex_opts.alpha=1.3;%constant determines how far to overshoot centroid
	complex_opts.n_r=4;%constant for adjusting to repeated unimprovements
elseif isempty(complex_opts)
    complex_opts.alpha=1.3;%constant determines how far to overshoot centroid
	complex_opts.n_r=4;%constant for adjusting to repeated unimprovements
end


fcn_str=['[fitness, x]=' fcn_name '(x,fcn_opts);'];%string to determine fitness
%output of x allows function to change x if desired

fit_best=-inf;%initial best fitness

n_params=size(bounds,2);

gen=1;%initialize number of generations

alpha=complex_opts.alpha;%copy values
n_r=complex_opts.n_r;

if isempty(x_start)
	f_excess=1.5;%factor to increase population over minimum (must be >=1)
	n_pop=round((n_params+1)*f_excess);
	x_pop=ones(n_pop,1)*bounds(1,:) +(ones(n_pop,1)*(bounds(2,:)-bounds(1,:))).*rand(n_pop,n_params);
else
	x_pop=x_start;
	n_pop=size(x_pop,1);

end


%initialize fitness
if isempty(fit_start)
	fit_pop=zeros(1,n_pop);
	for i=1:n_pop
		x=x_pop(i,:);
		eval(fcn_str); %get fitness for each x
		x_pop(i,:)=x;
		fit_pop(i)=fitness;
		gen=gen+1;
	end
else
	fit_pop=fit_start;
	if numel(fit_pop)~=n_pop
		error('Incorrect size of fit_pop');
	end
end

stats.trace_fitness=zeros(1,gen_max);
while (gen<gen_max)
	
	[fit_best idx_best]=max(fit_pop);%find best fitness
	x_best=x_pop(idx_best,:);%find best params
	[fit_worst idx_worst]=min(fit_pop);%find worst
	x_worst=x_pop(idx_worst,:);%find best params
	
	x_centroid=(sum(x_pop)-x_worst)/(n_pop-1);%calc centroid of all but worst x
	
	x_new=x_centroid+alpha*(x_centroid-x_worst);%"mirror" worst point through centroid 
	
	idx=find(x_new<bounds(1,:));%find params out of bounds
	x_new(idx)=bounds(1,idx);		
	idx=find(x_new>bounds(2,:));
	x_new(idx)=bounds(2,idx);
	
	x=x_new;
	eval(fcn_str); %get fitness for new x
	x_new=x;
	fit_new=fitness;
	stats.trace_fitness(gen)=fitness;
	gen=gen+1;%increment generation
	
	if fit_new<fit_worst %check if the new point is still worst
		k_r=1;%reset number of iterations
		while (fit_new<fit_worst&gen<gen_max)
			epsilon=(n_r/(n_r+k_r-1))^((n_r+k_r-1)/n_r);
			k_r=k_r+1;%increment number of iterations
			R=rand;
			x_store=x_new;%store previous x_new
			x_new=(x_new+epsilon*x_centroid+(1-epsilon)*x_best)/2+(x_centroid-x_best)*(1-epsilon)*(2*R-1);
			
			idx=find(x_new<bounds(1,:));%find params out of bounds
			x_new(idx)=bounds(1,idx);		
			idx=find(x_new>bounds(2,:));
			x_new(idx)=bounds(2,idx);
	
			x=x_new;
			eval(fcn_str); %get fitness for new x
			x_new=x;
			fit_new=fitness;
			stats.trace_fitness(gen)=fitness;
			gen=gen+1;%increment generation	
		end
	end	
	x_pop(idx_worst,:)=x_new;%replace worst params with new params
	fit_pop(idx_worst)=fit_new;
end

[fit_best idx_best]=max(fit_pop);%find best fitness
x_best=x_pop(idx_best,:);%find best params




	
