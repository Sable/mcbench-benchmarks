% LOADODS: Loads data from an open document spreadsheet (ods) file into a cell
%          array
%
% SYNTAX: data = loadods(filename,options)
%
% INPUTS:
%   filename:   String representing the path and name of the ods file
%   options:    Structural variable containing optional arguments
%
% OUTPUTS:
%   data:       MxN cell array containing data from the spreadsheet
%
% OPTIONS:
%   sheet_name: Name of a specific sheet to load [defaults to the first sheet]
%   blank:      Value to store for blank spreadsheet cells [NaN]
%
% VERSION: 1.0
%

%Antonio Quarta - sgheppy88@gmal.com
%
% based on Alex Marten loadods.m function


function data = loadods(filename,opt1,opt2)
	% Set default options
            if nargin<2, sheetn = '';bchar=nan; end
            if nargin==2 
                if  ~ischar(opt1)
                    sheetn = opt1;
                    bchar=nan;
                else
                    sheetn='';
                    bchar=opt2;
                end
            end
            if nargin==3
                sheetn = opt1;
                bchar=opt2;
            end

	% Check for the existence of the ods file
	if exist(filename)~=2
		error('The file does not exist');
	end
	
	% Create a temporary directory to unzip the ods file into
	if ~mkdir(tempdir,filename)
		error('Permission error');
	end
	dir_temp = strcat(tempdir,filename);
	
	% Unzip the contents of the ods file
	unzip(filename,dir_temp);
	
	% Load the XML file containing the spreadsheet data
	try
 		XMLfile = xmlread(strcat(dir_temp,'/content.xml'));
	catch
	   error('Unable to read the spreadsheet data');
	end
	
	% Parse down to the <office:spreadsheet> node

	nodes = XMLfile.getChildNodes;
        nodes2=nodes;
        i=0;
        trovato=0;
        while (~trovato && i < nodes.getLength )
            if (nodes.item(i).getNodeName ==  'office:document-content')
                node=nodes.item(i);
                nodes = node.getChildNodes;
                i=0;
            end
            if (nodes.item(i).getNodeName ==  'office:body')
                node=nodes.item(i);
                nodes = node.getChildNodes;
                i=0;
            end
            if (nodes.item(i).getNodeName ==  'office:spreadsheet')
                node=nodes.item(i);
                nodes = node.getChildNodes;
                trovato=1;
            end
            i=i+1;
        end

	% Find the requested sheet by name or default to the first sheet
	if ~isempty(sheetn)
		numSheets = nodes.getLength;
		for count = 1:numSheets
			sheet = nodes.item(count-1);
			if strcmp(get_attribute(sheet,'table:name'),sheetn)
				break
			end
		end
	else
            i=0;
            trovato=0;
            while (~trovato && i < nodes.getLength)
                if( nodes.item(i).getNodeName == 'table:table') 
                    sheet = nodes.item(i);

                trovato=1;
               end
               i=i+1;
            end
	end

	% Get the begin of rows
 	nodes = sheet.getChildNodes;
	num_nodes = nodes.getLength;
	num_cols = 0;
	        for count = 1:num_nodes
		node = nodes.item(count-1);
            	if strcmp(char(node.getNodeName),'table:table-row')
                    count = count-2;
			break
		end
	end

	% Get the number of rows
	num_rows = num_nodes-count-1;
	
	% Initialize memory for the data
	data = cell(1,1);

	% Extract the data for the sheet
        rn=0;
        numrep=0;
	for row_num = 1:num_rows
            if ( ~strcmp(nodes.item(count+row_num).getNodeName,'#text') ...
                 && exist_validvalue( nodes.item(count+row_num)) )
                rn=rn+1;
                row = nodes.item(count+row_num);
                cols = row.getChildNodes;
                col_num = 0;
                num_items = cols.getLength-1;

                for item_num = 0:num_items
                    if ( ~strcmp(cols.item(item_num).getNodeName,'#text') ...
                         && exist_attribute(cols.item(item_num), ...
                                            'office:value') )
                        col = cols.item(item_num);
                        if (exist_attribute(col, ...
                                            'table:number-columns-repeated'))
                            numrep = str2num(get_attribute(col,['table:' ...
                                                'number-columns-repeated']));
                        end
                        value_type = get_attribute(col,'office:value-type');
                        if strcmp(value_type,'string')
                            temp = col.getChildNodes;
                            temp = temp.item(0);
                            temp = temp.getChildNodes;
                            temp = temp.item(0);
                            if any(strcmp(methods(temp),'getData'))
                                    value = char(temp.getData);
                            else
                                value = options.blank;
                            end
                        elseif strcmp(value_type,'float')
                            value = str2num(get_attribute(col,'office:value'));
                        else
                            value = bchar;
                        end
                        if numrep
                            for i=1:numrep
                            col_num = col_num+1;
                            data{rn,col_num} = value;
                            end
                            numrep=0;
                        else
                            col_num = col_num+1;
                            data{rn,col_num} = value;
                        end
                    end
                end
            end
                                                           

 end

	% Remove the temporary files
	if ~rmdir(dir_temp,'s')
		warning('Temporary files could not be removed');
	end		

end



% Returns the value of the attribute_name in node
function attribute = get_attribute(node,attribute_name)
	attribute = [];
	if node.hasAttributes
		attributes = node.getAttributes;
		num_attributes = attributes.getLength;
		for count = 1:num_attributes
			item = attributes.item(count-1);
		 	if strcmp(char(item.getName),attribute_name)
				attribute = char(item.getValue);
			end
		end
	end	
end
function attribute = exist_attribute(node,attribute_name)
    if node.hasAttributes
        attributes=node.getAttributes;
        num_attributes=attributes.getLength;
        for count = 1:num_attributes
            item= attributes.item(count-1);
            if(strcmp(char(item.getName),attribute_name))
                attribute=1;
                return ;
            end
        end
        attribute=0;
        return ;
    end
    attribute=0;
    return ;
end
% It will return 1 if row contains any cells with a valid value.
% node is valid row
function result = exist_validvalue( node )
    cols = node.getChildNodes;
    col_num = 0;
    num_items = cols.getLength-1;
    for item_num = 0:num_items
        if (  ~strcmp(cols.item(item_num).getNodeName,'#text') ...
                         && exist_attribute(cols.item(item_num), ...
                                            'office:value') )
            result = 1 ;
            return ;
        end
    end
    result = 0;
    return ;
end