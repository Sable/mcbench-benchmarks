
%**************************************************************************
%     Programme Algorithme Génétique pour maximiser une fonction à n
%           variables pour notre cas nombre de variable =2
%**************************************************************************
%                   Développé par :MEKHMOUKH Abdenour
%                     1 Année Post Graduation ATS 
%           Département d'Electronique Université de Bejaia                                                                     
%                                2005/2006
%**************************************************************************





%**************************************************************************
%                         Programme Principal :
%**************************************************************************
clear all;
load parametres;
clc;
%**************************************************************************
%                  Initialisation des parametres :
%**************************************************************************
nbregeneration = ng;	% Nombre de générations
taillepopulation = ni;		% Tailee de la population
probdecroisement = pc;	% Probabilite de croisement
probdemutation = pm;	% Probabilité de mutation
nbredebits = nb;		    % Nombre de bits pour chaque variable
%**************************************************************************
disp('*************************************************************');
disp('            Paramètres de l''Algorithme Génétique            ');
disp('*************************************************************');

disp([' Nombre de Générations     =',num2str(ng)]);
disp([' Nombre d''individus       =',num2str(ni)]);
disp([' Probabilite de croisement =',num2str(pc)]);
disp([' Probabilité de mutation   =',num2str(pm)]);
disp([' Nombre de bits (Codage)   =',num2str(nb)]);
disp('*************************************************************');




%**************************************************************************
%                    Le tracé de la fonction à maximiser
%**************************************************************************
figure;
blackbg;
obj_fcn = 'mafonc';	
nbredevariable = 2;		% Nombre de variables
intervalle = [-5, 5; -5, 5];	% intervalle pour les variables

fonction;%appel de la fonction pour la tracer

	
%**************************************************************************


%**************************************************************************
%                      Génération de population aléatoirement
%*************************************************************************
popu = rand(taillepopulation, nbredebits*nbredevariable) > 0.5; 

haut = zeros(nbregeneration, 1);
moyen = zeros(nbregeneration, 1);
bas = zeros(nbregeneration, 1);
%**************************************************************************


%**************************************************************************
% Evaluation de la fonction objective ( à maximiser) pour chaque individu
%**************************************************************************

disp('*************************************************************');
disp(['         Evaluation de f(x,y) pour ',num2str(nbregeneration),' Générations']);
disp('*************************************************************');
for i = 1:nbregeneration;
  

	fcn_evaluation = evalpopu(popu, nbredebits, intervalle, obj_fcn);


	
	haut(i) = max(fcn_evaluation );
	moyen(i) = mean(fcn_evaluation );
	bas(i) = min(fcn_evaluation );
%**************************************************************************
	
%**************************************************************************   
%                        Affiche à l'ecran
%**************************************************************************
	[meilleur, index] = max(fcn_evaluation );
	fprintf('Génération %i: ', i);
	fprintf('f(%f, %f)=%f\n', ...
			bit2num(popu(index, 1:nbredebits), intervalle(1,:)), ...
			bit2num(popu(index, nbredebits+1:2*nbredebits), intervalle(2,:)), ...
			meilleur);
     
	%----------------------------------------------------------------------
	% Génération de la nouvelle population  par selection, croisement et mutation
    %----------------------------------------------------------------------
	popu = nextpopu(popu, fcn_evaluation , probdecroisement, probdemutation);

   xopt=bit2num(popu(index, 1:nbredebits), intervalle(1,:));%x optimal
   yopt=bit2num(popu(index, nbredebits+1:2*nbredebits), intervalle(2,:));%y optimal
  
  xopts(i)=xopt ;
  yopts(i)=yopt ;
   savefile = 'resultats.mat';

save(savefile,'xopt','yopt','meilleur')
   
end
disp('*************************************************************');
disp(['       Fin d''évaluation de f(x,y) pour les ',num2str(nbregeneration),' Générations']);
disp('*************************************************************');
disp( '       Résultats :  ');
disp(['                       x =',num2str(xopt)]);
disp(['                       y =',num2str(yopt)]);
disp(['                       f(',num2str(xopt),',',num2str(yopt),') =',num2str(meilleur)]);
disp('*************************************************************');

%**************************************************************************
%                        Evolution de x et y  
%**************************************************************************
xevolution =xopts ;
yevolution = yopts;
grid on
subplot(2,1,1); plot(xevolution);xlabel('Générations'); ylabel('x');
subplot(2,1,2); plot(yevolution);xlabel('Générations'); ylabel('y');
%**************************************************************************


figure;
blackbg;
x = (1:nbregeneration)';
plot(x, haut, 'o', x, moyen, 'x', x, bas, '*');
hold on;
plot(x, [haut moyen bas]);
hold off;
legend('Meilleur', 'Moyenne', 'Faible');
xlabel('Générations'); 
ylabel('F(x,y)');
%**************************************************************************
