function [costunit, selectedf] = choosefactory(factorycap,factholdcost,transcost,setupcost,factory,trkcap,salespoint,selectedsp);
                                        
    costPerUnitValues = inf(1,length(factorycap));
    
    

    for i = 1:length(factorycap)
        if (factory{i}(1,2)>=salespoint{selectedsp}(1,2))
            costPerUnitValues(1,i) = transcost(i,selectedsp) / trkcap + ( ( factorycap(i) - salespoint{selectedsp}(1,2) ) / factorycap(i) ) * factholdcost(i);
        elseif(factory{i}(1,1)==0 && (factorycap(i)+factory{i}(1,2))>=salespoint{selectedsp}(1,2))
            costPerUnitValues(1,i) = (setupcost(i) * (1 - factory{i}(1,1))) / salespoint{selectedsp}(1,2) + transcost(i,selectedsp) / trkcap + ( ( factorycap(i) - salespoint{selectedsp}(1,2) ) / factorycap(i) ) * factholdcost(i);
        end
            
    end;
    
    [costunit,selectedf] = min(costPerUnitValues);

