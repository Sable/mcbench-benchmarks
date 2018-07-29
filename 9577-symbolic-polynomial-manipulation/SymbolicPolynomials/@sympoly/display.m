function display(sp)
% sympoly/display: Display a sympoly object, calls disp

name = inputname(1);
if ~isempty(name)
  display([name,' ='])
else
  display('ans =')
end

% is it a scalar or an array?
s=size(sp);
if any(s>1)
  % an array or vector
  disp(['Sympoly array has size = [',num2str(s),']'])
  disp(' ')
  
  sj = [0,ones(1,length(s)-1)];
  sj(1) = 0;
  for j=1:numel(sp)
    sj(1) = sj(1)+1;
    while any(sj>s)
      k = find(sj>s,1,'first');
      sj(k) = 1;
      sj(k+1) = sj(k+1)+1;
    end
    
    disp(['Sympoly array element [',num2str(sj),']'])
    disp(sp(j))
  end
  
else
  % A scalar
  
  disp(sp)
  
end




