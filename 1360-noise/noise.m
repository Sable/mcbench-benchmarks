function y = noise(varargin)
%  NOISE    Adds noise to an image.
%
%     NOISE creates a new image by adding noise to the original image.
%     NOISE can be used to any matrix (1D, 2D, 3D, nD)
%
%     Noisetypes are:
%       'ag' : additive gaussian (default)    'au' : additive uniform
%       'mg' : multiplicative gaussian        'mu' : multiplicative uniform
%       'sp' : salt and pepper
%
%     Additive noise sums an random value to the image value at each pixel,
%     Multiplicative noise replaces a pixel value with an random value,
%     Salt and Pepper noise replaces a pixel value with the maximum or minimum possible values.
%
%     For 'ag' noisetype use:  y = NOISE(x,'ag', variance, [incidence])
%       where 'variance' is the variance of the gaussian noise added and the optional parameter
%       'incidence' is the percetual of pixels affected be the noise (default for additive noise=1).
%       For a 50% incidence use 'incidence' = .5 and so on.
%
%     For 'au' noisetype use :  y = NOISE(x,'au', maximum, [incidence])
%       where 'maximum' is the maximum value the uniform noise can achieve
%
%     For 'mg' noisetype use :  y = NOISE(x,'mg', incidence)
%     For 'mu' noisetype use :  y = NOISE(x,'mu', incidence)
%       Multiplicative noisetypes require that the 'incidence' parameter. For this kind of noise
%       the variance or the maximum (respectivelly for gaussian and uniform noisetypes) are allways
%       set to the maximum image value.
%
%     For 'sp' noisetype use :  y = NOISE(x,'sp', incidence)
%
%     The 'maximum' and 'variance' parameters can be set as percentual of the maximum - minimum image 
%     values by using these values as strings containg the percentual rate followed by the percent symbol.
%     The 'incidence' can also be expressed as a pecentual in this same way
%
%     Example:  y = NOISE(x,'ag', '25%')
%               y = NOISE(x,'mu', 10, .5) -> same as y = NOISE(x,'mu',10, '50%')
%

[u, noisetype,  scale, incid] = parse_inputs(varargin{:});

if ~isa(u,'double')
   u = double(u);
end

y = u;

n = zeros(size(u));
if incid == 1
   m_incid = logical(ones(size(u)));
else
   m_incid = rand(size(u));
   m_incid = find(m_incid <= incid);
end

if strcmp(noisetype, 'ag')
   n(m_incid) = scale*randn(size(m_incid));
   y = u + n;
   
elseif strcmp(noisetype, 'au')
   n(m_incid) = scale*rand(size(m_incid));
   y = u + n;
   
elseif strcmp(noisetype, 'mg')
   n(m_incid) = scale*randn(size(m_incid));
   y(m_incid) = n(m_incid);
   
elseif strcmp(noisetype, 'mu')
   n(m_incid) = scale*rand(size(m_incid));
   y(m_incid) = n(m_incid);
   
elseif strcmp(noisetype, 'sp')
   n(m_incid) = sign(randn(size(m_incid)));
   umax = max(u(:));
   umin = min(u(:));
   salt = find(n==-1);
   pepper = find(n==1);
   y(salt) = umax;
   y(pepper) = umin;
end

function [u, noisetype, scale, incid] = parse_inputs(varargin)
switch nargin
case 0
   error('Too few inputs')
   
case 1
   u = varargin{1};
   noisetype = 'ag';
   scale = double(max(u(:)));
   incid = 1;
   
case 2
   u = varargin{1};
   if strmatch(varargin{2},['ag';'au'])
      noisetype = varargin{2};
      scale = double(max(u(:)));
      incid = 1;
   elseif strmatch(varargin{2},['mg'; 'mu'; 'sp'])
      error('Incidence missing');
   else
      noisetype = 'ag';
      scale = varargin{2};
      incid = 1;
   end
   
case 3
   u = varargin{1};
   if strmatch(varargin{2},['ag';'au'])
      noisetype = varargin{2};
      scale = varargin{3};
      incid = 1;
   elseif strmatch(varargin{2},['mg'; 'mu'; 'sp'])
      noisetype = varargin{2};
      scale = double(max(u(:)));
      incid = varargin{3};
   else
      noisetype = 'ag';
      scale = varargin{2};
      incid = varargin{3};
   end
   
case 4
   u = varargin{1};
   if strmatch(varargin{2},['ag';'au'])
      noisetype = varargin{2};
      scale = varargin{3};
      incid = varargin{4};
   else
      error('Too many parameters')
   end
   
otherwise
   error('Too many parameters')
end

if findstr(scale,'%')
   scale = ( double(max(u(:))) - double(min(u(:))) )*str2num(scale(1:end-1))/100;
end
if findstr(incid,'%')
   incid = str2num(incid(1:end-1))/100;
end
