function [pg] = endofdive(depth,time)
table1=load('table1naui.dat');
row = min(find(table1(:,1)>=depth));
col = min(find(table1(row,2:end)>=time));
if isempty(row) | isempty(col)
    col = 13;
end
switch col
    case 1
        pg='A';
    case 2
        pg='B';
    case 3
        pg='C';
    case 4
        pg='D';
    case 5
        pg='E';
    case 6
        pg='F';
    case 7
        pg='G';
    case 8
        pg='H';
    case 9
        pg='I';
    case 10
        pg='J';
    case 11
        pg='K';
    case 12
        pg='L';
    otherwise
        pg='X';
end