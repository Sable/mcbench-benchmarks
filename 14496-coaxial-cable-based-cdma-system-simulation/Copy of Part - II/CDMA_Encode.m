function [DataBit,Chipbit,Signal,OutSignal] = CDMA_Encode(TotalChips, ...
    TotalUser,TotalDataBit)

chippingSeq = PNSeq(TotalChips);                    % Makes Chiping Seq.
while (abs(ones(size(chippingSeq))'*chippingSeq)==length(chippingSeq))
    chippingSeq = PNSeq(TotalChips); % Makes Chips again if no variation
end
Signal=zeros(TotalChips,TotalUser);
OutSignal = zeros(TotalDataBit*TotalChips,1);
for user =1:TotalUser,
    DataBit(:,user)=round(rand(1,TotalDataBit));    % Makes Random data
    
    a = find(DataBit(:,user)==0);   %###############################
    for k =a                        %  This part finds and replaces
        DataBit(k,user)=-1;         %  all zeros of data with -1
    end                             %###############################

    Chipbit(:,user)=RotateSeq(chippingSeq); 
    chippingSeq = Chipbit(:,user);
    
    for l1 = 1:TotalDataBit
        for l2 = 1:TotalChips
            Signal((l1-1)*TotalChips+l2,user)=DataBit(l1,user)* ...
                Chipbit(l2,user);
        end
    end
    OutSignal = OutSignal + Signal(:,user);    
end