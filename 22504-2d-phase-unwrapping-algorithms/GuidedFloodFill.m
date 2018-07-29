%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GuidedFloodFill.m unwraps a single 2D image.
% Input: IM_phase, IM_unwrapped (seed points / pixels already unwrapped), 
% unwrapped_binary the derivative variance, an adjoining matrix and a mask. 
% Created by B.S. Spottiswoode on 11/11/2004
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function IM_unwrapped=GuidedFloodFill(IM_phase, IM_unwrapped, unwrapped_binary, derivative_variance, adjoin, IM_mask)

[r_dim, c_dim]=size(IM_phase);
isolated_adjoining_pixel_flag=1;                            %Only remains set if an isolated adjoining pixel exists

while sum(sum(adjoin(2:r_dim-1,2:c_dim-1)))~=0              %Loop until there are no more adjoining pixels
    adjoining_derivative_variance=derivative_variance.*adjoin + 100.*~adjoin;      %Derivative variance values of the adjoining pixels (pad the zero adjoining values with 100)
    [r_adjoin, c_adjoin]=find(adjoining_derivative_variance==min(min(adjoining_derivative_variance)));      %Obtain coordinates of the maximum adjoining unwrapped phase pixel
    r_active=r_adjoin(1);
    c_active=c_adjoin(1);
    isolated_adjoining_pixel_flag=1;                                                %This gets cleared as soon as the pixel is unwrapped
    if (r_active==r_dim | r_active==1 | c_active==c_dim | c_active==1);             %Ignore pixels near the border
       IM_unwrapped(r_active, c_active)=0;
       adjoin(r_active, c_active)=0;
    else
        %First search below for an adjoining unwrapped phase pixel
        if unwrapped_binary(r_active+1, c_active)==1
            phase_ref=IM_unwrapped(r_active+1, c_active);                                   %Obtain the reference unwrapped phase
            p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
            IM_unwrapped(r_active, c_active)=p(2);
            unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
            adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
            isolated_adjoining_pixel_flag=0;
            %Update the new adjoining pixels:
            if r_active-1>=1 & unwrapped_binary(r_active-1, c_active)==0 & IM_mask(r_active-1, c_active)==1
                adjoin(r_active-1, c_active)=1; 
            end
            if c_active-1>=1 & unwrapped_binary(r_active, c_active-1)==0 & IM_mask(r_active, c_active-1)==1
                adjoin(r_active, c_active-1)=1; 
            end
            if c_active+1<=c_dim & unwrapped_binary(r_active, c_active+1)==0 & IM_mask(r_active, c_active+1)==1
                adjoin(r_active, c_active+1)=1; 
            end
        end
        %Then search above
        if unwrapped_binary(r_active-1, c_active)==1
            phase_ref=IM_unwrapped(r_active-1, c_active);                                       %Obtain the reference unwrapped phase
            p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
            IM_unwrapped(r_active, c_active)=p(2);
            unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
            adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
            isolated_adjoining_pixel_flag=0;
            %Update the new adjoining pixels:
            if r_active+1<=r_dim & unwrapped_binary(r_active+1, c_active)==0 & IM_mask(r_active+1, c_active)==1
                adjoin(r_active+1, c_active)=1; 
            end
            if c_active-1>=1 & unwrapped_binary(r_active, c_active-1)==0 & IM_mask(r_active, c_active-1)==1
                adjoin(r_active, c_active-1)=1; 
            end
            if c_active+1<=c_dim & unwrapped_binary(r_active, c_active+1)==0 & IM_mask(r_active, c_active+1)==1
                adjoin(r_active, c_active+1)=1; 
            end
        end
        %Then search on the right
        if unwrapped_binary(r_active, c_active+1)==1
            phase_ref=IM_unwrapped(r_active, c_active+1);                                       %Obtain the reference unwrapped phase
            p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
            IM_unwrapped(r_active, c_active)=p(2);
            unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
            adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
            isolated_adjoining_pixel_flag=0;
            %Update the new adjoining pixels:
            if r_active+1<=r_dim & unwrapped_binary(r_active+1, c_active)==0 & IM_mask(r_active+1, c_active)==1
                adjoin(r_active+1, c_active)=1; 
            end
            if c_active-1>=1 & unwrapped_binary(r_active, c_active-1)==0 & IM_mask(r_active, c_active-1)==1
                adjoin(r_active, c_active-1)=1; 
            end
            if r_active-1>=1 & unwrapped_binary(r_active-1, c_active)==0 & IM_mask(r_active-1, c_active)==1
                adjoin(r_active-1, c_active)=1; 
            end
        end
        %Finally search on the left
        if unwrapped_binary(r_active, c_active-1)==1
            phase_ref=IM_unwrapped(r_active, c_active-1);                                       %Obtain the reference unwrapped phase
            p=unwrap([phase_ref IM_phase(r_active, c_active)]);                             %Unwrap the active pixel
            IM_unwrapped(r_active, c_active)=p(2);
            unwrapped_binary(r_active, c_active)=1;                                         %Mark the pixel as unwrapped
            adjoin(r_active, c_active)=0;                                                   %Remove it from the list of adjoining pixels
            isolated_adjoining_pixel_flag=0;
            %Update the new adjoining pixels:
            if r_active+1<=r_dim & unwrapped_binary(r_active+1, c_active)==0 & IM_mask(r_active+1, c_active)==1
                adjoin(r_active+1, c_active)=1; 
            end
            if c_active+1<=c_dim & unwrapped_binary(r_active, c_active+1)==0 & IM_mask(r_active, c_active+1)==1
                adjoin(r_active, c_active+1)=1; 
            end
            if r_active-1>=1 & unwrapped_binary(r_active-1, c_active)==0 & IM_mask(r_active-1, c_active)==1
                adjoin(r_active-1, c_active)=1; 
            end
        end
        if isolated_adjoining_pixel_flag==1;
            adjoin(r_active,c_active)=0;                                                    %Remove the current active pixel from the adjoin list
        end
    end
end
   

