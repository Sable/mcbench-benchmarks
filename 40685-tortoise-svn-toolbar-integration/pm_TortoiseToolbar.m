
function pm_TortoiseToolbar( pathTortoise  )
% adds the 4 most important fcns of tortoise svn as buttons to the "current folder" toolbar

    %% DOCUMENTATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %
    %%%%%%%%%%%%%%%
    % DESCRIPTION %
    %%%%%%%%%%%%%%
    %
    %     functionality is based on 3 java-Buttons wich are added at the end of the "current
    %     folder browser"-toolbar. Their callbacks will call a dos command which invokes
    %     tortois.exe with some parameters (which you can edit for your purposes)
    %     Additional commandline parameters for tortoise can be found here:
    %     
    %     http://tortoisesvn.net/docs/nightly/TortoiseSVN_en/tsvn-automation.html
    %     
    %     For removing the buttons simply restart Matlab
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % INPUT %  MIN  0 %  MAX  1 %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %
    % 1| pathTortoise:  the path to your tortoise.exe (optional, default path implemented)
    %
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % OUTPUT %  MIN  0 %  MAX  0 %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %
    %  | No Output
    %
    %
    %%%%%%%%%%%%
    % EXAMPLES %
    %%%%%%%%%%%%
    %
    %
    %  EXAMPLE 1 ( select + F9 to execute )
    %{ 
    
    pm_TortoiseToolbar
    
    %}
    %
    %%%%%%%%
    % REF  %
    %%%%%%%%
    %
    %
    % ACKNOWLEDGE CODE:  
    %
    %
    %  -  Tortoise SVN Wrapper | Jedediah Frey | 29 May 2009 | (FEXid: 24307)
    % 
    %
    % ACKNOWLEDGE KNOW HOW:  
    %
    %  - Yair Altman (finding the toolbar, misc javaKnowHow) | http://undocumentedmatlab.com/
    %
    % SEE ALSO:
    %
    %  - findjobj , svn
    %
    % COPYRIGHT: 
    %
    %  - Constantine Devorak (2013) | constantine.devorak@gmx.net
    %
    % LICENSE: BSD ( use & change at own risk | feel free to improve )
    %
    %
    %%%%%%%%
    % META %
    %%%%%%%%
    %
    % ADVICE:
    % 
    %  - none
    %
    %
    %
    % TODO:
    %
    % - function for removing the buttons
    %
    % - arguments, for wich buttons to create
    %
    % - coloring the background of each dataentry in current folder browser, if it is not
    %   synchronous to the repository:
    %
    %  Tasks:  1 coloring specific cells
    %          2 get state of visible current-folder-browser-entrys from tortoise
    %          3 change listener for currentfolderBrowser
    %          
    %
    %      % 1. SNIPPETS:
    %
    % =========================================================================================
    %
    %         t = com.mathworks.mde.explorer.Explorer.getInstance.getTable;
    % 
    %         t.getCellRenderer( 0 , 1 ).setBackground( java.awt.Color( rand (1,1) , rand (1,1), rand (1,1) ) )
    % 
    % 
    %         % javaaddpath('ColoredFieldCellRenderer.zip');
    %         % cr = ColoredFieldCellRenderer(java.awt.Color.white);
    %         % cr.setDisabled(true);  % to bg-color the entire column
    %         % cr.setCellBgColor(  1 , 1 , java.awt.Color(1,1,0) ); 
    % 
    % 
    %         % cr = javax.swing.tree.DefaultTreeCellRenderer;
    %         cr = javax.swing.table.DefaultTableCellRenderer;
    %         % cr = com.mathworks.widgets.grouptable.GroupingTableCellRenderer(java.awt.Color.white);
    % 
    %         % cr.setBackground(java.awt.Color( 0 , 1 , 0 ))
    % 
    % 
    %         % t.getColumnModel.getColumn(0).setCellRenderer( cr )
    % 
    % 
    %         t.repaint 
    % 
    % =========================================================================================
    %
    % CHANGLOG
    %
    % - 13-03-08 - HEADREVISION 
    %
    %
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% paracheck
if nargin < 1 , pathTortoise='"C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe"'; end


% handles

    % Datatable
    cfb = com.mathworks.mde.explorer.Explorer.getInstance.getTable;

    % Toolbar ( current-path control is no longer part of current-folder browser in 2013)
    if  verLessThan('matlab', '8.0')
        
        curFolderBrowserComponents = com.mathworks.mde.explorer.Explorer.getInstance.getComponents;
        tb = curFolderBrowserComponents(1);

    else

        deM = com.mathworks.mlservices.MatlabDesktopServices.getDesktop;

            deG = deM.getMainFrame; % MLMainFrame

            tb = deG.getComponent(0).getComponent(1).getComponent(0).getComponent(0).getComponent(1).getComponent(0);
        
    end%-if
   
    

% 1 - button commit
bCommit = com.mathworks.mwswing.MJButton;
bCommit.setToolTipText('Commit to SVN');
bCommit.setPreferredSize( java.awt.Dimension( 20 , 20 ) );
bCommit.setToolTipText( [ 'Commit the selected files/folders to your repository.' 10 ...
                          ' If no files are selected, the whole directory will be commited' ] );
set( bCommit , 'ActionPerformedCallback' ,{ @callback_commit , pathTortoise , cfb });
bCommit.setIcon( createIconCommit );
tb.add(bCommit);

% 2 - button update
bUpdate = com.mathworks.mwswing.MJButton;
bUpdate.setToolTipText('Update from SVN');
bUpdate.setPreferredSize( java.awt.Dimension( 20 , 20 ) );
bUpdate.setToolTipText( [ 'Update the selected files/folders from your repository.' 10 ...
                          ' If no files are selected, the whole directory will be updated' ] );
set( bUpdate , 'ActionPerformedCallback' ,{ @callback_update , pathTortoise , cfb });
bUpdate.setIcon( createIconUpdate );
tb.add(bUpdate);


% 3 - button log
bLog = com.mathworks.mwswing.MJButton;
bLog.setToolTipText('Update from SVN');
bLog.setPreferredSize( java.awt.Dimension( 20 , 20 ) );
bLog.setToolTipText( [ 'Shows the log for the selected files/ folders.' 10 ...
                          ' If no files are selected, the whole directory will be shown in log' ] );
set( bLog , 'ActionPerformedCallback' ,{ @callback_log , pathTortoise , cfb });
bLog.setIcon( createIconLog );
tb.add(bLog);


% 3 - button del
bDel = com.mathworks.mwswing.MJButton;
bDel.setToolTipText('Update from SVN');
bDel.setPreferredSize( java.awt.Dimension( 20 , 20 ) );
bDel.setToolTipText( [ 'Shows the log for the selected files/ folders.' 10 ...
                          ' If no files are selected, the whole directory will be shown in log' ] );
set( bDel , 'ActionPerformedCallback' ,{ @callback_del , pathTortoise , cfb });
bDel.setIcon( createIconDel );
tb.add(bDel);



% COMMIT
function callback_commit( ~ , ~ , pathTortoise , cfb )

    fileList = strrep( strrep( strrep( char( cfb.getSelectedItems.toString ) ,...
                                                          '[' , '') , ']' , '' ) , ', ' , '*');

    if isempty( fileList ) % submit the current directory (no files selected)
        fileList = cd;
    end

    dos( sprintf('%s /command:%s /closeonend:2 /path:"%s"' , pathTortoise , 'commit' ,  fileList )  );





% UPDATE
function callback_update(  ~ , ~ , pathTortoise , cfb )

    fileList = strrep( strrep( strrep( char( cfb.getSelectedItems.toString ) ,...
                                                          '[' , '') , ']' , '' ) , ', ' , '*');

    if isempty( fileList ) % submit the current directory (no files selected)
        fileList = cd;
    end
  
    dos( sprintf('%s /command:%s /closeonend:0 /log /path:"%s"' , pathTortoise , 'update' ,  fileList  ));



% LOG
function callback_log(  ~ , ~ , pathTortoise , cfb )

    fileList = strrep( strrep( strrep( char( cfb.getSelectedItems.toString ) ,...
                                                          '[' , '') , ']' , '' ) , ', ' , '*');

    if isempty( fileList ) % submit the current directory (no files selected)
        fileList = cd;
    end

    dos( sprintf('%s /command:%s /closeonend:0 /path:"%s"' , pathTortoise , 'log' ,  fileList  ));

    
    
% LOG
function callback_del(  ~ , ~ , pathTortoise , cfb )

    fileList = strrep( strrep( strrep( char( cfb.getSelectedItems.toString ) ,...
                                                          '[' , '') , ']' , '' ) , ', ' , '*');

    if isempty( fileList ) % submit the current directory (no files selected)
        fileList = cd;
    end

    dos( sprintf('%s /command:%s /closeonend:1 /path:"%s"' , pathTortoise , 'remove' ,  fileList  ));

% % %     if ~strcmpi( 'Yes' , questdlg('Would you like to keep local instances of the file(s)?') )
% % %         
% % %         for curFilePath = regexp( fileList , '*' , 'split' )
% % %             
% % %             delete( curFilePath{1} )
% % %             
% % %         end
% % %         
% % %     end



% ICONS =======================================================================================

function icon = createIconCommit()



icon(:,:,1) = double( [...
  241  241  241  240  240  239  245  218  191  194  193  191  187  184  201  241
  241  241  241  240  239  248  202  217  255  247  251  249  244  241  240  191
  241  241  241  240  239  247  206  221  255  247  251  249  244  242  239  176
  241  241  241  240  238  248  199  197  238  245  248  243  234  227  227  190
  241  241  241  240  238  249  196  204  251  248  251  249  244  241  240  190
  241  241  241  240  238  249  197  205  251  248  251  249  244  241  240  191
  241  241  241  234  255   72    0    5    6    0   76  255  237  241  240  191
  241  241  236  255   50   14   65   61   52   62   23   50  255  236  240  191
    0  223  255   27   68  117  119   56    0   98  255  242  244  241  240  194
    0  237   24   79  114  127   13  116  255  243  251  249  244  241  240  194
    0   47   56  104   86    0  104  233  243  248  251  249  244  241  240  194
    0   54  108   82    0  171  226  192  236  245  248  243  234  227  227  179
    0   56   61   72    0  168  239  202  233  246  248  243  234  227  227  170
    0   47   59   72    0  161  255  212  192  199  198  197  195  192  194  241
    0   47   52   48   62    0  144  255  233  240  240  240  240  241  241  241
    0    0    0    0    0    7    0  130  255  233  240  240  240  241  241  241]/255  );


icon(:,:,2) = [...
  241  241  241  240  240  238  246  209  155  149  153  147  136  131  182  241
  241  241  241  240  238  249  193  177  209  228  248  234  221  203  176  170
  241  241  241  240  238  251  183  172  210  226  249  234  221  205  173  109
  241  241  241  240  237  253  171  127  184  229  237  215  192  160  120  124
  241  241  241  240  237  255  163  151  223  240  246  234  221  205  174  124
  241  241  241  240  237  255  165  152  223  240  246  234  221  205  174  125
  241  241  241  237  252  161  117  130  130  116  162  248  217  205  174  125
  241  241  238  251  151  134  177  192  165  169  164  143  232  202  174  125
  128  233  255  134  218  255  255  188  100  177  255  232  221  205  174  128
  128  240  134  228  255  255  168  149  223  239  246  235  221  204  174  129
  128  153  177  249  212  140  120  166  218  239  246  235  221  204  174  129
  128  179  253  208  120  215  185  124  180  228  237  216  192  160  119  102
  128  182  186  194  127  208  216  147  174  229  237  216  192  159  121  152
  128  152  182  195  129  199  255  205  161  161  162  159  153  147  165  241
  128  153  156  154  161  123  195  252  237  240  240  240  240  241  241  241
  128  128  128  128  128  131  114  188  253  236  240  240  240  241  241  241 ]/255 ;


icon(:,:,3) = [...
  241  241  241  240  240  235  255  156   46   52   54   51   45   41   88  241
  241  241  241  240  235  255  132   31   52  114  166  125   83   55   32   61
  241  241  241  240  235  255  130   32   48  107  168  125   82   56   31   38
  241  241  241  240  235  255  134   16   29   78  101   65   32   17    8   51
  241  241  241  240  235  255  130   36   82  137  162  126   83   55   31   51
  241  241  241  240  235  255  130   36   82  137  161  125   82   56   31   50
  241  241  241  234  255   72    0    5    3    0   45  142   76   56   31   50
  241  241  236  255   55    0    4    0    0    2    0   21   92   53   31   50
    0  223  255   34   12   41   39   21    0   63  175  121   83   56   31   49
    0  236   29   18   39   42    7   27   89  133  159  128   86   55   31   49
    0    0    0   33   12    0   39   66   80  133  158  131   89   55   31   49
    0    0   35   14    0  187  157   12   30   75   98   68   34   17    8   39
    0    0    0    7    0  184  174   25   27   75   98   68   35   17    9   50
    0    0    0    7    0  163  255  149   53   66   63   60   58   50   71  241
    0    0    0    0    7    0  149  255  233  240  240  240  240  241  241  241
    0    0    0    0    0    7    0  130  255  233  240  240  240  241  241  241 ]/255;


% Convert2Java
icon = javax.swing.ImageIcon( im2java( icon ) );


function icon = createIconUpdate()

icon(:,:,1) = double( [ ...
  241  241  241  241  241  241  241  199  194  194  192  189  184  199  241  241
  241  241  241  241  241  241  191  251  249  252  251  246  240  242  191  241
  241  241  241  241  241  241  197  251  249  252  251  246  240  242  176  241
  241  241  241  241  241  241  182  226  243  249  246  237  226  229  190  241
  241  241  241  241  241  241  181  240  249  252  251  246  240  242  190  241
  241  241   40   40   40   40   40   40   40   40  251  246  240  242  191  241
  241  241  241  241   50   60   60   50   50   40  251  246  240  242  191  241
  241  241  241   40   60  109   60   60   50   40  251  246  240  242  191  241
  241  241   40  109  109   60   60   60   50   40  251  246  240  242  194  241
  241   40  133  133   60   40   40   40   50   40  251  246  240  242  194  241
   40   50  133  109   40  241  186  239   40   40  251  246  240  242  194  241
   40   60  133   40  241  241  186  223  243   40  246  237  226  229  179  241
   40   60   40  241  241  241  204  223  243  249  246  237  226  229  170  241
   40   50   40  241  241  241  241  199  198  199  198  196  194  192  241  241
   40   60  241  241  241  241  241  241  241  241  241  241  241  241  241  241
  241   40  241  241  241  241  241  241  241  241  241  241  241  241  241  241 ] )/255;


icon(:,:,2) = [ ...
  241  241  241  241  241  241  241  177  149  153  149  141  129  177  241  241
  241  241  241  241  241  241  170  201  216  248  239  224  207  177  170  241
  241  241  241  241  241  241  158  203  213  248  239  224  207  177  109  241
  241  241  241  241  241  241  132  156  213  240  223  197  166  121  124  241
  241  241  241  241  241  241  129  200  233  248  239  224  207  177  124  241
  241  241  124  124  124  124  124  124  124  124  239  224  207  177  125  241
  241  241  241  241  155  186  186  155  155  124  240  224  207  177  125  241
  241  241  241  124  186  255  186  186  155  124  240  224  207  177  125  241
  241  241  124  255  255  186  186  186  155  124  240  224  207  177  128  241
  241  124  255  255  186  124  124  124  155  124  240  224  207  177  129  241
  124  155  255  255  124  241  134  198  124  124  240  224  207  177  129  241
  124  186  255  124  241  241  134  153  211  124  224  197  166  121  102  241
  124  186  124  241  241  241  176  153  211  240  224  197  166  121  152  241
  124  155  124  241  241  241  241  177  161  162  161  155  149  161  241  241
  124  186  241  241  241  241  241  241  241  241  241  241  241  241  241  241
  241  124  241  241  241  241  241  241  241  241  241  241  241  241  241  241 ]/255;



icon(:,:,3) = [ ...
  241  241  241  241  241  241  241   79   50   53   52   47   43   79  241  241
  241  241  241  241  241  241   61   44   77  161  140   90   60   31   61  241
  241  241  241  241  241  241   59   45   68  161  140   90   60   31   38  241
  241  241  241  241  241  241   61   19   53  101   77   37   20    6   51  241
  241  241  241  241  241  241   61   59  112  161  140   90   60   31   51  241
  241  241    0    0    0    0    0    0    0    0  139   89   60   31   50  241
  241  241  241  241    0    0    0    0    0    0  138   88   60   31   50  241
  241  241  241    0    0   36    0    0    0    0  136   87   60   31   50  241
  241  241    0   36   36    0    0    0    0    0  138   90   60   31   49  241
  241    0   72   72    0    0    0    0    0    0  140   94   60   31   49  241
    0    0   72   36    0  241   61   66    0    0  143   97   60   31   49  241
    0    0   72    0  241  241   61   21   52    0   79   40   20    7   39  241
    0    0    0  241  241  241   84   21   52   97   79   40   20    7   50  241
    0    0    0  241  241  241  241   79   63   63   61   58   55   63  241  241
    0    0  241  241  241  241  241  241  241  241  241  241  241  241  241  241
  241    0  241  241  241  241  241  241  241  241  241  241  241  241  241  241 ]/ 255;

% Convert2Java
icon = javax.swing.ImageIcon( im2java( icon ) );


function icon = createIconLog()

icon(:,:,1) = double( [ ...
  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241
  241  241  241  241  240  241  241  241  241  241  241  241  241  241  241  241
  241  241  241  239  250  240  240  241  241  241  241  241  241  241  241  241
  240  240  240  249  151  252  252  241  240  240  240  240  240  240  240  240
  240  240  240  168  223  255  255  237  240  241  241  241  241  241  239  240
  240  240  240  127  255  254  254  255  240  238  233  233  237  237  245  240
  240  240  240  121  255  250  249  206  240  248  255  255  252  252  213  240
  240  240  237   79  196  255  255  204  235  255  151  151  234  234  169  240
  240  240  248  173  130  180  172  255  255  253  150  150  233  233  157  240
  240  240  211  213  123  169  142  194  172  254  178  178  160  160  160  240
  240  240  110  110  113  229  211  113   44  254  126  126  130  130  159  240
  240  240   67  136  136  105  109  127   65  254  202  202  202  202  160  240
  240  240   87  127  122  107  102   99   38  255   99   99   99   99  156  240
  241  241   82   88   68   69   49   48    8  253  235  235  235  235  168  241
  241  241  117   30   31   31   30   30   20  240  240  240  240  240  244  241
  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241 ] )/255;


icon(:,:,2) = [ ...
  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241
  241  241  241  241  240  240  240  241  241  241  241  241  241  241  241  241
  241  241  241  239  249  244  249  241  241  241  241  241  241  241  241  241
  240  240  240  249  154  206  161  238  240  240  240  240  240  240  240  240
  240  240  240  168  193  244  225  248  240  241  241  241  241  241  239  240
  240  240  240  127  231  232  255  189  240  238  233  233  237  237  245  240
  240  240  240  121  179  210  228  116  240  248  255  255  252  252  213  240
  240  240  237   81  148  185  221  184  236  255  151  151  234  234  169  240
  240  240  248  168  127  123  147  255  255  253  150  150  233  233  157  240
  240  240  212  229  176  176  142  215  183  254  178  178  160  160  160  240
  240  240  107  200  255  245  228  180   78  254  126  126  130  130  159  240
  240  240   76  249  238  170  174  186   93  254  202  202  202  202  160  240
  240  240  132  178  173  152  148  140   54  255   99   99   99   99  156  240
  241  241  117  139  109  110   75   45    7  253  235  235  235  235  168  241
  241  241  115   70   71   71   29   31   20  240  240  240  240  240  244  241
  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241 ]/255;



icon(:,:,3) = [ ...
  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241
  241  241  241  241  240  239  239  241  241  241  241  241  241  241  241  241
  241  241  241  239  247  251  251  241  241  241  241  241  241  241  241  241
  240  240  240  249  161  122  127  237  240  240  240  240  240  240  240  240
  240  240  240  168  137  157  122  251  240  241  241  241  241  241  239  240
  240  240  240  127  150  166  176  167  240  238  233  233  237  237  245  240
  240  240  240  121  116  117  164    0  240  248  255  255  252  252  213  240
  240  240  237   76  123  105  122  115  233  255  151  151  234  234  171  240
  240  240  248  187  156   99   87  255  255  253  150  150  233  233  161  240
  240  240  210  158   88  198  173  142  149  254  178  178  160  160  164  240
  240  240  117    0   42  186  167    0    0  254  126  126  130  130  163  240
  240  240   49   70   62    0    0    8    6  254  202  202  202  202  164  240
  240  240    0    0    0    8    6    0    5  255   99   99   99   99  160  240
  241  241    8    0    0    0    0    0   10  253  235  235  235  235  171  241
  241  241  120   14   14   14   32   32   19  240  240  240  240  240  244  241
  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241  241 ]/ 255;

% Convert2Java
icon = javax.swing.ImageIcon( im2java( icon ) );


function icon = createIconDel()

icon(:,:,1) = double( [ ...
  241  240  240  241  240  240  241  240  240  241  240  240  241  240  240  241
  240  244  255  255  254  242  238  238  239  240  239  239  238  237  238  240
  240  252  237  207  246  255  243  237  238  240  238  239  244  243  241  240
  241  255  208  128  205  255  255  243  239  241  239  244  255  255  249  241
  240  240  238  207  151  176  255  255  238  238  245  251  255  255  251  240
  240  233  255  255  180  150  203  245  255  243  249  255  255  251  245  240
  241  240  237  241  255  207  128  205  255  255  252  255  255  244  238  241
  240  239  237  238  243  249  224  156  174  255  255  243  243  238  238  240
  240  239  237  238  243  249  224  166  156  205  244  255  241  237  238  240
  241  240  237  241  255  206  128  224  224  128  203  255  255  243  238  241
  240  233  255  255  180  150  203  252  254  207  149  177  255  255  238  238
  240  240  238  207  151  177  255  252  249  255  179  151  205  246  255  244
  241  255  208  128  205  255  255  243  236  241  255  207  128  205  255  255
  240  253  238  207  247  255  243  238  237  237  247  248  208  149  165  255
  240  243  254  255  252  241  239  238  241  240  230  251  255  185  178  253
  241  240  240  241  240  240  241  240  240  241  240  239  241  250  255  255 ] )/255;


icon(:,:,2) = [ ...
  241  240  240  241  240  240  241  240  240  241  240  240  241  240  240  241
  240  206  115   69  113  200  252  245  232  240  235  237  252  255  255  240
  240  127    0    0   16  113  209  249  243  237  246  244  211  162  175  240
  241   92    0    0    0   22  108  209  250  241  250  212  108    0   61  241
  240  202  105    0    0    1   22  104  213  255  220   97    3   20  131  240
  240  255  216   72    6    0    0   24  109  168  103   14   40  144  226  240
  241  232  255  241   72    0    0    3    2    0    0   49  181  237  241  241
  240  234  241  252  224  136    1    3    0    0   68  172  239  250  238  240
  240  234  241  252  224  137    2    0    0   11   87  175  237  245  235  239
  241  232  255  241   72    0    0    3    2    0    0   49  180  236  241  241
  240  255  216   72    6    0    0   94   89    0    0    6   48  166  242  244
  240  202  105    0    0   12   49  185  196   72   10    0    0   71  167  231
  241   92    0    0    0   49  180  229  255  241   72    0    0    0   52  180
  240  125    0    0   11  121  236  248  245  255  207  107    0    0    4   94
  240  211  132   92  129  202  241  244  229  232  255  214   92   82   78   76
  241  240  240  241  240  240  241  240  240  241  238  244  241  206  152  108 ]/255;



icon(:,:,3) = [ ...
  241  240  240  241  240  240  241  240  240  241  240  240  241  240  240  241
  240  206  115   69  113  200  252  245  232  240  235  237  252  255  255  240
  240  127    0    0   16  113  209  249  243  237  246  244  211  162  175  240
  241   92    0    0    0   22  108  209  250  241  250  212  108    0   61  241
  240  202  105    0    0    1   22  104  213  255  219   98    8   22  130  240
  240  255  216   72    6    0    0   24  109  168  106   12   26  138  228  240
  241  232  255  241   72    0    0    3    2    0    0   35  144  222  247  241
  240  234  241  252  224  136    1    3    0    0   36  134  225  248  240  240
  240  234  241  252  224  137    2    0    0   11   55  145  243  251  233  239
  241  232  255  241   72    0    0    3    2    0    0   49  180  236  241  241
  240  255  216   72    6    0    0   94   89    0    0    9   48  165  242  244
  240  202  105    0    0   12   49  185  196   72    8    0    0   72  167  231
  241   92    0    0    0   49  180  229  255  241   72    0    0    0   52  180
  240  125    0    0   11  121  236  248  245  255  207  107    0    0    4   94
  240  211  132   92  129  202  241  244  229  232  255  214   92   82   78   76
  241  240  240  241  240  240  241  240  240  241  238  244  241  206  152  108
 ]/ 255;

% Convert2Java
icon = javax.swing.ImageIcon( im2java( icon ) );


































