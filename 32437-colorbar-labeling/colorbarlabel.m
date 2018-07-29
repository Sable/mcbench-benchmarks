%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% colorbarlabel.m
%
% Function to nicely label the colorbars. Works for individual plots or
% subplots.
% Handles single- and multi-line labels on the top, bottom and/or on the right
% of the colorbar. 
% 
% Input: colorbar handle ([] if unknown), label location ('top','bottom' or
% 'right'), indication for subplots (1 if subplots, 0 otherwise), text
% label (normal MatLab text style)
%
% Output: Nicely positioned labels for the specified colorbar
% 
% Warning: 1) If the label is too close to the colorbar or graph, try
%             reapplying the function, it will largen up the gap 
%          2) Depending on your case, the font, gap and position can be
%             easily adapted
%            
% Example: colorbarlabel([],'r',0, [{'String line 1'},{'String line 2'}])       
%
% Fanny Besem
% August 5th, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function[]=colorbarlabel(hcb,location,subplt,textlabel),

flag=0;

%%%%%%%%%%%%%%%%%%%%% Find the colorbar handle if not provided %%%%%%%%%%
if isempty(hcb),
    hf=get(gcf);
    hcb=findobj(gcf,'Tag','Colorbar');
    if size(hcb,1)>1,
        hcb=max(hcb);
        warning('There are more than one colorbar, I picked the last one created');
    elseif size(hcb,1)==0,
        error('Could not find any colorbar, please input the colorbar handle');
        flag=1;
    else
        disp('Colorbar found');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main routine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if flag==0,
    if strcmpi(location,'top') || strcmpi(location,'t'),
        if not(subplt),
            set(gca,'Units','inches');
            pos_gca=get(gca,'Position');
            pos_gca(2)=pos_gca(2)*0.6;
            set(gca,'Position',pos_gca);
            set(gca,'Units','normalized');
            top=get(hcb,'title');
            set(top,'string',textlabel,'FontSize',14,'FontWeight','demi');
            set(top,'Units','inches');
            pos=get(top,'Position');
            pos(2)=pos(2)*1.02;
            set(top,'Position',pos);
            set(top,'Units','normalized');
        else
            top=get(hcb,'title');
            set(top,'string',textlabel,'FontSize',12,'FontWeight','demi');
            pos=get(top,'Position');
            pos(2)=pos(2)*1.01;
            set(top,'Position',pos);
        end

    elseif strcmpi(location,'bottom') || strcmpi(location,'b'),
        if not(subplt),
            set(gca,'Units','inches');
            pos_gca=get(gca,'Position');
            pos_gca(2)=pos_gca(2)*1.4;
            set(gca,'Position',pos_gca);
            set(gca,'Units','normalized');
            bottom=get(hcb,'xlabel');
            set(bottom,'string',textlabel,'FontSize',14,'FontWeight','demi');
            set(bottom,'Units','inches');
            pos=get(bottom,'Position');
            if pos>0,
                pos(2)=pos(2)*.6;
            else
                pos(2)=pos(2)*2.9;
            end
            set(bottom,'Position',pos);
            set(bottom,'Units','normalized');
        else
            bottom=get(hcb,'xlabel');
            set(bottom,'string',textlabel,'FontSize',12,'FontWeight','demi');
            set(bottom,'Units','inches');
            pos=get(bottom,'Position');
            if pos>0,
                pos(2)=pos(2)*.6;
            else
                pos(2)=pos(2)*2;
            end
            set(bottom,'Position',pos);
            set(bottom,'Units','normalized');
        end

    elseif strcmpi(location,'right') || strcmpi(location,'r'),
        if not(subplt),
            set(gca,'Units','inches');
            pos_gca=get(gca,'Position');
            pos_gca(1)=pos_gca(1)*0.7;
            set(gca,'Position',pos_gca);
            set(gca,'Units','normalized');
            right=get(hcb,'ylabel');
            set(right,'string',textlabel,'FontSize',14,'FontWeight','demi');
            set(right,'Units','inches');
            pos=get(right,'Position');
            pos(1)=pos(1)*1.05;
            set(right,'Position',pos);
            set(right,'Units','normalized');
        else
            right=get(hcb,'ylabel');
            set(right,'string',textlabel,'FontSize',12,'FontWeight','demi');
            set(right,'Units','inches');
            pos=get(right,'Position');
            pos(1)=pos(1)*1.05;
            set(right,'Position',pos);
            set(right,'Units','normalized');
        end

    else
        error('The specified location is not recognized, try "top", "bottom" or "right"');

    end
end
end