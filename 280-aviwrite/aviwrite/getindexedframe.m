function Frame = getindexedframe(varargin)
%GETINDEXEDFRAME  Get indexed movie frame.
%
%   GETINDEXEDFRAME returns the contents of the current figure
%   as an indexed image movie frame.  This format requires about
%   one third of the memory that a true color frame returned by 
%   GETFRAME occupies.  However, indexed frames can only store
%   a maximum of 256 colors.  
%
%   This function is intended for use with AVIWRITE.
%
%   Example:  for I=1:num_frames,
%                plot_command
%                M(I) = getindexedframe;
%             end;
%             aviwrite('my_video.avi',M)
%
%   GETINDEXEDFRAME(H) gets a frame from object H, where H is a 
%   handle to a figure or an axis.
%

if nargin==0,
   Figure_Handle = gcf;
end;
if nargin==1,
   Figure_Handle=varargin{1};
end;
if nargin>1,
   fprintf(1,'Arguments after the first one will be ignored.\n');
end;

[F,MAP] = getframe(Figure_Handle);
% In C, the first array index is 0, not 1.  Rather than subtracting 1 from the index of each
% pixel, we will just pad the beginning of the colormap with a dummy line (purple).  Finally,
% multiply by 2^8-1, convert to unsigned integers, transpose to get contiguous RGB triples in
% memory, swap to BGR triples, and return the colormap and pixels in a structure similar to 
% that returned by GETFRAME.
[M,N]=size(F);
NewMap = round([1 0 1; MAP]' .* 255);
Frame = my_struct('cdata',my_uint8((F(M:-1:1,:))'),'colormap',my_uint8(NewMap(3:-1:1,:)));

return;
