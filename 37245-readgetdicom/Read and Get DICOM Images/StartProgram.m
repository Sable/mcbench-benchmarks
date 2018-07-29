function StartProgram
%----------------------------------------
clc;clear all;close all;delete('*.asv');
%----------------------------------------

if exist('Program''s Data','dir')==0
    if exist('Program''s Data.zip','file')~=0
        unzip('Program''s Data.zip');
    else
        msgbox('The Program Can''t find Help files','Error!!!','Warn','modal');
    end
end

if exist('Program''s Data','dir')~=0
    rgdicom;
end

end