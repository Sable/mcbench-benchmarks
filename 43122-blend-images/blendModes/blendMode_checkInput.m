function blendMode_checkInput(nargin, a, b, functionName)

%% Check input
if nargin < 2
    error(strcat(functionName, ':argChk'), 'Wrong number of input arguments.');
end

if ((length(a) ~= length(b)) || (a(end) ~= b(end)))
    error(strcat(functionName, ':argChk'), 'The number of dimensions of A must be equal to the number of dimension of B.');
end

% if nargin < 3
%     offsetW = 1;
%     offsetH = 1;
% end
% 
% if nargin < 4
%     offsetH = 1;
% end