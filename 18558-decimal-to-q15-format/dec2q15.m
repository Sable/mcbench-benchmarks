%%%%%%%%%%% author: Szymon Leja 2008-01-11
function [y]=dec2q15(x,form)


option = {'mode' , 'roundmode', 'overflowmode', 'format'}; 
value   = {'fixed', 'ceil'     , 'saturate'    ,  [16 15]}; 
q = quantizer( option, value ) ;

if form=='bin'
    y=num2bin(q,x);
end;

if form=='hex'
    y=num2hex(q,x);
end;

end