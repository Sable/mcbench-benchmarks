%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FloodFill.m unwraps the phase image, avoiding all branch cuts.
% Created by B.S. Spottiswoode on 12/10/2004
% Last modified on 13/10/2004
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [IM_unwrapped, rowref, colref]=FloodFill(IM_phase, branch_cuts, IM_mask)

[r_dim, c_dim]=size(IM_phase);
figure; imagesc(immultiply(IM_phase, ~branch_cuts)), colormap(gray), axis square, axis off, title('Phase image');
uiwait(msgbox('Select a known true phase reference point','Phase reference point','modal'));
[xref,yref] = ginput(1); 
colref=round(xref); rowref=round(yref);
close;
if (branch_cuts(rowref,colref)==1)
    error('Selected point corresponds to a branch cut.');
end

IM_unwrapped=zeros(r_dim,c_dim);
unwrapped_binary=zeros(r_dim,c_dim);
adjoin=zeros(r_dim,c_dim);

adjoin(rowref-1, colref)=1;                                 %Label the first four adjoining pixels
adjoin(rowref+1, colref)=1;
adjoin(rowref, colref-1)=1;
adjoin(rowref, colref+1)=1;
IM_unwrapped(rowref, colref)=IM_phase(rowref, colref);      %Mark the first pixel as unwrapped
unwrapped_binary(rowref, colref)=1;

disp('Performing floodfill operation ...');
tic;
count_limit=0;
adjoin_stuck=0;
while sum(sum(adjoin(2:r_dim-1,2:c_dim-1)))~=0              %Loop until there are no adjoining pixels or they all lie on the border
    while count_limit<100                                   %or the code gets stuck because of isolated regions
        [r_adjoin, c_adjoin]=find(adjoin);                          %Obtain coordinates of adjoining unwrapped phase pixels
        if size(r_adjoin)==adjoin_stuck
            count_limit=count_limit+1;                              %Make sure loop doesn't get stuck
        else
            count_limit=0;
        end
        temp=size(r_adjoin);
        adjoin_stuck=temp;
        for i=1:temp(1)
            r_active=r_adjoin(i);
            c_active=c_adjoin(i);
            if r_active<=r_dim-1 & r_active>=2 & c_active<=c_dim-1 & c_active>=2                    %Ignore pixels near the border
                %First search below for an adjoining unwrapped phase pixel
                if branch_cuts(r_active+1, c_active)==0 & unwrapped_binary(r_active+1, c_active)==1
                    phase_ref=IM_unwrapped(r_active+1, c_active);                                   %Obtain the reference unwrapped phase
                    p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
                    IM_unwrapped(r_active, c_active)=p(2);
                    unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
                    adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
                    if r_active-1>=1 & unwrapped_binary(r_active-1, c_active)==0 & branch_cuts(r_active-1, c_active)==0
                        adjoin(r_active-1, c_active)=1;
                    end
                    if c_active-1>=1 & unwrapped_binary(r_active, c_active-1)==0 & branch_cuts(r_active, c_active-1)==0
                        adjoin(r_active, c_active-1)=1;
                    end
                    if c_active+1<=c_dim & unwrapped_binary(r_active, c_active+1)==0 & branch_cuts(r_active, c_active+1)==0
                        adjoin(r_active, c_active+1)=1;
                    end
                end
                %Then search above
                if branch_cuts(r_active-1, c_active)==0 & unwrapped_binary(r_active-1, c_active)==1
                    phase_ref=IM_unwrapped(r_active-1, c_active);                                   %Obtain the reference unwrapped phase
                    p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
                    IM_unwrapped(r_active, c_active)=p(2);
                    unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
                    adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
                    %Update the new adjoining pixels:
                    if r_active+1<=r_dim & unwrapped_binary(r_active+1, c_active)==0 & branch_cuts(r_active+1, c_active)==0
                        adjoin(r_active+1, c_active)=1;
                    end
                    if c_active-1>=1 & unwrapped_binary(r_active, c_active-1)==0 & branch_cuts(r_active, c_active-1)==0
                        adjoin(r_active, c_active-1)=1;
                    end
                    if c_active+1<=c_dim & unwrapped_binary(r_active, c_active+1)==0 & branch_cuts(r_active, c_active+1)==0
                        adjoin(r_active, c_active+1)=1;
                    end
                end
                %Then search on the right
                if branch_cuts(r_active, c_active+1)==0 & unwrapped_binary(r_active, c_active+1)==1
                    phase_ref=IM_unwrapped(r_active, c_active+1);                                   %Obtain the reference unwrapped phase
                    p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
                    IM_unwrapped(r_active, c_active)=p(2);
                    unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
                    adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
                    if r_active+1<=r_dim & unwrapped_binary(r_active+1, c_active)==0 & branch_cuts(r_active+1, c_active)==0
                        adjoin(r_active+1, c_active)=1;
                    end
                    if c_active-1>=1 & unwrapped_binary(r_active, c_active-1)==0 & branch_cuts(r_active, c_active-1)==0
                        adjoin(r_active, c_active-1)=1;
                    end
                    if r_active-1>=1 & unwrapped_binary(r_active-1, c_active)==0 & branch_cuts(r_active-1, c_active)==0
                        adjoin(r_active-1, c_active)=1;
                    end
                end
                %Finally search on the left
                if branch_cuts(r_active, c_active-1)==0 & unwrapped_binary(r_active, c_active-1)==1
                    phase_ref=IM_unwrapped(r_active, c_active-1);                                   %Obtain the reference unwrapped phase
                    p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
                    IM_unwrapped(r_active, c_active)=p(2);
                    unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
                    adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
                    if r_active+1<=r_dim & unwrapped_binary(r_active+1, c_active)==0 & branch_cuts(r_active+1, c_active)==0
                        adjoin(r_active+1, c_active)=1;
                    end
                    if c_active+1<=c_dim & unwrapped_binary(r_active, c_active+1)==0 & branch_cuts(r_active, c_active+1)==0
                        adjoin(r_active, c_active+1)=1;
                    end
                    if r_active-1>=1 & unwrapped_binary(r_active-1, c_active)==0 & branch_cuts(r_active-1, c_active)==0
                        adjoin(r_active-1, c_active)=1;
                    end
                end
            end
        end
        %figure; imagesc(adjoin), colormap(gray), axis square, axis off, title('Adjoining pixels');
        %figure; imagesc(IM_unwrapped), colormap(gray), axis square, axis off, title('Pixels unwrapped');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finally, fill in the branch cut pixels that adjoin the unwrapped pixels.
% This can be done because the branch cuts actually lie between the pixels,
% and not on top of them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Filling in branch cuts that border on unwrapped pixels ...');
adjoin=zeros(r_dim, c_dim);                                 
%Re-load the adjoining pixel matrix with the branch cut values:
for i=2:r_dim-1
    for j=2:c_dim-1
       if branch_cuts(i,j)==1 & ...                         %Identify which branch cut pixel borders an unwrapped pixel
          ( (branch_cuts(i+1,j)==0 | branch_cuts(i-1,j)==0 | branch_cuts(i,j-1)==0 | branch_cuts(i,j+1)==0) ) 
         adjoin(i,j)=1;
       end
    end
end

[r_adjoin, c_adjoin]=find(adjoin);                          %Obtain coordinates of adjoining unwrapped phase pixels
temp=size(r_adjoin);
for i=1:temp(1)
    r_active=r_adjoin(i);
    c_active=c_adjoin(i);
        %First search below for an adjoining unwrapped phase pixel
        if unwrapped_binary(r_active+1, c_active)==1
            phase_ref=IM_unwrapped(r_active+1, c_active);                                   %Obtain the reference unwrapped phase
            p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
            IM_unwrapped(r_active, c_active)=p(2);
            unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
            adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
        end
        %Then search above
        if unwrapped_binary(r_active-1, c_active)==1
            phase_ref=IM_unwrapped(r_active-1, c_active);                                   %Obtain the reference unwrapped phase
            p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
            IM_unwrapped(r_active, c_active)=p(2);
            unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
            adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
        end
        %Then search on the right
        if unwrapped_binary(r_active, c_active+1)==1
            phase_ref=IM_unwrapped(r_active, c_active+1);                                   %Obtain the reference unwrapped phase
            p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
            IM_unwrapped(r_active, c_active)=p(2);
            unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
            adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
        end
        %Finally search on the left
        if unwrapped_binary(r_active, c_active-1)==1
            phase_ref=IM_unwrapped(r_active, c_active-1);                                   %Obtain the reference unwrapped phase
            p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
            IM_unwrapped(r_active, c_active)=p(2);
            unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
            adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
        end
end
%figure; imagesc(adjoin), colormap(gray), axis square, axis off, title('Branch cut adjoining pixels');
%figure; imagesc(IM_unwrapped), colormap(gray), axis square, axis off, title('Peripheral branch cut pixels unwrapped');

t=toc;
disp(['Floodfill operation completed in ',int2str(t),' second(s).']);
disp('Done!');


   
