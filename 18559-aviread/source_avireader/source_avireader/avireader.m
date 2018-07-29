function mov = avireader(filename, index)
% AVIREAD Read AVI file. 
%     MOV = AVIREAD(FILENAME) reads the AVI movie FILENAME into the
%     MATLAB movie structure MOV. If FILENAME does not include an
%     extension, then '.avi' will be used. MOV has two fields, "cdata"
%     and "colormap".
%     
%     MOV = AVIREAD(...,INDEX) reads only the frame(s) specified by
%     INDEX.  INDEX can be a single index or an array of indices into the
%     video stream, where the first frame is number one.
%     Without INDEX specification the default frame is the first.
%
%     Using the ffdshow filter Installing and configuring appropriate ffdshow codec 
%     
%     Original idea by Lei Wang
%     http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=15864&objectType=File
%
% Written by Gregory PAIS
%
% The doc aviread referenced in Help browser is the aviread original Matlab
% function


try    

    mov = AviReadMex(filename, index);
    
    
catch
    err = lasterror;

    if strfind(err.message,'combination')
        disp('The ''No combination of intermediate filters could be found to make the connection'' error');
        disp('means that no appropriate codec could be found.  Mpg2 files seem to be the worst.  ');
        disp('Installing ffdshow (www.free-codecs.com/FFDShow_download.htm) often fixes this problem. ');
    end
    rethrow(err);
end
