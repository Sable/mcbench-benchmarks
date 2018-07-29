% cell2file   writes a cell array of strings, or number into a file
% ==This function has been obtained modifyng the file str2file.m I found in the FEX.==
% Last Modified: 2008/01/09 (yyyy/mm/dd).
%
% Syntax: cell2file(fid,cell,....) where ... is PARAMETER, VALUE (in pair).
%
% Possible Parameter are: 'EndOfLine' and 'Delimiter'
%
% cell2str can write to a file both sting and numeric format.
%
% You just have to pass the handle to the file
%(so that you can choice your opening attribute) and the cellarray.
%
% Ex:
% A={'prova',[1],'prova';
% [3],'txt',[4]};
%
% fid=fopen('prova.log','a+');
% cell2file(fid,A,'EndOfLine','\r\n');
% fclose(fid);



function cell2file(fid,str,varargin)

id=find(strcmpi('Delimiter',varargin)==1);
if isempty(id)
    delimiter=';';
else
    delimiter=varargin{id+1};
end

id=find(strcmpi('EndOfLine',varargin)==1);
if isempty(id)
    EndOfLine='\n';
else
    EndOfLine=varargin{id+1};
end


for k=1:size(str,1)
    for j=1:size(str,2)
        app=[str{k,j}];
        if isnumeric(app)
            app=num2str(app);
        end
        if not(j==size(str,2))
        fprintf(fid,['%s' delimiter],app);
        else
            fprintf(fid,'%s',app);
        end
    end
    
    if not(k==size(str,1))
    fprintf(fid,EndOfLine);
    end
end
