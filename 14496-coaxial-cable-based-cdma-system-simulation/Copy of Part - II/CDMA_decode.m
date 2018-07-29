function [Decoded,Decoder_Chip,Temp_Decoded,intgrl] =  ...
  CDMA_decode(OutSignal,Chipbit,User_to_Decode, ...
  SamplesPerBit,SamplePerChip,TotalDataBit)

% ........................ CDMA Decoding Starts Here .....................
clipto = TotalDataBit*SamplesPerBit;


TotalChips = length(Chipbit(:,User_to_Decode));
Decoder_Chip1 =[];
for l1 = 1:TotalDataBit
    Decoder_Chip1 = vertcat(Decoder_Chip1,Chipbit(:,User_to_Decode));
end
Decoder_Chip = MakeSampled(Decoder_Chip1,length(OutSignal),SamplePerChip);
Temp_Decoded = OutSignal.*Decoder_Chip;
Temp_Decoded = Temp_Decoded(1:TotalDataBit*SamplesPerBit);

intgrl = zeros(length(Temp_Decoded),1);
Avg_Ingl = 0;
Decoded = zeros(TotalDataBit,1);
    bitno = 0;
    for l1 = 1:TotalChips*SamplePerChip:length(Temp_Decoded)
        bitno = bitno+1;
        for l2 = l1:(l1+TotalChips*SamplePerChip-1)
            if (l2==1),intgrl(1)=Temp_Decoded(1);continue;end
            intgrl(l2) = intgrl(l2-1) + Temp_Decoded(l2);
        end
        if (intgrl(l2)>0),
            Decoded(bitno)=1;
        else
            Decoded(bitno)=-1;
        end
        intgrl(l2) = 0;
    end
intgrl=vertcat(intgrl,zeros(length(OutSignal)-length(intgrl),1));
Temp_Decoded = vertcat(Temp_Decoded,zeros(length(OutSignal)-length(Temp_Decoded),1));
% ........................ CDMA Decoding Ends Here .....................