function matrix2lyx(M, file_name, format)
% MATRIX2LYX  Save matrix as LyX table
%    MATRIX2LYX(M,F) saves the matrix M in the LyX file given by F.
%
%    MATRIX2LYX(M,F,FORMAT) uses the format string FORMAT (see SPRINTF for
%    details).
%
%    Example
%          M = magic(4);
%          matrix2lyx(M, 'table.lyx', '%d');
%       stores the matrix M in the file named 'table.lyx', using the number
%       format '%d'.
%
%    See also SPRINTF, FPRINTF
%
%    Author: Pål Næverlid Sævik

    if ~exist('format', 'var')
        format = '%g';
    end

    if ~(numel(file_name) > 4 && strcmp(file_name(end-3:end), '.lyx'))
        file_name = [file_name '.lyx'];
    end
    
    fid = fopen(file_name, 'w');
    
    if fid < 3
        error(['Bad file name: ' file_name]);
    end
    
    header_text = {
        '#LyX 1.6.10 created this file. For more info see http://www.lyx.org/'
        '\lyxformat 345'
        '\begin_document'
        '\begin_header'
        '\textclass article'
        '\use_default_options true'
        '\language english'
        '\inputencoding auto'
        '\font_roman default'
        '\font_sans default'
        '\font_typewriter default'
        '\font_default_family default'
        '\font_sc false'
        '\font_osf false'
        '\font_sf_scale 100'
        '\font_tt_scale 100'
        ''
        '\graphics default'
        '\paperfontsize default'
        '\use_hyperref false'
        '\papersize default'
        '\use_geometry false'
        '\use_amsmath 1'
        '\use_esint 1'
        '\cite_engine basic'
        '\use_bibtopic false'
        '\paperorientation portrait'
        '\secnumdepth 3'
        '\tocdepth 3'
        '\paragraph_separation indent'
        '\defskip medskip'
        '\quotes_language english'
        '\papercolumns 1'
        '\papersides 1'
        '\paperpagestyle default'
        '\tracking_changes false'
        '\output_changes false'
        '\author "" '
        '\end_header'
        ''
        '\begin_body'
        ''
        '\begin_layout Standard'
        '\begin_inset Tabular'
    };

    for i = 1:numel(header_text)
        fprintf(fid, '%s\n', header_text{i});
    end
    
    fprintf(fid, '<lyxtabular version="3" rows="%g" columns="%g">\n', size(M, 1), size(M, 2));
    fprintf(fid, '%s\n', '<features>');
    
    for j = 1:size(M, 2)
        fprintf(fid, '%s\n', '<column alignment="center" valignment="top" width="0">');
    end
    
    for i = 1:size(M, 1)
        fprintf(fid, '%s\n', '<row>');
        
        for j = 1:size(M, 2)
            fprintf(fid, '%s\n', '<cell alignment="center" valignment="top" usebox="none">');
            fprintf(fid, '%s\n', '\begin_inset Text');
            fprintf(fid, '%s\n', '\begin_layout Plain Layout');
            fprintf(fid, [format '\n'], M(i,j));
            fprintf(fid, '%s\n', '\end_layout');
            fprintf(fid, '%s\n', '\end_inset');
            fprintf(fid, '%s\n', '</cell>');
        end
        
        fprintf(fid, '%s\n', '</row>');
    end
    
    fprintf(fid, '%s\n', '</lyxtabular>');
    fprintf(fid, '%s\n', '\end_inset');
    fprintf(fid, '%s\n', '\end_layout');
    fprintf(fid, '%s\n', '\end_body');
    fprintf(fid, '%s\n', '\end_document');
    
    fclose(fid);
end