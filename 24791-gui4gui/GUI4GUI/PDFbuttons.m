function pdfButtons(varargin)
% function pdfButtons(varargin)
% Purpose: Use (default) pdf.gif logo as the pushbutton to display a PDF 
%          document when pressed.
% All objects whose 'String' is 'replace1' will be replaced with the pdf image
% Each image is positioned at the center of the push button it replaces.
% varargin could be used as the key string for replacement.
% such as 'replace1' (default) or 'PDF' (passed in as varargin{1})
% Kadin Tseng, SCV, Boston University, April 27, 2009

H = varargin{1};
H = H';     % should find a robust way to handle this
I = gif2RGB('pdf.gif');  % coverts gif file to true color RGB needed for Cdata
info = imfinfo('pdf.gif','gif');  % query make-up of the image file
width = info.Width;   % width of pdf file
height = info.Height; % height of pdf file
%H = findobj('String',mystr);  % find all 'replace1' objects
for obj = H'
  set(obj,'String','');  % first, clear the button's string
  set(obj,'units','pixels');  % make sure units is pixels to handle image
  p = get(obj,'position');
  xc = p(1) + p(3)*0.5;  % x at center of button
  yc = p(2) + p(4)*0.5;  % y at center of button
  pimage = [xc - width*0.5, yc - height*0.5, width, height];
  set(obj,'Units','pixels','Position',pimage,'Cdata',I)
end
