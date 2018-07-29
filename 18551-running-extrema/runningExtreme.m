function [out,varargout] = runningExtreme(input,nSamples,type)
% runningmin - Computes a running extreme of an input vector or matrix
% Optional file header info (to give more details about the function than in the H1 line)
% Syntax: out = runningmin(input,nSamples,type)
% input - vector or matrix of data to return the running min or max from
% nSamples - The size of the window to check for mins or maxes
% type - 'min','max', or 'both' (default) which type of extremes to return
% out - running minimum or maximum requested.  If both minimum is returned
% first, then maximum
%   Example
%  [runMin,runMax] = runningExtreme(data,31,'both')
%
% Subfunctions: vanherk
%   See also: min, max, sort
%% AUTHOR    : Dan Kominsky
%%

if nargin<2
	error('RunningExtreme:notEnoughInputs','Invalid Usage - must specify window size');
elseif nargin ==2
	type = 'both';
end

if ~mod(nSamples,2)
	warning('RunningExtreme:evenWindowSize','Running Min/Max is not meaningful for a windown with an even number of samples');
	nSamples = nSamples+1;
end

[input,dimShift]=shiftdim(input);

switch lower(type)
	case 'min'
		out=vanherk(input,nSamples,'min');% Create output for minimum
	case 'max'
		out=vanherk(input,nSamples,'max'); % Create output for maximum
	otherwise
		out=vanherk(input,nSamples,'max');% Create output for maximum
		varargout{1} = out; % Transfer to the second output
		out=vanherk(input,nSamples,'min');% Create output for minimum
end
if dimShift
	out = shiftdim(out,-dimShift);% if we transposed, undo to return the same shape as we got.
	if nargout>1
		varargout{1} = shiftdim(varargout{1},-dimShift);
	end
end

end

function Y = vanherk(X,N,TYPE)
%  VANHERK    Fast max/min 1D filter
%
%    Y = VANHERK(X,N,TYPE) performs the 1D max/min filtering of the row
%    vector X using a N-length filter.
%    The filtering type is defined by TYPE = 'max' or 'min'. This function
%    uses the van Herk algorithm for min/max filters that demands only 3
%    min/max calculations per element, independently of the filter size.
%
%    If X is a 2D matrix, each column will be filtered separately.
%    X can be uint8 or double. If X is uint8 the processing is quite faster, so
%    dont't use X as double, unless it is really necessary.
%

% Initialization
% if strcmp(direc,'col')
%    X = X';
% end
switch lower(TYPE)
	case 'max'
		maxfilt = 1;
	case 'min'
		maxfilt = 0;
	otherwise
		error([ 'TYPE must be ' char(39) 'max' char(39) ' or ' char(39) 'min' char(39) '.'])
end

% Correcting X size
fixsize = 0;
addel = 0;
if mod(size(X,1),N) ~= 0
	fixsize = 1;
	addel = N-mod(size(X,1),N);
	if maxfilt
		f = [X; -Inf*ones(addel,size(X,2)) ]; % Change from adding zeros
	else
		f = [X; Inf*ones([addel size(X,2)])];
		%       f = [X; repmat(X(end,:),addel,1)];  % Adds a replication of the end of the matrix
	end
else
	f = X;
end
lf = size(f,1); % # of elements in adjusted matrix
lx = size(X,1); % # of elements in original matrix
clear X

% Declaring aux. mat.
g = f;
h = g;

% Filling g & h (aux. mat.)
ig = (1:N:size(f,1)).'; % First element of each window
ih = ig + N - 1;    % Last element of each window

if maxfilt
	for i = 2 : N
		igold = ig;
		ihold = ih;

		ig = ig + 1;
		ih = ih - 1;

		g(ig,:) = max(f(ig,:),g(igold,:));
		h(ih,:) = max(f(ih,:),h(ihold,:));
	end
else
	for i = 2 : N
		igold = ig;
		ihold = ih;

		ig = ig + 1;
		ih = ih - 1;

		g(ig,:) = min(f(ig,:),g(igold,:));
		h(ih,:) = min(f(ih,:),h(ihold,:));
	end
end
clear f


if fixsize % If we had to pad the data
	if addel > (N-1)/2 % If the padding is more than half a zone
		ig =  (N : 1 : lf - addel + floor((N-1)/2)).' ;
		ih = ( 1 : 1 : lf-N+1 - addel + floor((N-1)/2)).';
		if maxfilt
			Y = [ g(1+ceil((N-1)/2):N-1,:);  max(g(ig,:), h(ih,:)) ];
		else
			Y = [ g(1+ceil((N-1)/2):N-1,:);  min(g(ig,:), h(ih,:)) ];
		end
	else
		ig = ( N : 1 : lf ).';
		ih = ( 1 : 1 : lf-N+1 ).';
		if maxfilt
			Y = [ g(1+ceil((N-1)/2):N-1,:);  max(g(ig,:), h(ih,:));  h(lf-N+2:lf-N+1+floor((N-1)/2)-addel,:) ];
		else
			Y = [ g(1+ceil((N-1)/2):N-1,:);  min(g(ig,:), h(ih,:));  h(lf-N+2:lf-N+1+floor((N-1)/2)-addel,:) ];
		end
	end
else % not fixsize (addel=0, lf=lx)
	ig = ( N : 1 : lx ).';
	ih = ( 1 : 1 : lx-N+1 ).';
	if maxfilt
		Y = [  g(N-ceil((N-1)/2):N-1,:); max( g(ig,:), h(ih,:) );  h(lx-N+2:lx-N+1+floor((N-1)/2),:) ];
	else
		Y = [  g(N-ceil((N-1)/2):N-1,:); min( g(ig,:), h(ih,:) );  h(lx-N+2:lx-N+1+floor((N-1)/2),:) ];
	end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

