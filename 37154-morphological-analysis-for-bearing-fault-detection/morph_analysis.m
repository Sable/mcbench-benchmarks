
function morph_analysis(sig,fault_fr,rpm)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Y= MORPH_ANALYSIS(sig,fault_fr,RPM) does the morphological operation on
%the signal "sig". The Morphological operations done are 
%Gradient 1: Beucher Gradient(Dilate - Erode)
%Gradient 2: Signal - Erode
%Gradient 3:Dilate - Signal
%It outputs a FFT graph of the signal along with the gradient
% It also prints on the Command Window, about the availability of Fault in
% the specified frequency
%
%sig - Vibration signal to be analysed 
%fault_fr - Frequency of expected fault (either Inner race or Outer Race)
%rpm-Rotations per minute(in Hz) when above vibration signal is recorded
%
% For better understanding of the algorithm and its usage, please refer to
%    http://ieeexplore.ieee.org/xpl/articleDetails.jsp?arnumber=6153367
% OR
%   https://sites.google.com/site/santhanarajarunachalam/my-research/
%                              condition-monitoring/morphological-operators
%Author:Santhana Raj.A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fault_tym=1/fault_fr;
X=12000*fault_tym;

%for taking different Structure Element lengths
Xk=[0.1*X 0.2*X 0.3*X 0.3*X 0.4*X 0.5*X 0.6*X 0.7*X 0.8*X 0.9*X]; 
Xk=round(Xk);i=1;
clear dil1 erd1 grad* sig_f k freq* max* peak*;

for X1=Xk
clear se;
se=strel(ones(X1,1)); % creating Structuring Elements
dil1(i,:)=imdilate(sig,se);
erd1(i,:)=imerode(sig,se);

grad1(:,i)=imdilate(sig,se)-imerode(sig,se); % Beucher gradient
grad2(:,i)=sig-imerode(sig,se);		     % other Gradients
grad3(:,i)=imdilate(sig,se)-sig;	     % other Gradients

% calculating kurtosis value for selection of SE form 10 different SE used
k(i,1)=kurtosis(grad1(1:150,i));k(i,2)=kurtosis(grad2(1:150,i));
k(i,3)=kurtosis(grad3(1:150,i));

i=i+1;
end

[a,b]=sort(k);


% For Plotting graphs
N=4*2048;Fs=12000;T=N/Fs;freq_s=(0:N-1)/T;
figure();
sig_f=abs(fft(sig(1:N),N));subplot(2,2,1);plot(freq_s(1:550),sig_f(1:550));title('signal');
grad1_f=abs(fft(grad1(1:N,b(10,1)),N));subplot(2,2,2);plot(freq_s,grad1_f);title(b(10,1));
grad2_f=abs(fft(grad2(1:N,b(10,2)),N));subplot(2,2,3);plot(freq_s,grad2_f);title(b(10,2));
grad3_f=abs(fft(grad3(1:N,b(10,3)),N));subplot(2,2,4);plot(freq_s,grad3_f);title(b(10,3));


%Finding Frequency peaks in Gradient 1 

[c,d]=sort(grad1_f(1:550),1,'descend');

for i=1:10
    max_f_grad1(i)=freq_s(d(i+1));
    % peak_freq_1(i)=freq_1(d(i+1));
    
end

fprintf('Max frequencies got from analysis :');fprintf(' %f ',max_f_grad1);
fprintf('\n');
fprintf('\n');

for i=1:10
    remain=round(mod(max_f_grad1(i),rpm));
    for j=1:3
        if (remain==j)||(remain==(rpm-j))||(remain==0)
            max_f_grad1(i)=0;
        end
    end
end

j=0;
for i=1:10
    if max_f_grad1(i)~=0
        j=j+1;
        peak_freq_1(j)=max_f_grad1(i);
    end
end
   
fprintf('Valid frequencies considered (removing sped harmonics) :');fprintf(' %f ',peak_freq_1);
fprintf('\n');
fprintf('\n');

for i=1:length(peak_freq_1)
remain=round(mod(peak_freq_1(i),fault_fr));
    for j=1:10
        if (remain==j)||(remain==(fault_fr-j))
            fprintf('FAULT DETECTED. Peak at Frequency: %f\n',peak_freq_1(i));
        end
    end
end

end
