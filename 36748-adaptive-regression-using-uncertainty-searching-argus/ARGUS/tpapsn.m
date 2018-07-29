function [funhndl st] = tpapsn(x,y,psifun,dis,ver)
%This function is a polyharmonic cubic spline in N-D
%This is written for the ARGUS stochastic search method
%The input format differs from tpaps. x is a nxd matrix where d is the
% dimension and n are the number of points
%y is a nx1 vector. tpaps handles multiple metrics
% The logic is taken from Matlab's tpaps including some code snippets
% psifun is the function handle for psi(centers,x). Default is second order 
% is a function handle to the resulting fit.
%dis is an existing distance matrix
%we is a weighting vector, but it is not currently used
%ver is a boolean for verbose output
%
%   Example inputs hnd = tpapsn([1;2;3;4],[1;2;3;4]);
%                  hnd = tpapsn([1;2;3;4],[1;2;3;4],@psifunc);
%                  hnd = tpapsn([1;2;3;4],[1;2;3;4],@psifunc,...
%                                      pdist2([1;2;3;4],[1;2;3;4]));
%                  hnd = tpapsn([1;2;3;4],[1;2;3;4],[],...
%                                      pdist2([1;2;3;4],[1;2;3;4]));
%                  ans = feval(hnd,[2.5;3.5])
%st is a structure of all the information needed to make the
% function handle
%Adaptations from tpaps algorithm makes this function up to 20x faster

[nx,m] = size(x);
[ny,my]=size(y);
if nargin<5, ver=true;end
%if nargin<5 || isempty(we),we=ones(ny,1);end

%Same number of values for y and x?
if ny~=nx
    error('The length of y and x must be equal')
end

mp1= m+1;
%Ignore all nonfinites
nonfinites = find(sum(~isfinite([x,y])));
if ~isempty(nonfinites)
   x(:,nonfinites) = []; y(:,nonfinites) = []; nx = size(x,2);
   if(ver)
       warning('Inf and NaN values ignored')
   end
end

% Are there enough points?
if nx<mp1
    if(ver)
        warning('Not enough points to fit. This will return a mean line' )
    end
   %Return a mean line line for any x
   funhndl = @(X)(mean(y)*ones(size(X,1),1));
   return;
end

%Depending on the inputs choose the psi transformation
if nargin==4 && isempty(psifun) && ~isempty(dis)
    psifun = @(centers,x)psitemp(centers,x);
    colmat = psitemp(x,x,dis);
elseif nargin<3 || isempty(psifun)
    psifun = @(centers,x)psitemp(centers,x);
    colmat = feval(psifun,x,x);
else
    colmat = feval(psifun,x,x);
end
%Weight the locations;
%colmat = diag(we)*colmat;

[Q,R] = qr([ x ones(nx,1)]);
radiags = sort(abs(diag(R)));
if radiags(1)<1.e-14*radiags(end)
    if(ver)
        warning('There are collinearsites. This will return a mean line')
    end
    %Return a mean line line for any x
    funhndl = @(X)(mean(y)*ones(size(X,1),1));
    st=[]; %st is an empty structure
else
    
    Q1 = Q(:,1:mp1); Q(:,1:mp1) = [];
    if nx==mp1 % simply return the interpolating plane
        coefs1 = zeros(my,mp1);
        coefs2 = y'/(R(1:mp1,1:mp1).');
    elseif nx<729 % solve the linear system directly:
        
        coefs1 = (y'*Q/(Q'*colmat*Q))*Q';
        coefs2 = ((y' - coefs1*colmat)*Q1)/(R(1:mp1,1:mp1).');
        
    else      % we use an iterative scheme, to avoid use of out-of-core memory
        % and, for very large problems, perhaps to save execution time
        
        % GMRES(AFUN,B,RESTART,TOL,MAXIT,M1FUN,M2FUN,X0,P1,P2,...)
        % [coefs1(:,i),flag,relres,iter,resvec] = ...
        % ask for the flag output to prevent GMRES from printing a message
        [coefs1,flag] = gmres(@tppval,(y'*Q).',10, ...
            1.e-6*max(abs(y(:))),[],[],[],zeros(nx-mp1,1), colmat,Q);
        if flag && ver, warning('Spline did not converge. Should approximate the LS regression.');
        end
        
        coefs1 = (Q*coefs1)';
        coefs2 = ((y' - coefs1*colmat)*Q1)/(R(1:mp1,1:mp1).');
    end
    %If more information is needed, put it in a structure
    st.centers = x;
    st.coefs =[coefs1,coefs2];
    [dco, nco] = size(st.coefs);
    st.ncenters = nx;
    st.number = nco;
    st.dim = dco;
    
    %Wrap everything in a nice function handle
    funhndl = @(X)(st.coefs*[feval(psifun,st.centers,X);X';ones(1,size(X,1))])';

end

end

function vals = tppval(x,colmat,Q2)
%TPPVAL evaluation for iterative solution of spline smoothing system
vals = ((Q2*x)'*colmat*Q2)';
end

function psi = psitemp(centers,x,dis)
%This function is the psi cubic spline function
if nargin<3
    dis = pdist2(centers,x);
end
r=dis.*dis;
r(r==0)=1;
psi=r.*log(r);
end

