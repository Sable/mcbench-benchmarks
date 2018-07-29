function [a,b,example_info] = example_process(name,varargin)

%EXAMPLE_PROCESS generates an example process
%   [a,b] = example_process(name_string) generates ARMA parameters
%   that represent a certain spectrum.
%
%   name_string can be any of the following strings:
%
%   EXAMPLE PROCESSES:
%   (1)  'gauss'
%   (2)  'gauss+target'
%
%   (3)  '-53slope'
%   (4)  '-53slope-7slope'
%
%   (5)  'stretched-exponent'
%
%   Additional information about the example can be found in example_info:
%   [a,b,example_info] = example_process(name_string).
%
%   An alternative way to approach the examples is:
%   [a,b] = example_process(number) with the number of the example
%
%   Details about the way the ARMA parameters are calculated can be found in the program listing
%
%   Uses: PSD2AR.

%S. de Waele, March 2002.

%Some detailed comments on the generation of the ARMA-models:
%
%For all examples, the following steps are taken:
%  (1) nspec samples of the spectrum are calculated; As the spectrum is calculated up to frequency
%      f=1/2, the signal has been sampled. To include the influcence of aliasing, one single alias
%      is included. In this way, the resulting spectrum is guaranteed to be flat at f=1/2. Besides
%      being more realistic, this also facilitates the calculation of an accurate ARMA model.
%  (2) IN PSD2AR: A continuous spectrum in created with Nearest Neigbor interpolation;
%  (3) IN PSD2AR: The best AR(p) model for this spectrum is calculated;
%  Future possibility, not implemented in this version:
%  (4) Based on a long AR model, ARMAsel for reduced statistics can be used to obtain an MA or an 
%      ARMA model. This may lead to a much more compact representation of the spectrum.
%
%  Remark: For the examples 1-5, no exact ARMA model of finite order is available. Here, a
%          low-order model is determined that provides an acccurate match to the original spectum
%          for the frequencies [0,1/2].

example_strings = {'gauss', 'gauss+target', '-53slope', '-53slope-7slope', 'stretched-exponent'};
nexample = length(example_strings);
if ~isstr(name)
    name = example_strings{number};
else
    name = lower(name);
    %Check if the name is in the list of examples
    match = 0;
    i=1;
    while ~match & i<=nexample
        match = strcmp(example_strings{i},name);
        i = i+1;
    end
    if ~match, example_strings, error(['Name ''' name ''' not in list of examples.']), end
end
    
switch name
case 'gauss'
    shape = 'gauss';
    nspec = 10000;
    Lar   = 100;
    comment = 'gauss';
case '-53slope'
    shape = 'slope53';
    nspec = 10000;
    Lar   = 100;
    comment = '-53 slope';
otherwise
    error(['Example ''' name ''' not implemented yet.'])
end
f = (0:nspec-1)/nspec/2;
[h,example_info] = feval(shape,f,varargin);
h = h + feval(shape,1-f,varargin); %Include one alias.

a = psd2ar(h,Lar);
b = 1;

example_info.comment = comment;
example_info.Lar = Lar;
example_info.nspec = nspec;

%------------------------------------------------------------------
%Functions for calculation of the various power spectra
%Addargs can either be left out or be ALL given.
%------------------------------------------------------------------
function [s, example_info] = slope53(f,addargs)
%addargs: f1 = roll-off frequency.
%If left out: f1 = 1/1000.

addargs_pres = 0;
if exist('addargs')
    if ~isempty(addargs), addargs_pres = 1; end
end
if addargs_pres,
    f1 = addargs{1};
else
    f1 = 1/1000; %-5/3 roll-off frequency.
end
example_info.f1 = f1;
s = 1./( (1 + (f/f1).^(5/3)) );

%------------------------------------------------------------------
function [s, example_info] = gauss(f,addargs)
%addargs: fw = Width of Gauss-curve.
%If left out: fw = 0.1.

addargs_pres = 0;
if exist('addargs')
   if ~isempty(addargs), addargs_pres = 1; end
end
if addargs_pres,
   fw = addargs{1};
else
   fw = .1; %Width of Gauss-curve.
end
fC = .25;  %Clutter in middle of spectrum
example_info.fw = fw;
example_info.fC = fC;

s = exp(-.5*(f-fC).^2/fw.^2);