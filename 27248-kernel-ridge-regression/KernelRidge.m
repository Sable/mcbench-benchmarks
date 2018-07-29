function final_ans = KernelRidge(in_data,out_data,test_data,lamda)
%
% This function performs the kernel ridge regression using the Gaussian
% Kernel. Anyother kernel can be used but according to Mercers Theorem it
% should not matter too much.
%
% FinalAns = KernelRidge(In_Data,Out_Data,Test_Data,Lamda)
%
% in_data - Input to the functio to be regressed. D (dimensional) X N (points)
% out_data - Ouput of the function to be regressed. 1 X N (points)
% test_data - Input not included in training. D (dimensions) X n (points)
% lamda - For tikhonov regularization. (Carefully choose this)
% final_ans - Output for a new set of inputs (those that were not in
%             training) 1 X n (points)  
%
% for linear ridge regression use the matlab function "ridge"
% Author - Ambarish Jash
% ref - http://www.eecs.berkeley.edu/~wainwrig/stat241b/lec6.pdf

if size(in_data,2) ~= size(out_data,2)
    fprintf('\nTotal number of points for function input and output are unequal');
    fprintf('\n Exitting program');
    return
elseif size(test_data,1) ~= size(in_data,1)
    fprintf('\nTest data and Input data are of unequal dimensions');
    fprintf('\nExitting program')
    return
else
    tot_data = in_data;
    vec_test = test_data;
    x_in = zeros(size(tot_data,2),size(tot_data,2));
    %% x_in(i,j) = x_in(j,i) -- Using symmetry of the Kernel
    for row = 1:size(x_in,2)
        for col = 1:row
            temp = sum((tot_data(:,row)-tot_data(:,col)).^2);
            x_in(row,col) = exp(-temp/2);
        end
    end
    x_in = x_in + x_in';
    for count = 1:size(x_in,2)
        x_in(count,count) = x_in(count,count)/2;
    end
    
    %% Calculating alpha and the final answer
    final_ans = zeros(1,size(vec_test,2));
    if det(x_in + lamda*eye(size(x_in))) > 1e9
        fprintf('\nThe kernel matrix is poorly scaled. Please choose a better scaling parameter.');
        return
    end
    alpha = inv(x_in + lamda*eye(size(x_in)))*out_data';
    for count1 = 1:size(vec_test,2)
        temp = 0;
        for count2 = 1:size(alpha,1)
            temp1 = sum((vec_test(:,count1) - tot_data(:,count2)).^2);
            temp = temp + alpha(count2)*exp(-temp1/2);
        end
        final_ans(count1) = temp;
    end
end

