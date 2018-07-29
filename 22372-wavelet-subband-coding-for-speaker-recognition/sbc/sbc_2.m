%****************************************************
% Function to calculate sub-band energy(SBC) parameters 
% from enframed signal
% modifided on 17 jan 2008
% *********sarikaya paper algorithm***********
% fs samapling rate 8000
%   frame size used 192 
%s signal
%
%
%***************************************************
function feature= sbc_2(s,fs)


frames=enframe(s,hamming(192),192);
no_offrames=size(frames);
no_of_frames=no_offrames(:,1);
feature=zeros(no_of_frames,12);
energy=zeros(24,1);


fe_frame=0;  % This counter is used to avoid frames with no energy is a sub band

f=statusbar('Extracting SBC Feature');% Creates status bar

for i=1:no_of_frames
    energy=ones(24);
    
    f=statusbar((i/no_of_frames),f);% updates status bar
    [coef,len]=wavedec(frames(i,:),6,'db3');
    s_no=cumsum(len);
    
    %% next two gives the last node in wavelet pacet
 
    energy(1)=en(coef(1:s_no(1)));
   

    energy(2)=en(coef((s_no(1)+1):s_no(2)));
   % coef((s_no(1)+1):s_no(2))
            %refer diagram in sarikaya paper
            [coef1,len1]=wavedec(coef(s_no(2):s_no(3)),1,'db3');
            len1=cumsum(len1);
                energy(3)=en(coef1(1:len1(1)) );
                energy(4)=en(coef1((len1(1)+1):len1(2)));
            
                    [coef2,len2]=wavedec(coef((s_no(3)+1):s_no(4)),2,'db3');
                        len2=cumsum(len2);
                        energy(5)=en(coef2(1:len2(1)));
                        
                        energy(6)=en(coef2( (len2(1)+1):len2(2) ) );
                            [coef3,len3]=wavedec(coef2((len2(2)+1):len2(3)),1,'db3');
                            len3=cumsum(len3);
                                    energy(7)=en(coef3(1:len3(1)));
                                    energy(8)=en(coef3((len3(1)+1):len3(2)));
                                    
                % all nodes at level six are over
                
           [coef4,len4]=wavedec(coef(s_no(4):s_no(5)),2,'db3');      
            len4=cumsum(len4);
                        energy(9)=en(coef4(1:len4(1)));
                        energy(10)=en(coef4((len4(1)+1):len4(2)));
                          
                        [coef5,len5]=wavedec(coef4((len4(2)+1):len4(3)),1,'db3');
                        len5=cumsum(len5);
                                    energy(11)=en(coef5(1:len5(1)));
                                    energy(12)=en(coef5((len5(1)+1):len5(2)));
                                    
                                
            [coef7,len7]=wavedec(coef(s_no(5):s_no(6)),3,'db3');
            len7=cumsum(len7);
                       energy(13)=en(coef7(1:len7(1)));
                       energy(14)=en(coef7((len7(1)+1):len7(2)));
                          
                        [coef8,len8]=wavedec(coef7((len7(2)+1):len7(3)),1,'db3');
                        len8=cumsum(len8);
                           energy(15)=en(coef8(1:len8(1)));
                           energy(16)=en(coef8((len8(1)+1):len8(2)));
                                    
             [coef9,len9]=wavedec(coef7((len7(3)+1):len7(4)),2,'db3');
              len9=cumsum(len9);  
                        energy(17)=en(coef9(1:len9(1)));
                        energy(18)=en(coef9((len9(1)+1):len9(2)));
                                     
                 energy(19)=en(coef9((len9(2)+1):len9(3)));
                 
  [coef10,len10]=wavedec(coef((s_no(6)+1):s_no(7)),3,'db3');   
  len10=cumsum(len10);
  
           energy(20)=en(coef10(1:len10(1)));
           energy(21)=en(coef10((len10(1)+1):len10(2)));
           energy(22)=en(coef10((len10(2)+1):len10(3)));
           
     [coef11,len11]=wavedec(coef10((len(3)+1):len10(4)),1,'db3'); 
     len11=cumsum(len11);
            energy(23)=en(coef11(1:len11(1)));
            energy(24)=en(coef11((len11(1)+1):len11(2)));

            
            
           
% Taking 12 filter bank equalent
%
%f=rdct(feature); function not woring
% 19 jan DCT modified file in dessai cmtr 
if all(energy>0)
  fe_frame=fe_frame+1;  
    log_en=log(energy.*1E+06);

   for j=1:12
   for k=1:24
            
        feature(fe_frame,j)=feature(fe_frame,j)+log_en(k)*cos((j*(k-0.5)*pi)/24);
   end
   end
 % feature=abs(feature); this needs to be checked
end
end
 delete(statusbar)
