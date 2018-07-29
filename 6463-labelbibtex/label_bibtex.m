function y=label_bibtex(bibtex,k)

%LABEL_BIBTEX labels bibliographic entries in bibtex file
%Syntax: y=label_bibtex(bibtex,k)
%Description: adds a label to each entry composed as Author:Year:[k letters of the title]
%             if k argument is not provided 25 will be used by default
%
%for example file file.bib with contents
%
%------------------------------------------------
%@article{de_Almeida:2001-Analysis-of-genomic-seque,
%   Author = {de Almeida, J. S. and Carrico, J. A. and Maretzek, A. and Noble, P. A. and Fletcher, M.},
%   Title = {Analysis of genomic sequences by Chaos Game Representation},
%   Journal = {Bioinformatics},
%   Volume = {17},
%   Number = {5},
%   Pages = {429-37},
%(...)
%    Year = {2001} }
%
%@article{Almeida:2002-Universal-sequence-map--U,
%   Author = {Almeida, J. S. and Vinga, S.},
%   Title = {Universal sequence map (USM) of arbitrary discrete sequences},
%   Journal = {BMC Bioinformatics},
%   Volume = {3},
%   Number = {1},
%  
%   etc ...
%------------------------------------------------
%
%will be rewritten by y=endnote2bibtex('file.bib',25) as
%
%------------------------------------------------
%   Author = {Almeida, J. S. and Carrico, J. A. and Maretzek, A. and Noble, P. A. and Fletcher, M.},
%   Title = {Analysis of genomic sequences by Chaos Game Representation},
%   Journal = {Bioinformatics},
%   Volume = {17},
%   Number = {5},
%(...)
%    Year = {2001} }
%
%@article{Almeida:2002:Universal sequence map (U...,
%   Author = {Almeida, J. S. and Vinga, S.},
%   Title = {Universal sequence map (USM) of arbitrary discrete sequences},
%   Journal = {BMC Bioinformatics},
%   Volume = {3},
%   Number = {1},
%   
%   etc ...
%------------------------------------------------
%
%Jonas Almeida, almeidaj@musc.edu, December 2004

if nargin<2;k=25;end

%1.Reads all contents and extracts Author, Year and Title
fid=fopen(bibtex,'r');
L=[];i=0;
while ~feof(fid)
    linha=fgetl(fid);i=i+1;%disp(linha);
    [a,b,c,d,e]=regexpi(linha,'@article{.*');
    if length(e)>0%this is the beggining of an entry
        L=[L,i]; %keep track of the lines that have to be changed
        j=length(L);
        %label{j}='';
    else
        [a,b,c,d,e]=regexpi(linha,'\s+Author = {(.+?),.*');
        if length(e)>0
            %disp(e{1});
            %label(j)=e{1};label{j}=[label{j},':'];
            Author{j}=regexprep(e{1}{1},'\W','_');
            %Author{j}=e{1}{1};
        else
            [a,b,c,d,e]=regexpi(linha,'\s+Year = {(\w+)}.*');
            if length(e)>0
                %disp(e{1});
                %label(j)=e{1};label{j}=[label{j},':'];
                Year{j}=e{1}{1};
            else                    
                [a,b,c,d,e]=regexpi(linha,'\s+Title = {(.*?)}.*');
                if length(e)>0
                    %disp(e{1});
                    %label(j)=e{1};label{j}=[label{j},':'];
                    Title{j}=regexprep(e{1}{1},'\W','-');  
                end
            end
        end
    end
end
fclose(fid);
y.L=L;
y.Author=Author;
y.Year=Year;
y.Title=Title;

%2. And now writes it back to the file
%first copy to temporary file
fid1=fopen(bibtex,'r');
fid2=fopen(['temp_',bibtex],'w');
i=0;j=1;
while ~feof(fid1)
    i=i+1;linha=fgetl(fid1);
    if sum(L==i)>0
        if k>0
            fprintf(fid2,'%s\n',[linha(1:9),y.Author{j},':',y.Year{j},'-',y.Title{j}(1:min([k,length(y.Title{j})])),',']);
        else
            fprintf(fid2,'%s\n',[linha(1:9),y.Author{j},':',y.Year{j},',']);
        end
        j=j+1;
    else
        fprintf(fid2,'%s\n',linha);
    end
end
fclose(fid1);fclose(fid2);
%copy temprary file onto original 
copyfile(['temp_',bibtex],bibtex);
%delete temporary file
delete(['temp_',bibtex]);
