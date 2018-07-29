function Speciation
% Speciation       
%    using MATLAB                     
%
%   $Ekkehard Holzbecher  $Date: 2006/05/03 $
%--------------------------------------------------------------------------
toll = 1.e-15;                    % tolerance
nmax = 50;                        % max. no. of iterations 
Se = [-1 -1 1];                   % reaction matrix
logc = [1.e-10; 1.e-10; 0];       % initial guess (log)
logK = [-0.93];                   % equilibrium constants (log)
logu = [-0.301; 0];               % total concentrations (log)
    
ln10 = 2.3026;
n=size(Se,1); m=size(Se,2);
S1 = Se(:,1:m-n); 
S2 = Se(:,m-n+1:m); 
S1star = -S2\S1; 
U = [eye(m-n),S1star'];

c=exp(ln10*logc);
u(1:m-n,1) = exp(ln10*logu);    
err = toll+1; nit = 0;
while (nit < nmax & err > toll),
    nit = nit+1;
    F = [U*c-u; Se*log10(c)-logK];
    DF = [U; Se*diag((1/ln10)./c)]; 
    dc = -DF\F; 
    cn = max(c+dc,0.005*abs(c));
    err = max(abs(cn-c));
    c = cn;
    logc = log10(c);
end
display (['Species concentrations obtained after ' num2str(nit) ' iterations:']);
c
exp(ln10*logK)-c(3)/c(1)/c(2)
