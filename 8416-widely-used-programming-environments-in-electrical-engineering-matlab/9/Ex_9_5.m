clear; close all
        % Impunerea primei solutii initiale
sol_init = bvpinit(linspace(0,4,5),[1 0]);
        % Gasirea primei solutii    
sol = bvp4c(@fbound,@ffront,sol_init);
        % Evaluarea primei solutii
x = linspace(0,4);
y1 = bvpval(sol,x);
        % Impunerea solutiei initiale a doua
sol_init = bvpinit(linspace(0,4,5),[-1 0]);
        % Gasirea solutiei a doua
sol = bvp4c(@fbound,@ffront,sol_init);
        % Evaluarea solutiei a doua
y2 = bvpval(sol,x);
        % Reprezentarea grafica a celor doua solutii
plot(x,y1(1,:),x,y2(1,:),'Linewidth',1.5);
xlabel('x');
ylabel('y');
grid
legend('Prima solutie','A doua solutie')