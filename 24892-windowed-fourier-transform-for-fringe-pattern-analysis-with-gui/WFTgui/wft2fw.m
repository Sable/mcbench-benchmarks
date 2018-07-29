function g=wft2fw(type,f,sigmax,wxl,wxi,wxh,sigmay,wyl,wyi,wyh,thr)
%This function and all the input and output are basicly the same as 
%in the function "wft2" shown in the OLEN paper. 
%Only the realization of convolution is slighly different.
%Fourier transfomrs are used to realize conv2.
%wft2f comsumes about 75% of wft2s time, and much less than wft2.
%However, wft2f uses more memory than wft2s.
%further, sigma is changed to sigmax and sigmay so that the parameter
%setting can be more general
%wft2fw = wft2f + waitbar 
%--------------------------------------------------------------------------
%type:  'wff' or 'wfr'
%f:     2D input signal, (1) exponential field from phase-shifting technique 
%       and digital holography; (2)carrier fringe from carrier technique, 
%       (3) it can also be a closed fringe pattern
%sigmax: window size along x, recomended value: 10
%wxl:   low bound of freuqency in x
%wxi:   increasement of wx;
%wxh:   high bound of frequency in x
%sigmay: window size along y, recomended value: 10
%wyl:   low bound of freuqency in y
%wyi:   increasement of wx
%wyh:   high bound of frequency in y
%thr:   threshold for 'wff', not needed for 'wfr', recomended
%       value:3*standard deviation of noise
%g:     For 'wff', g.filtered is 2D filtered signal, for phase-shifting and
%       carrier technique, use "phase=angle(g)" to get the phase map; 
%       for closed fringe, use "h=real(g.filtered)" to get smoothed 
%       fringe pattern. wxi<=1/sigmax and wyi<=1/sigmay are required.
%       For 'wfr', g is a structure, ridge value, wx, wy and phase are
%       instored as g.r,g.wx,g.wy and g.phase. 
%       wxi and wyi are set according to required frequency resolution
%interesting: fft2 0f 297*297 is much faster than 296*296 and
%298*298
%--------------------------------------------------------------------------
%Example:   g=wft2f2('wff',f,10,-0.5,0.1,0.5,10,-0.5,0.1,0.5,6);
%           g=wft2f2('wfr',f,10,-0.5,0.1,0.5,10,-0.5,0.1,0.5);
%--------------------------------------------------------------------------
%References:
%[1]Windowed Fourier transform for fringe pattern analysis,
%   Applied Optics, 43(13):2695-2702, 2004
%[2]Two-dimensional windowed Fourier transform for fringe pattern analysis: 
%   principles, applications and implementations, 
%   Optics and Lasers in Engineering, 45(2): 304-317, 2007.
%[3]Windowed Fourier transform for fringe pattern analysis: 
%   theoretical analyses, Applied Optics, 47(29): 5408-5419, 2008
%[4]A windowed Fourier filtered and quality guided phase unwrapping 
%   algorithm, Applied Optics, 47(29):5420-5428, 2008
%--------------------------------------------------------------------------
%Last update: 19 May 2009
%Contact: mkmqian@ntu.edu.sg (Dr Qian Kemao, Nanyang Technological Univ.)
%All Copyrights reserved.
%--------------------------------------------------------------------------

%the purpose is to make the wff faster by choosing smaller window size
%which does not affect its accuracy.
if strcmp(type,'wff')
    %half window size along x, by default 2*sigmax; window size: 2*sx+1
    sx=round(2*sigmax); 
    %half window size along y, by default 2*sigmay; window size: 2*sy+1
    sy=round(2*sigmay); 
elseif strcmp(type,'wfr')
    %half window size along x, by default 3*sigmax; window size: 2*sx+1
    sx=round(3*sigmax); 
    %half window size along y, by default 3*sigmay; window size: 2*sy+1
    sy=round(3*sigmay); 
end

%image size
[m n]=size(f); 
%expanded size: size(A)+size(B)-1
mm=m+2*sx;nn=n+2*sy;
%expand f to size [mm nn]
f=fexpand(f,mm,nn); 
%pre-compute the spectrum of f; 
Ff=fft2(f); 
%meshgrid (2D index) for window
[y x]=meshgrid(-sy:sy,-sx:sx); 
%generate a window w0
w0=exp(-x.*x/2/sigmax/sigmax-y.*y/2/sigmay/sigmay); 
%norm2 normalization
w0=w0/sqrt(sum(sum(w0.*w0))); 

%creat a waitbar
h = waitbar(0,'Please wait...');
%total steps for waitbar
steps=floor((wyh-wyl)/wyi)+1;
tic;

if strcmp(type,'wff')
    %to store result
    g.filtered=zeros(m,n);
    for wyt=wyl:wyi:wyh
        
        %current step for waitbar
        step=floor((wyt-wyl)/wyi);
        %show waitbar
        waitbar(step/steps,h,['Elapsed time is ',num2str(round(toc)),' seconds, please wait...']);
        
        for wxt=wxl:wxi:wxh
            %WFT basis
            w=w0.*exp(j*wxt*x+j*wyt*y);
            %expand w to size [mm nn]
            w=fexpand(w,mm,nn); 
            %spectrum of w
            Fw=fft2(w);  
            %implement of WFT: conv2(f,w)=ifft2(Ff*Fw);
            sf=ifft2(Ff.*Fw); 
            %cut to get desired data size
            sf=sf(1+sx:m+sx,1+sy:n+sy); 
            %threshold the spectrum
            sf=sf.*(abs(sf)>=thr); 
            %exapand sf to size [mm nn]
            sf=fexpand(sf,mm,nn); 
            %implement of IWFT: conv2(sf,w);
            gtemp=ifft2(fft2(sf).*Fw); 
            %update
            g.filtered=g.filtered+gtemp(1+sx:m+sx,1+sy:n+sy); 
        end
    end
    %scale the data
    g.filtered=g.filtered/4/pi/pi*wxi*wyi; 
elseif strcmp(type,'wfr')
    %to store wx, wy, phase and ridge values
    g.wx=zeros(m,n); g.wy=zeros(m,n); g.phase=zeros(m,n); g.r=zeros(m,n);
    for wyt=wyl:wyi:wyh

        %current step for waitbar
        step=floor((wyt-wyl)/wyi)+1;
        %show waitbar
        waitbar(step/steps,h);

        for wxt=wxl:wxi:wxh
            %WFT basis
            w=w0.*exp(j*wxt*x+j*wyt*y);
            %expand w to size [mm nn]
            w=fexpand(w,mm,nn); 
            %spectrum of w 
            Fw=fft2(w); 
            %implement of WFT: conv2(f,w)=ifft2(Ff*Fw);
            sf=ifft2(Ff.*Fw); 
            %cut to get desired data size
            sf=sf(1+sx:m+sx,1+sy:n+sy);
            %indicate where to update
            t=(abs(sf)>g.r); 
            %update r
            g.r=g.r.*(1-t)+abs(sf).*t; 
            %update wx
            g.wx=g.wx.*(1-t)+wxt*t; 
            %update wy
            g.wy=g.wy.*(1-t)+wyt*t; 
            %update phase
            g.phase=g.phase.*(1-t)+angle(sf).*t; 
        end
    end
end

%close waitbar
waitbar(1,h,['Elapsed time is ',num2str(round(toc)),' seconds, please wait...']);
close(h)

function f=fexpand(f,mm,nn)
%expand f to [m n]
%this function can be realized by padarray, but is slower

%size f
[m n]=size(f); 
%store f
f0=f;
%generate a larger matrix with size [mm nn]
f=zeros(mm,nn);
%copy original data
f(1:m,1:n)=f0;
