function tex_out = matlab_marker_to_latex(mkr_in)

if strcmp(mkr_in, '+')
    tex_out = '+';
elseif strcmp(mkr_in, 'o')
    tex_out = '$\circ$';
elseif strcmp(mkr_in, '*')
    tex_out = '$\ast$';
elseif strcmp(mkr_in, '.')
    tex_out = '$\bullet$';
elseif strcmp(mkr_in, 'x')
    tex_out = '$\times$';
elseif strcmp(mkr_in, 'square')
    tex_out = '$\Box$';
elseif strcmp(mkr_in, 'diamond')
    tex_out = '$\Diamond$';
elseif strcmp(mkr_in, 'v')
    tex_out = '$\nabla$';
elseif strcmp(mkr_in, '^')
    tex_out = '$\triangle$';
elseif strcmp(mkr_in, '>')
    tex_out = '$\triangleright$';
elseif strcmp(mkr_in, '<')
    tex_out = '$\triangleleft$';
elseif strcmp(mkr_in, 'pentagram')
    tex_out = '$\star$';
elseif strcmp(mkr_in, 'hexgram')
    tex_out = '$\bowtie$';
else
    tex_out = '$\otimes$';
end    
    