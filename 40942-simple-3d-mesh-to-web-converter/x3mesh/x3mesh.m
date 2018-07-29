function x3mesh(f,v, varargin)


% A simple function to convert a matlab mesh consisting of faces (f) and
% vertices (v) to x3dom html fle to allow viewing of the 3d mesh in a
% browser. 

% Required Inputs,
%   f : Faces of the input mesh
%   v : Vertices of the input mesh
% 
% Optional Inputs,
%   reduction   : factor to reduce size of mesh (default = 0.5) 
%                (useful because large meshes will render poorly and make large html files)
%   name        : File name and title of the html file (default = 'example')
%   subheading  : Additional text that can be added
%   color       : n x 3 vector specifying the RGB color of each vertex 
%                 If 1 x 3 vector then the whole mesh will
%                 have the same color. Values must be between 0 and 1
%                 e.g. [0.5 0 0.5]              
%   rotation    : set to:
%                        0, no rotation
%                        1, rotating mesh
%   deformation :
%		  / under construction /
%
% Output, 
%   html file is saved in the 'html' subfolder of the current directory

% Function written by Benjamin Irving 2013/03/25 (updated 2013/04/08)

% Running example (see demo1.m, demo2.m and demo3.m)

%% Parsing the input parameters

p=inputParser;
%checking dimensions are correct
%faces
p.addRequired('f',@(x) size(x,2)==3);
%vertices
p.addRequired('v',@(x) size(x,2)==3);
%reduce the mesh size (1 means no reduction)
p.addOptional('reduction', 0.5, @(x) length(x)<=1);
% file name
p.addParamValue('name', 'example', @isstr);
% sub heading
p.addParamValue('subheading', 'scroll to zoom, click and drag to rotate', @isstr);
%color vec
p.addParamValue('color', [1 0 0], @(x) size(x,2)==3);
%set the object to rotate
p.addParamValue('rotation', 0, @(x) x==1 || x==0);
% parse the inputs
p.parse(f,v, varargin{:});
inps=p.Results;

%% Mesh processing

%create a mesh structure
m2.faces=inps.f;
m2.vertices=inps.v;

%reduce mesh
m2=reducepatch(m2, inps.reduction);

%centre mesh
m2.vertices=m2.vertices-repmat(mean(m2.vertices),size(m2.vertices, 1), 1);

%convert from matlab to numbering starting at 0
m2.faces=m2.faces-1;
m2.faces(:,4)=-1;

%convert to a 1D list
flist=reshape(m2.faces', 1, size(m2.faces, 1)*size(m2.faces,2));
vlist=reshape(m2.vertices', 1, size(m2.vertices, 1)*size(m2.vertices,2));

%normalise over maximum value
vlist=vlist/max(abs(vlist));


%% x3com conversion
% create the subdirectory if it doesn't exist
if ~exist('htmlfigs', 'dir')
    mkdir('htmlfigs')
end

% open the file to write to
file1=fopen(['htmlfigs/' inps.name '.html'],'w+');

% color (if color is just a single 1x3 vector)
if ( size(inps.color, 1)==1 )
    clist=repmat(inps.color, size(m2.vertices,1), 1);
    clist=reshape(clist', 1, size(clist, 1)*size(clist,2));
% if color is a nx3 vector
else
    if (inps.reduction~=1)
        error('Set ''reduction'' to 1 if assigning color to each of the indices.');
    elseif (size(inps.color,1) ~= size(inps.v,1))
        error('Color and vertices arrays must be the same size');
    else
        clist=reshape(inps.color', 1, size(inps.color, 1)*size(inps.color,2));
    end
    
end

% rotation
if inps.rotation==1
    rot_string=[...
'<timeSensor DEF=''clock'' cycleInterval=''20'' loop=''true''></timeSensor>'...
'<orientationInterpolator DEF=''spinThings'' key=''0 0.25 0.5 0.75 1'' keyValue=''0 1 0 0  0 1 0 1.57079  0 1 0 3.14159  0 1 0 4.71239  0 1 0 6.28319''></orientationInterpolator>'...
'<ROUTE fromNode=''clock'' fromField=''fraction_changed'' toNode=''spinThings'' toField=''set_fraction''></ROUTE>'...
'<ROUTE fromNode=''spinThings'' fromField=''value_changed'' toNode=''airway1'' toField=''set_rotation''></ROUTE>'...
];
    
else
    rot_string='';
end

% print html along with face and vertex arrays
file_string=[...
'<!DOCTYPE html> \n'...
'<html> \n'...
'\t <head> \n'...
'\t\t <meta http-equiv=''Content-Type'' content=''text/html;charset=utf-8''></meta>  \n'...
'\t\t <link rel=''stylesheet'' type=''text/css'' href=''http://www.x3dom.org/x3dom/release/x3dom.css''></link>  \n'...
'\t\t <script type=''text/javascript'' src=''http://www.x3dom.org/x3dom/release/x3dom.js''></script>  \n'...
'\t </head>  \n'...
'\t <body>  \n'...
'\t\t <h1> %s </h1> \n'...
'\t\t <h1> %s </h1> \n'...
'\t\t <x3d id=''someUniqueId'' showStat=''false'' showLog=''false'' x=''0px'' y=''0px'' width=''650px'' height=''650px''>  \n'...
'\t\t\t\t <scene>  \n'...
'\t\t\t\t\t <viewpoint id=''aview'' centerOfRotation=''0 0 0'' position=''0 0 3''></viewpoint>  \n'...
'\t\t\t\t\t <transform DEF=''airway1'' rotation=''0 1 0 0''>  \n'...
'\t\t\t\t\t\t <shape>  \n'...
'\t\t\t\t\t\t\t <Appearance DEF=''App''>  \n'...
'\t\t\t\t\t\t\t\t <Material ambientIntensity=''0.0243902'' diffuseColor=''0.9 0.1 0.1'' shininess=''0.12'' specularColor=''0.94 0.72 0'' transparency=''0.1'' />  \n'...
'\t\t\t\t\t\t\t </Appearance>  \n'...
'\t\t\t\t\t\t\t <indexedFaceSet creaseAngle=''1'' solid=''false'' coordIndex=''%s''>   \n'...   
'\t\t\t\t\t\t\t <coordinate point=''%s''></coordinate>  \n'...
'\t\t\t\t\t\t\t <color color=''%s''></color> \n'...
'\t\t\t\t\t\t\t </indexedFaceSet>  \n'...
'\t\t\t\t\t\t </shape>  \n'...
'\t\t\t\t\t </transform>  \n'...
'%s \n'...
'\t\t\t\t </scene>  \n'...
'\t\t\t </x3d>  \n'...
'\t </body>  \n'...
'</html>'...
];

fprintf(file1, file_string, inps.name, inps.subheading, num2str(flist),...
    num2str(vlist), num2str(clist), rot_string);

% close the file that has been written. 
fclose(file1);

disp('Conversion to html complete')

%{
%web based libraries
'\t\t <link rel=''stylesheet'' type=''text/css'' href=''http://www.x3dom.org/x3dom/release/x3dom.css''></link>  \n'...
'\t\t <script type=''text/javascript'' src=''http://www.x3dom.org/x3dom/release/x3dom.js''></script>  \n'...
%local libraries
'\t\t <link rel=''stylesheet'' type=''text/css'' href=''media/x3dom/x3dom.css''></link> \n'...  
'\t\t <script type=''text/javascript'' src=''media/x3dom/x3dom.js''></script> \n'...
%}
