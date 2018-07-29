% Test case for FMINCONSET

xlb=[0 0 0 0 0 0 1 1 1]';
xub=[20 20 20 20 20 20 9 9 9]';
set={[],[],[],[],[],[],[1 2 3 4 5 6 7 8 9],[1 2 3 4 5 6 7 8 9],[1 2 3 4 5 6 7 8 9]};
x0=[1 1 1 1 1 1 1 1 1]';
options=optimset('Hessian','off','largescale','off','Gradobj','on','Gradconstr','on','TolX',1e-6,'display','iter',...
   'tolcon',1e-6,'Derivativecheck','on');
% Set 'Display','off' and 'Derivativecheck','off' if you don't like all the output from FMINCON.
% For 'Display','off' you have to correct an error in ../toolbox/optim/nlconst.m where an EXITFLAG = -1 is
% placed within an if verbosity>0  ... end.  
% The if verbosity>0 ... end should only enclose the display statements. 

% global spor	% enable this and the use of the global variable 'spor' in FMINCON to record the prograss of the algorithm.
% spor=[];


[x,h,exitflag,output,lambda,grad,hessian]=fminconset('J134org',x0,[],[],[],[],xlb,xub,'H134org',options,set,inf,'a','b');


