function [w]=JGAopt(w0,pop_size,Kga_fin,Max_error)

%--------------------------------------------------------------------------
% Djaghloul Mehdi Genetic Algorithme Real code 
%--------------------------------------------------------------------------
% [w]=JGAopt(w0,pop_size,Kga_fin,Max_error)
% w0 : Solution candidate initial
% pop_size : Taille de la population  
% Kga_fin : Nbre max d'iterations 
% Max_error : Tolerence en erreure pour solution 
% Mut_rate : Le pas de mutation (interne au programme)
% Cros_rate : Le pas de Croisement (interne au programme)
% You muste create a fitness function named 'fit_fun' 
%--------------------------------------------------------------------------
%--------------------------%
%Info on the used operators %
%--------------------------%
% Selection : We select the best efficience individuals
% Crossover : The Crossover function c=F(a,b)=(min_fit(a,b)+(a+b)/2)/2 
% Mutation : We mutate individual by alternance (Mutate , not , Mutate)
%--------------------------------------------------------------------------

%-------------------------------------------------------------------------- 
% Genetic algorithme Real code 
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% I N I T I A L I S A T I O N 
%------------------------------------------------------------------------
w=w0;
Mut_rate=0.03;%300
Cros_rate=0.02;%1500-2000
% w0=[-0.3;-0.08];
% pop_size=16;
% Kga_fin=1500;
% Max_error=0.001;
%--------------------------------------------------------------------------
% % E N D * I N I T I A L I S A T I O N 
%--------------------------------------------------------------------------
  
 for kga=1:Kga_fin

%--------------------------------------------------------------------------
% Initial population
%--------------------------------------------------------------------------
   Modification_pop =Cros_rate*(rand(length(w),pop_size)-rand(length(w),pop_size));

% For mor convergence we preserve the best solution    
%    if kga > 3
%        Ini_pop(:,1)=w;
%        ini_kpop=2;
%    else
     ini_kpop=1;  
%    end
   
for kpop=ini_kpop:pop_size
    Ini_pop(:,kpop)=w+(Modification_pop(:,kpop));
end
%--------------------------------------------------------------------------         

%--------------------------------------------------------------------------
%-----------%
% Selection % %selection des plus efficace des individues
%-----------%
for ksel=1:pop_size
    Sel_pop_cri(ksel)=fit_fun(Ini_pop(:,ksel));
end
% order
Min_fit_sel=[];

for ksel=1:pop_size

    [sel index]=min(Sel_pop_cri);
    
    Min_fit_sel=[ Ini_pop(:,index) , Min_fit_sel];
    
    if index <= (length(Sel_pop_cri))
        Sel_pop_cri(index)=Sel_pop_cri(end);
    end
    
    Sel_pop_cri=Sel_pop_cri(1:end-1);
    
end
Sel_pop=Min_fit_sel(:,((pop_size/2)+1):pop_size);

%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%-----------%
% Crossover % c=(min_fit(a,b)+(a+b)/2)/2 Mliha bark Croisement des indevedues
%-----------%
Cros_pop=[];

for i=1:pop_size/2
    
    for j=1:pop_size/2
        
        Cros_popA1=(Sel_pop(:,i)+ Sel_pop(:,j))/2;
        
        if j>i
            Cros_pop=[Cros_pop ,(Cros_popA1+Sel_pop(:,j))/2];
            
        else    
            Cros_pop=[Cros_pop ,(Cros_popA1+Sel_pop(:,j))/2];
        end
        
    end
end


%% order

for kcros=1:length(Cros_pop)
    Cros_pop_cri(kcros)=fit_fun(Cros_pop(:,kcros));
end


Min_fit_cros=[];

for kcros=1:length(Cros_pop)

    [cros index]=min(Cros_pop_cri);
    
    Min_fit_cros=[ Cros_pop(:,index) Min_fit_cros];
    
    if index <= (length(Cros_pop))
    Cros_pop_cri(index)=Cros_pop_cri(end);
    end
    Cros_pop_cri=Cros_pop_cri(1:end-1);
end
Cros_pop=Min_fit_cros(:,length(Cros_pop)-(pop_size/2)+1:length(Cros_pop));
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%----------%
% Mutation %  par 2 (1n1)
%----------%

 Mut_pop=[Cros_pop Sel_pop];

Masck=1*eye(length(w),1);
%Masck(length(w))=1;
for kmut=1:2:pop_size
    %Mut_pop(:,kmut)=Mut_pop(:,kmut).*(not(Masck))-300*(rand(1)-rand(1)).*Masck;
   Mut_pop(:,kmut)=Mut_pop(:,kmut)-Mut_rate*(rand(1)-rand(1)).*Masck;
end


%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%------------------%
% final selection  %
%------------------%


for kmut=1:pop_size
    Mut_pop_cri(ksel)=fit_fun(Mut_pop(:,kmut));
end
% order
Min_fit_mut=[];

for kmut=1:pop_size

    [Mut index]=min(Mut_pop_cri);
    
    Min_fit_mut=[ Mut_pop(:,index) , Min_fit_mut];
    
    if index <= (length(Mut_pop_cri))
        Mut_pop_cri(index)=Mut_pop_cri(end);
    end
    
    Mut_pop_cri=Mut_pop_cri(1:end-1);
    
end
Sol_tr=Min_fit_mut(:,end);
minF=fit_fun(Sol_tr);
%----------------%
% Adaptive Rate  % Mut , Cros
%----------------%

if minF < 0.05
    Mut_rate=50;
    Cors_rate=400;
% elseif minF < 0.05
%     Mut_rate=100;
%     cors_rate=1000;
else
    Mut_rate=300;
    cors_rate=2000;
end

    if  minF < Max_error
          w=Sol_tr;
        break
    else 
    w=Sol_tr;
    end
%-------------------------------------------------------------------------- 
kga;

%-------------------------------------------------------------------------- 
% END * Genetic algorithme Real code 
%--------------------------------------------------------------------------
end
      



