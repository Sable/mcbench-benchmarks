scores=mod(score,1000);
d1=mod(scores,10);
d2=(mod(scores,100)-d1)/10;
d3=(mod(scores,1000)-d2*10-d1)/100;
if scores<10
    d2=10;
end
if scores<100
    d3=10;
end
set_digit(his,digs{3},d1);
set_digit(his,digs{2},d2);
set_digit(his,digs{1},d3);