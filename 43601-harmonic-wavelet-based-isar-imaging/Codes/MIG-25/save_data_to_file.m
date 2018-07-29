function save_data_to_file(t3,s)

[nr,nc]=size(t3);
f1=fopen(s,'w');
fprintf(f1,'%d %d\n',nr,nc);
for ii=1:nr
    for jj=1:nc
        fprintf(f1,'%d ',t3(ii,jj));
    end
    fprintf(f1,'\n');
end
fclose(f1);