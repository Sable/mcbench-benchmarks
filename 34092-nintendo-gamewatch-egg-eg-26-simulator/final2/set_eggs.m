function set_eggs(hia,eggs,eggsp,edr)
%set_visible(hia,eggs{1,1}(rand(1,5)>0.5));
%     set_visible(hia,eggs{2,1}(rand(1,5)>0.5));
%     set_visible(hia,eggs{1,2}(rand(1,5)>0.5));
%     set_visible(hia,eggs{2,2}(rand(1,5)>0.5));

set_visible(hia,eggs{1,1}(eggsp(edr,1)));
set_visible(hia,eggs{2,1}(eggsp(edr,2)));
set_visible(hia,eggs{1,2}(eggsp(edr,3)));
set_visible(hia,eggs{2,2}(eggsp(edr,4)));

