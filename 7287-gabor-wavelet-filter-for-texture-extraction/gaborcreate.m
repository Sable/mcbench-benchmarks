function [gab]=gaborcreate(M,N)

%CREATION OF GABOR MASK
 %Parameters -m=0,1,...M-1 scales ; n=0,1,...N-1 orientation
 
 %CREATION OF GABOR MASK
 %Parameters -m=0,1,...M-1 scales ; n=0,1,...N-1 orientation
 
 M=4;
 N=3;
 a=(0.4 / 0.05)^(1/(M-1));
 gab=cell(2,2);
 count=1;
 
 for m=1:M
     for n=1:N
         
         W=a^m * 0.05;
         sigmax=((a+1)*sqrt(2 * log(2))) / (2 * pi * a^m * (a-1) * 0.05);
         sigmay1=((0.4 *0.4) / (2*log(2))) - (( 1 / (2 *pi* sigmax))^2); 
         sigmay=1 / ((2* pi * tan(pi/(2*N)) * sqrt ( sigmay1)));
         theta=(n*pi)/N ;

         for ij=1:2
            for i=1:3
              for j=1:3
                    xb=a^(-m) * (i*cos(theta) + j*sin(theta));
                    yb=a^(-m) * ((-i)*sin(theta) + j*cos(theta));
                    phi1=(-1/2) * ((xb*xb)/(sigmax*sigmax) + (yb*yb)/(sigmay*sigmay));
                     if ij==1
                        prob=i;
                    else
                        prob=j;
                    end
                    phi=(1/(2*pi*sigmax*sigmay)) * exp(phi1) * exp(2*2*pi*W*prob);
                    gab1(i,j)=phi* a^(-m);
              end
          end
         gab{count,ij}=gab1;
 
        end

          count=count+1;
      end
  end