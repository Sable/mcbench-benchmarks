function obj = ReadVRML20(vrml_fn)
% function obj = ReadVRML20(vrml_fn)
% Read VRML2 file. In this version, the geometry information (Vertices and
% faces) are provided.
%
% @Input: 
%   vrml_fn: VRML2 file name
%
% @Output:
%   obj: with the following fields
%   obj.Vertex: 3-by-VertexNumber
%   obj.Face:   3-by-FaceNumber

% Written by
%   Chunxiao ZHANG,
%   Department of Technology
%   University of Central Lancashire 
%   31/Aug, 2006

obj = ReadVRML2_0(vrml_fn);