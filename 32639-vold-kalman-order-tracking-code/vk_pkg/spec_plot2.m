function spec_plot2(varargin);
%
% Type: spec_plot2(S_m,freq,time,typ,f_min,f_max,c_min,c_max);
% Type: spec_plot2(S_m,freq,time,typ,f_min,f_max,c_min);
% Type: spec_plot2(S_m,freq,time,typ,f_min,f_max);
% Type: spec_plot2(S_m,freq,time,typ,f_min);
% Type: spec_plot2(S_m,freq,time,typ);
% Type: spec_plot2(S_m,freq,time);
%
% Inputs:
%
% S_m    := Time frequency distribution matrix n x m matrix
% freq   := Frequency vector n x 1 vector
% time   := Time vector m x 1 vector
% typ    := 'lin' or 'log' string for color scale of image plot
% f_min  := Minimum frequency to show, scalar
% f_max  := Maximum frequency to show, scalar
% c_min  := value for low end of color spectrum (see caxis), scalar
% c_max  := value for high end of color spectrum (see caxis), scalar
%
% This version uses pcolor and shading interp instead of imagesc

% Scot McNeill, University of Houston, Fall 2007.
%
msg=nargchk(3,8,nargin);
if ~isempty(msg)
   error(msg)
end
%
S_m=varargin{1};
freq=varargin{2};
time=varargin{3};
%
if (length(varargin) >= 4 & ~isempty(varargin{4}))
   typ=varargin{4};
else
   typ='log';
end
%
if (length(varargin) >= 5 & ~isempty(varargin{5}))
   f_min=varargin{5};
else
   f_min=min(freq);
end
%
if (length(varargin) >=6 & ~isempty(varargin{6}))
   f_max=varargin{6};
else
   f_max=max(freq);
end
%
if (length(varargin) >= 7 & ~isempty(varargin{7}))
   c_min=varargin{7};
else
   c_min=[];
end
%
if (length(varargin) ==8 & ~isempty(varargin{8}))
   c_max=varargin{8};
else
   c_max=[];
end
%
[nr,nc]=size(S_m);
nt=length(time);
nf=length(freq);
if (nr ~= nf & nc ~= nt)
   error('S_m must have dimensions length(freq) x length(time)')
end
%
[i1]=find(freq>=f_min & freq<=f_max);
freq=freq(i1);
S_m=S_m(i1,:);
%
newplot;
if strcmp(typ,'log');
   %imagesc(time,freq,log10(abs(S_m)+eps));
   pcolor(time,freq,log10(abs(S_m)+eps));shading interp;
   axis xy;
   colormap(jet);
   xlabel('Time (seconds)');
   ylabel('Frequency (Hz)');
   title('Spectrogram');
   axis([min(time),max(time),f_min,f_max]);
   [c1,c2]=caxis;
   if isempty(c_min);c_min=c1;end;
   if isempty(c_max);c_max=c2;end;
   caxis([c_min,c_max]);
   h = colorbar;
   set(get(h,'YLabel'),'String','Spectrogram, log_1_0([Units]^2/Hz)');
elseif strcmp(typ,'lin');
   %imagesc(time,freq,abs(S_m));
   pcolor(time,freq,abs(S_m));shading interp;
   axis xy;
   colormap(jet);
   xlabel('Time (seconds)');
   ylabel('Frequency (Hz)');
   title('Spectrogram');
   axis([min(time),max(time),f_min,f_max]);
   [c1,c2]=caxis;
   if isempty(c_min);c_min=c1;end;
   if isempty(c_max);c_max=c2;end;
   caxis([c_min,c_max]);
   h = colorbar;
   set(get(h,'YLabel'),'String','Spectrogram, [Units]^2/Hz');
else
   error(['typ must be ''lin'' or ''log''.']);
end
set(gca,'tickdir','out');
drawnow
