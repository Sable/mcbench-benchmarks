function Dir2SpSh()

% Author:  Eric L. LePage, Ph.D.; National Acoustic Labs, Sydney, Australia
% Eric.LePage@nal.gov.au
% written 8 June 2001; submitted 9 Feb 2002
%
% A big gap in Windows (even XP!! - unlike linux) is the lack of ability to generate a directory 
% listing (i.e. of filenames and details not the file) as a text file which can be picked up by an editor or 
% spreadsheet, for a more efficient method of keeping track of files, date generated, versions etc, 
% file/project management.  This recursive function allows spreadsheet listing (and manipulation) 
% of files in and below any folder pointed to by your browser and copied to the clipboard (Cntl-C). 
% The file has a header detailing which computer, which disk, and the time the listing was generated. 
% It automatically writes result to a file with name of the form 
% Computername_Dk_Folder1_Folder2_etc_dir.txt, where the various columns of the directory 
% listing are in separate columns, semicolon delimited.

%for Windows 2000
folder = clipboard('paste') ;
%for Windows NT/95
%folder = input('Enter directory exactly as appears in Windows Explorer: ','s')
cprname = input('Enter computer name : ','s'); %haven't figured how to interrogate the OS to find this

temp = strrep(folder,'\','_');
temp = strrep(temp,':','');

OutFile  = ['c:\temp\' cprname '_' temp '_dir.txt'];
fid=fopen(OutFile,'wt');
dat = datestr(now);
fprintf(fid,'"%s";DIRECTORY LISTING ;on;"%s";"%s"\n\n',[cprname ' ' folder ' (' getenv('os') ')'],dat(1:11),dat(13:20));
fprintf(fid,'"%s";"%s";"%s";"%s";"%s";"%s"\n','Folder','Name','Extn','Date','Time','#Bytes');

currfolder(folder,fid)
fclose('all');

return
%-------------------------------------------------

function currfolder(folder,fid)

fprintf('%s\n',folder) %;
di = dir(folder);
DirSz = size(di,1);

for i=3:DirSz
    nam = deblank(di(i).name) ;
    namsiz = size(nam,2);
    isd = di(i).isdir;
    if ~isd
        ctr = findstr('.',fliplr(nam)); % look for extention
        if isempty(ctr) 
            ctr=0; 
        end
        nam2 = nam(1:namsiz-ctr);
        extn = nam(namsiz-ctr+2:namsiz);
        dat = di(i).date;
        if isempty(dat)
            dat = 'dateisempty nil_time';
        end
        byt = di(i).bytes;
        fprintf(fid,'"%s";"%s";"%s";"%s";"%s";"%d"\n',folder,[nam2],lower(extn),dat(1:11),dat(13:20),byt);
    else
        currfolder([folder '\' nam],fid) % recursively do subfolders
    end
end

return
