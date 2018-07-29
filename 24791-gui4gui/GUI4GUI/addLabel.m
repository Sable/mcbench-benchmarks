function varargout = addLabel(GID)

GIDout = GID;   % output starts with everything that is in input
Nmenus = GIDout.Nmenus;

% these are the additional stuff we want the output to have
% initialize them first, so if the user didn't specify a menu item
% it will appear as blank
for menu=1:Nmenus
   GIDout.task(menu).menu = menu;
   GIDout.task(menu).type(1:9,1:9,1:3) = { '' };
   GIDout.task(menu).label(1:9,1:9,1:3) = { '' };
   GIDout.task(menu).ops(1:9,1:9,1:3) = { '' };
end

for menu=1:Nmenus
  n = length(GID.task(menu).string(:,1));
  [num{1:n}] = GID.task(menu).string{1:n,1};
[label{1:n}] = GID.task(menu).string{1:n,2};
 [type{1:n}] = GID.task(menu).string{1:n,3};
  [ops{1:n}] = GID.task(menu).string{1:n,4};
  for i=1:n
    m = num{i} + 11;
    s = num2str(m); s1 = s(1); s2 = s(2); s3 = s(3);
    i1 = str2double(s1); i2=str2double(s2); i3=str2double(s3);
    GIDout.task(menu).label(i1,i2,i3) = GID.task(menu).string(i,2);
    GIDout.task(menu).type(i1,i2,i3) = GID.task(menu).string(i,3);
    GIDout.task(menu).ops(i1,i2,i3) = GID.task(menu).string(i,4);
%    disp(['m,i1,i2,i3: ' num2str(m) '  ' num2str(i1) '  ' num2str(i2) '  ' num2str(i3)])
  end
end

varargout{1} = GIDout;
