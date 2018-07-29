function xslt6p1(in,xsl,out);
%XSLT6p1 - XSLT implementation for MATLAB 6.1
%
% xslt6p1(xml_in,xsl_in,html_out)
%
% All three arguments are file names.
%
% The versions of xerces.jar and saxon.jar which ship with MATLAB 6.1
% must be on your classpath

% Copyright 2005-2010 The MathWorks, Inc.

in = i_url(in);
xsl = i_url(xsl);

tf = javax.xml.transform.TransformerFactory.newInstance;
streamstyle = javax.xml.transform.stream.StreamSource(xsl);
transformer = tf.newTransformer(streamstyle);

streamin = javax.xml.transform.stream.StreamSource(in);
streamout = javax.xml.transform.stream.StreamResult(out);

transformer.transform(streamin,streamout);


%%%%%%%%%%%%%%%%%%%
function url = i_url(filename)

filename = which(filename);
% This bit might be Windows-specific.
url = [ 'file:///' strrep(filename,'\','/') ];

