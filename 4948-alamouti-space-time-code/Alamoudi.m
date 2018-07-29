function ber_ml=Alamoudi(snr,soglia);

%This function simulates a Alamouti scheme. The input variables are soglia and snr.
%Soglia: is the number of errors after which the iterations stop. For better results, put high value of soglia, but
%the simulation is longer.
%snr: the signal to noise ratio (if u don't know what is a signal to noise ratio, well, come back to your high school!).
%
%
%Note: U should use this function with a main function in wich u chose different value of snr. That's because this
%function work just with one value of snr.
%
%If u have problem with this code, write me at m.allegritti@email.it.
%
%Take care!
%
%
%Max

%clc;

S_ML=zeros(1,4);
X_dec=zeros(1,2);
Nt=2;                                                          %Number of TX Antennas
Nr=2;                                                          %Number of RX Antennas
dec=zeros(1,2);
no_bit_sym=1;                                                  %Number of bit per symbol
no_it_x_SNR=10000;                                             %Number of iteration per simulation

iter=0;                                                        %Setting up the variables
err = 0;
tot_err_h = 0;
tot_err_ml = 0;                                                %Number of total errors

while tot_err_ml<soglia                                        %Starting the loop
        
    iter=iter+1;                                                 %Counting the iterations
    
        for i=1:no_it_x_SNR                                                 %Starting the simulation
           
            Data=(2*round(rand(Nt,1))-1)/(sqrt(Nt));                        %Creating random data
            
            %Building the Rayleigh Channel
            
            H=rey(2,2);
            %H=ones(2,2);                                                   %If u want a AWGN channel, use this!
             
            sig = sqrt(0.5/(10^(snr/10)));                                  %Noise variance 
            
            n   =   sig * (randn(Nr,Nt) + j*randn(Nr,Nt));                    %Noise
         
            %Encoder.We code the data in an Alamouti Matrix

            X=[Data(1) -conj(Data(2)); Data(2) conj(Data(1))];              %Coded data
            
            R=H*X + n    ;                                                   %Received matrix
    
            %Combiner

            s0=conj(H(1,1))*R(1,1)+H(1,2)*conj(R(1,2))+conj(H(2,1))*R(2,1)+H(2,2)*conj(R(2,2));    %As Alamouti says 
            s1=conj(H(1,2))*R(1,1)-H(1,1)*conj(R(1,2))+conj(H(2,2))*R(2,1)-H(2,1)*conj(R(2,2));
            
            %S = kron(R,ones(1,2^(2*no_bit_sym)));
            S=[s0 s1];
       
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            %          Decoding              %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
                    
            dh = sqrt(2)*[1 -1]/2;
          
            %Computing the distances for the first symbol%
            
            d11=((dh(1)-real(S(1)))^2+(imag(S(1)))^2);
            d12=((dh(2)-real(S(1)))^2+(imag(S(1)))^2);
              
            
            D1=[d11 d12];                                                    %Distances for the received symbol
              
              
            %Building the decisions vector for the first symbol%
                            
              for k=1:2
                  
                  X1_dec(k)=((abs(dh(k)))^2)*sum(sum((abs(H)).^2)-1)+D1(k);    
                  
              end
              
              %Computing the distances for the second symbol%
              
              d21=((dh(1)-real(S(2)))^2+(imag(S(2)))^2);
              d22=((dh(2)-real(S(2)))^2+(imag(S(2)))^2);
              
              D2=[d21 d22];
              
              %Building the decisions vector for the second symbol%
              
              for x=1:2
                  
                  X2_dec(x)=((abs(dh(k)))^2)*sum(sum((abs(H)).^2)-1)+D2(x);
                  
              end
                  
              %The decisions!! We chose the little one%
              
              [scelta1, posizione1]=min(X1_dec);
              [scelta2, posizione2]=min(X2_dec);
              
              decoded=[dh(posizione1) dh(posizione2)];
              
            err_ml = sum(round(Data')~=round(decoded));                 %Computing the errors
            
            tot_err_ml = err_ml + tot_err_ml;                           
            
        end
        
end
        
            ber_ml=tot_err_ml/(no_it_x_SNR*iter*2)                      %Computing the BER
            
        end

