function out=repmf(fis,varType,varIndex,MFLabel,MFType,MFIndex,MFParams)

%  Synopsis
%  a = repmf(a,varType,varIndex,mfName,mfType,MFIndex,mfParams)

numInputs=length(fis.input);
numOutputs=length(fis.output);


out=fis;
if ~isempty(fis.input)
  if strcmp(varType,'input'),   
    MFindex=MFIndex;
    out.input(varIndex).mf(MFindex).name=MFLabel;
    out.input(varIndex).mf(MFindex).type=MFType;
    out.input(varIndex).mf(MFindex).params=MFParams;
    
  elseif strcmp(varType,'output'),    
   
    MFindex=MFIndex;
    out.output(varIndex).mf(MFindex).name=MFLabel;
    out.output(varIndex).mf(MFindex).type=MFType;
    out.output(varIndex).mf(MFindex).params=MFParams;
    
  end
else
 disp('No Input Variable yet');
end
