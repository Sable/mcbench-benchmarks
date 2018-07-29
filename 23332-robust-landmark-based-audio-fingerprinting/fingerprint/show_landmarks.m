function show_landmarks(D,SR,L,T,C)
% show_landmarks(D,SR,L[,T,C])
%    Display the landmarks superimposed on a spectrogram.
%    Rows of L are landmark pairs <t1 f1 f2 dt>
%    T is optional 2-element time range selector (empty for all)
%    C is optional graphic mode specifier (defaults to 'o-r')
%    If D is 2-D, it is taken as the spectrogram up to 4 kHz from
%    find_landmarks (and SR is ignored).
% 2008-12-30 Dan Ellis dpwe@ee.columbia.edu

if nargin < 4
  T = [];
end
if nargin < 5
  C = 'o-r';
end

targetSR = 8000;
% We use a 64 ms window (512 point FFT) for good spectral resolution
fft_ms = 64;
nfft = round(targetSR/1000*fft_ms);

fbase = targetSR/nfft;
tbase = fft_ms/2/1000;

if (size(D,1)<3) || (size(D,2)<3)
  % we have an actual soundfile

   if length(D) > 0

   %%%%%%%% vvvvvvvvv Copied from find_landmarks

     if size(D,1) > size(D,2)
       D = D';
     end
     if size(D,1) == 2;
       D = mean(D);
     end
     
     % Resample to target sampling rate
     if (SR ~= targetSR)
       srgcd = gcd(SR, targetSR);
       D = resample(D,targetSR/srgcd,SR/srgcd);
     end

     % Take spectral features
     S = abs(specgram(D,nfft,targetSR));

   %%%%%%%% ^^^^^^^^ Copied from find_landmarks
   
   end

else
  S = D;
end

if length(D) > 0
   
  [nr,nc] = size(S);
  tt = [1:nc]*tbase;
  ff = [0:nr-1]*fbase;

  imagesc(tt,ff,20*log10(S));
  axis xy
  ca = caxis;
  caxis([-60 0]+ca(2));

end
  
hold on

for i = 1:size(L,1);
  lrow = L(i,:);
  t1q = lrow(1);
  f1q = lrow(2);
  f2q = lrow(3);
  dtq = lrow(4);
  t2q = t1q+dtq;
  t1 = t1q*tbase;
  t2 = t2q*tbase;
  f1 = f1q*fbase;
  f2 = f2q*fbase;
  plot([t1 t2],[f1 f2],C);
end

hold off

if length(T) == 2
  a = axis;
  axis([T(1) T(2) a(3) a(4)]);
end
