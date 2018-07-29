function sdc_coeff = mfcc2sdc(CepCoeff,N,d,P,K)
%--------------------------------------------------------------------------
%Function for Shifted Delta Coefficient Computation.
%
% If you have any query or suggestion please mail to sahidullahmd@gmail.com
% Ussage: sdc_coeff = mfcc2sdc(CepCoeff,N,d,P,k)
%         CepCoeff: MFCC Coefficients stored in row-wise
%         N: NoOfCepstrum i.e. no of column of CepCoeff
%         d: Amount of shift for delta computation
%         P: Amount of shift for next frame whose deltas are to be
%            computed.
%         K: No of frame whose deltas are to be stacked.
%
%         sdc_coeff: Shifted delta coefficient of CepCoeff.
%                    Dimension of the output: NumberOfFrame x N*K
% Example: 
% CepCoeff=rand(1000,19); % Randomly generate MFCC of 1000 frames
% sdc_coeff = mfcc2sdc(CepCoeff,7,1,3,7); %Compute SDC Coefficients.
%
%Details of shifted delta computation is available in W.M. Campbell, J.P.
%    Campbell, D.A. Reynolds, E. Singer, P.A. Torres-Carrasquillo, Support 
%    vector machines for speaker and language recognition, 
%    Computer Speech & Language, Volume 20, Issues 2-3, 
%    Odyssey 2004: The speaker and Language Recognition 
%    Workshop - Odyssey-04, April-July 2006, Pages 210-229.
%--------------------------------------------------------------------------
ToT=size(CepCoeff,1); %Actual Number of Frames 
CepCoeff=(horzcat(CepCoeff', CepCoeff(1:P*(K-1),:)'))'; %Circular padding
[NoOfFrame NoOfCoeff]=size(CepCoeff); %Note the number of frames and 
%                                             number of coefficients (N).
% % N=7; d=1; P=3; k=7;      %Default values are hard-coded if necessary.
delt=(mfcc2delta(CepCoeff,d))';   %Delta Feature Computation
sd_temp=cell(1,K);                %Preparation of a cell array for delta's
for i=1:K                         %For k number of shifts
    temp=delt(:,P*(i-1)+1:1:end); %P: Size of shift
    sd_temp{i}=temp(:,1:ToT);     %Take only desired (i.e. ToT) no of deltas. 
end
sdc_coeff=cell2mat(sd_temp');     %Stacking the SDCs in a single variable
sdc_coeff=sdc_coeff';
%--------------------------------------------------------------------------