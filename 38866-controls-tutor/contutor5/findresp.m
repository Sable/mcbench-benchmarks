function kw = findresp(x,y,freq_data,axs_han,mode);
% FINDRESP Find location of pointer on frequency response.
%          FINDRESP finds the location of the mouse in the Bode, Nyquist,
%          Nichols, and Time Response plots.

% Author: Craig Borghesani
% Date: 8/21/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

kw=[];
xlim = get(axs_han,'xlim');
ylim = get(axs_han,'ylim');

if mode==1, % Bode (magnitude plot), Nichols

 if strcmp(get(axs_han,'xscale'),'log'),
  x_pts = log(freq_data(1,:));
  xlim = log(xlim);
  x = log(x);
 else
  x_pts = phasecor(freq_data(2,:),[-360,0]);
 end
 y_pts = 20*log10(abs(freq_data(2,:)));

elseif mode==2, % Bode (phase plot)

 x_pts = log(freq_data(1,:));
 xlim = log(xlim);
 x = log(x);
 y_pts = phasecor(freq_data(2,:),[-360,0]);

elseif mode==3, % Nyquist

 x_pts = real(freq_data(2,:));
 y_pts = imag(freq_data(2,:));

end

% normalize everything
normx_pts = (x_pts - xlim(1))/(xlim(2)-xlim(1));
normy_pts = (y_pts - ylim(1))/(ylim(2)-ylim(1));
normx = (x - xlim(1))/(xlim(2)-xlim(1));
normy = (y - ylim(1))/(ylim(2)-ylim(1));

difx=normx_pts-normx;
dify=normy_pts-normy;
dist=sqrt((difx).^2+(dify).^2);
[mindist,k]=min(dist);
if mindist<0.06,
 kw=k;
end
