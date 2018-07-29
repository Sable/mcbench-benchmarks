function varargout=Whos(varargin)
%Whos (Upper case W) is  a customized version of whos (lower case w).
%
%The differences are 
%
% (1) "Whos" will compute/display memory in kilobytes whereas "whos" displays in bytes.
%
% (2) "Whos" will always display all array dimensions whereas "whos" will
%     not display array dimensions for 4th and higher dimensional arrays.
%     
%
%EXAMPLE: Given arrays
%
%  A=rand(10,20,30,40); 
%  B=rand(5,10,15,20,25,'single')*i;
%
%using "whos" displays the following:
%
%>> whos
%   Name      Size              Bytes  Class     Attributes
% 
%   A         4-D             1920000  double              
%   B         5-D             3000000  single    complex   
%
%
%whereas "Whos" will display the following
%
%>> Whos
%   Name   Size              Kilobytes     Class    Attributes
%                                                             
%   A      10x20x30x40            1875     double             
%   B      5x10x15x20x25          2930     single   complex   
%
%
%An unfortunate limitation is that Whos relies on EVALIN and so will not work
%correctly in a workspace context reached using DBUP and DBDOWN.
%I elaborate on this somewhat in this Newsgroup thread:
%
%      http://www.mathworks.com/matlabcentral/newsreader/view_thread/303357
%
%Hopefully, TMW will provide a way around this eventually.
%
%by Matt Jacobson
%  
%Copyright, Xoran Technologies, Inc. 2011
  
  
  
if nargin==0

  cmdstr='whos;';
  s=evalin('caller', cmdstr) ;

else


     in=['''' varargin{1} ''''];

     numargs=length(varargin);

     if numargs>1  
       for ii=2:numargs
         in= [in ',' '''' varargin{ii} ''''];
       end
     end

     cmdstr=['whos(' in  ');'];


     s=evalin('caller', cmdstr) ;

end

flds=fieldnames(s);
idx=strmatch('bytes',flds);
flds{idx}='kilobytes';
S=rmfield(s,'bytes');
[S.kilobytes]=deal([]);
S=orderfields(S,flds);

deepestLevel=S(1).nesting.level;
setAns=strmatch('ans',{S.name});
idx=[];
for ii=setAns(:).'
    
    if isequal(S(ii).class,'(unassigned)') && S(ii).nesting.level==deepestLevel
       idx=ii; 
    end
        
end
S(idx)=[];


N=length(S);

sizeStrings=cell(N,1);
memStrings=cell(N,1);
attributesStrings=cell(N,1);
nestFuncs=cell(1,N);
nestLevels=nan(N,1);
 lastLevel=nan;
 
blockCounts=zeros(1,N); 
blockIndex=0;

for ii=1:N

  
    sizeStrings{ii}=regexprep(num2str(S(ii).size),'\s*','x');
    
    S(ii).kilobytes=s(ii).bytes/2^10;
    if S(ii).kilobytes>=10
        
     memStrings{ii}=num2str(ceil(S(ii).kilobytes));
    else 
     memStrings{ii}=num2str(S(ii).kilobytes,'%2.3f'); 
    end
    
    str='';
    
    if S(ii).persistent,  str=[str,'persistent, ']; end   
    if S(ii).global,   str=[str,'global, ']; end
    if S(ii).sparse,   str=[str,'sparse, ']; end       
    if S(ii).complex,  str=[str,'complex, ']; end      
       
    
    idx=find(str==',',1,'last');
    str(idx:end)='';
    if isempty(str), str=' '; end
        
    attributesStrings{ii}=str;
    
    

    thisLevel=S(ii).nesting.level;
    nestLevels(ii)=thisLevel;
    
    if thisLevel~=lastLevel
        
       lastLevel=thisLevel;
       blockIndex=blockIndex+1;
       nestFuncs{ii}=S(ii).nesting.function;
       
    end
    
    blockCounts(blockIndex)=blockCounts(blockIndex)+1;
    
end

  


if ~nargout

  blockCounts=nonzeros(blockCounts);
  nestFuncs=nestFuncs( ~cellfun('isempty',nestFuncs)) ;
    nestFuncs=cellfun(@(str) ['  ---- ',str,' -'] , nestFuncs(:), 'UniformOutput',0);
    
  NameCol=char('Name',' ',S.name);
  SizeCol=char('Size',' ',sizeStrings{:});

  ClassCol=char('Class',' ',S.class);
  AttributesCol=char('Attributes',' ',attributesStrings{:});
  
  %%Right justify the memory footprints
  memStrings=cellfun(@fliplr, memStrings,'UniformOutput',0);
  MegCol=fliplr( char(fliplr('Kilobytes'),' ',memStrings{:}));
  
   
  %% set up the display table
  
  d=repmat(' ',N+2,1);
  dd=[d,d];
  ddd=[dd,d];
  
  DisplayTable=[dd,NameCol,ddd,...
                SizeCol,ddd,dd,...
                MegCol, ddd,dd,...
                ClassCol, ddd,...
                AttributesCol];
            
           
            
            
  DisplayTable=char(DisplayTable,' ');
   
  
  if length(blockCounts)>1
      
      subTable=DisplayTable(3:end-1,:);
      subTable=mat2cell(subTable,blockCounts,size(subTable,2));
      subTable=[repmat({' '},size(subTable,1),1)  , nestFuncs,subTable ];
      subTable=subTable.';
      subTable=char(subTable{:});
      
      DisplayTable=char( DisplayTable(1,:), subTable, DisplayTable(end,:) );
      
      divs=strmatch('  ----',DisplayTable);
      
      for ii=1:length(divs)
         
          jj=divs(ii);
          
          kk=find(DisplayTable(jj,:)=='-',1,'last');
          
          DisplayTable(jj,kk+1:end)='-';
      end
          
   end
      
          
  disp(DisplayTable)
            
else
    
    varargout{1}=S;

end  
  
  
 
  
  