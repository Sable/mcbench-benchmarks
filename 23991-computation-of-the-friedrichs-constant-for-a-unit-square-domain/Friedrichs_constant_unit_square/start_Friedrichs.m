
clear all

levels=8; %maximum uniform refinemnt level for my comp with 2Gb memory is 9!
C_omega_exact=sqrt(1/(2*pi*pi)); %exact value known for unit square domain

%coarse mesh of the unit square
coordinates=[0 0; 1 0; 0 1; 1 1];
elements3=[1 2 4; 1 4 3];  
dirichlet=[1 2; 2 4; 4 3; 3 1];

fprintf('The last level of uniform refinement is %d. ', levels);
fprintf('Please wait for all levels. \n');
fprintf('\n');
fprintf('Start of counting the time. \n'); tic

for level=1:levels
    %uniform refinement
    [coordinates,elements3,dirichlet]=refinement_uniform(coordinates,elements3,dirichlet);
    fprintf('level=%d, ', level);
    
    %creating 3D matrix for Talal functions
    %coord=zeros(3,2,size(elements3,1));
    %coord(1,1,:)=coordinates(elements3(:,1),1);
    %coord(1,2,:)=coordinates(elements3(:,1),2);
    %coord(2,1,:)=coordinates(elements3(:,2),1);
    %coord(2,2,:)=coordinates(elements3(:,2),2);
    %coord(3,1,:)=coordinates(elements3(:,3),1);
    %coord(3,2,:)=coordinates(elements3(:,3),2);
    
    %stifness and mass matrices generation
    Xscalar=kron(ones(1,3),elements3); Yscalar=kron(elements3,ones(1,3)); Zscalar=zeros(size(Xscalar));
    areas=zeros(size(elements3,1),1);
    
    for j = 1:size(elements3,1)
        I=elements3(j,:); 
        verticesTrans=coordinates(I,:)'; %new definition (transpose operation) for faster performance!!!!
        area=det([1 1 1; verticesTrans])/2; areas(j)=area;
        PhiGrad = [1 1 1; verticesTrans]\[0 0; 1 0; 0 1];        
        Alocal = area * PhiGrad * PhiGrad'; 
        Zscalar(j,:)=reshape(Alocal,1,9); 
    end
    Zmassmatrix=kron(areas,reshape((ones(3)+eye(3))/12,1,9));
    A=sparse(Xscalar,Yscalar,Zscalar); 
    MASS=sparse(Xscalar,Yscalar,Zmassmatrix);
    
    all_nodes=(1:size(coordinates,1))';
    dirichlet_nodes=unique(dirichlet);
    free_nodes=setdiff(all_nodes,dirichlet_nodes); %internal + pure Neumann nodes 
    
    A_modif=A(free_nodes,free_nodes);
    MASS_modif=MASS(free_nodes,free_nodes);
    
    options.disp=0;
    few_largest_eigenvalues=eigs(MASS_modif,A_modif,1,'LM',options);
    C_omega(level)=sqrt(max(few_largest_eigenvalues));
    
    
    fprintf('C_omega=%12.8f, ',C_omega(level));
    fprintf('error=%12.8f, ',C_omega_exact-C_omega(level));
    fprintf('number of nodes=%d \n',size(coordinates,1));
    
    %sol=sinuswave(coordinates,1,1); solVec=vectorform([sol sol]);
    %C_omega_Dirichlet(level)
    %C_omega_Dirichlet_wave1(level+1)=sqrt((sol'*MASS*sol)/(sol'*A*sol))
end
toc

fprintf('\n');
fprintf('Convergence visualization. \n'); tic
plot(C_omega,'*-');
title('Computation of the Friedrichs constant C_\Omega for the unit square domain'); 
xlabel('level of refinement')
ylabel('C_\Omega value')

    




