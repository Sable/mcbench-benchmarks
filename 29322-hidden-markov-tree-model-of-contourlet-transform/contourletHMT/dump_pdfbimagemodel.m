%dump_pdfbimagemodel.m
%written by: Duncan Po
%Date: Sept 27, 2002
%Saves a pdfb model into a file in a readable format
%Usage: dump_pdfbimagemodel(model, filename)
%       model - model of image to be saved
%       filename - name of the file (including full path) to save model in

function dump_pdfbimagemodel(model, filename)

nl = model{1}.nlevels;

for m = 1:nl
    levndir(m) = length(model{1}.stdv{m});
end;

for i = 1:length(model)
    dump_pdfbmodel_to_file(model{i}, filename, levndir, nl);
end;
