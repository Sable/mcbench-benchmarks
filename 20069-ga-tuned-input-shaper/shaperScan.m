function shaperScan(model,numC,maxT,N,maxepochs,perf,show,plot,initC,initT)

% Use a Genetic Algorithm to find shaper parameters which best fit model
% response
%
% shaperScan(model,numC,maxT,N,maxepochs,perf,show,plot,initC,initT)
%
% Input
%       model    : name of simulink model
%       numC     : number of shaper coefficients
%       maxT     : time interval (s) in which shaper should work (default=0.3 s)
%       N        : population size (default=10)
%       maxepochs: default=100 
%       perf     : performance index to be achieved (default=0)
%       show     : displays intermediate results after 'show' epochs
%       plot     : enable plotting (default=true)
%       initC    : coefficients vector to be put into initial population (default=[])
%       initT    : time instants vector to be put into initial population (default=[])
%
% Ouput
%       bestC and bestT returned into workspace

if nargin<10, initT=[]; end
if nargin<9, initC=[]; end
if nargin<8, plot=true; end
if nargin<7, show=1; end
if nargin<6, perf=0; end
if nargin<5, maxepochs=100; end
if nargin<4, N=10; end
if nargin<3, maxT=0.3; end

if isempty(plot), plot=true; end
if isempty(show), show=1; end
if isempty(perf), perf=0; end
if isempty(maxepochs), maxepochs=100; end
if isempty(N), N=10; end
if isempty(maxT), maxT=0.3; end

if numC<=1
    disp('error: numC must be greater than 1.');
    return;
end

numT=numC-1;

% perf should be not negative
perf=max(0,perf);

% N should be even
if mod(N,2)
    N=N+1;
end

% translate maxT in milliseconds
maxT=max(round(1000*maxT),10);

% params for mutation
prob=0.5;
deltaC_inc=1.3;
deltaC_dec=0.7;
deltaT=10;

len=numC+numT;

Cidx=find(mod(1:len,2));
Tidx=find(~mod(1:len,2));

% create initial population
Pop=zeros(len,N);
% randomly initialized
Pop(Cidx,:)=rand(numC,N);
Pop(Tidx,:)=round((maxT-1)*rand(numT,N)) + 1;

% reshape to apply constraints
for i=1:N
    Pop(Cidx,i)=Pop(Cidx,i)/sum(Pop(Cidx,i));
end

for i=1:N
    lim=sum(Pop(Tidx,i));
    if lim>maxT
        Pop(Tidx,i)=floor(Pop(Tidx,i)*maxT/lim);
    end
end

if (~isempty(initC)) && (~isempty(initT))
    if (length(initC)~=numC) && (length(initT)~=numT)
        disp('error: wrong dimension for initC and/or initT.');
        return;
    end
    Pop(Cidx,1)=initC;
    Pop(Tidx,1)=initT;
end

global stopFlag;

stopFlag=false;

epochs=1;
s=1;

NewPop=Pop;
fitness=zeros(N,1);

% get time step from within the model
load_system(model);
stopTime=str2double(get_param(bdroot,'StopTime'));
close_system;

time=(0:.001:stopTime)';
u=zeros(length(time),1);
u(find(time>=0.1))=1; %#ok<FNDSB>

figure('Color',[1 1 1]);
uicontrol('Style','pushbutton','String','Stop',...
          'Position',[10 10 40 30],'Callback',@stop);

while epochs<=maxepochs

    % calculate fitness function
    minJ=inf;
    for i=1:N
        assignin('base','C',Pop(Cidx,i));
        assignin('base','T',Pop(Tidx,i));        
                
        [t,x,y1,y2,J]=sim(model,[time(1) time(end)],[],[time u]);
        fitness(i)=J(end);

        if fitness(i)<minJ
            besty=y1;
            bestsh=y2;
            minJ=fitness(i);
        end
    end
    
    % sort
    [fitness,idx]=sort(fitness);
        
    % create new population
    
    % elitism => first two parents hold
    NewPop(:,1)=Pop(:,idx(1));
    NewPop(:,2)=Pop(:,idx(2));

    % crossover of the first two parents
    % select random crossover point
    p=round((len-3)*rand)+2;
    NewPop(1:p,3)=NewPop(1:p,1);
    NewPop((p+1):end,3)=NewPop((p+1):end,2);    
    NewPop(1:p,4)=NewPop(1:p,2);
    NewPop((p+1):end,4)=NewPop((p+1):end,1);
    
    % mutation of the first two parents
    m=floor(len*prob);
    if m
        sel=1:len;
        for i=1:m
            for j=3:4
                % select a random point not already choosen
                tmp=round((length(sel)-1)*rand)+1;
                p=sel(tmp);
                sel(tmp)=[];
                if ismember(p,Cidx)
                    if round(rand)
                        NewPop(p,j)=NewPop(p,j)*deltaC_inc;
                    else
                        NewPop(p,j)=NewPop(p,j)*deltaC_dec;
                    end
                else
                    NewPop(p,j)=NewPop(p,j)+2*round(deltaT*rand)-deltaT;
                    if NewPop(p,j)<0
                       NewPop(p,j)=0; 
                    end
                end
            end
        end
    end
        
    % remove last two chromosomes from new population
    idx=idx(3:(end-2));
    
    for i=1:(N/2-2)
        % select chromosomes
        tmp=round((length(idx)-1)*rand)+1;
        idx1=idx(tmp);
        idx(tmp)=[];

        tmp=round((length(idx)-1)*rand)+1;
        idx2=idx(tmp);
        idx(tmp)=[];
        
        j=5+2*(i-1);
        
        % crossover
        p=round((len-3)*rand)+2;
        NewPop(1:p,j)=Pop(1:p,idx1);
        NewPop((p+1):end,j)=Pop((p+1):end,idx2);    
        NewPop(1:p,j+1)=Pop(1:p,idx2);
        NewPop((p+1):end,j+1)=Pop((p+1):end,idx1);
                
        % mutation
        m=floor(len*prob);
        if m
            j=j- 1;
            sel=1:len;
            for h=1:m
                for k=1:2
                    % select a random point not already choosen
                    tmp=round((length(sel)-1)*rand)+1;
                    p=sel(tmp);
                    sel(tmp)=[];
                    if ismember(p,Cidx)
                        if round(rand)
                            NewPop(p,j+k)=NewPop(p,j+k)*deltaC_inc;
                        else
                            NewPop(p,j+k)=NewPop(p,j+k)*deltaC_dec;
                        end
                    else
                        NewPop(p,j+k)=NewPop(p,j+k)+2*round(deltaT*rand)-deltaT;
                        if NewPop(p,j+k)<0
                           NewPop(p,j+k)=0; 
                        end                        
                    end
                end
            end
        end
        
    end
    
    % reshape to apply constraints
    for i=1:N
        NewPop(Cidx,i)=NewPop(Cidx,i)/sum(NewPop(Cidx,i));
    end

    for i=1:N
        lim=sum(NewPop(Tidx,i));
        if lim>maxT
            NewPop(Tidx,i)=floor(NewPop(Tidx,i)*maxT/lim);
        end
    end
    
    Pop=NewPop;
    
    if s==show
        text=sprintf('epoch = %d/%d; performance = %f/%f;',epochs,maxepochs,minJ,perf);
        disp(text);
        
        if plot
            stairs(t,[u bestsh besty],'LineWidth',2);
            title(text);
            drawnow;
        end

        s=1;
    else
        s=s+1;
    end       
        
    assignin('base','bestC',Pop(Cidx,1));
    assignin('base','bestT',Pop(Tidx,1));
    
    if (minJ<=perf) || stopFlag
        if s~=1
            disp(sprintf('epoch = %d/%d; performance = %f/%f;',epochs,maxepochs,minJ,perf));
        end

        if minJ<=perf
            disp('performance achieved.');
        end
        
        break;
    end
    
    epochs=epochs+1;    
end

if epochs>=maxepochs
    disp('max epoch reached.');
end


function stop(obj,event) %#ok<INUSD>

global stopFlag;

stopFlag=true;

