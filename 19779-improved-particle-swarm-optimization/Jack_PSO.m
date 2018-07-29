
function sol=Jpso(w0,pop_size,Max_error,Kpso_fin)
tic
%--------------------------------------------------------------------------
% Djaghloul Mehdi Partical Swarm Optimiation
%--------------------------------------------------------------------------
% sol=Jpso(w0,pop_size,Max_error,Kpso_fin)
% w0 : Solution candidate (initial)
% pop_size : Taille de la population des particules  
% Kpso_fin : Nbre max d'iterations 
% Max_error : Tolerence en erreure pour solution 
% You muste create a fitness function named 'fit_fun' 
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% I N I T I A L I S A T I O N 
%------------------------------------------------------------------------



Nbre_var=length(w0);%Nembre de variable 
Ini_pop=[w0 rand(Nbre_var,pop_size-1)];
Ini_vilocity=rand(Nbre_var,pop_size);



for ksel=1:pop_size
    Sel_Partcule_cri(ksel)=fit_fun(Ini_pop(:,ksel));
end

[pbest index]=min(Sel_Partcule_cri);
 pbest_sol=Ini_pop(:,index);
 gbest=pbest;
 gbest_sol=pbest_sol;
 temp_sol=pbest_sol;
%--------------------------------------------------------------------------
% % E N D * I N I T I A L I S A T I O N 
%--------------------------------------------------------------------------
%   gr=[]
%-------------------------------------------------------------------------- 
% P S O  
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

for kpso=1:Kpso_fin
     
     for ksel=1:pop_size
         Sel_Partcule_cri(ksel)=fit_fun(Ini_pop(:,ksel));
                    
     end
     
         
     [pbest index]=min(Sel_Partcule_cri);
     pbest_sol=Ini_pop(:,index);
     
     if pbest < gbest
         gbest=pbest;
         gbest_sol=pbest_sol;
         
     end
%--------------------------------------------------------------------------
%-----------%
% Out Test  %
%-----------%
    if gbest < Max_error
         sol=gbest_sol;
         break
     end
%--------------------------------------------------------------------------         
%------------%
% Adaptation %
%------------%
     
for ksel=1:pop_size
     Ini_vilocity(:,ksel)=rand(1)*Ini_vilocity(:,ksel) + rand(1)*(gbest_sol-Ini_pop(:,ksel))+rand(1)*(pbest_sol-Ini_pop(:,ksel));
     Ini_pop(:,ksel)=Ini_pop(:,ksel)+Ini_vilocity(:,ksel);
end   
%--------------------------------------------------------------------------    
%          gr=[gr; Ini_pop ];     
%          figure(1)
%          hold on
%          plot (gr,'g:.')
%          pause(0.3)
kpso;
%-------------------------------------------------------------------------- 
% END PSO 
%--------------------------------------------------------------------------
end
 toc    



