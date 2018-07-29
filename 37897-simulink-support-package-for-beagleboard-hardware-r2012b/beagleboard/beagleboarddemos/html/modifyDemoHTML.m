function modifyDemoHTML(mlStyleSheet)

%   Copyright 2012 The MathWorks, Inc.

% FIXME: pass in the file to modify as an argument from the makefile.
demoFiles = dir('*.html');

for p=1:length(demoFiles)
  [~, fAtt] = fileattrib(demoFiles(p).name);
  if fAtt.UserWrite
    % File is writable, go ahead and clean the file
    % NOTE: this protects trying to update some other manually published demo that is
    % still checked in.
    fprintf('Cleaning demo file %s\n', demoFiles(p).name);
    
    fid = fopen(demoFiles(p).name);
    demoHTML = fscanf(fid, '%c');
    fclose(fid);
    
    % Update style sheet path
    demoHTML = strrep(demoHTML, ...
      ['href="' mlStyleSheet '"'], ... 
      'href="./style.css"'); % new path
    
    fid = fopen(demoFiles(p).name, 'w');
    fprintf(fid, '%c', demoHTML);
    fclose(fid);
  else
    fprintf('Skipping demo file %s because it is not writable\n', demoFiles(p).name);
  end
end

end
