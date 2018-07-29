% This m-file takes care of synthetic division.
% By giving one polynomial and one root this function returns 
% the polynomial formed with the other roots of the given polynomial excluding the given root.
% Keerthi Venkateswara Rao
function coeff_second=syn_division(coeff_function,fun_root_new)
order_fun=size((coeff_function),2);
coeff_second=0;
for index=1:size((coeff_function),2)-1
    if index==1
        coeff_second(index)=coeff_function(index); 
    else
        coeff_second(index)=coeff_function(index)+fun_root_new*coeff_second(index-1);
    end
end