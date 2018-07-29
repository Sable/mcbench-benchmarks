% %Question No: 5 (a)
% Determine the weights of a network with 4 input and 2 output units using 
% Perceptron Learning Law for the following input-output pairs:

% Input: [1100]' [1001]' [0011]' [0110]'
% output: [11]' [10]' [01]' [00]'
% Discuss your results for different choices of the learning rate 
% parameters.
% Use suitable values for the initial weights.

in=[1 1 0 0 -1;1 0 0 1 -1; 0 0 1 1 -1; 0 1 1 0 -1];
out=[1 1; 1 0; 0 1; 0 0];
eta=input('Enter the learning rate value = ');
it=input('Enter the number of iterations required = ');
wgt=input('Enter the weights,2 by 5 matrix(including weight for bias):\n');
for x=1:it
    for i=1:4
        s1=0;
        s2=0;
        for j=1:5
          s1=s1+in(i,j)*wgt(1,j);
          s2=s2+in(i,j)*wgt(2,j);
        end
        wi=eta*(out(i,1)-sign(s1))*in(i,:);
        wgt(1,:)=wgt(1,:)+wi;
        wi=eta*(out(i,2)-sign(s2))*in(i,:);
        wgt(2,:)=wgt(2,:)+wi;
    end
end
wgt

