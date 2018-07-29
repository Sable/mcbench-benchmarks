% ________________________________________________
%  Intensity Duration and Frequency 
%  1.   With this routine you can get a plot which shows you the different curves
%       of intensity - duration - frequency of rain events, using the Gumbel distribution.
%       The curves represent a "x" frequency of occurence or a "x" return period that
%       it's expressed in terms of years.
%       This routine can use it for all the people who begin to study hidrology.
%
% 2. Inputs:
%             
%       Precipitations or Intensities values of rain.                                      
%
% 3. Outputs:
%               
%        A plot which shows the different curves of Intensity - Duration - Frequency of rain events.            
%               
% 4. Notes:
%       
%        The data must be into a Excel worksheet.    
%        This file must only have one worksheet. 
%        When you run idtplot.m, the routine asks you what kind of values you wants
%        to work, whether precipitation or intensy values of rain.
%        The worksheet must have next arrangement:
%        First column: you need to put the years in which exist data about   
%        precipitations or intensities. The years must sort ascending.   
%        2nd, 3th, ... n columns must have the values of the precipitation 
%        or intensities for "x" duration.  
%        First row must have the duration value of the rainfall.
%        The cell (1,1) will be avoid.
%        It mustn't have any cell avoid between rows and columns.
%        For example:   
     
%                   5     10     30   ....     < -- Duration value of rainfall (min)
%        1956    4.5    15     7.8          < -- Precipitation or Intensity values (mm).
%        1957    2.6    5.6    8.9                (rainfall amounts)
%           .
%           .
%           ^              
%           I               
%           I                  
%          Year                    
%                          
%          I put two *.xls files like examples, in those files you
%          can see the arrangement which rows and columns must have.       
%            
%          The equations, that I used, are in the Gumbel.Doc (in Spanish).     
%
% 5. Referents .
%       
%      SCT. (1984). Métodos hidrológicos para previsión de escurrimientos. 
%                       Subsecretaria de Infraestructura, Dirección General 
%                       de Servicios Técnicos. México. pp. 27-37.
%              
%       Author: M. en C. Gabriel Ruiz Martinez
%       This routine is provided "as is" without warranty of any kind. 
%       Please, you don't attribute it.
%       If you'll detect any mistake or bug, may you communicate me?
%       February 2006
%       v1.1.
% _______________________________________________