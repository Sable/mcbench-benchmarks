%% Non Parallel (serial) computing  example, / Uzyto jeden procesor
tic              % start timer / pocz¹tek pomiaru czasu obliczeñ
%% For loop / Petla for
for tt=10:20,    % repeat computation in loop / wykonaj kilkakrotnie
[~,~]=ode23('ode1000',[0,tt],[1,-1]); % solving ode from ode1000.m
          % rozwiazywanie równania roniczkowego z pliku ode1000.m
% [~,~]             % do not save solution 
                    % wyniki obliczen nie s¹ zapamietania 
end
%% Computation time measurement / Czas obliczen
toc              % stop timer / koniec pomiaru czasu obliczen
disp('single processor used / u¿yto jeden procesor')