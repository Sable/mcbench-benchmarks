% Read generic object editor text file to load classifier name
function classifiers = getclass(fileName)
%fileName = 'GenericObjectEditor.props';
cellStr = textread(fileName,'%s','delimiter','\n','whitespace','');
nlines = size(cellStr,1);
locationClassifiers = 'weka.classifiers.Classifier=\';
for i=1:nlines
    if strcmp(cellStr(i),locationClassifiers)
        loc=i;
        break
    end
end
j=1;

for i=loc+1:nlines
    
    str=cellStr{i};
    if strcmp(str,'')
        break
    end
    % remove text after comma
    k = strfind(str, ',');
    if ~isempty(k)
        str=str(1:k-1);
    end
    % remove trailing spaces
    str = strtrim(str);
    classifiers{j}=str;
    j=j+1;
end
        

