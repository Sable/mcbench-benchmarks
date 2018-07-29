function gantt_chart_demo
% GanttChart Demo with multiple tasks alá JFreeGraph-Demo
%
% The code behind is just a demo of what is possible with JFreeChart using it in Matlab. I played a little
% with codesnippets I found on the web and the API-Documentation.
% (http://www.jfree.org/jfreechart/api/javadoc/index.html). When  you want to explore the whole functionality,
% I think it is better to buy the JFreeChart Developer Guide (http://www.jfree.org/jfreechart/devguide.html). 
%
% This function shows a single domain multiple range axis plot as an example of JFreeChart
% (http://www.jfree.org/). The Idea to this code is based on the UndocumentedMatlab-Blog of Yair Altman, who
% shows a sample Code of JFreeChart for creating a PieChart
% (http://undocumentedmatlab.com/blog/jfreechart-graphs-and-gauges/#comments) 
%
% Within the plot you can zoom by pressing the left mouse button and moving the pointer. Also you have some
% properties by right-clicking on the chart. With the slider or by mousclick in the chart you can set the
% position of the crosshair. The actual values of the crosshair are displayed in the table.  
%
% Before this demo works, you need to download JFreeChart and make matlab get to know with it. There are 2
% ways you can do this:
% 1. Add the jcommon and jfreechart jar to the dynamic matlab JavaClassPath (uncommented lines in the first
%    cell an change path to your local installation path)
% 2. Add the jcommon and jfreechart jar to the static matlab JavaClassPath (see Matlab Help, modify
%    classpath.txt on matlabroot\toolbox\local) 
%
% Finally you must donwload jcontrol from Malcom Lidierth
% (http://www.mathworks.com/matlabcentral/fileexchange/15580-using-java-swing-components-in-matlab).
% 
%
% Bugs and suggestions:
%    Please send to Sven Koerner: koerner(underline)sven(add)gmx.de
% 
% You need to download and install first:
%    http://sourceforge.net/projects/jfreechart/files/1.%20JFreeChart/1.0.13/ 
%    http://sourceforge.net/projects/jfreechart/files/1.%20JFreeChart/1.0.9/
%    http://www.mathworks.com/matlabcentral/fileexchange/15580-using-java-swing-components-in-matlab 
%
% Programmed by Sven Koerner: koerner(underline)sven(add)gmx.de
% Date: 2011/05/25 



%%  JFreeChart to matlab
%%%  Add the JavaPackages to the static javaclasspath (see Matlab Help, modify classpath.txt on
%%%  matlabroot\toolbox\local) or alternativ turn it to the dynamic path (uncomment the next and change path to jFreeeChart) 

% javaaddpath C:/Users/sk/Documents/MATLAB/jfreechart-1.0.13/lib/jcommon-1.0.16.jar
% javaaddpath C:/Users/sk/Documents/MATLAB/jfreechart-1.0.13/lib/jfreechart-1.0.13.jar


%% Start

% create_IntervalCategoryDataset 
dataset = create_IntervalCategoryDataset;

% generate chart 
chart            = org.jfree.chart.ChartFactory.createGanttChart('Gantt Chart Demo', 'Task', 'Date', dataset, true, true, false);
chart.getCategoryPlot().getDomainAxis().setMaximumCategoryLabelWidthRatio(10) 

% generate Panel
chartPanel = org.jfree.chart.ChartPanel(chart);
chartPanel.setPreferredSize(java.awt.Dimension(500, 270));
chartPanel.setVisible(true);

%% Show the GanttChart
jPanel2 = chartPanel;                                                     % create new panel
fh      = figure('Units','normalized','position',[0.1,0.1,  0.7,  0.7]);  % create new figure
jp      = jcontrol(fh, jPanel2,'Position',[0.01 0.01 0.98 0.98]);         % add the jPanel to figure




function collection = create_IntervalCategoryDataset
%% Function for IntervalCategory-Dataset Generation

% Create first TaskSeries
s1      = org.jfree.data.gantt.TaskSeries('Scheduled');

% TimePeriods
t1      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('April 1 2001'), java.util.Date('April 5 2001'));         
t2      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('April 9 2001'), java.util.Date('April 9 2001'));        
t3      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('April 10 2001'), java.util.Date('May 5 2001'));           
t4      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('May 6 2001'), java.util.Date('May 30 2001'));             
t5      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('June 2 2001'), java.util.Date('June 2 2001'));            
t6      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('June 3 2001'), java.util.Date('July 31 2001'));           
t7      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('August 1 2001'), java.util.Date('August 8 2001'));        
t8      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('August 10 2001'), java.util.Date('August 10 2001'));          
t9      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('August 12 2001'), java.util.Date('September 12 2001'));    
t10     = org.jfree.data.time.SimpleTimePeriod(java.util.Date('September 13 2001'), java.util.Date('October 31 2001'));  
t11     = org.jfree.data.time.SimpleTimePeriod(java.util.Date('November 1 2001'), java.util.Date('November 15 2001'));   
t12     = org.jfree.data.time.SimpleTimePeriod(java.util.Date('November 28 2001'), java.util.Date('November 30 2001'));  

% Add Tasks to Series
s1.add(org.jfree.data.gantt.Task('Write Proposal', t1 ));  
s1.add(org.jfree.data.gantt.Task('Obtain Proposal', t2 ));   
s1.add(org.jfree.data.gantt.Task('Requirements Analysis', t3 ));   
s1.add(org.jfree.data.gantt.Task('Design Phase', t4 ));   
s1.add(org.jfree.data.gantt.Task('Design Signoff', t5 ));   
s1.add(org.jfree.data.gantt.Task('Alpha Implementation', t6 ));
s1.add(org.jfree.data.gantt.Task('Design Review', t7 ));
s1.add(org.jfree.data.gantt.Task('Revised Design Signoff', t8 ));
s1.add(org.jfree.data.gantt.Task('Beta Implementation', t9 ));
s1.add(org.jfree.data.gantt.Task('Testing', t10 ));
s1.add(org.jfree.data.gantt.Task('Final Implementation', t11 ));
s1.add(org.jfree.data.gantt.Task('Signoff', t12 ));

% Create second TaskSeries
s2      = org.jfree.data.gantt.TaskSeries('Actual');

% TimePeriods of the second TaskSeries
t1      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('April 1 2001'), java.util.Date('April 5 2001'));          
t2      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('April 9 2001'), java.util.Date('April 9 2001'));          
t3      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('April 10 2001'), java.util.Date('May 15 2001'));           
t4      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('May 15 2001'), java.util.Date('June 17 2001'));             
t5      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('June 30 2001'), java.util.Date('June 30 2001'));            
t6      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('July 1 2001'), java.util.Date('September 12 2001'));           
t7      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('September 12 2001'), java.util.Date('September 22 2001'));        
t8      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('September 25 2001'), java.util.Date('September 27 2001'));      
t9      = org.jfree.data.time.SimpleTimePeriod(java.util.Date('September 27 2001'), java.util.Date('October 30 2001'));    
t10     = org.jfree.data.time.SimpleTimePeriod(java.util.Date('October 31 2001'), java.util.Date('November 17 2001'));  
t11     = org.jfree.data.time.SimpleTimePeriod(java.util.Date('November 18 2001'), java.util.Date('December 5 2001'));   
t12     = org.jfree.data.time.SimpleTimePeriod(java.util.Date('December 10 2001'), java.util.Date('December 11 2001'));  

% Add Tasks to second Series
s2.add(org.jfree.data.gantt.Task('Write Proposal', t1 ));  
s2.add(org.jfree.data.gantt.Task('Obtain Proposal', t2 ));   
s2.add(org.jfree.data.gantt.Task('Requirements Analysis', t3 ));   
s2.add(org.jfree.data.gantt.Task('Design Phase', t4 ));   
s2.add(org.jfree.data.gantt.Task('Design Signoff', t5 ));   
s2.add(org.jfree.data.gantt.Task('Alpha Implementation', t6 ));
s2.add(org.jfree.data.gantt.Task('Design Review', t7 ));
s2.add(org.jfree.data.gantt.Task('Revised Design Signoff', t8 ));
s2.add(org.jfree.data.gantt.Task('Beta Implementation', t9 ));
s2.add(org.jfree.data.gantt.Task('Testing', t10 ));
s2.add(org.jfree.data.gantt.Task('Final Implementation', t11 ));
s2.add(org.jfree.data.gantt.Task('Signoff', t12 ));

% SeriesCollection
collection      =  org.jfree.data.gantt.TaskSeriesCollection();
collection.add(s1);
collection.add(s2);
