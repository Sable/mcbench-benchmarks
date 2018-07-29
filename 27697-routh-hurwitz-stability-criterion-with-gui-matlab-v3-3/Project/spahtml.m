function [S]=spahtml(N)
%these function generate html space(&nbsp;) by number of N
spa={};
for i=1:N
    spa{i}='&nbsp;';
end
S=strcat(spa{:});
