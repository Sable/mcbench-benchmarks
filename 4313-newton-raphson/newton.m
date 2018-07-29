% this m-file calculates the real roots of the given polynomial using 
% newton raphson technique.this m-file calls the functions in the two m-files named as syn_division and
% derivate.
% coeff_function is the 1xn matrix conatining the coeff of the polynomial.
% Keerthi Venkateswara Rao
function [final_roots,functionvalue] = newton(coeff_function,initial_guess,error_tolerance,max_iterations)
iterations=0;
max_no_roots=size(coeff_function,2);
final_roots=0;
functionvalue=0; 
for no_roots=1:max_no_roots-1
    fun_root_new=initial_guess;
    flag=1;
    coeff_der_function=derivate(coeff_function);
    order_fun=size(coeff_function,2);
    order_der_fun=size(coeff_der_function,2);
    while flag==1
        fun_root_old=fun_root_new;
        fx=0;
        dfx=0;
        nonzero=1;
        while nonzero==1
            powers=order_fun-1;
            for index=1:order_fun
                fx=fx+coeff_function(index)*fun_root_old^powers;
                powers=powers-1;
            end
            powers=order_der_fun-1;
            for index=1:order_der_fun
                dfx=dfx+coeff_der_function(index)*fun_root_old^powers;
                powers=powers-1;
            end
            if dfx==0
                fun_root_old=fun_root_old+1;
            else
                nonzero=0;                
            end                
        end
        iterations = iterations + 1;
        fun_root_new = fun_root_old - fx/dfx;
        if iterations >= max_iterations 
            flag=0;
        elseif  abs(fun_root_new-fun_root_old)<=error_tolerance 
            flag=0;
            final_roots(no_roots)=fun_root_new;
            functionvalue(no_roots)=fx;
        end
    end
    coeff_function=syn_division(coeff_function,fun_root_new);
 end
 