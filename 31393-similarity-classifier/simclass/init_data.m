function [new_data, lc, cs]= init_data(data,v,c)
% P‰ivitetty 11.5.2004
% INPUT:
%
%data = data matrix
%c = column of the data matrix where class vector is given e.g. [6]
%v= columns of the data matrix where your data measurements are e.g. [1:5]
%
% OUTPUT
%
% new_data = your new data matrix ordered w.r.t. classes.
%lc = size of the class
%cs = starting points of the classes in your matrix new_data

data_v=data(:,v);
data_c=data(:,c);

data_v;
mins_v = min(data_v);
Ones = ones(size(data_v));
data_v = data_v+Ones*diag(abs(mins_v));
maxs_v = max(data_v);
data_v = data_v*diag(maxs_v.^(-1));

data = [data_v, data_c];

d_dim = size(data,1); % vektoreiden m‰‰r‰
v_dim = size(data,2)-1; % vektoreiden dimensio 
data=sortrows(data, v_dim+1); % j‰rjestet‰‰n vektorit luokkien mukaan

% purkkaa: luokkien j‰rjestysnumerot menem‰‰n j‰rjestyksess‰ 1,2,...
class_n=1;
temp = data(1, v_dim +1);
data(1, v_dim +1) = 1;

for i=2:d_dim
    
    if temp ~= data(i,v_dim +1);
        class_n=class_n+1;
        temp = data(i, v_dim +1);
    end
    
    data(i, v_dim +1) = class_n;
end

%purkka loppuu

nc = class_n;
cs = []; % luokkien alkupisteet
cs(1) = 1;

for j = 1 : nc % etsit‰‰n kaikkien luokkien alkupisteet ja koot
    lc(j) = length(find(data(:, v_dim+1) == j)); %luokan 'j' koko.
    cs(j+1) = cs(j) + lc(j);
end
cs=cs(1:nc);

new_data = data;