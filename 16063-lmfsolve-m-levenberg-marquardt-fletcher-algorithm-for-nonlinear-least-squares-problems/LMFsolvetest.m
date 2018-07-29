% LMFsolvetest	Test of the function LMFtest
% ~~~~~~~~~~~~  { default = Rosenbrock }   2009-01-08

x   = inp('Starting point [xo]',[-1.2; 1]);
x   = x(:);
lx  = length(x);
fun = inp('Function name      ','rosen');
D   = eval(inp('vektor vah      [D]','1'));
ipr = inp('Print control   ipr',1);

resid = eval(['@' fun]);    %   function handle
options = LMFsolve('default');
options = LMFsolve...
    (options,...
    'XTol',1e-6,...
    'FTol',1e-12,...
    'ScaleD',D,...
    'Display',ipr...
    );
[x,S,cnt]=LMFsolve(resid,x,options);
%         ~~~~~~~~~~~~~~~~~~~~~~~~~

fprintf('\n  radius = %15.8e\n', sqrt(x'*x));

