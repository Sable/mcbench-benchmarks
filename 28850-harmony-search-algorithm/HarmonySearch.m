function [BestGen,BestFitness,gx]=HarmonySearch

% This code has been written with Matlab 7.0
% You can modify the simple constraint handlening method using more efficient
% methods. A good review of these methods can be found in:
% Carlos A. Coello Coello,"Theoretical and numerical constraint-handling techniques used with evolutionary algorithms: a survey of the state of the art"

clc
clear;
global NVAR NG NH MaxItr HMS HMCR PARmin PARmax bwmin bwmax;
global HM NCHV fitness PVB BW gx;
global BestIndex WorstIndex BestFit WorstFit BestGen currentIteration;


NVAR=4;         %number of variables
NG=6;           %number of ineguality constraints
NH=0;           %number of eguality constraints
MaxItr=5000;    % maximum number of iterations
HMS=6;          % harmony memory size
HMCR=0.9;       % harmony consideration rate  0< HMCR <1
PARmin=0.4;      % minumum pitch adjusting rate
PARmax=0.9;      % maximum pitch adjusting rate
bwmin=0.0001;    % minumum bandwidth
bwmax=1.0;      % maxiumum bandwidth
PVB=[1.0 4;0.6 2;40 80;20 60];   % range of variables

% /**** Initiate Matrix ****/
HM=zeros(HMS,NVAR);
NCHV=zeros(1,NVAR);
BestGen=zeros(1,NVAR);
fitness=zeros(1,HMS);
BW=zeros(1,NVAR);
gx=zeros(1,NG);
% warning off MATLAB:m_warning_end_without_block

MainHarmony;

% /**********************************************/

    function sum =Fitness(sol)
        
        sum = 0.6224*sol(1)*sol(3)*sol(4)+1.7781*sol(2)*sol(3)^2+3.1661*sol(1)^2*sol(4)+19.84*sol(1)^2*sol(3)+ eg(sol);  %F(x) = f(x) + penalty  
        
    end

% /*********************************************/
    function sum=eg(sol)
        
        % constraints g(x) > 0
        gx(1)=sol(1)-0.0193*sol(3);     %  x1 - 0.0193 x3 > 0
        gx(2)=sol(2)-0.00954*sol(3);
        gx(3)=3.14*sol(3)^2*sol(4)+(4/3)*3.14*sol(3)^3 - 1296000;
        gx(4)=-sol(4)+240;
        gx(5)=sol(1) - 1.1;
        gx(6)=sol(2) - 0.6;
        
        % we use static penalty function to handle constraints
        sum = 0;
        for i=1:NG
            if(gx(i)<0)
                sum = sum - 1000 * gx(i);
            end
        end
    end

% /*********************************************/

    function initialize
        % randomly initialize the HM
        for i=1:HMS
            for j=1:NVAR
                HM(i,j)=randval(PVB(j,1),PVB(j,2));
            end
            fitness(i) = Fitness(HM(i,:));
        end
    end

%/*******************************************/

    function MainHarmony
        % global NVAR NG NH MaxItr HMS HMCR PARmin PARmax bwmin bwmax;
        % global HM NCHV fitness PVB BW gx currentIteration;
        
        initialize;
        currentIteration  = 0;
        
        while(StopCondition(currentIteration))
            
            PAR=(PARmax-PARmin)/(MaxItr)*currentIteration+PARmin;
            coef=log(bwmin/bwmax)/MaxItr;
            for pp =1:NVAR
                BW(pp)=bwmax*exp(coef*currentIteration);
            end
            % improvise a new harmony vector
            for i =1:NVAR
                ran = rand(1);
                if( ran < HMCR ) % memory consideration
                    index = randint(1,HMS);
                    NCHV(i) = HM(index,i);
                    pvbRan = rand(1);
                    if( pvbRan < PAR) % pitch adjusting
                        pvbRan1 = rand(1);
                        result = NCHV(i);
                        if( pvbRan1 < 0.5)
                            result =result+  rand(1) * BW(i);
                            if( result < PVB(i,2))
                                NCHV(i) = result;
                            end
                        else
                            result =result- rand(1) * BW(i);
                            if( result > PVB(i,1))
                                NCHV(i) = result;
                            end
                        end
                    end
                else
                    NCHV(i) = randval( PVB(i,1), PVB(i,2) ); % random selection
                end
            end
            newFitness = Fitness(NCHV);
            UpdateHM( newFitness );
            
            currentIteration=currentIteration+1;
        end
        BestFitness = min(fitness);
    end
% /*****************************************/

    function UpdateHM( NewFit )
        % global NVAR MaxItr HMS ;
        % global HM NCHV BestGen fitness ;
        % global BestIndex WorstIndex BestFit WorstFit currentIteration;
        
        if(currentIteration==0)
            BestFit=fitness(1);
            for i = 1:HMS
                if( fitness(i) < BestFit )
                    BestFit = fitness(i);
                    BestIndex =i;
                end
            end
            
            WorstFit=fitness(1);
            for i = 1:HMS
                if( fitness(i) > WorstFit )
                    WorstFit = fitness(i);
                    WorstIndex =i;
                end
            end
        end
        if (NewFit< WorstFit)
            
            if( NewFit < BestFit )
                HM(WorstIndex,:)=NCHV;
                BestGen=NCHV;
                fitness(WorstIndex)=NewFit;
                BestIndex=WorstIndex;
            else
                HM(WorstIndex,:)=NCHV;
                fitness(WorstIndex)=NewFit;
            end
            
            
            WorstFit=fitness(1);
            WorstIndex =1;
            for i = 1:HMS
                if( fitness(i) > WorstFit )
                    WorstFit = fitness(i);
                    WorstIndex =i;
                end
            end
            
        end
    end % main if
end %function

% /*****************************************/
function val1=randval(Maxv,Minv)
    val1=rand(1)*(Maxv-Minv)+Minv;
end

function val2=randint(Maxv,Minv)
    val2=round(rand(1)*(Maxv-Minv)+Minv);
end
% /*******************************************/

function val=StopCondition(Itr)
    global MaxItr;
    val=1;
    if(Itr>MaxItr)
        val=0;
    end
end

% /*******************************************/




