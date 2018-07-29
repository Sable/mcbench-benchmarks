function [P Fcost Pl]=eld(data,B,Pd)
if nargin ~= 3
     error('Wrong number of input arguments')
end
ss=size(data);
if ss(2)~=5
    P='data is wrong the matrix should have six columns';
    Fcost='verify your data';
     Pl='verify your data';
else
end
n=length(data(:,1));

     Aeq=ones(1,n);
     a=data(:,1);
          b=data(:,2);
               c=data(:,3);
                    l=data(:,4);
                         u=data(:,5);
                           P=l;
                         for i=1:5
                             Pl=P'*B*P;
                             Pd1=Pd+Pl;
                             ll=diag(1-2*B*P);
                             A1=inv(ll)*a;
                              B1=inv(ll)*b;
                              H=2*diag(A1);
                              P=quadprog(H,B1,[],[],Aeq,Pd1,l,u);
                              Fcost=.5*P'*H*P+B1'*P+sum(c);
                         end