%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% tabela.m
%%
%% This function generates a text (.txt) table with the evaluated values of
%% the room acoustic parameters.
%%
%% tabela(s,n)

function tabela(s,n)


fid = fopen('parametros.txt','w');

    fprintf(fid,'freq [Hz]');
    for m=1:(n-3)
        fprintf(fid,'   %5d  ',s(1,m));
    end
    fprintf(fid,'     A    ');
    fprintf(fid,'     C    ');
    fprintf(fid,'   Linear ');
    fprintf(fid,'\n');
    
    fprintf(fid,' C50 [dB]');
    for m=1:n
        fprintf(fid,'   %-5.2f  ',s(2,m));
    end
    fprintf(fid,'\n');

    fprintf(fid,' C80 [dB]');
    for m=1:n
        fprintf(fid,'   %-5.2f  ',s(3,m));
    end
    fprintf(fid,'\n');

    fprintf(fid,' D50 [%%] ');
    for m=1:n
        fprintf(fid,'   %-5.2f  ',s(4,m));
    end
    fprintf(fid,'\n');

    fprintf(fid,' D80 [%%] ');
    for m=1:n
        fprintf(fid,'   %-5.2f  ',s(5,m));
    end
    fprintf(fid,'\n');

    fprintf(fid,' CT  [ms]');
    for m=1:n
        fprintf(fid,'   %-5.2f  ',s(6,m)*1000);
    end
    fprintf(fid,'\n');

    fprintf(fid,' EDT [s] ');
    for m=1:n
        fprintf(fid,'   %-2.3f  ',s(7,m));
    end
    fprintf(fid,'\n');

    fprintf(fid,' T20 [s] ');
    for m=1:n
        fprintf(fid,'   %-2.3f  ',s(8,m));
    end
    fprintf(fid,'\n');

    fprintf(fid,' T30 [s] ');
    for m=1:n
        fprintf(fid,'   %-2.3f  ',s(9,m));
    end
    fprintf(fid,'\n');

    fprintf(fid,' T40 [s] ');
    for m=1:n
       fprintf(fid,'   %-2.3f  ',s(10,m));
    end
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    
    fprintf(fid,'   BR:  %-2.3f  \n',(s(8,2)+s(8,3))/(s(8,4)+s(8,5)));
    fprintf(fid,'   TR:  %-2.3f  \n',(s(8,6)+s(8,7))/(s(8,4)+s(8,5)));
    
    fclose(fid)