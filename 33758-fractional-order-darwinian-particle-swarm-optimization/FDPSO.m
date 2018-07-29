function [xbest,fitness,time] = FDPSO(func,xmin,xmax,type,population,iterations)

% fdpso - MatLab function for FDPSO
% Fractional Order Darwinian Particle Swarm Optimization
% Limited to optimization problems of nine variables but can easily be extended
% many more variables.
%
% xbest = fdpso(func)
% xbest - solution of the optimization problem. The number of columns
% depends on the input func. size(func,2)=number of xi variables
% func - string containing a mathematic expression. Variables are defined
% as xi. For instance, func='2*x1+3*x2' means that it is an optimization problem of
% two variables.
%
% [xbest,fit] = fdpso(func)
% fit - returns the optimized value of func using the xbest solution.
%
% [xbest,fit] = fdpso(func,xmin)
% xmin - minimum value of xi. size(xmin,2)=number of xi variables. Default
% -100.
%
% [xbest,fit] = fdpso(func,xmin,xmax)
% xmax - maximum value of xi. size(xmax,2)=number of xi variables. Default
% 100.
%
% [xbest,fit] = fdpso(func,xmin,xmax,type)
% type - minimization 'min' or maximization 'max' of the problem. Default
% 'min'.
%
% [xbest,fit] = fdpso(func,xmin,xmax,type,population)
% population - number of the swarm population. Default 30.
%
% [xbest,fit] = fdpso(func,xmin,xmax,type,population,iterations)
% iterations - number of iterations. Default 300.
%
% Example:  xbest = fdpso('10+5*x1^2-0.8*x2',[-10 -20],[20 40],'min')
%
% Micael S. Couceiro
% v1.0
% 13/11/2011
%
% Original PSO developed by: 
% Kennedy, J. and Eberhart, R. C. (1995).
% "Particle swarm optimization".
% Proceedings of the IEEE 1995 International Conference on Neural Networks, pp. 1942-1948.
%
% Original DPSO developed by:
% Tillett, J., Rao, T., Sahin, F., Rao, R. (2005).
% "Darwinian particle swarm optimization".
% Proceedings of the 2nd Indian International Conference on Artificial Intelligence (IICAI05).
%
% Extended Fractional-Order DPSO developed by:
% Couceiro, M. S., Ferreira, N. M. F. and Machado, J. A. T. (2011).
% "Fractional Order Darwinian Particle Swarm Optimization".
% Proceedings of the Symposium on Fractional Signals and Systems (FSS’11) .

tic;

fun=inline(func);

n_par=length(argnames(fun));

if (nargin<6)
    iterations=300;
    if (nargin<5)
        population=30;
        if (nargin<4)
            type='min';
            if (nargin<3)
                xmax=100*ones(1,n_par);
                if (nargin<2)
                    xmin=-100*ones(1,n_par);
                end
            end
        end
    end
end

alfa=0.632;

N = population;

n_ger = iterations;

vbef3=0;
vbef2=0;
vbef1=0;

min_swarms=4;
n_swarms=6;
max_swarms=8;

swarms=zeros(max_swarms,1);

for i=1:max_swarms
    if (i<=n_swarms)
        swarms(i)=1;
    end
end

n_init=N;
n_max=2*n_init;
n_min=round(n_init/2);
 
n=n_init*ones(max_swarms,1);

scmax = 15;      % nº de iterações máximo sem uma swarm melhorar
sc=zeros(max_swarms,1);

X_MAX = xmax;
X_MIN = xmin;

vmin=-(max(xmax)-min(xmin))/(N*5);
vmax=(max(xmax)-min(xmin))/(N*5);

if (strcmpi(type,'min')==1)
    gbestvalue = 1000000*ones(max_swarms,1);    % aptidao da melhor particula
end
if (strcmpi(type,'max')==1)
    gbestvalue = -1000000*ones(max_swarms,1);    % aptidao da melhor particula
end

gbestvalueaux=gbestvalue;
% fit=ones(max_swarms,1);
fit = cell(max_swarms,1);
for i=1:n_swarms
    if (strcmpi(type,'min')==1)
        fit{i}(1:n(i),1)=1000000;     % fitness do vector best
    end
    if (strcmpi(type,'max')==1)
        fit{i}(1:n(i),1)=-1000000;     % fitness do vector best
    end
end
fitbest=fit;

x=cell(max_swarms,1);
for i=1:n_swarms
    x{i}=zeros(n(i),n_par);     % fitness do vector best
end
xaux=x;

v=cell(max_swarms,1);
for i=1:n_swarms
    v{i}=zeros(n(i),n_par);  %inicializa v a nxn_par zeros
end
vaux=v;

xbest=cell(max_swarms,1);
gbest=cell(max_swarms,1);

nger=1;                 % iteração corrente

fitbefore=fit;

nkill=zeros(max_swarms,1);

xbest=cell(max_swarms,1);

for i=1:n_swarms
    xaux{i}(1:n(i),1:n_par)=inicializaswarm(n(i), n_par, X_MIN, X_MAX); %x será uma matriz com todos os valores de k
    x=xaux;
    for j=1:n(i)
        switch(n_par)
            case 1
                fit{i}(j)=fun(x{i}(j,1));
            case 2
                fit{i}(j)=fun(x{i}(j,1),x{i}(j,2));
            case 3
                fit{i}(j)=fun(x{i}(j,1),x{i}(j,2),x{i}(j,3));
            case 4
                fit{i}(j)=fun(x{i}(j,1),x{i}(j,2),x{i}(j,3),x{i}(j,4));
            case 5
                fit{i}(j)=fun(x{i}(j,1),x{i}(j,2),x{i}(j,3),x{i}(j,4),x{i}(j,5));
            case 6
                fit{i}(j)=fun(x{i}(j,1),x{i}(j,2),x{i}(j,3),x{i}(j,4),x{i}(j,5),x{i}(j,6));
            case 7
                fit{i}(j)=fun(x{i}(j,1),x{i}(j,2),x{i}(j,3),x{i}(j,4),x{i}(j,5),x{i}(j,6),x{i}(j,7));
            case 8
                fit{i}(j)=fun(x{i}(j,1),x{i}(j,2),x{i}(j,3),x{i}(j,4),x{i}(j,5),x{i}(j,6),x{i}(j,7),x{i}(j,8));
            case 9
                fit{i}(j)=fun(x{i}(j,1),x{i}(j,2),x{i}(j,3),x{i}(j,4),x{i}(j,5),x{i}(j,6),x{i}(j,7),x{i}(j,8),x{i}(j,9));
                % if your problem has more than 9 variables then add the corresponding "case"
            otherwise
                disp('Incorrect number of variables');
        end
%         fit{i}(j) = fun(x{i}(j,1),x{i}(j,2));
        fitbest{i}(j)=fit{i}(j);      %inicializar fitbest
    end
    
    if (strcmpi(type,'min')==1)
        [a,b]=min(fit{i});         %guarda em a o valor minimo de fit e em b a linha do valor minimo
    end
    if (strcmpi(type,'max')==1)
        [a,b]=max(fit{i});         %guarda em a o valor minimo de fit e em b a linha do valor minimo
    end
    
    gbest{i}=x{i}(b,:);           %guarda em gbest a linha de x que permitiu o melhor fit
    
    gbestvalue(i) = fit{i}(b);    %guarda em gbestvalue o valor de fit correspondente
    gbestvalueaux(i)=gbestvalue(i);
    
    xbest{i}(1:n(i),1:n_par) = inicializaswarm(n(i), n_par, X_MIN, X_MAX); %melhor x
    
end
fitaux=fit;
xbestaux=xbest;
gbestaux=gbest;
fitbestaux=fitbest;

while (nger<=n_ger)
    
    for i=1:max_swarms
        if (swarms(i)==1)   %swarm is alive
            [fitaux{i},xaux{i},vaux{i},xbestaux{i},gbestaux{i},gbestvalueaux(i),fitbestaux{i}]=dpsoscript2(n(i),x{i}(1:n(i),1:n_par),fit{i}(1:n(i),1),v{i}(1:n(i),1:n_par),xbest{i}(1:n(i),1:n_par),gbest{i},gbestvalue(i),fitbest{i}(1:n(i)),alfa, n_par, X_MAX, X_MIN, vmin, vmax, fun, type);
            if (nger>1)
                if ((strcmpi(type,'min')==1)&&(gbestvalueaux(i)>=gbestvalue(i)))||((strcmpi(type,'max')==1)&&(gbestvalueaux(i)<=gbestvalue(i)))  %check performance of the swarm
                    sc(i)=sc(i)+1;
                    if (sc(i)==scmax)        %reached search limit
                        if n(i)>n_min        %delete particle
                            if (strcmpi(type,'min')==1)
                                [a,b]=max(fitaux{i});
                            end
                            if (strcmpi(type,'max')==1)
                                [a,b]=min(fitaux{i});
                            end
                            if b==1
                                xaux{i}=xaux{i}(2:n(i),:);
                            end
                            if b==n(i)
                                xaux{i}=xaux{i}(1:b-1,:);
                            end
                            if (b>1 && b<n(i))
                                xaux{i}=vertcat(xaux{i}(1:(b-1),:),xaux{i}((b+1):n(i),:));
                            end
                            %                             xaux{i}(b)=[];    %delete particle
                            
                            %                                     fprintf('\ndelete particle from swarm %d',i);
                            n(i)=n(i)-1;
                            nkill(i)=nkill(i)+1;
                            sc(i)=fix(scmax*(1-1/(nkill(i)+1)));
                        else                    %delete swarm
                            if (n_swarms>min_swarms)
                                swarms(i)=0;
                                n_swarms=n_swarms-1;
                                sc(i)=0;
                                %                                         fprintf('\ndelete swarm %d',i);
                            end
                        end
                    end
                else
                    if (nkill(i)>0)
                        nkill(i)=nkill(i)-1;
                    end
                    if (n(i)<n_max)     %create particle
                        n(i)=n(i)+1;
                        %n_alive=size(xaux{i},1);
                        xaux{i}(n(i),1:n_par)=inicializaswarm(1, n_par, X_MIN, X_MAX);
                        xbestaux{i}(n(i),1:n_par)=inicializaswarm(1, n_par, X_MIN, X_MAX);
                        vaux{i}(n(i),1:n_par)=zeros(1,n_par);
                        
                        switch(n_par)
                            case 1
                                fitaux{i}(n(i),1)=fun(xaux{i}(n(i),1));
                            case 2
                                fitaux{i}(n(i),1)=fun(xaux{i}(n(i),1),xaux{i}(n(i),2));
                            case 3
                                fitaux{i}(n(i),1)=fun(xaux{i}(n(i),1),xaux{i}(n(i),2),xaux{i}(n(i),3));
                            case 4
                                fitaux{i}(n(i),1)=fun(xaux{i}(n(i),1),xaux{i}(n(i),2),xaux{i}(n(i),3),xaux{i}(n(i),4));
                            case 5
                                fitaux{i}(n(i),1)=fun(xaux{i}(n(i),1),xaux{i}(n(i),2),xaux{i}(n(i),3),xaux{i}(n(i),4),xaux{i}(n(i),5));
                            case 6
                                fitaux{i}(n(i),1)=fun(xaux{i}(n(i),1),xaux{i}(n(i),2),xaux{i}(n(i),3),xaux{i}(n(i),4),xaux{i}(n(i),5),xaux{i}(n(i),6));
                            case 7
                                fitaux{i}(n(i),1)=fun(xaux{i}(n(i),1),xaux{i}(n(i),2),xaux{i}(n(i),3),xaux{i}(n(i),4),xaux{i}(n(i),5),xaux{i}(n(i),6),xaux{i}(n(i),7));
                            case 8
                                fitaux{i}(n(i),1)=fun(xaux{i}(n(i),1),xaux{i}(n(i),2),xaux{i}(n(i),3),xaux{i}(n(i),4),xaux{i}(n(i),5),xaux{i}(n(i),6),xaux{i}(n(i),7),xaux{i}(n(i),8));
                            case 9
                                fitaux{i}(n(i),1)=fun(xaux{i}(n(i),1),xaux{i}(n(i),2),xaux{i}(n(i),3),xaux{i}(n(i),4),xaux{i}(n(i),5),xaux{i}(n(i),6),xaux{i}(n(i),7),xaux{i}(n(i),8),xaux{i}(n(i),9));
                                % if your problem has more than 9 variables then add the corresponding "case"
                            otherwise
                                disp('Incorrect number of variables');
                        end
                        
                        fitbestaux{i}(n(i),1)=fitaux{i}(n(i),1);
                        if (strcmpi(type,'min')==1)
                            [a,b]=min(fitaux{i});
                        end
                        if (strcmpi(type,'max')==1)
                            [a,b]=max(fitaux{i});
                        end
                        gbestaux{i}=xaux{i}(b,:);
                        gbestvalueaux(i) = fitaux{i}(b);
                        %                                 fprintf('\ncreate particle in swarm %d',i);
                    end
                end
                if (nkill(i)==0)&&(n_swarms<max_swarms)     %add new swarm
                    prob=rand/n_swarms;
                    create_swarm=rand;
                    if (create_swarm<prob)
                        sc(i)=0;
                        swarm_alive=find(swarms==0);    %search the swarms that are dead
                        swarms(min(swarm_alive(1)))=1;
                        n_swarms=n_swarms+1;
                        n(min(swarm_alive(1)))=n_init;
                        xaux{min(swarm_alive(1))}(1:n(min(swarm_alive(1))),1:n_par)=inicializaswarm(n(min(swarm_alive(1))), n_par, X_MIN, X_MAX);
                        vaux{min(swarm_alive(1))}(1:n(min(swarm_alive(1))),1:n_par)=zeros(n(min(swarm_alive(1))),n_par);
                        xbestaux{min(swarm_alive(1))}(1:n(min(swarm_alive(1))),1:n_par) = inicializaswarm(n(min(swarm_alive(1))), n_par, X_MIN, X_MAX);
                        for j=1:n(min(swarm_alive(1)))
                            switch(n_par)
                                case 1
                                    fitaux{min(swarm_alive(1))}(j,1)=fun(xaux{i}(j,1));
                                case 2
                                    fitaux{min(swarm_alive(1))}(j,1)=fun(xaux{i}(j,1),xaux{i}(j,2));
                                case 3
                                    fitaux{min(swarm_alive(1))}(j,1)=fun(xaux{i}(j,1),xaux{i}(j,2),xaux{i}(j,3));
                                case 4
                                    fitaux{min(swarm_alive(1))}(j,1)=fun(xaux{i}(j,1),xaux{i}(j,2),xaux{i}(j,3),xaux{i}(j,4));
                                case 5
                                    fitaux{min(swarm_alive(1))}(j,1)=fun(xaux{i}(j,1),xaux{i}(j,2),xaux{i}(j,3),xaux{i}(j,4),xaux{i}(j,5));
                                case 6
                                    fitaux{min(swarm_alive(1))}(j,1)=fun(xaux{i}(j,1),xaux{i}(j,2),xaux{i}(j,3),xaux{i}(j,4),xaux{i}(j,5),xaux{i}(j,6));
                                case 7
                                    fitaux{min(swarm_alive(1))}(j,1)=fun(xaux{i}(j,1),xaux{i}(j,2),xaux{i}(j,3),xaux{i}(j,4),xaux{i}(j,5),xaux{i}(j,6),xaux{i}(j,7));
                                case 8
                                    fitaux{min(swarm_alive(1))}(j,1)=fun(xaux{i}(j,1),xaux{i}(j,2),xaux{i}(j,3),xaux{i}(j,4),xaux{i}(j,5),xaux{i}(j,6),xaux{i}(j,7),xaux{i}(j,8));
                                case 9
                                    fitaux{min(swarm_alive(1))}(j,1)=fun(xaux{i}(j,1),xaux{i}(j,2),xaux{i}(j,3),xaux{i}(j,4),xaux{i}(j,5),xaux{i}(j,6),xaux{i}(j,7),xaux{i}(j,8),xaux{i}(j,9));
                                    % if your problem has more than 9 variables then add the corresponding "case"
                                otherwise
                                    disp('Incorrect number of variables');
                            end
%                             fitaux{min(swarm_alive(1))}(j,1) = fun(xaux{i}(j,1),xaux{i}(j,2));
                            fitbestaux{min(swarm_alive(1))}(j,1)=fitaux{min(swarm_alive(1))}(j,1);
                        end
                        if (strcmpi(type,'min')==1)
                            [a,b]=min(fitaux{min(swarm_alive(1))});
                        end
                        if (strcmpi(type,'max')==1)
                            [a,b]=max(fitaux{min(swarm_alive(1))});
                        end
                        gbestaux{min(swarm_alive(1))}=xaux{min(swarm_alive(1))}(b,:);
                        gbestvalueaux(min(swarm_alive(1))) = fitaux{min(swarm_alive(1))}(b);
                        %                                 fprintf('\ncreate swarm %d',i);
                        sc(i)=0;
                    end
                end
            end
            fit=fitaux;
            x=xaux;
            v=vaux;
            xbest=xbestaux;
            gbest=gbestaux;
            gbestvalue(i)=gbestvalueaux(i);
            fitbest=fitbestaux;
        end
    end
    if strcmpi(type,'min')==1
        [fit_f(nger), ifit_f]=min(gbestvalue);
    end
    if strcmpi(type,'max')==1
        [fit_f(nger), ifit_f]=max(gbestvalue);
    end
    nger=nger+1;
end
xbest = gbest{ifit_f};
fitness = fit_f(n_ger);
time = toc;

end

function [swarm]=inicializaswarm(N,n_par,X_MIN, X_MAX)

swarm = zeros(N,n_par);
  for i = 1: N,            
      for j = 1: n_par,    
          swarm(i,j) = rand(1,1) * ( X_MAX(j)-X_MIN(j) ) + X_MIN(j);
      end                                                        
  end

end




function [fit,xaux,vaux,xBestaux,gBestaux,gbestvalueaux,fitBestaux]=dpsoscript2(N,x,fit,v,xBest,gBest,gbestvalue,fitBest,alfa,n_par, X_MAX, X_MIN, vmin, vmax, fun, type)

PHI1 = 1;  %default 1.5
PHI2 = 1;  %default 1.5
W = 0.9;     %default 0.9

gaux = ones(N,1);
i=1;

randnum1 = rand ([N, n_par]);
randnum2 = rand ([N, n_par]);

vbef3=0;
vbef2=0;
vbef1=0;

vbef3=vbef2;
vbef2=vbef1;
vbef1=v;

v = W*(alfa*v + (1/2)*alfa*vbef1 + (1/6)*alfa*(1-alfa)*vbef2 + (1/24)*alfa*(1-alfa)*(2-alfa)*vbef3) + randnum1.*(PHI1.*(xBest-x)) + randnum2.*(PHI2.*(gaux*gBest-x));

v = ( (v <= vmin).*vmin ) + ( (v > vmin).*v );
v = ( (v >= vmax).*vmax ) + ( (v < vmax).*v );

x = x+v;


for j = 1:N,
    for k = 1:n_par,
        if x(j,k) < X_MIN(k)
            x(j,k) = X_MIN(k);
            
        elseif x(j,k) > X_MAX(k)
            x(j,k) = X_MAX(k);
            
        end
    end
end


while(i<=N)
    
    a1=x(i,1);
    b1=x(i,2);
    
    
    if(i==N)
        
        
        for j=1:N
            switch(n_par)
                case 1
                    fit(j)=fun(x(j,1));
                case 2
                    fit(j)=fun(x(j,1),x(j,2));
                case 3
                    fit(j)=fun(x(j,1),x(j,2),x(j,3));
                case 4
                    fit(j)=fun(x(j,1),x(j,2),x(j,3),x(j,4));
                case 5
                    fit(j)=fun(x(j,1),x(j,2),x(j,3),x(j,4),x(j,5));
                case 6
                    fit(j)=fun(x(j,1),x(j,2),x(j,3),x(j,4),x(j,5),x(j,6));
                case 7
                    fit(j)=fun(x(j,1),x(j,2),x(j,3),x(j,4),x(j,5),x(j,6),x(j,7));
                case 8
                    fit(j)=fun(x(j,1),x(j,2),x(j,3),x(j,4),x(j,5),x(j,6),x(j,7),x(j,8));
                case 9
                    fit(j)=fun(x(j,1),x(j,2),x(j,3),x(j,4),x(j,5),x(j,6),x(j,7),x(j,8),x(j,9));
                    % if your problem has more than 9 variables then add the corresponding "case"
                otherwise
                    disp('Incorrect number of variables');
            end
%             fit(j)=fun(x(j,1),x(j,2));
            if ((strcmpi(type,'min')==1)&&(fit(j) < fitBest(j)))||((strcmpi(type,'max')==1)&&(fit(j) > fitBest(j)))
                fitBest(j) = fit(j);
                xBest(j,:) = x(j,:);
            end
        end
        
        
        [a,b] = min (fit);
        
        
        if ((strcmpi(type,'min')==1)&&(fit(b) < gbestvalue))||((strcmpi(type,'max')==1)&&(fit(b) > gbestvalue))
            gBest=x(b,:);
            gbestvalue = fit(b);
        end
        
        
    end
    
    
    i=i+1;
end

xaux=x;
vaux=v;
gBestaux=gBest;
xBestaux=xBest;
gbestvalueaux=gbestvalue;
fitBestaux=fitBest;

end
