function browse_mdl(bpath)
% browse_mdl(bpath), Browse models
%
% A quick and dirty simulink model file browser
% Copies pictures of the simulink models files specified by bpath into a new word document with the model name
% If bpath is not specified it lists all the simulink files in the current directory.

if nargin < 1
    files=dir('*.mdl');
else
    [pathstr,name] = fileparts(bpath);
    if exist(bpath,'dir')
        name = [name '\*'];
    end
    ext = '.mdl';
    files=dir(fullfile(pathstr,[name ext]));
end

if ~isempty(files)
    whandle = actxserver('word.application');
    whandle.Visible = 1;
    Add(whandle.Documents);
    sel=whandle.Selection;
    set(sel.ParagraphFormat,'Alignment','wdAlignParagraphLeft');
    set(sel.PageSetup,'LeftMargin',28.35,'RightMargin',28.35,'BottomMargin',28.35*1.43);
    for index=1:size(files,1)
        title=files(index).name;
        eval(title(1:end-4));
        print('-dmeta',['-s', title(1:end-4)]);
        bdclose;
        close('all');
        TypeText(sel,title);
        set(sel.ParagraphFormat,'KeepWithNext',-1)
        TypeParagraph(sel);
        Paste(sel);
        set(sel.ParagraphFormat,'KeepWithNext',0)
        TypeParagraph(sel);
    end
    release(whandle);
end

return