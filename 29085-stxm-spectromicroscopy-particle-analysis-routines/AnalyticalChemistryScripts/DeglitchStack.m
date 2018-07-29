%% DeglitchStack
% removes images from stack 
% S = complete stack struct
% badEnergy=

function Snew=DeglitchStack(S,badEnergy)

numbad=length(badEnergy);
resolution=0.1;            % Half of best energy resolution in scan definition

Snew=S;


for counter=1:numbad            % Find bad energy points

    rmindex=find(Snew.eVenergy < badEnergy(counter)+resolution & ...
        Snew.eVenergy > badEnergy(counter)-resolution);

     if isempty(rmindex)==0

        Snew.eVenergy(rmindex)=[];
        Snew.spectr(:,:,rmindex)=[];
    
    else
        
        displayeV=num2str(badEnergy(counter));
        display(strcat('Error: no energy match for input = ',displayeV,' eV! Image not removed!!!'))
        clear displayeV;
        
    end
    
    clear rmindex

end
    
return