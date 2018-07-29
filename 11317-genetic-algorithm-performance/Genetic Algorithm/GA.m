function GA
% Genetic Algorithm(real coding)
% By: Javad Ivakpour
% E-mail: javad7@gmail.com
% May 2006
% Goal: find maximum of function that introduced in fun00.m file in current
% directory and can be plotted in plot00
% this file is also include the random serach for comparision
tic
clc
figure(1)
clf
clear all
format long

%------------------------        parameters        ------------------------
% befor using this function you must specified your function in fun00.m
% file in current directory and then set the parameters
var=2;            % Number of variables (this item must be equal to the
                  %   number of variables that is used in the function in
                  %   fun00.m file)
n=100;            % Number of population

m0=20;            % Number of generations that max value remains constant
                  %   (use for termination criteria)
nmutationG=20;                  %number of mutation children(Gaussian)
nmutationR=20;                  %number of mutation children(random)
nelit=2;                        %number of elitism children
valuemin=ones(1,var)*-5*pi;     % min possible value of variables
valuemax=ones(1,var)*5*pi;      % max possible value of variables

%-------------------------------------------------------------------------
nmutation=nmutationG+nmutationR;
sigma=(valuemax-valuemin)/10;    %Parameter that related to Gaussian
                                 %   function and used in mutation step
max1=zeros(nelit,var);
parent=zeros(n,var);
cu=[valuemin(1) valuemax(1) valuemin(2) valuemax(2)];
for l=1:var
    p(:,l)=valuemin(l)+rand(n,1).*(valuemax(l)-valuemin(l));
end
initial=p;
m=m0;
maxvalue=ones(m,1)*-1e10;
maxvalue(m)=-1e5;
g=0;
meanvalue(m)=0;
%-------------   ****    termination criteria   ****-------------
while abs(maxvalue(m)-maxvalue(m-(m0-1)))>0.001*maxvalue(m) &...
        (abs(maxvalue(m))>1e-10 & abs(maxvalue(m-(m0-1)))>1e-10)...
        & m<10000 & abs(maxvalue(m)-meanvalue(m))>1e-5 | m<20
    sigma=sigma./(1.05);% reducing the sigma value
    %  ------  **** % reducing the number of mutation()random   **** ----
    g=g+1;
    if g>10 & nmutationR>0
        g=0;
        nmutationR=nmutationR-1;
        nmutation=nmutationG+nmutationR;
    end

    %-------------   ****    function evaluation   ****-------------
    for i=1:n
        y(i)=fun00(p(i,:));
    end
    s=sort(y);
    maxvalue1(1:nelit)=s(n:-1:n-nelit+1);
    if nelit==0
        maxvalue1(1)=s(n);
        for i=1:n
            if y(i)==maxvalue1(1)
                max1(1,:)=p(i,:);
            end
        end
    end
    for k=1:nelit
        for i=1:n
            if y(i)==maxvalue1(k)
                max1(k,:)=p(i,:);
            end
        end
    end
    if var==2
        figure(1)
        subplot(2,2,1)
        hold off
        plot00(cu)
        hold on
        plot3(p(:,1),p(:,2),y,'ro')
        plot3(max1(1,1),max1(1,2),maxvalue1(1),'bh')
        title({' Genetic Algorithm '...
            ,'Performance of GA ( o : each individual)'},'color','b')

    end
    y=y-min(y)*1.02;
    sumd=y./sum(y);
    meanvalue=y./(sum(y)/n);


    %-------------   ****   Selection: Rolette wheel   ****-------------
    for l=1:n
        sel=rand;
        sumds=0;
        j=1;
        while sumds<sel
            sumds=sumds+sumd(j);
            j=j+1;
        end
        parent(l,:)=p(j-1,:);
    end
    p=zeros(n,var);

    %-------------   ****    regeneration   ****-------------
    for l=1:var


        %-------------   ****    cross-over   ****-------------
        for j=1:ceil((n-nmutation-nelit)/2)
            t=rand*1.5-0.25;
            p(2*j-1,l)=t*parent(2*j-1,l)+(1-t)*parent(2*j,l);
            p(2*j,l)=t*parent(2*j,l)+(1-t)*parent(2*j-1,l);
        end


        %-------------   ****    elitism   ****-------------
        for k=1:nelit
            p((n-nmutation-k+1),l)=max1(k,l);
        end


        %-------------   ****    mutation   ****-------------
        for i=n-nmutation+1:n-nmutationR
            phi=1-2*rand;
            z=erfinv(phi)*(2^0.5);
            p(i,l)=z*sigma(l)+parent(i,l);

        end
        for i=n-nmutationR+1:n
            p(i,1:var)=valuemin(1:var)+rand(1,var).*(valuemax(1:var)-...
                valuemin(1:var));
        end
        for i=1:n
            for l=1:var
                if p(i,l)<valuemin(l)
                    p(i,l)=valuemin(l);
                elseif p(i,l)>valuemax(l)
                    p(i,l)=valuemax(l);
                end
            end
        end
    end
    p;
    m=m+1;
    max1;
    maxvalue(m)=maxvalue1(1);
    maxvalue00(m-m0)=maxvalue1(1);
    mean00(m-m0)=sum(s)/n;
    meanvalue(m)=mean00(m-m0);
    figure(1)
    if var==2
        subplot(2,2,2)
    end
    hold off
    plot(maxvalue00,'b')
    hold on
    plot(mean00,'r')
    hold on
    title({'Performance of GA',...
        'best value GA:blue, best value RS:black, mean value GA:red',''}...
        ,'color','b')
    xlabel('number of generations')
    ylabel('value')


    %-------------   ****    Random search   ****-------------
    %-------------   ****   for comparision  ****-------------
    p00=zeros(n,var);
    for l=1:var
        p00(:,l)=valuemin(l)+rand(n,1).*(valuemax(l)-valuemin(l));
    end
    for i=1:n
        y(i)=fun00(p00(i,:));
    end
    s=sort(y);
    maxvalueRAND(m-m0)=s(n);
    if m>(m0+1)
        if maxvalueRAND(m-m0)<maxvalueRAND(m-(m0+1))
            maxvalueRAND(m-m0)=maxvalueRAND(m-(m0+1));
        else
            for i=1:n
                if y(i)==maxvalueRAND(m-m0)
                    maxRand=p00(i,:);
                end
            end
        end
    else
        for i=1:n
            if y(i)==maxvalueRAND(m-m0)
                maxRand=p00(i,:);
            end
        end
    end
    plot(maxvalueRAND,'k')
    if var==2
        figure(1)
        subplot(2,2,3)
        plot00(cu)
        hold on
        plot3(maxRand(1,1),maxRand(1,2),maxvalueRAND(m-m0),'k*')
        plot3(max1(1,1),max1(1,2),maxvalue00(m-m0),'bo')
        title({'Best solution found by GA(: o) & RS(:*)'...
            'in each generation ',''},'color','b')
    end
    pause(0.001)
end

clc
disp('     Genetic Algorithm(real coding)   ')
disp('          By: Javad Ivakpour          ')
disp('       E-mail: javad7@gmail.com       ')
disp('**************************************')
num_of_fun_evaluation=n*m
max_point_GA=max1(1,:)
maxvalue_GA=maxvalue00(m-m0)
max_point_RS=maxRand
maxvalue_RS=maxvalueRAND(m-m0)
if var==2
    figure(1)
    subplot(2,2,4)
    hold off
    plot3(max1(1,1),max1(1,2),maxvalue1,'o')
    hold on
    plot00(cu)
    hold on
    plot3(maxRand(1,1),maxRand(1,2),maxvalueRAND(m-m0),'*')
    title({'Best solution ';'GA: o & RS: *'},'color','b')
end
figure(2)
title('Performance of GA(best value)','color','b')
xlabel('number of generations')
ylabel('max value of best solution')
hold on
plot(maxvalue00)
hold on
toc