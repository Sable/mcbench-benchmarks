function [N,T] = add_tracks(D,SR,ID)
% [N,T] = add_tracks(D,SR,ID)
%    Add one or more tracks to the hashtable database.
%    <D, SR> define the waveform of the track, and ID is its
%    reference ID.
%    If D is a char array, load that wavefile.  Second arg is ID.
%    If D is a cell array, load each of those wavefiles; second arg
%    is vector of IDs.
%    N returns the total number of hashes added, T returns total
%    duration in secs of tracks added.
% 2008-12-29 Dan Ellis dpwe@ee.columbia.edu

if isnumeric(D)
  H = landmark2hash(find_landmarks(D,SR),ID);
  save_hashes(H);
  N = length(H);
  T = length(D)/SR;
elseif ischar(D)
  if nargin < 3
    ID = SR;
  end
  [D,SR] = mp3read(D);
  [N,T] = add_tracks(D,SR,ID);
elseif iscell(D)
  nd = length(D);
  if nargin < 3
    if nargin < 2
      % omitting IDs defaults to track number
      ID = 1:nd;
    else
      ID = SR;
    end
  end
  N = 0;
  T = 0;
  for i = 1:nd
    disp(['Adding #',num2str(ID(i)),' ',D{i},' ...']);
    [n,t] = add_tracks(D{i},ID(i));
    N = N + n;
    T = T + t;
  end
  disp(['added ',num2str(nd),' tracks (',num2str(T),' secs, ', ...
        num2str(N),' hashes, ',num2str(N/T),' hashes/sec)']);
else
  error('I cant tell what D is');
end

