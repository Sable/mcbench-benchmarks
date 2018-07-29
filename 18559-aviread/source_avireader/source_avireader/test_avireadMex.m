close all;

[filename, pathname] = uigetfile({'*.avi','AVI file'; '*.*','Any file'},'Pick an AVI file');


mov = avireader([pathname filename],[20 100 200]);

for i=1:length(mov)
    figure;image(mov(1,i).cdata);
end


