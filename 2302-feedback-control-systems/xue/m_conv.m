function a=m_conv(varargin)
a=varargin{1};
for i=2:length(varargin)
   eval(['a=conv(a,varargin{' int2str(i) '});']);
end
