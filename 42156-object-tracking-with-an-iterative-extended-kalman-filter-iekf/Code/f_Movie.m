% function to produce movie from the simulation 
%  uses f_Render to produce the plots
% X - state variables
% OBS - observations
% name - movie name
function f_Movie(X,OBS,name)

n = size(X,2); % number of frames

F(n) = struct('cdata',[],'colormap',[]); % make room

for i=1:n;
    f_Render(X(:,i),OBS(:,i),i);    % make plot
    F(i) = getframe(gcf);           % take snapshot
    if i~=n; cla; end               % clear axis
end

movie2avi(F, sprintf('%s.avi',name), 'compression', 'None','FPS',8);
