function def=enviinfo(varargin)
%ENVIINFO returns ENVI header description for Matlab variable.
%info=ENVIINFO(); returns structure info with default generic values.
%info=ENVIINFO(a); returns structure info with default values specific to
%variable a.
%Test case: a= rand(2,3,4)+j*rand(2,3,4); info=enviinfo(a);

def=[]; %default values
def.description='{}';
def.samples=1;
def.lines=1;
def.samples=1;
def.bands=1;
def.header_offset=0;
def.file_type='ENVI Standard';
def.data_type=4;
def.interleave='bsq';
def.sensor_type='Unknown';
def.byte_order=0; %machine = 'ieee-le';

if nargin==0
    return
end

data=varargin{1};
assert(ndims(data)<=3,'Data with more than 3 dimensions is not supported');

[def.lines,def.samples,def.bands]=size(data);

format = class(data);
iscx=~isreal(data);

switch format
    case 'uint8'
        def.data_type=1;
    case 'int16'
        def.data_type=2;
    case 'int32'
        def.data_type=3;
    case 'single'
        def.data_type=4;
    case 'double'
        def.data_type=5;
    case 'uint16'
        def.data_type=12;
    case 'uint32'
        def.data_type=13;
    case 'int64'
        def.data_type=14;
    case 'uint64'
        def.data_type=15;
    otherwise
        error(['File type number: ',format,' not supported.']);
end

if iscx
    switch format
        case 'single'
            def.data_type=6;
        case 'double'
            def.data_type=9;
        otherwise
            error(['File type number: ',format,' not supported in complex data.']);
    end
end


