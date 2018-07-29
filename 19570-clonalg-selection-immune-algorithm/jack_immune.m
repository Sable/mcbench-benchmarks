function Sol=jack_immune_clonal(w0,pop_size,best_pop_size,clone_size_factor,KImmune_fin,Max_error)
tic
%--------------------------------------------------------------------------
% Djaghloul Mehdi ClonalG Immune Algorithm for Optimiation
%--------------------------------------------------------------------------
% sol=jack_immune(w0,pop_size,best_pop_size,Nbre_var,clone_size_factor,KImmune_fin,Max_error)
% w0 : Solution candidate (initial)
% pop_size : Taille de la population d'antcorps
% best_pop_size : Taille de la meilleur population d'antcorps
% clone_size_factor : Facteur de colnage
% KImmune_fin : Nbre max d'iterations 
% Max_error : Tolerence en erreure pour solution 
% You muste create a fitness function named 'fit_fun' 
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% I N I T I A L I S A T I O N 
%------------------------------------------------------------------------

Nbre_var=length(w0);
Ini_Ab=[w0 rand(Nbre_var,pop_size-1)];


%--------------------------------------------------------------------------
% % E N D * I N I T I A L I S A T I O N 
%--------------------------------------------------------------------------


%-------------------------------------------------------------------------- 
% ClonalG 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

for kImmune=1:KImmune_fin
     
%-----------%
% Selection % %selection des plus efficace des Ab
%-----------%
for ksel=1:pop_size
    Sel_Ab_cri(ksel)=fit_fun(Ini_Ab(:,ksel));
end
% Order
Min_fit_sel=[];
Min_fit=[];
for ksel=1:pop_size

    [sel index]=min(Sel_Ab_cri);
    
    Min_fit=[Min_fit ,sel];
    Min_fit_sel=[ Min_fit_sel ,Ini_Ab(:,index) ];
    
    if index <= (length(Sel_Ab_cri))
        Sel_Ab_cri(index)=Sel_Ab_cri(end);
    end
    
    Sel_Ab_cri=Sel_Ab_cri(1:end-1);
    
end

Sel_best_pop=Min_fit_sel(:,1:best_pop_size);
Fit_best_pop=Min_fit(:,1:best_pop_size);

%--------------------------------------------------------------------------
%-----------------------%
% Fitness Normalisation % 
%-----------------------% 

Max_Fit=max(Fit_best_pop);
Min_Fit=min(Fit_best_pop);
Fit_best_pop=Fit_best_pop/Max_Fit;

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%---------%
% Clonage % clonage des meilleurs anticorps
%---------%     
Nc=[];
for kclone=1:best_pop_size
%----------%
% Maturate % 
%----------%    
   maturat_rate= (1)*exp(-Fit_best_pop(kclone));
   clone_best_pop= Sel_best_pop(:,kclone)+ maturat_rate*((rand(Nbre_var,1)-rand(Nbre_var,1))*Min_Fit);
%--------------------------------------------------------------------------   
   Nci_size=round((clone_size_factor*pop_size)/kclone);
   
   Nci=[];
   
   for kNci=1:Nci_size       
       Nci=[Nci clone_best_pop];
   end
   
   Nc=[Nc Nci];   %Les clones 
end 
%--------------------------------------------------------------------------
%-------------%
%Re-Selection % %selection des plus efficace des Ab
%-------------%

for kNcsel=1:length(Nc)
    Sel_Nc_cri(kNcsel)=fit_fun(Nc(:,kNcsel));
end
% Order
Min_fit_Ncsel=[];

for kNcsel=1:length(Nc)

    [Ncsel index]=min(Sel_Nc_cri);
    
    Min_fit=[Min_fit ,sel];
    Min_fit_Ncsel=[ Min_fit_Ncsel ,Nc(:,index) ];
    
    if index <= (length(Sel_Ab_cri))
        Sel_Nc_cri(index)=Sel_Nc_cri(end);
    end
    
    Sel_Nc_cri=Sel_Nc_cri(1:end-1);
    
end

Re_Sel_best_pop=Min_fit_Ncsel(:,1:best_pop_size);

Sol_tr=Min_fit_Ncsel(:,1);
Sol=Sol_tr;
minF=fit_fun(Sol_tr);

    if  minF < Max_error
          Sol=Sol_tr;
        break
    else 
    Ini_Ab(:,1:best_pop_size)=Re_Sel_best_pop;
    end
%--------------------------------------------------------------------------
kImmune;
%-------------------------------------------------------------------------- 
% END clonalG
%--------------------------------------------------------------------------
end
toc
 



