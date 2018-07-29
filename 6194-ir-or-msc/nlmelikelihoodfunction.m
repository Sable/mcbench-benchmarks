function loglikelihood=nlmelikelihoodfunction(B,D,q)
degradationdata;
timedata;
Options = optimset('TolX', 1E-8, 'TolFun', 1E-8,'MaxFunEvals', 1E10);

h=[1e-10];
s=0;
G=0;

for i=1:1:M


b=ones(q,1);
[b_hat(:,i),exit,flag]=fminsearch('nlmeadd1',b,Options,B,Y(i,:),D);

end


for i=1:M


% First derivative of the degradation function with regard to b(i)
    afgeleide_f=((nlmeadd3(B,i,(b_hat(:,i)+h))-nlmeadd3(B,i,b_hat(:,i))))./h;
    
    %second order derivative approximation of g. 

    g_dubbel_accent=(afgeleide_f)*transp(afgeleide_f)+inv(D);
    G=G+log(det(g_dubbel_accent));
 
  
    s=s+(nlmeadd2(B,i,b_hat(:,i),D)/N);

end

sigma_squared_hat=s;
loglikelihood=0.5*(N*(1+log(2*pi)+log(sigma_squared_hat))+M*log(det(D))+(G));
