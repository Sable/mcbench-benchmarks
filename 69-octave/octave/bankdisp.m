function h = bankdisp(P,F,Pmin,Pmax);
% BANKDISP  Display filterbank power spectrum in 'bar' form.
%    BANKDISP(P,F) display the power spectrum P with one bar for
%    each frequency band in F. P should already be in dB.
%    P and F must be vectors of same sizes. Some frequency labels
%    can be omitted by using null elements in F.
%    Example: F = [ ..., 0 500 0, 0 1000 0, ... ] can be used to
%    label only the octave bands in a one-third-octave spectrum P. 
%
%    BANKDISP(P,F,Pmin,Pmax) can be used to specify explicitly the limits
%    of the Y axis. If min(P) < 0, this version avoid 'hanging' bars. 
% 
%    See also FILTBANK.

% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Aug. 27, 1997, 9:00am.

N = length(F);
if (nargin == 4)
  if (Pmin < 0)
    H = bar(P-Pmin);
    axis([0 N+1 0 Pmax-Pmin]); 
%    YTickLabels = get(gca,'YTickLabels'); % MATLAB 4.1
%    NewYTickLabels = str2num(YTickLabels) + Pmin;
%    set(gca,'YTickLabels',NewYTickLabels); 
    YTickLabel = get(gca,'YTickLabel'); % MATLAB 5.1
    NewYTickLabel = str2num(YTickLabel) + Pmin;
    set(gca,'YTickLabel',NewYTickLabel); 
  else
    H = bar(P);
    axis([0 N+1 Pmin Pmax]); 
  end
else
  H = bar(P);
  ax = axis;
  axis([0 N+1 ax(3) ax(4)]);
end
ticks = find(F > 0);
set(gca,'XTick',ticks); 		% Label frequency axis.
%set(gca,'XTickLabels',F(ticks));         % MATLAB 4.1
set(gca,'XTickLabel',F(ticks)); 	% MATLAB 5.1
xlabel('Frequency band [Hz]'); 
ylabel('Level [dB]');

if (nargout ~= 0)
  h = H;
end





