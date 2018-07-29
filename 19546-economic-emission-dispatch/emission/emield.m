function [P Fcost Emi Pl]=emield(elddata,emidata,h1,h2,B,Pd)

if nargin ~= 6
     error('Wrong number of input arguments')
end
n=length(elddata(:,1));

     Aeq=ones(1,n);
     a=elddata(:,1);
          b=elddata(:,2);
               c=elddata(:,3);
                    l=elddata(:,4);
                         u=elddata(:,5);
                          a1=emidata(:,1);
          b1=emidata(:,2);
               c1=emidata(:,3);
                           P=l;
                         for i=1:5
                             Pl=P'*B*P;
                             Pd1=Pd+Pl;
                             ll=diag(1-2*B*P);
                             A1=inv(ll)*(h1*a+h2*a1);
                              B1=inv(ll)*(h1*b+h2*b1);
                              H=2*diag(A1);
                              P=quadprog(H,B1,[],[],Aeq,Pd1,l,u);
                              Fcost=a'*(P.*P)+b'*P+sum(c);
                               Emi=a1'*(P.*P)+b1'*P+sum(c1);
                         end