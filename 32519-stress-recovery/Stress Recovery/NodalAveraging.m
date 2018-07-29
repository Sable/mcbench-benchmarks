function [stressavg] = NodalAveraging(stress_N,type)
%--------------------------------------------------------------------------
% Purpose:
%         Nodal averaging of elemental nodal stresses
% Synopsis :
%         stressavg = NodalAveraging(stress_N,type)
% Variable Description:
%           stress_N - elemental nodal stresses
%           type = average   does the averaging
%                = sum       adds the stresses
%           stressavg - averaged nodal stresses
%--------------------------------------------------------------------------

 load nodes.dat ;
 load coordinates.dat ;

nnode = length(coordinates);
stressavg = zeros(nnode,3);
for ind = 1:nnode
    [r c] = find(nodes==ind) ;
    switch type
        case 'average'
        share = length(r) ;
        case 'sum'
        share = 1 ;
    end
    ele = 4*(r-1)+c ;
    stress=[sum(stress_N(ele,1))/share.....
            sum(stress_N(ele,2))/share.....
            sum(stress_N(ele,3))/share];                        
    stressavg(ind,:)=stress;
end

