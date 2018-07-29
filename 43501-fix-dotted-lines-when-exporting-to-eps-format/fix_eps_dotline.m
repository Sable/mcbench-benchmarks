function fix_eps_dotline(filename,line_width,gap_width)
%  Repair the horrendous way that the default dotted \ dash-dot lines look
%  when exported to .eps
%
% Inputs:
%   filename   - the bad looking .eps file name (no need for .eps suffix)
%   line_width - the visible line width in points
%   gap_width  - the gap width in points
%
% Outputs:
%    a new eps file named "filename_fixed.eps'
%
% Example:
%    fix_eps_dotline('fig1',3,3)
%
%   Comments \ improvements are welcomed
%   Natan (nate2718281828@gmail.com)

dotstr = ['[' num2str(line_width)];
gapstr = ['mul ' num2str(gap_width)];

fid = fopen([filename '.eps'],'r');
filename_fixed=[filename '_fixed.eps'];
tempfile = tempname;
outfid = fopen(tempfile,'w');
repeat = 1;
while repeat==1
    thisLine = fgetl(fid);
    
    iStart = strfind(thisLine,'/DO { [.5');
    
    if iStart
        thisLine = regexprep(thisLine,'[.5',dotstr);
        thisLine = regexprep(thisLine,'mul 4',gapstr);
    end
    
    iStart = strfind(thisLine,'/DD { [.5');
    if iStart
        thisLine = regexprep(thisLine,'[.5',dotstr);
        thisLine = regexprep(thisLine,'mul 4',gapstr);
        
    end
    
    iStart = strfind(thisLine,'/DA { [6');
    if iStart
        thisLine = regexprep(thisLine,'[6',dotstr);
    end
    
    if ~ischar(thisLine)
        repeat = 0;
    else
        fprintf(outfid,'%s\n',thisLine);
    end
end

fclose(fid);
fclose(outfid);
copyfile(tempfile, filename_fixed,'f');
delete(tempfile);
