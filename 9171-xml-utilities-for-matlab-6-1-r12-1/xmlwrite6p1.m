function xmlwrite6p1(filename,doc)
%XMLWRITE6p1 - XMLWRITE implementation for MATLAB 6.1
%
% vmt_xmlwrite(filename,doc);
%
% doc is an instance of org.w3c.dom.Document
%
% The versions of xerces.jar and saxon.jar which ship with MATLAB 6.1
% must be on your classpath

% Copyright 2005-2010 The MathWorks, Inc.

jfile = java.io.File(filename);
result = javax.xml.transform.stream.StreamResult(jfile);

domsrc = javax.xml.transform.dom.DOMSource(doc);

tf = javax.xml.transform.TransformerFactory.newInstance;
t = tf.newTransformer;
t.setOutputProperty(javax.xml.transform.OutputKeys.METHOD,'xml');
t.setOutputProperty(javax.xml.transform.OutputKeys.INDENT,'yes');
t.transform(domsrc,result)

