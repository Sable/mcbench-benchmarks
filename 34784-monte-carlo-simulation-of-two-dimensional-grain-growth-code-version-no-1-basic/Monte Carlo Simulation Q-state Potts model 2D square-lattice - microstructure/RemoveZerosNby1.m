function DMVIWZ = RemoveZerosNby1(DMVI)

ZeroIndices=find(DMVI==0);
DMVI(ZeroIndices(:))=[];
DMVIWZ=DMVI;