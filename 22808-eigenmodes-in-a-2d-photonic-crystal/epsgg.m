%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% calculation of the 'epsgg' matrix for circular holes using
%%% analytical expression; the matrix is symmetric, i.e E'=E
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epsi=epsgg(r, na, nb, b1, b2, N1, N2)
N = N1*N2;
epsilon=zeros(N1,N2); 
epsi=zeros(N,N); 
%%% filling factor, ratio between the area occupied by the cylinders and area of the unit cell
f=(2*pi/sqrt(3))*r^2; 

for  l=1:N1
      for m=1:N2
          for  n=1:N1
              for p=1:N2
                  GGx=(l-n)*b1(1)+(m-p)*b2(1);
                  GGy=(l-n)*b1(2)+(m-p)*b2(2);	
                  GG=sqrt(GGx^2+GGy^2); x=2*pi*GG;
                  %%% GG is a scalar which changes with iteration and goes into Bessel function argument	
                  if (GG~=0)
                      epsilon(p,n)=2*f*(na^2-nb^2)*besselj(1,x*r)/(x*r);
                  else
                      epsilon(p,n)=f*na^2+(1-f)*nb^2;
                  end ; 
              end;  
           end; 
           u=(l-1)*N2+m; %%% this is the line index
           epsi(u,:)=reshape(epsilon,1,N);
        end; 
end; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%