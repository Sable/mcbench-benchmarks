function fj=CF_SVj(xt,vt,tau,mu,a,uj,bj,rho,sig,phi)
%--------------------------------------------------------------------------
%PURPOSE: implements the CF fj of Heston. Uses Heston's notations.
%--------------------------------------------------------------------------


xj = bj - rho.*sig.*phi.*i;
dj = sqrt( xj.^2 - (sig.^2).*( 2.*uj.*phi.*i - phi.^2 ) );
gj = ( xj+dj )./( xj-dj );
D  = ( xj+dj )./(sig.^2).* ( 1-exp(dj.*tau) )./( 1-gj.*exp(dj.*tau)  ) ;
xx = ( 1-gj.*exp(dj.*tau) )./( 1-gj );
C  = mu.*phi.*i.*tau + a./( sig.^2 ) .* ( (xj+dj) .* tau - 2.*log(xx) );
fj = exp( C + D.*vt + i.*phi.*xt );