%load_pdfbimagemodel.m
%written by: Duncan Po
%Date: Oct 1, 2002
%loads a pdfb model from a text file
%Usage: model = load_pdfbimagemodel(filename, levndir, ns, zeromean)
%       filename - name of the file to load model from
%       levndir - number of subbands in each scale (log2)
%       ns - number of states in the model
%       zeromean - 'yes' for zeromean and 'no' otherwise

function model = load_pdfbimagemodel(filename, levndir, ns, zeromean)

nlevel = length(levndir);

for i = 1:2.^levndir(1)    
    model{i}.nstates = -2;
    model{i}.nlevels = -1;
    model{i}.zeromean = 0;
    model{i}.rootprob = zeros(1,ns);
    for l = 1:nlevel-1
        for k = 1:2.^(levndir(l+1)-levndir(1))
            model{i}.transprob{l}{k} = zeros(ns);
        end;
    end;
    for l = 1:nlevel
        for k = 1:2.^(levndir(l)-levndir(1))     
            if strcmp(zeromean, 'yes') == 0
                model{i}.mean{l}{k} = zeros(1,ns);
            end;
            model{i}.stdv{l}{k} = zeros(1, ns);
        end;
    end;
end;

startpos = 0;
for i = 1:2.^levndir(1) 
    startpos = load_pdfbmodel_from_file(model{i}, filename, levndir, nlevel, ...
        startpos);
end;
