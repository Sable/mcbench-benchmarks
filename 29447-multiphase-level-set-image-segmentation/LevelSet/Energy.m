function Energy(M)
global x_methods;
global decision_parameter_of_saving_energy;
global x_iteration;
global x_frequency;

E=find(M);

for i=1:length(E)
    L(i)=M(E(i));
end

if str2double(x_frequency)==1
    X=[1:str2double(x_iteration)];
else
   X=[1 str2double(x_frequency):str2double(x_frequency):str2double(x_iteration)] ;
end
    
    
    
if decision_parameter_of_saving_energy
    if exist('SaveEnergy.mat')
        load('SaveEnergy.mat', 'Energy', 'Xaxis', 'name_method', 'j');
        j=j+1;
        Energy(j,:) = L;
        Xaxis(j,:) = X;
        name=[num2str(j) ': ' x_methods];
        name_method = strvcat(name_method, name);
        save('SaveEnergy.mat', 'Energy', 'Xaxis', 'name_method', 'j');
    else
        j=1;
        Energy(j,:) = L;
        Xaxis(j,:) = X;
        name_method=[num2str(j) ': ' x_methods];
        save('SaveEnergy.mat', 'Energy', 'Xaxis', 'name_method', 'j');    
    end
end
