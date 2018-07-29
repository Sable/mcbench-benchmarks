function omimport(modelname)  
%
% Read OpenModelica Result File into Workspace
%
% SYNTAX: omimport(modelname)
% z.B. omimport('package.model')
%
% All $dummies, der(*) and data(time)=0 are thrown out
% Feedback/problems: Christian Schaad, ingenieurbuero@christian-schaad.de

load ([modelname,'_res.mat']);
%Sort out double times 


deltat0=find(diff(data_2(1,:))<1e-5);
disp(['Removed same time values: ',num2str(length(deltat0)),'/',num2str(length(data_2(1,:)))])
assignin('base','data_2',data_2);
assignin('base','dataInfo',dataInfo);
assignin('base','name',name);
assignin('base','deltat0',deltat0);
name=name';
%	description=description';
for i=1:size(name,1)%length(data_2(:,1))
    
    if (isempty(strfind(name(i,:),'der(')))&&(isempty(strfind(name(i,:),'[')))&&abs(dataInfo(2,i))<=length(data_2(:,1));
    nonchars=strfind(name(i,:),char(0));
  if dataInfo(2,i)<0
assignin('base','temp',-data_2(-dataInfo(2,i),:));
%eval([num2str(name(i,1:nonchars(1)-1)),'=-data_2(-dataInfo(2,i),:);'])
%evalin('base',([num2str(name(i,1:nonchars(1)-1)),'=-data_2(-dataInfo(2,i),:);']));
  else
assignin('base','temp',data_2(dataInfo(2,i),:));
%eval([num2str(name(i,1:nonchars(1)-1)),'=data_2(dataInfo(2,i),:);']);
%evalin('base',([num2str(name(i,1:nonchars(1)-1)),'=data_2(dataInfo(2,i),:);']));
  end
%if (max(daten(i).data)~=0 | min(daten(i).data)~=0))
%disp(num2str(nonchars))
%disp (num2str(name(i,1:nonchars(1)-1)))

evalin('base',(['temp(deltat0)=[];']));


evalin('base',([num2str(name(i,1:nonchars(1)-1)),'=temp;']));

end 
end
clear data_1 data_2 Aclass description modelname i dataInfo temp deltat0;
evalin('base',(['clear name data_2 dataInfo nonchars temp']));
