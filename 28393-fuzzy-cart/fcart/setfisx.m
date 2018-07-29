function out = setfisx(fis, arg1, arg2, arg3, arg4, arg5, arg6)
%SETFISX Set fuzzy inference system properties.
% 
%   See setfis for syntax and explanation.
% 
%   It is almost clone of MATALAB's setfis
%   with some modifications, so it's compatible 
%   with extendent fuzzy rule structure.
% 
%   Compare also lines 90-97 of this function
%   with lines 97-106 of the original setfis.      

%   Per Konstantin A. Sidelnikov, 2009.

numInputs=length(fis.input);
numOutputs=length(fis.output);

switch nargin 
case 1
   indent=32*ones(1,8);
   fprintf('      Name\n');
   fprintf('      Type\n');
   fprintf('      AndMethod\n');
   fprintf('      OrMethod\n');
   fprintf('      ImpMethod\n');
   fprintf('      AggMethod\n');
   fprintf('      DefuzzMethod\n');
   fprintf('      InMFParams\n');
   fprintf('      OutMFParams\n');
   fprintf('      RuleList\n');
   
case 3
   propName=lower(arg1);
   newVal=arg2;
   
   switch propName
   case 'name'
      fis.name=newVal;
      out=fis;
   case 'type'
      fis.type=newVal;
      out=fis;
   case 'andmethod'
      fis.andMethod=newVal;
      out=fis;
   case 'ormethod'
      fis.orMethod=newVal;
      out=fis;
   case 'impmethod'
      fis.impMethod=newVal;
      out=fis;
   case 'aggmethod'
      fis.aggMethod=newVal;
      out=fis;
   case 'defuzzmethod'
      fis.defuzzMethod=newVal;
      out=fis;
      
   case {'inlabels','outlabels','inmflabels','outmflabels','inrange','outrange','inmftypes','outmftypes'}
      error('You may not set this property directly');
      
   case 'inmfparams'
      for i=1:numInputs
         numInputMFs(i)=length(fis.input(i).mf);
      end
      totalInputMFs=sum(numInputMFs);
      k=1;
      for i=1:numInputs
         for j=1:numInputMFs(i)
            fis.input(i).mf(j).params=newVal(k,:);
            k=k+1;
         end
      end
      out=fis;
      
   case 'outmfparams'
      for i=1:length(fis.output)
         numOutputMFs(i)=length(fis.output(i).mf);
      end
      totalOutputMFs=sum(numOutputMFs);
      k=1;
      for i=1:numOutputs
         for j=1:numOutputMFs(i)
            fis.output(i).mf(j).params=newVal(k,:);
            k=k+1;
         end
      end
      out=fis;
      
   case 'rulelist'      
       newVal = newVal';
       fis.rule = struct( ...
           'antecedent', newVal(1, :), ...
           'consequent', newVal(2, :), ...
           'weight', newVal(3, :), ...
           'connection', newVal(4, :));
       out = fis;
       
   otherwise
      error(['There is no FIS system property called ', propName]);
   end
   
case 5
   % Name assignment
   % ===========================================
   varType=lower(arg1);
   varIndex=arg2;
   varProp=lower(arg3);
   newVal=arg4;
   
   switch varType
   case 'input'
      
      if varIndex>length(fis.input),
         error(['There are not that many input variables.']);
      end
      
      switch varProp
      case 'name'         
         fis.input(varIndex).name=newVal;
         out=fis;     
      case 'range'         
         fis.input(varIndex).range=newVal;
         out=fis;
      case 'nummfs'         
         error('You may not set this property directly');
      case 'mflist'         
         error('You may not set this property directly');
      end
      
   case 'output'
      % Range checking
      if varIndex>length(fis.output),
         error(['There are not that many output variables.']);
      end
      
      switch varProp
      case 'name'         
         fis.output(varIndex).name=newVal;
         out=fis;
      case 'range'           
         fis.output(varIndex).range=newVal;
         out=fis;
      case 'nummfs'         
         error('You may not set this property directly');
      case 'mflist'         
         error('You may not set this property directly');
      end
      
   otherwise
      disp(['Variable type must be either "input" or "output"']);
      
   end
   
   % ===============================================
   % Handle MEMBERSHIP FUNCTIONS
   % ===============================================
case 7
   % Name assignment
   % ===========================================
   varType=lower(arg1);
   varIndex=arg2;
   MFIndex=arg4;
   MFProp=lower(arg5);
   newVal=arg6;
   
   % New value preparation
   % ===========================================
   switch varType
   case 'input'
      
      % Range checking
      % =======================================
      if varIndex>length(fis.input)
         error(['There are not that many input variables.']);
      end
      
      if MFIndex>length(fis.input(varIndex).mf),
         errStr=['There are only ',int2str(length(fis.input(varIndex).mf)), ...
               ' MFs associated with that variable'];
         error(errStr)
      end
      
      switch MFProp
      case 'name'
         fis.input(varIndex).mf(MFIndex).name=newVal;
         out=fis;
      case 'type'
         fis.input(varIndex).mf(MFIndex).type=newVal;
         out=fis;
      case 'params'
         fis.input(varIndex).mf(MFIndex).params=newVal;
         out=fis;
      end
      
   case 'output'
      % Range checking
      % =======================================
      if MFIndex>length(fis.output(varIndex).mf),
         errStr=['There are only ',int2str(length(fis.output(varIndex).mf)), ...
               ' MFs associated with that variable'];
         error(errStr)
      end
      
      switch MFProp
      case 'name'
         fis.output(varIndex).mf(MFIndex).name=newVal;
         out=fis;
      case 'type'
         fis.output(varIndex).mf(MFIndex).type=newVal;
         out=fis;
      case 'params'
         fis.output(varIndex).mf(MFIndex).params=newVal;
         out=fis;
      end
   end
   
end




