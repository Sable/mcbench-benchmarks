function [ varargout ] = xmlData(xmlFile,xml2matTrans,varargin)
%XMLDATA reads a xml file (transformed if required) and returns the
%specified elements
%   [v1]=xmlData(xmlFile,xmlTransform,'var1') extracts
%   XML element "var1" text from a XML file "xmlFile" transformed by a 
%   XLST transform "xml2matTrans".  The evaluated text content of "var1" 
%   is output to variable v1.  "var1" is an element (after being
%   transformed): <var1>[1,0,;0,1,;]</var1>  the above function is
%   equivalent to v1=eval('[[1;0;] [0;1;] ])
%   xmlTransform may be [] if xml file does not need to be transformed
%
%   [v1,...,vn]=xmlData(xmlFile,xmlTransform,'var1',...,'varn') extracts
%   XML element "var1" thru "varn" evaluates the text content and 
%   outputs to variables v1 thru vn
%
%   [v]=xmlData(xmlFile,xmlTransform,'var1',...,'varn') extracts
%   XML element "var1" thru "varn" and stores each evaluated text content
%   in a structure field of v
%   	fieldnames(v)
%             ans = 
%                 'var1'
%                 ...
%                 'varn'
%
%   [v]=xmlData(xmlFile,xmlTransform) extracts all transformed XML 
%   elements under the root node and stores the evaluated text content 
%   	fieldnames(a)
%             ans = 
%                 'var1'
%                 ...
%                 'varn'
%   [v]=xmlData(xmlFile) extracts all XML elements under the
%   root node and stores the evaluated text content 
%   	fieldnames(v)
%             ans = 
%                 'var1'
%                 ...
%                 'varn'
%
%xml transformed into:
% <?xml version="1.0" encoding="utf-8"?>
% <constants>
%    <piSlice>[[3.14;] ]</piSlice>
%    <deg2rad>[[0.017453292519943;] ]</deg2rad>
%    <primes3x2>[[2;3;5;] [7;11;13;] ]</primes3x2>
%    <testMat2>[[{'Hello'};] [{'world'}] ]</testMat2>
% </constants>
%
%the transformed xml file or (input xml file itself if no transform
%specified) must have a root element named "constants".  The child elements
%can be any valid xml tag name.  The inner text of the child elements must 
%be a valid expression to assign to the respective variable.  
%ie var1=eval('[[3.14;] ]')
%
%Example 1: Get specific child elements of "constants"
%   [p1e p]=xmlData('sample.xml','const2mat.xsl','piSlice','primes3x2')
% p1e =
%     3.1400
% p =
% 
%      2     7
%      3    11
%      5    13
%Example 2 return all child elements of "constants" to a structure
% [a]=xmlData('sample.xml','const2mat.xsl')
% a = 
%       piSlice: 3.1400
%       deg2rad: 0.0175
%     primes3x2: [3x2 double]
%      testMat2: {'Hello'  'world'}
%
%See also xmlread xslt java

%% check inputs and outputs
outputStructure=false; %use this as a flag 
checkInputs(nargin,nargout);
%this is broken into a nested fuction to drive down complexity
%mlint('xmlData','-cyc') %check complexity
function checkInputs(nin,nout) 
    %nin=nargin of calling function
    %nout=nargout of calling function
    if nin==1
     xml2matTrans=[];
    end

    if nin>2
        %check 3rd input
        if ~iscellstr(varargin)
            error('xmlFile:IO','Inputs 3 to n must be of type char')
        end

        if nout<=1 && length(varargin)~=1
            %1 output ok also, that can be a structure 
            outputStructure=true; 
        elseif nout~=length(varargin)
            error('xmlFile:IO',['Number of outputs must equal the '...
                'number of constants to retrieve, '...
                'one output may also be used for a structure.'])
        end
    end
    
    %if 2nd arg is [] or only 1 arg is specified, use input xml file only
    if ~isempty(xml2matTrans)
        %transform data
        s=xslt(xmlFile,xml2matTrans,'-tostring');
        reader = java.io.StringReader(s);
        xmlFile = org.xml.sax.InputSource(reader);
    end
end %checkInputs


%% create the xml document to use with the DOM
xDoc=xmlread(xmlFile);

%% case of nargin==2get all the element names
if nargin==2
    %output needs to be checked again; varargout can be length 0, 1 or the
    %number of contstants in the file
    if nargout>1 && (nargout~=length(varargin))
        error('xmlFile:IO',['When not specifiying a third input the '...
            'number of outputs must equal the number of elements '...
            'retrieved or 1 (for structure)'])
    end
    varargin=getContsList;
    if length(varargin)>1
         outputStructure=true;
    end
end

%% get values
output=cell(size(varargin));
for p=1:length(varargin)
    elm=xDoc.getElementsByTagName(varargin{p});
    if elm.getLength==0
        error('xmlFile:IO','"%s is not a valid tag',varargin{p})
    end
    output{p}=eval(elm.item(0).getTextContent);
end %p loop

if outputStructure
    varargout = {cell2struct(output, varargin, 2)};
else
    varargout =output;
end


%% nested function to extract all the child element of "constants"
    function listConstants=getContsList
        %gets a cell array of the names of the constants
        allListItems = xDoc.getElementsByTagName('constants');
        for m=allListItems.item(0).getChildNodes.getLength-1:-1:0
            %remmove non element elements (whitespace)
            if allListItems.item(0).getChildNodes.item(m).getNodeType~=1
                nonElm=allListItems.item(0).getChildNodes.item(m);
                allListItems.item(0).removeChild(nonElm);
            end            
        end %m loop
        %now get all the names
        listConstants=cell(1,...
            allListItems.item(0).getChildNodes.getLength);%preallocate
        for n=0:allListItems.item(0).getChildNodes.getLength-1
            listConstants(1,n+1)=...
                allListItems.item(0).getChildNodes.item(n).getNodeName;
        end %n loop
    end %getContsList

end % xmlData

