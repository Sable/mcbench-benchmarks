%% update fitness for each particle and   iteration
function update_fit()
global ell FitVal El NumVer p fhandle;
ell(1,1:NumVer)=El(1,1:NumVer,p);
FitVal = feval(fhandle,ell);
end