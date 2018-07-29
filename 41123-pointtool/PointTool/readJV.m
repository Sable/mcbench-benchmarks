function readJV(file)
[nv,nf]=nnu(file);
fprintf('number of point:%d\n',nv);
fprintf('number of face:%d\n',nf);
fid=fopen(file);
fid2=fopen('point.off','w');
while 1
    tline = fgetl(fid);
    if ~ischar(tline),   break,   end
    %disp(tline)
    n=length(tline);
    if n > 0 
        header=findstr(tline,'#JV');
        J=isempty(header);
        if J==1
        disp(tline)
        fprintf(fid2,'%s \n',tline);
        end
    end
end
fclose(fid);
fclose(fid2);
function [nv,nf]=nnu(file)
fid = fopen(file);
C=0;
while 1
    tline = fgetl(fid);
    C=C+1;
    if ~ischar(tline),   break,   end
    if C==3
        CC = textscan(tline, '%f %f %f');
        break;
    end
    %disp(tline)
end
fclose(fid);
nv=CC{1,1};
nf=CC{1,2};


