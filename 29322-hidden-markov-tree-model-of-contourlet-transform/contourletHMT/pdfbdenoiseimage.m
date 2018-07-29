% pdfbdenoiseimagethmt.m
% written by: Duncan Po
% Date: January 14, 2004
% Clean the noisy image using the model and state probabilities of the
% noisy image. The image is assumed to be square.
% Usage: cleanimage = pdfbdenoiseimage( model, stateprob, nvar, nc, imname, imformat)
% Inputs:   model       - model of the noisy image
%           stateprob   - state probabilities of the noisy image
%           nvar        - noise variance, normalized to the image range
%                           (ie. should be between 0 and 1)
%           nc          - noise variance in contourlet domain. Input '' if
%                           unknown
%           imname      - name of the image file
%           imformat    - format of the image file (e.g. 'gif')
% Output:   cleanimage  - the denoised image


function cleanimage = pdfbdenoiseimage( model, stateprob, nvar, nc, imname, imformat)

pyrfilter = '9-7';
dirfilter = 'pkva';
nlevel = model{1}.nlevels;
for lev = 1:nlevel
    levndir(lev) = log2(length(model{1}.stdv{lev})*length(model));
end;

if nargin == 6
    coef = contourlet(pyrfilter, dirfilter, levndir, imname, imformat);
elseif nargin == 5
    coef = contourlet(pyrfilter, dirfilter, levndir, imname);
end;

% Verify image is square and obtain image dimensions
[nrow, ncol] = size(coef{2}{1});
imagestats = imfinfo(imname, imformat);
imdim = imagestats.Width;
if imdim ~= imagestats.Height
    error('Image must be square.');
end

for state = 1:size(stateprob{1}{1},2)
    for lev = 1:nlevel+1
        newstateprob{state}{lev} = [];
        covariance{state}{lev} = [];
    end;
end;

% process stateprob, and covariance so that it has the same structure as coef
for state = 1:size(stateprob{1}{1},2)
    for dir = 1:2.^levndir(1)
        for scale = 1:length(stateprob{dir})
            tempsp{scale} = stateprob{dir}{scale}(:,state);
        end;
        tempstateprob = tree2contourlet(tempsp, dir, levndir, nrow, ncol);
        
        for lev = 1:nlevel
            newstateprob{state}{lev+1} = [newstateprob{state}{lev+1} tempstateprob{lev}];
            for subdir = 1:length(model{dir}.stdv{lev})
               covariance{state}{lev+1} = [covariance{state}{lev+1} ...
                     {ones(size(coef{lev+1}{(dir-1)*(2.^(levndir(lev)-levndir(1)))+subdir},1),...
                        size(coef{lev+1}{(dir-1)*(2.^(levndir(lev)-levndir(1)))+subdir},2))*...
                        model{dir}.stdv{lev}{subdir}(state)*model{dir}.stdv{lev}{subdir}(state)}];
            end;
        end;
    end;
end;

% calculates the noise variance in contourlet domain
if isempty(nc)
    nc = contournc(nvar, pyrfilter, dirfilter, levndir, imdim);
end;

% computes the attenuator for each coefficient and state
for state = 1:length(covariance)
   for lev = 2:nlevel+1
      for dir = 1:length(covariance{state}{lev})
         [covrow, covcol] = size(covariance{state}{lev}{dir});
         covariance{state}{lev}{dir}=max(covariance{state}{lev}{dir}...
            -nc{lev}{dir}, zeros(covrow, covcol))./covariance{state}{lev}{dir};
      end;
   end;
end;

% multiplies each contourlet coefficient with its corresponding state probabilities
for state = 1:length(newstateprob)
   for lev = 2:nlevel+1
      for dir = 1:length(newstateprob{state}{lev})
         newcoef{state}{lev}{dir} = newstateprob{state}{lev}{dir}...
            .*coef{lev}{dir};
      end;
   end;
end;

% we don't denoise the scaling function since its SNR is high
cleancoef{1} = coef{1};

% initialize the clean coefficients
for lev = 2:nlevel+1
    for dir = 1:length(newstateprob{state}{lev})
        cleancoef{lev}{dir} = zeros(size(coef{lev}{dir},1), size(coef{lev}{dir},2));
    end;
end;
          

% denoise
for state = 1:length(newstateprob)
   for lev = 2:nlevel+1
      for dir = 1:length(newstateprob{state}{lev})
         cleancoef{lev}{dir}=cleancoef{lev}{dir}+covariance{state}{lev}{dir}...
            .*newcoef{state}{lev}{dir};
      end;
   end;
end;


cleanimage = pdfbrec(cleancoef, pyrfilter, dirfilter);
figure;
imshow(uint8(cleanimage));
