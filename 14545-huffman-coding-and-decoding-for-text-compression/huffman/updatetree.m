function [tree ndnm]=updatetree(tree,ndnm,al)
  apr=find([tree.sym]==al);
  if isempty(apr)
      apr=find([tree.wgt]==0);
      
      tree(end+1).left=0;
      tree(end).right=0;
      tree(end).sym=al;
      tree(end).parent=apr;
      tree(end).wgt=1;
      tree(end).nn=ndnm;
      
      ndnm=ndnm-1;
      
      tree(apr).wgt=tree(apr).wgt+1;
      tree(apr).right=length(tree);
      
      tree(end+1).left=0;
      tree(end).right=0;
      tree(end).sym=0;
      tree(end).parent=apr;
      tree(end).wgt=0;
      tree(end).nn=ndnm;
      
      ndnm=ndnm-1;
      tree(apr).left=length(tree);
      
      apr=tree(apr).parent;
      if apr==0
		return;
      end
  end
      while(1)
      ndwt=tree(apr).wgt;
      ndn=tree(apr).nn;
      wt=find([tree.wgt]==ndwt);
      mx=max([tree(wt).nn]);
      idx=find([tree.nn]==mx);
      if (ndn==mx) | (tree(apr).parent==idx)
          tree(apr).wgt=tree(apr).wgt+1;
      else
          temp=tree(idx);
          tree(idx)=tree(apr);
          tree(apr)=temp;
          
          temp=idx;
          idx=apr;
          apr=temp;
          
          temp=tree(idx).nn;
          tree(idx).nn=tree(apr).nn;
          tree(apr).nn=temp;
          
          temp=tree(idx).parent;
          tree(idx).parent=tree(apr).parent;
          tree(apr).parent=temp;
          
          id=tree(apr).left;
          if id~=0
              tree(id).parent=apr;
          end
          id=tree(apr).right;
          if id~=0
              tree(id).parent=apr;
          end
          
          id=tree(idx).left;
          if id~=0
              tree(id).parent=idx;
          end
          id=tree(idx).right;
          if id~=0
              tree(id).parent=idx;
          end
          
          tree(apr).wgt=tree(apr).wgt+1;
      end  
          if tree(apr).parent==0
              break;
          end
          apr=tree(apr).parent;
    
      end
end