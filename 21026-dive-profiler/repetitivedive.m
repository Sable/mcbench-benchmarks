function [rnt] = repetitivedive(pg2,depth)
table3=load('table3naui.dat');
switch pg2
    case 'A'
        row=1;
    case 'B'
        row=2;
    case 'C'
        row=3;
    case 'D'
        row=4;
    case 'E'
        row=5;
    case 'F'
        row=6;
    case 'G'
        row=7;
    case 'H'
        row=8;
    case 'I'
        row=9;
    case 'J'
        row=10;
    case 'K'
        row=11;
    case 'L'
        row=12;
end
col = min(find(table3(1,:)>=depth));
rnt = table3(row+1,col);