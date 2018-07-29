function [MCOH,F] = MultipleCoherehence(fs,x,y,index,nfft)
% Calculation of multiple coherence.
%
% x :inputs (#time samples x #inputs)
% y :outputs (#time samples x #outputs)
% index : selected output 
% nfft : number of fft
% fs : sampling rate
% window : you can change window function if your data are not periodic
%
%
% Sample usage:
%   [mCoh,F] = MultipleCoherehence(2048,inputs,Datas,5,2048);
%
%
%
%  For other Modal Analysis Routines please contact :
%  mmbicak@mtu.edu
%  http://www.me.mtu.edu/~mmbicak
    noverlap = [];    
    m = length(x(1,:));% # inputs 
    n = length(y(1,:));% # outputs     
    if (index<=0) | (index>n) 
        error('index error, check index value (index)') 
    end
    window =[];% assuming pure harmonic signal,otherwise use a window
    for ii = 1 : m 
        for jj = 1 : m
          [Cxy,F] = cpsd(x(:,ii),x(:,jj),window, noverlap,nfft,fs); 
          GXX{ii,jj} = Cxy;
        end
    end
    for ii = 1 : m 
         [Cyx,F] = cpsd(y(:,index),x(:,ii),window, noverlap,nfft,fs); 
         GYX{ii,1} = Cyx;                  
    end
    [Cyy,F] = cpsd(y(:,index),y(:,index),window, noverlap,nfft,fs);     
    GYY{1}=Cyy;    
    GYXX = [GYX';GXX];    
    GY = [GYY;GYX];
    GYXX = [GY GYXX];    
    for ii= 1:length(F)        
        for jj = 1 :m+1
            for kk = 1:m+1;
                G = GYXX{jj,kk};
                GYXX_f( jj , kk )=G(ii);
            end
        end
         for jj = 1 :m
            for kk = 1:m;
                G = GXX{jj,kk};
                GXX_f( jj , kk )=G(ii);
            end
         end       
        MCOH(ii) = 1 - (det(GYXX_f)/(Cyy(ii)*det(GXX_f)));
    end;
    
    
        
        