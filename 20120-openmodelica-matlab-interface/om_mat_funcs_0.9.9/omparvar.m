function omparvar(modelname,parameter,values,varargin)
% Parametervariation and plotting...
% SYNTAX: omparvar(modelname,parameter_to_be_changed,values,toplotx1,toploty1,toplotx2,toploty2,...)
%  Example:
% omparvar('HelloWorld.test','Hello1.a',[2:1.5:10],'time','Hello1.x','Hello1
% .a','Hello1.x')
%  ingenieurbuero@christian-schaad.de


j=1;
figure;
 if exist('textscan')==0;  % is it octave?
        octplot_enable;   % Octplot 
        k0=get(gcf,'Number');
        else
	k0=gcf;
	end





   
for value=values
    success=omparameter(modelname,parameter,num2str(value));
    switch success
        case -1
            error(['Parameter ',parameter,' not found!']);
            break;
    end;
    disp(['Simulating model ',modelname,' with ',parameter,'= ',num2str(value)]);
    omrun(modelname)
    omimport(modelname);



    k=k0;
    for i=1:2:length(varargin)-1
        toplot1=varargin{i};
        toplot2=varargin{i+1};
        figure(k);k=k+1;
        evalin('base',['plot(',toplot1,',',toplot2,',''.-'')'])
        if exist('textscan')==0;  % is it octave?
	hold on;    % Octave issue
        else
	hold all;
	end
        xlabel(toplot1);ylabel(toplot2);
    end
    legende(j).name=[parameter,'=',num2str(value)];
    j=j+1;
   
   
   
end
for fig=k0:k-1;
figure(fig);
 legend(legende.name);
 grid on;
end
clear legende i j k
