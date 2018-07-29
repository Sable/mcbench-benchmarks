function root = xmlread6p1(filename)
%XMLREAD6p1 - xmlread implementation for MATLAB 6.1
%
% doc = vmt_xmlread(filename)
%
% doc is an instance of org.w3c.dom.Document
%
% The versions of xerces.jar and saxon.jar which ship with MATLAB 6.1
% must be on your classpath

% Copyright 2005-2010 The MathWorks, Inc.

jfile = java.io.File(filename);
fr = java.io.FileReader(jfile);
is = org.xml.sax.InputSource(fr);
dbf = javax.xml.parsers.DocumentBuilderFactory.newInstance;
db = dbf.newDocumentBuilder;
root = db.parse(is);

