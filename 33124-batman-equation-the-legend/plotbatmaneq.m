% function plotbatmaneq

x = -7:0.01:7;

pos_y = [];
neg_y = [];
pos_x = [];
neg_x = [];

close all;
figure(1);
hold on

kernel_colormap = [
  0 0 0
  1 0 0
  0 1 0
  0 0 1
  1 1 0
  1 0 1
];

for ind_x = x
    [y ind_kernel] = batmaneq(ind_x);
    neg_y_added_flag = false;
    pos_y_added_flag = false;
    for ind_y = 1:length(y)
        h = plot(ind_x, y(ind_y), '*', 'Color', kernel_colormap(ind_kernel(ind_y),:));
        
        if y(ind_y)<=0
            neg_y = [neg_y y(ind_y)];
            neg_x = [neg_x ind_x];
        end
        if y(ind_y)>=0
            pos_y = [pos_y y(ind_y)];
            pos_x = [pos_x ind_x];
        end
    end
end
axis equal

figure(2)
hold on
plot(pos_x,pos_y,'LineWidth', 5);
plot(neg_x,neg_y, 'LineWidth', 5);

axis equal

figure(3)
rev_neg_x  = neg_x(end:-1:1);
rev_neg_y  = neg_y(end:-1:1);
fill([pos_x rev_neg_x], [pos_y rev_neg_y], 'k');

axis equal

% end