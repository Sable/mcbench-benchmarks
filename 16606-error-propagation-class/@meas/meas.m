function obj = meas(varargin)

% Constructor for meas class object.
% You must always pass one argument if you want to create a new object.

if nargin==0 % Used when objects are loaded from disk
  obj = init_fields;
  obj = class(obj, 'meas');
  return;
end

firstArg = varargin{1};
if isa(firstArg, 'meas') %  used when objects are passed as arguments
  obj = firstArg;
  return;
end

% We must always construct the fields in the same order,
% whether the object is new or loaded from disk.
% Hence we call init_fields to do this.
obj = init_fields; 

% attach class name tag, so we can call member functions to
% do any initial setup
obj = class(obj, 'meas'); 

% Now the real initialization begins
obj.value = varargin{1};
obj.error = varargin{2};

return;
%%%%%%%%% 

function obj = init_fields()
% Initialize all fields to dummy values 
obj.value = [];
obj.error = [];