function LnX = coefficient(x,y,L)
% Lagrange form for the polynomial interpolation
% this function produces elements of the form y_k*L_k(x) 
n = length(x);
Num = '';
Den = '';
syms X

for i = 1:n
    if i ~= L
    TempNum = strcat('(X-x(',num2str(i),')',')','*');
    Num = strcat(Num,TempNum); 
    TempDen = strcat('(x(',num2str(L),')','-','x(',num2str(i),')',')','*');
    Den = strcat(Den,TempDen);
    end
end

Num(end) = []; Den(end) = [];
LnX = (eval(strcat('(',Num,')','/','(',Den,')')))*y(L);