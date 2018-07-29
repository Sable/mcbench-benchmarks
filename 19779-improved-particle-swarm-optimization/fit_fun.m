function Fit_fun_val=fit_fun(v)

   %Fit_fun_val= sin(1/v(1))^6 + sin(1/v(2))^6 + sin(1/v(3))^6-3;
   %Fit_fun_val= 100*(v(1)^2-v(2))^2+(1-v(1))^2+v(3);
   Fit_fun_val= v(1)^2 + v(2)^2 + v(3)^2;