function [pg2] = surfaceinterval(pg,si)
table2=load('table2naui.dat');
switch pg
    case 'A'
        col=1;
    case 'B'
        col=2;
    case 'C'
        col=3;
    case 'D'
        col=4;
    case 'E'
        col=5;
    case 'F'
        col=6;
    case 'G'
        col=7;
    case 'H'
        col=8;
    case 'I'
        col=9;
    case 'J'
        col=10;
    case 'K'
        col=11;
    case 'L'
        col=12;
end
row = min(find(table2(:,col)<si));
if isempty(row)
    pg2=pg;
else
    switch row
        case 1
            pg2='A';
        case 2
            pg2='B';
        case 3
            pg2='C';
        case 4
            pg2='D';
        case 5
            pg2='E';
        case 6
            pg2='F';
        case 7
            pg2='G';
        case 8
            pg2='H';
        case 9
            pg2='I';
        case 10
            pg2='J';
        case 11
            pg2='K';
        case 12
            pg2='L';
    end
end