function produceavifromcpic(pfrom,pto,pext,navi)
aviobj = avifile(navi);
aviobj.Quality = 100;
aviobj.compression='None';%%color image
for i=pfrom:pto
       fname=strcat(num2str(i),pext)
       adata=imread(fname);
    aviobj = addframe(aviobj,uint8(adata));
end
aviobj=close(aviobj);