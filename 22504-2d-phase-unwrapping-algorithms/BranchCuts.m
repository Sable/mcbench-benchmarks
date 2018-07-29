%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BranchCuts.m generates branch cuts based on the phase residues. This is
% done using the Goldstein method, as described in "Two-dimensional phase 
% unwrapping: theory, algorithms and software" by Dennis Ghiglia and 
% Mark Pritt.
% "residue_charge" is a matrix wherein positive residues are 1 and 
% negative residues are 0. 
% "max_box_radius" defines the maximum search radius for the balancing of 
% residues. If this is too large, areas will be isolated by the branch
% cuts.
% "IM_mask" is a binary matrix. This serves as an artificial border for the
% branch cuts to connect to.
% Created by B.S. Spottiswoode on 15/10/2004
% Last modified on 18/10/2004
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function branch_cuts=BranchCuts(residue_charge, max_box_radius, IM_mask);

[rowdim, coldim]=size(residue_charge);

branch_cuts=~IM_mask;                               %Define initial branch cuts borders as the mask.
residue_charge_masked=residue_charge;
residue_charge(logical(~IM_mask))=0;                %Remove all residues except those in the mask
cluster_counter=1;                                  %Keep track of the number of residues in each cluster
satellite_residues=0;                               %Keep track of the number of satellite residues accounted for

residue_binary=(residue_charge~=0);                 %Logical matrix indicating the position of the residues
residue_balanced=zeros(rowdim, coldim);             %Initially designate all residues as unbalanced

[rowres,colres] = find(residue_binary);             %Find the coordinates of the residues
adjacent_residues=zeros(rowdim, coldim);            %Defines the positions of additional residues found in the search box
missed_residues=0;                                  %Keep track of the effective number of residues left unbalanced because of

disp('Calculating branch cuts ...');
tic;
temp=size(rowres);
for i=1:temp(1);                                    %Loop through the residues
    radius=1;                                       %Set the initial box size
    r_active=rowres(i);                             %Coordinates of the active residue
    c_active=colres(i);
    count_nearby_residues_flag=1;                   %Flag to indicate whether or not to keep track of the nearby residues
    cluster_counter=1;                              %Reset the cluster counter
    adjacent_residues=zeros(rowdim, coldim);        %Reset the adjacent residues indicator
    charge_counter=residue_charge_masked(r_active, c_active);                %Store the initial residue charge
    if residue_balanced(r_active, c_active)~=1                        %Has this residue already been balanced?
        while (charge_counter~=0)                                     %Loop until balanced
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %This portion of code serves to search the box perimeter,
            %place branch cuts, and keep track of the summed residue charge
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for m=r_active-radius:r_active+radius                         %Coordinates of the box border pixels  ***I COULD MAKE THIS MORE EFFICIENT***
                for n=c_active-radius:c_active+radius
                    if (abs(m - r_active)==radius | abs(n - c_active)==radius) & charge_counter~=0  %Ensure that only the border pixels are being scrutinised
                        if m<=1 | m>=rowdim | n<=1 | n>=coldim                                      %Is the current pixel on the image border?
                            if m>=rowdim m=rowdim; end                                              %Make sure that the indices aren't too large for the matrix
                            if n>coldim n=coldim; end
                            if n<1 n=1; end
                            if m<1 m=1; end
                            branch_cuts=PlaceBranchCutInternal(branch_cuts, r_active, c_active, m, n);      %Place a branch cut between the active point and the border
                            cluster_counter=cluster_counter+1;                                      %Keep track of how many residues have been clustered
                            charge_counter=0;                                                       %Label the charge as balanced
                            residue_balanced(r_active, c_active)=1;                                 %Mark the centre residue as balanced
                        end
                        if IM_mask(m,n)==0
                            branch_cuts=PlaceBranchCutInternal(branch_cuts, r_active, c_active, m, n);      %Place a branch cut between the active point and the mask border
                            cluster_counter=cluster_counter+1;                                      %Keep track of how many residues have been clustered
                            charge_counter=0;                                                       %Label the charge as balanced
                            residue_balanced(r_active, c_active)=1;                                 %Mark the centre residue as balanced
                        end
                        if residue_binary(m,n)==1                                                   %Is the current pixel a residue?
                            if count_nearby_residues_flag==1                                        %Are we keeping track of the residues encountered?
                                adjacent_residues(m,n)=1;                                           %Mark the current residue as adjacent
                            end 
                            branch_cuts=PlaceBranchCutInternal(branch_cuts, r_active, c_active, m, n);      %Place a branch cut regardless of the charge_counter value
                            cluster_counter=cluster_counter+1;                                      %Keep track of how many residues have been clustered
                            if residue_balanced(m,n)==0; 
                                residue_balanced(m,n)=1;                                            %Mark the current residue as balanced
                                charge_counter=charge_counter + residue_charge_masked(m,n);                %Update the charge counter            
                            end
                            if charge_counter==0                                                    %Is the active residue balanced?
                                residue_balanced(r_active, c_active)=1;                             %Mark the centre (active) residue as balanced
                            end
                        end
                    end
                end
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %This next portion of code centres the box on the adjacent
            %residues. If the charge is still not balanced after moving
            %through all adjacent residues, increase the box radius and
            %centre the box around the initial residue.
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if sum(sum(adjacent_residues))==0                           %If there are no adjacent residues:
                radius=radius+1;                                        %Enlarge the box    
                r_active=rowres(i);                                     %Centre the larger box about the original active residue
                c_active=colres(i);
            else                                                        %If there are adjacent residues:
                if count_nearby_residues_flag==1;                       %Run this bit once per box being searched
                    [r_adjacent,c_adjacent] = find(adjacent_residues);  %Find the coordinates of the adjacent residues
                    adjacent_size=size(r_adjacent);                     %How many residues are on the perimeter
                    r_active=r_adjacent(1);                             %Centre the search box about a nearby residue
                    c_active=c_adjacent(1);
                    adjacent_residue_count=1;
                    residue_balanced(r_active, c_active)=1;             %Mark the centre (active) residue as balanced before moving on
                    count_nearby_residues_flag=0;                       %Disable further counting of adjacent residues
                else
                    %disp(['Moving block size ', int2str(radius), ' for point ', int2str(i)]);
                    adjacent_residue_count=adjacent_residue_count + 1;  %Move to the next nearby residue
                    if adjacent_residue_count<=adjacent_size(1)
                        r_active=r_adjacent(adjacent_residue_count);    %Centre the search box about the next nearby residue 
                        c_active=c_adjacent(adjacent_residue_count);
                    else                                                %Ok, we're done with this box
                        radius=radius+1;                                %Enlarge the box and move on   
                        r_active=rowres(i);                             %Centre the larger box about the original active residue
                        c_active=colres(i);
                        adjacent_residues=zeros(rowdim, coldim);        %Reset the adjacent residues indicator
                        count_nearby_residues_flag=1;                   %Enable further counting of adjacent residues
                    end
                end
            end
            
            if radius>max_box_radius                                    %Enforce a maximum boundary condition
                %disp('Warning: unreasonably large search area...');
                if cluster_counter~=1                                   %The single satellite residues will still be taken care of
                    missed_residues=missed_residues+1;                  %This effectively means that we have an unbalanced residue 
                else
                    satellite_residues=satellite_residues+1;            %This residues is about to be accounted for...                       
                end
                charge_counter=0;
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %This next portion of code ensures that single satellite
                %residues are not left unaccounted for. The box is simply
                %expanded regardless until the border or ANY other residue
                %is found.
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while cluster_counter==1                                %If the centre residue is a single satellite, then continue to increase the search radius
                     r_active=rowres(i);                                %Centre the box on the original residue
                     c_active=colres(i);
                     for m=r_active-radius:r_active+radius              %Coordinates of the box border pixels  ***This code works but could definitely be made more efficient***
                        for n=c_active-radius:c_active+radius
                            if (abs(m - r_active)==radius | abs(n - c_active)==radius)                      %Ensure that only the border pixels are being scrutinised
                                if m<=1 | m>=rowdim | n<=1 | n>=coldim                                      %Is the current pixel on the image border?
                                    if m>=rowdim m=rowdim; end                                              %Make sure that the indices aren't too large for the matrix
                                    if n>coldim n=coldim; end
                                    if n<1 n=1; end
                                    if m<1 m=1; end
                                    branch_cuts=PlaceBranchCutInternal(branch_cuts, r_active, c_active, m, n);      %Place a branch cut between the active point and the border
                                    cluster_counter=cluster_counter+1;                                      %Keep track of how many residues have been clustered
                                    residue_balanced(r_active, c_active)=1;                                 %Mark the centre (active) residue as balanced
                                end
                                if IM_mask(m,n)==0                                                          %Does the point fall on the mask
                                    branch_cuts=PlaceBranchCutInternal(branch_cuts, r_active, c_active, m, n);      %Place a branch cut between the active point and the mask border
                                    cluster_counter=cluster_counter+1;                                      %Keep track of how many residues have been clustered
                                    residue_balanced(r_active, c_active)=1;                                 %Mark the centre (active) residue as balanced
                                end
                                if residue_binary(m,n)==1                                                   %Is the current pixel a residue?
                                    branch_cuts=PlaceBranchCutInternal(branch_cuts, r_active, c_active, m, n);      %Place a branch cut regardless of the charge_counter value
                                    cluster_counter=cluster_counter+1;                                      %Keep track of how many residues have been clustered
                                    residue_balanced(r_active, c_active)=1;                                 %Mark the centre (active) residue as balanced
                                end
                            end
                        end
                    end
                    radius=radius+1;                                %Enlarge the box and continue searching
                end
            end  
            
        end         % of " while (charge_counter~=0) "
    end             % of " if residue_balanced(r_active, c_active)~=1 "
end

t=toc;
disp(['Branch cut operation completed in ',int2str(t),' seconds.']);
disp(['Unbalanced residues = ', num2str(100*missed_residues/sum(sum(residue_binary))), ' %']);
disp(['Satellite residues accounted for = ', num2str(satellite_residues)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PlaceBranchCutInternal.m places a branch cut between the points [r1, c1] and 
% [r2, c2]. The matrix branch_cuts is binary, with 1's depicting a 
% branch cut. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function branch_cuts=PlaceBranchCutInternal(branch_cuts, r1, c1, r2, c2); 

branch_cuts(r1,c1)=1;                       %Fill the initial points
branch_cuts(r2,c2)=1;
radius=sqrt((r2-r1)^2 + (c2-c1)^2);         %Distance between points
warning off MATLAB:divideByZero;            
m=(c2-c1)/(r2-r1);                          %Line gradient
theta=atan(m);                              %Line angle

if c1==c2                                   %Cater for the infinite gradient
    if r2>r1
        for i=1:radius
            r_fill=r1 + i;  
            branch_cuts(r_fill, c1)=1;
        end
        return;
    else
        for i=1:radius
            r_fill=r2 + i;   
            branch_cuts(r_fill, c1)=1;
        end
        return;
    end
end

%Use different plot functions for the different quadrants (This is very clumsy, 
%I'm sure there is a better way of doing it...)
if theta<0 & c2<c1                           
    for i=1:radius                          %Number of points to fill in
        r_fill=r1 + round(i*cos(theta));    
        c_fill=c1 + round(i*sin(theta));
        branch_cuts(r_fill, c_fill)=1;
    end
    return;
elseif theta<0 & c2>c1 
     for i=1:radius                         %Number of points to fill in
        r_fill=r2 + round(i*cos(theta));
        c_fill=c2 + round(i*sin(theta));
        branch_cuts(r_fill, c_fill)=1;
    end
    return;
end

if theta>0 & c2>c1                          
    for i=1:radius                          %Number of points to fill in
        r_fill=r1 + round(i*cos(theta));    
        c_fill=c1 + round(i*sin(theta));
        branch_cuts(r_fill, c_fill)=1;
    end
    return;
elseif theta>0 & c2<c1 
     for i=1:radius                         %Number of points to fill in
        r_fill=r2 + round(i*cos(theta));
        c_fill=c2 + round(i*sin(theta));
        branch_cuts(r_fill, c_fill)=1;
    end
    return;
end



