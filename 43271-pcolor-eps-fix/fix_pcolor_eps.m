function fix_pcolor_eps(filename)
% Replace triangular tiles in EPS files generated from pcolor with proper 
% rectangular tiles in order to avoid diagonal artefacts in viewing
% software due to their anti-aliasing settings.
%
% Call as fix_pcolor_eps(filename) with filename being a string

tempfile = tempname;
outfid = fopen(tempfile,'w');

str = fileread(filename);  
strings = regexp(str,'(?![/%]).+(?=MP(?! stroke))','match','dotexceptnewline');

crunch = NaN(length(strings),7);
for i = 1:length(strings)
    temp = sscanf(strings{i},'%d');
    if length(temp) == 7
        crunch(i,:) = temp;
    end
end

i = length(strings);
while i > 1
    if all(crunch(i,5:6) == crunch(i-1,5:6)) && all(~isnan(crunch(i,5:6)))
        %if 2 matching triangular tiles, replace second triangle by rectangle
        newstr = [sprintf('%d ',[-1*crunch(i,1:4) crunch(i,1:6) 5]) sprintf('MP\nPP')];
        str = regexprep(str,[strings{i} '.+?PP'],newstr);
        % and delete first triangle
        str = regexprep(str,[strings{i-1} '.+?PP\n'],'');
        i = i-2;
    else
        %no mathing tiles -> do nothing
        i = i-1;
    end
end

fprintf(outfid,'%s\n',str);
fclose(outfid);

copyfile(tempfile, filename);
delete(tempfile);
