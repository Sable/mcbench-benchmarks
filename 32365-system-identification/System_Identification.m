function[Weights_Model] = system_identification()

%clear all;
%clc;

% Direct modeling of Electrical system of the plant using LMS algorithm
% By Y.Yella Reddy, 08EE01015, SES, IIT Bhubaneswar.

%Plant Parameters

Weights_Plant=[0.26 0.93 0.26] ; % Transfer function coefficients
N=input('Enter the no of the iterations/input samples: '); %input number of samples.
Input_Plant= rand(1,N);  % input to the plant with mean zero and input to model is also same.


% Model Parameters
Weights_Model=[0 0 0];
Input_Model=Input_Plant;
Learning_Para=input('Enter the Learning Parameter value:'); % Learning rate of the model

%Signal Power to noise power
snr=input('Enter the snr value : ');

%Signal Power and Noise Power
sp=var(Input_Plant);
np =(sp)*power(10,-(snr/10)); 

%Noise to be added
Noise=sqrt(np)*(rand(1,N)-0.5);  


%--------------Intialization-------------%

    % Plant Output.
    Plant_Output(1)=Input_Plant(1)*Weights_Plant(1);
    Plant_Output(2)=Input_Plant(2)*Weights_Plant(1)+Input_Plant(1)*Weights_Plant(2);
    
    %Model Output
    Model_Output(1)=Input_Model(1)*Weights_Model(1);
    Model_Output(2)=Input_Model(2)*Weights_Model(1)+Input_Model(1)*Weights_Model(2);
     
    % Plant output with added noise
    Plant_Output(1)=Plant_Output(1)+Noise(1);
    Plant_Output(2)=Plant_Output(2)+Noise(2);
     
    % Error
    error(1)=Plant_Output(1)-Model_Output(1);
    error(2)=Plant_Output(2)-Model_Output(2);

     %Weight Values
    Weights_Model(1)=Weights_Model(1) + (2*Learning_Para*Input_Model(1)*error(1));
    Weights_Model(1:2)=Weights_Model(1:2) + (2*Learning_Para*Input_Model(2:-1:1)*error(2));

%------Applying Adaptive LMS algorithm--------%    
for i=3:1:N
    
    %Outputs
    Plant_Output(i)=Input_Plant(i)*Weights_Plant(1)+Input_Plant(i-1)*Weights_Plant(2)+Input_Plant(i-2)*Weights_Plant(3);
    Model_Output(i)=Input_Model(i)*Weights_Model(1)+Input_Model(i-1)*Weights_Model(2)+Input_Model(i-2)*Weights_Model(3);

    %White gaussian noise signal added to the output of the plant.
    Plant_Output(i)=Plant_Output(i)+Noise(i);
    error(i)=Plant_Output(i)-Model_Output(i);
    
    %Weight Update using LMS algorithm
    Weights_Model=Weights_Model + (2*Learning_Para*Input_Model(i:-1:i-2)*error(i));
end

%Plots of error square and log of normalized error square

t=1:1:N;
error_square=power(error,2);
Max_error_square=max(error_square);

Normalized_error_Square=error_square./Max_error_square;

plot(t,error_square);
legend('error square');
title('Plot of error square Vs no of iterations');
xlabel('iterations');
ylabel('error square')

figure,
plot(t,log(Normalized_error_Square));
legend('Normalized error square log');
title('Plot of Normalized error square log Vs no of iterations');
xlabel('iterations');
ylabel('Normalized error square log')

%----------------------Testing mode-------------%

s=30;
Input_test=rand(1,s);


for j= 3:1:s
    
    
    Plant_Out_test(1)=Input_test(1)*Weights_Plant(1);
    Plant_Out_test(2)=Input_test(2)*Weights_Plant(1)+Input_test(1)*Weights_Plant(2);
    Plant_Out_test(j)=Input_test(j)*Weights_Plant(1)+Input_test(j-1)*Weights_Plant(2)+Input_test(j-2)*Weights_Plant(3);
    
    Out_Model_test(1)=Input_test(1)*Weights_Model(1);
    Out_Model_test(2)=Input_test(2)*Weights_Model(1)+Input_test(1)*Weights_Model(2);
    Out_Model_test(j)= Input_test(j)*Weights_Model(1)+Input_test(j-1)*Weights_Model(2)+Input_test(j-2)*Weights_Model(3);
    
    error_test(1)= Plant_Out_test(1)-Out_Model_test(1);
    error_test(2)= Plant_Out_test(2)-Out_Model_test(2);
    error_test(j)= Plant_Out_test(j)-Out_Model_test(j);
    
end
p=1:1:s;
figure,
plot(p,Plant_Out_test,'-ro',p,Out_Model_test,'-.b');
legend('Plant Out test','Out Model test');
title('Comparision of outputs of Plant and Model during testing');
xlabel('iterations');
ylabel('Output')

square_error= error_test.^2;
SSE=sum(square_error);


end