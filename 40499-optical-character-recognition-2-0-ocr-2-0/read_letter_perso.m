function letter=read_letter(imagn,num_letras)
% Computes the correlation between template and input image
% and its output is a string containing the letter.
% Size of 'imagn' must be 42 x 24 pixels
% Example:
% imagn=imread('D.bmp');
% letter=read_letter(imagn)
global templates
comp=[ ];
for n=1:num_letras
    sem=corr2(templates{1,n},imagn);
    comp=[comp sem];
end
vd=find(comp==max(comp));
%we start with the digits
    if vd==1
        letter='0';
    elseif vd==2
        letter='1';
    elseif vd==3
        letter='2';
    elseif vd==4
        letter='3';
    elseif vd==5
        letter='4';
    elseif vd==6
        letter='5';
    elseif vd==7
        letter='6';
    elseif vd==8
        letter='7';
    elseif vd==9
        letter='8';
    elseif vd==10
        letter='9';
    %We move on with CAPITAL LETTERS
    elseif vd==11
        letter='A';
    elseif vd==12
        letter='B';
    elseif vd==13
        letter='C';
    elseif vd==14
        letter='D';
    elseif vd==15
        letter='E';
    elseif vd==16
        letter='F';
    elseif vd==17
        letter='G';
    elseif vd==18
        letter='H';
    elseif vd==19
        letter='I';
    elseif vd==20
        letter='J';
    elseif vd==21
        letter='K';
    elseif vd==22
        letter='L';
    elseif vd==23
        letter='M';
    elseif vd==24
        letter='N';
    elseif vd==25
        letter='O';
    elseif vd==26
        letter='P';
    elseif vd==27
        letter='Q';
    elseif vd==28
        letter='R';
    elseif vd==29
        letter='S';
    elseif vd==30
        letter='T';
    elseif vd==31
        letter='U';
    elseif vd==32
        letter='V';
    elseif vd==33
        letter='W';
    elseif vd==34
        letter='X';
    elseif vd==35
        letter='Y';
    elseif vd==36
        letter='Z';
    %We end whith the lowercase letters 
    elseif vd==37
        letter='a';
    elseif vd==38
        letter='b';
    elseif vd==39
        letter='c';
    elseif vd==40
        letter='d';
    elseif vd==41
        letter='e';
    elseif vd==42
        letter='f';
    elseif vd==43
        letter='g';
    elseif vd==44
        letter='h';
    elseif vd==45
        letter='i';
    elseif vd==46
        letter='j';
    elseif vd==47
        letter='k';
    elseif vd==48
        letter='l';
    elseif vd==49
        letter='m';
    elseif vd==50
        letter='n';
    elseif vd==51
        letter='o';
    elseif vd==52
        letter='p';
    elseif vd==53
        letter='q';
    elseif vd==54
        letter='r';
    elseif vd==55
        letter='s';
    elseif vd==56
        letter='t';
    elseif vd==57
        letter='u';
    elseif vd==58
        letter='v';
    elseif vd==59
        letter='w';
    elseif vd==60
        letter='x';
    elseif vd==61
        letter='y';
    elseif vd==62
        letter='z';
    %This is the error character
    else
        letter='¤';
    end 
end

