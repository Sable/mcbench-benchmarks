function [imdata] = clipboardimage(format)
%
%DESCRIPTION
%   clipboardimage image Copy images to and from system clipboard.
%
%INPUT  :
%   format :specifies the format in which the image data is requested.
%   accepted values are 'jpg' or 'bmp'
%OUTPUT :
%   empty if image data is not present.
%   uint8 array describing image information.
%
%EXAMPLE: 
%  >>t = clipboardimage('jpg');
%  >>t = clipboardimage('bmp');
%  gets the imagedata in the matlab workspace variable t.
%  now the information can be manipulated with matlab commands.
%  >>image(t);
%  >>axis off;
% can be used to display the image on the screen.
% 
%SEE ALSO:
%  clipboard (a mathworks utility) 
%
%Written by Saurabh Kumar, saurabhkumar_@rediffmailcom
%

imdata     = '';
try
tKit        = java.awt.Toolkit.getDefaultToolkit()              ;
cbrd        = tKit.getSystemClipboard()                         ;%get clipboard handle
reqObj      = java.lang.Object                                  ;
img         = cbrd.getContents(reqObj)                          ;
Dflavor    = img.getTransferDataFlavors()                       ;
imgDfvr     = java.awt.datatransfer.DataFlavor.imageFlavor      ;
if(Dflavor(1).equals(imgDfvr))                 %check if it is image data
   imarr = img.getTransferData(java.awt.datatransfer.DataFlavor.imageFlavor); %image caught!!
   filehandle = java.io.File(['__clpbrdimg04102007_temp.' format]);
   javax.imageio.ImageIO.write(imarr,format,filehandle);
   imdata = imread(['__clpbrdimg04102007_temp.' format],format); %temporary file..easy way out :)..someone help me avoid it!!
   delete(['__clpbrdimg04102007_temp.' format]);               %file no more
end    
    
catch
    errordlg('Error in Getting Image Information');
end



end