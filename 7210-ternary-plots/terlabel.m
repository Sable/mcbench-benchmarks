function handels=terlabel(label1,label2,label3)
%FUNCTIONS HANDELS=TERLABEL(LABEL1,LABEL2,LABEL3) adds labels to a ternary 
% plot. Note that the order of labels must be the same as in the vectors in
% the ternaryc function call.
% The labels can be modified through the handel vector HANDELS.
%
% Uli Theune, Geophysics, University of Alberta
% 2005
%

if nargout >= 1
    handels=ones(3,1);
    handels(1)=text(0.5,-0.05,label2,'horizontalalignment','center');
    handels(2)=text(0.15,sqrt(3)/4+0.05,label1,'horizontalalignment','center','rotation',60);
    handels(3)=text(0.85,sqrt(3)/4+0.05,label3,'horizontalalignment','center','rotation',-60);
else
    text(0.5,-0.05,label2,'horizontalalignment','center');
    text(0.15,sqrt(3)/4+0.05,label1,'horizontalalignment','center','rotation',60);
    text(0.85,sqrt(3)/4+0.05,label3,'horizontalalignment','center','rotation',-60);
end