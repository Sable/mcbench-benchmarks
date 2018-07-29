function [Dimension,NodeCoord,NodeWeight,Name]=GetTSPData(infile)
if exist(infile,'file')
    fid=fopen(infile,'r');
else
    disp('Input file no exist!');
    return;
end
if fid<0
    disp('Error while open file!');
    return;
end
NodeWeight = [];
while feof(fid)==0
    temps=fgetl(fid);
    if strcmp(temps,'')
        continue;
    elseif strncmpi('NAME',temps,4)
        k=findstr(temps,':');
        Name=temps(k+1:length(temps));
    elseif strncmpi('DIMENSION',temps,9)
        k=findstr(temps,':');
        d=temps(k+1:length(temps));
        Dimension=str2double(d);
    elseif strncmpi('EDGE_WEIGHT_SECTION',temps,19)
        formatstr = [];
        for i=1:Dimension
            formatstr = [formatstr,'%g '];
        end
        NodeWeight=fscanf(fid,formatstr,[Dimension,Dimension]);
        NodeWeight=NodeWeight';
    elseif strncmpi('NODE_COORD_SECTION',temps,18) || strncmpi('DISPLAY_DATA_SECTION',temps,20)
        NodeCoord=fscanf(fid,'%g %g %g',[3 Dimension]);
        NodeCoord=NodeCoord';
    end
end
fclose(fid);