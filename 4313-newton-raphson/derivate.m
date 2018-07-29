% This m-file calculates the derivative of the function, the limitation of
% this function is, it can calculate only the derivatives of power(x,n)....
% Keerthi Venkateswara Rao
function coeff_derivative=derivate(coeff_function)
der_order=size((coeff_function),2)-1;
coeff_derivative=0;
for index=1:size((coeff_function),2)-1
    coeff_derivative(index)=der_order*coeff_function(index);
    der_order=der_order-1;
end