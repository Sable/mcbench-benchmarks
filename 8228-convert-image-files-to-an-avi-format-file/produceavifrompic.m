function produceavifrompic(pfrom,pto,pext,navi)
aviobj = avifile(navi);
aviobj.Quality = 100;
aviobj.compression='None';
cola=0:1/255:1;
cola=[cola;cola;cola];%%grey image
cola=cola';
aviobj.colormap=cola;
for i=pfrom:pto
         fname=strcat(num2str(i),pext)
        adata=imread(fname);
    aviobj = addframe(aviobj,uint8(adata));
end
aviobj=close(aviobj);  