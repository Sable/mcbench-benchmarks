function [valFunc, var_min, iter] = simplexMethod(fun, init_point, step_size, toll, numMaxIter)

% It's a function that finds the minimum value of a two variables objective
% function with a deterministic zero order algorithm: simplex method.

% The input variables are:
%-fun: inline function of the objective function
%-init_point: initial point for the simplex method
%-step_size: initial dimension of the simplex
%toll: tolerance for the stop criterion on the simplex dimension
%-numMaxIter: stop criterion on the maximum number of iterations

% The output variables are:
%-valFunc: the minumum value of the objective function
%-var_min: the minimum point
%-iter: the number of iteration made

%%%%%%%% IMPORTANT %%%%%%%%%%%
% To run correctly the Matlab function, you must run first a contour plot
% of the objective function. You can also view: help countour.

iter=0; % Iteration number
f1=fun; % Inline objective function
N=numMaxIter;   % Max number of iterations (first stop criterion)
tolleranza_passo=toll;  % Tolerance on the simplex dimension (second stop criterion)
passo=step_size;    % Initial step
p0=init_point;  % Initial point. Example: [-5e-6 1e-6]
p=[p0(1,:); p0(1,1)-passo p0(1,2); p0(1,1)-passo/2 p0(1,2)+sqrt(3)/2*passo];    % Vector that contains the three triangle's vertices
plot([p(:,1); p(1,1)], [p(:,2); p(1,2)],'g')    % Plot the initial simplex on the contour plot of objective function

while iter<N  && passo>tolleranza_passo
    V=[f1(p(1,1),p(1,2)); f1(p(2,1),p(2,2)); f1(p(3,1),p(3,2))];   % Objective function's values in the simplex's points
    [V_ord, ind]=sort(V);   % Calculates the worst point: p(ind(3)) it is the point to reverse
    V_pegg=V(ind(3));   %Calculating the function in the point of maximum value
    p_ord=p(ind,:);     %Sorts the vector
    p_new=[p_ord(3,1)+2*((p_ord(1,1)+p_ord(2,1))/2-p_ord(3,1)) p_ord(3,2)+2*((p_ord(1,2)+p_ord(2,2))/2-p_ord(3,2))];    % It reverse the worst point
    if f1(p_new(1,1),p_new(1,2))<=V_pegg
        p(ind(3),:)=p_new(1,:);     %Checks if the function's value in the new point is smaller than the previous. In the positive case, it saves the new point
        plot([p(:,1); p(1,1)], [p(:,2); p(1,2)],'g')    %Plot the simplex on the contour plot of objective function
        pause(0.5);
    else
        plot([p_ord(1,1); p_ord(2,1); p_new(1,1); p_ord(1,1)],[p_ord(1,2); p_ord(2,2); p_new(1,2); p_ord(1,2)],'--r')   %Plot the worst simplex on the contour plot of objective function
        pause(0.5);
        V_pegg2=V(ind(2));      % If the reversed point returned a worst result, it reverse the second worst point
        p_new=[p_ord(2,1)+2*((p_ord(1,1)+p_ord(3,1))/2-p_ord(2,1)) p_ord(2,2)+2*((p_ord(1,2)+p_ord(3,2))/2-p_ord(2,2))];
        if f1(p_new(1,1),p_new(1,2))<=V_pegg2
            p(ind(2),:)=p_new(1,:);
            plot([p(:,1); p(1,1)], [p(:,2); p(1,2)],'g')
            pause(0.5);
        else 
            plot([p_ord(1,1); p_ord(3,1); p_new(1,1); p_ord(1,1)],[p_ord(1,2); p_ord(3,2); p_new(1,2); p_ord(1,2)],'--r')   %Plot the worst simplex on the contour plot of objective function
            pause(0.5);
            % If the first reversed point and the second reversed point
            % returned a worst value, it contracts the simplex
            p=[p_ord(1,1) p_ord(1,2); (p_ord(2,1)-p_ord(1,1))/2+p_ord(1,1) (p_ord(2,2)-p_ord(1,2))/2+p_ord(1,2); (p_ord(3,1)-p_ord(1,1))/2+p_ord(1,1) (p_ord(3,2)-p_ord(1,2))/2+p_ord(1,2)];    %Se anche il secondo punto peggiore ha restituito un valore più alto, ritorno al simplesso precedente e dimezzo il passo (lato del simplesso)
            passo=passo/2;  % Contracts the simplex dimension
            plot([p(:,1); p(1,1)], [p(:,2); p(1,2)],'g')    % Plot the new simplex
            pause(0.5);
        end
    end
    
    % It calculates the output variables
    valFunc=f1(p(1,1),p(1,2));
    var_min=[p(1,1), p(1,2)];
    
    iter=iter+1;    % Increases the iterations number
end