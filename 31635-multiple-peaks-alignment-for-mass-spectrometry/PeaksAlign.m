%% Function that aligns peaks from several mass spectrometry spectra.
% 
%       Usage: PeaksAlign (FileExtension, delimiterin, dMass, OutputFileName, IntensityColumn, Percentage)  
%
% This function Keeps masses and intensity from all the file with the same 
% extension in the current directory and sum them into a unique output
% files, that contains a matrix vector with samples name as rows and masses
% as columns. 
% Each mass was averaged between masses of the same m/z.
% 
% Passed Parameters:
% FileExtension = for example '*.txt' or '*.csv'. You need to type a star
% as willcard.
% delimiter = tabulation delimiter of files. For example '\t' (tab
% delimiter or ' ' space delimiter)
% dMass = delta Mass to keep as sliding window
% OutputFileName = chose a filename as output. Defaul is example.csv
% Column of Intensity = specify the column to keep as intensity in the 
% input file. Must be > % of 1.
% Percentage = trim peaks represented less than 'percentage' considering
% all peaks
% May 2011, Andrea Padoan
%

function PeaksAlign (FileExtension, delimiterin, dMass, OutputFileName, IntensityColumn, Percentage)

%Check argument passed to variable


%Default for output file
if (nargin < 4)
    fprintf ('\n%s\n', 'Output file name was not specified. It will be named [example.csv]');
    OutputFileName = 'example.csv';
    fprintf ('\n\n%s\n', 'Missing to specify column for mass intensity. It will take the 2nd column');
    IntensityColumn = 2;
end

%Default don't trim for features presence (see below)
if (nargin < 6)
    Percentage = 0;
end

%Default intensity column is the 2nd
if (IntensityColumn < 2)
    printf ('\n%s\n','Column to keeps as Intensity must be greater of 1');
    return;
end
    
%The first passed argument must be a filename    
if (~ischar(FileExtension))
    fprintf('\n%s\n', 'First passed argument at the function is not valid');
    fprintf('%s\n', 'See help');
    beep;
    return;
end

%Trim the extension
[BeforeDot, Extension] = strtok(FileExtension,'.');

%Check if there is a star in the filename
if (isempty(strfind(BeforeDot, '*')))
    warning ('Character before dot in file extention should be a * (star)');
end

%Other typeof rules
if (~ischar(delimiterin))
    fprintf('\n%s\n','Second passed argument at the function is not valid');
    fprintf('\n%s\n','See help');
    beep;
    return;
end

if (~isnumeric(dMass))
    fprintf('\n%s\n','Third passed argument at the function is not valid');
    fprintf('\n%s\n','See help ');
    beep;
end;

if (~ischar(OutputFileName))
    fprintf('\n%s\n','Fourth passed argument at the function is not valid');
    fprintf('\n%s\n','See help');
    beep;
    return;
end

%Check if the default output file exist
if (nargin < 4)
    fid = fopen ('example.csv', 'r') ;

    if (fid ~= -1)
         warning('The current directory already contains the file example.csv.');
         fclose(fid);
         beep;
    end
end

fprintf('\n\n');
%% Find files and add spectra to the function

%Dirlist with the extension you gave
dirlist =dir(FileExtension);

%Count the number of files in the current directory
NumberOfFiles=size(dirlist, 1);

%Show you the number
fprintf('%s %d %s\n', 'Found ', NumberOfFiles, ' file(s) in the current directory'); 

%Show you files name
fprintf('%s\n','Files found in the current working directory :');
fprintf('%s \n', dirlist.name);

%Initialize variables
MassMarkerArray = 0;
MassMarkerMatrix = 0;
Spectra = 0;
MWMassesArray = 0;
IntensityArray = 0;

%Defining structure for spectra.
%Each Spectra(n) contains information of Spectra n. n is the number of list
%directory entry for file
Spectra = struct ('SpectrumName', {}, 'MW', {}, 'MWAdj', {}, 'Intensity', {});

%Create MassMarkerArray e PeaksIntensityArray

for Index = 1:1:NumberOfFiles
    display (['Performing Adding MassMarkerArray and PeaksIntensityArray of : ', dirlist(Index).name]);
    %Read file, delimiter set up to ' '
    %buffSpectra contain MASS and Intensity. It's a void parameter
    buffSpectra = dlmread(dirlist(Index).name, delimiterin,1,0);
    
    %Save into structure
    Spectra(Index).MW = buffSpectra (:,1);
    Spectra(Index).Intensity = buffSpectra (:,IntensityColumn);
    Spectra(Index).SpectrumName = dirlist(Index).name;
    
    %Concatenate masses with previous masses
    MWMassesArray = cat (1, MWMassesArray, buffSpectra(:,1));
    IntensityArray = cat (1, IntensityArray, buffSpectra(:,IntensityColumn));
           
end 

%Drop first point of MWMassesArray because it's 0
MWMassesArray (1) = [];
IntensityArray (1) = [];

%Sort MWMassArray in ascendent order
MWMassesArray =sort (MWMassesArray, 'ascend');




%% Find similar peaks and calculate means
% Find peaks within the sliding windows. It will find all peaks within this
% windows and store the averaged masses into MassesMean

%Initialize variables. MassesMean will contain mean of masses
MassesMean = 0;
Index = 1;

%Loop until reach end of MWMassesArray
while (Index < length (MWMassesArray))
    buffFind = find((MWMassesArray < (MWMassesArray(Index) + dMass)) & (MWMassesArray >= (MWMassesArray (Index))));
    %Calculate mean value of masses
    MassesMean (length(MassesMean)+1)= mean(MWMassesArray(buffFind));
    
    %update index    
    Index = max(buffFind) + 1;
end

%Cut the first space that is 0
MassesMean(1)=[];


%% Replace Masses in Spectra structure and replace with calculated mean
% values
% Find ipotetical peaks that could be a double charge. For example if you
% have a peak with m/z of 3000, a double charge could have m/z of 1500.
 
DoublePeaks = 0;
%Repeat n times as number of spectra
for Index = 1:1:NumberOfFiles
    
    %Copy the original Spectra MW to a surrogate called MWAdj
    %Spectra(Index).MWAdj = Spectra(Index).MW;
    %Loop n times as number of calculated means of masses
    for MassesIndex = 1:1:length(MassesMean)
        PositionIndex=find( (Spectra(Index).MW < (MassesMean(MassesIndex) + dMass)) & (Spectra(Index).MW >= (MassesMean(MassesIndex))) );
        if length(PositionIndex) > 1 
            display('Found double peaks in spectra');
            DoublePeaks = DoublePeaks + 1;
        end
        Spectra(Index).MWAdj(PositionIndex) = MassesMean(MassesIndex);
    end
end 
fprintf('%s %.0f\n','Number of double peaks found:', DoublePeaks);

%Export DoubleCharge Structure to workspace so you can visual check
assignin('base', 'Spectra', Spectra);
assignin('base', 'MassesMean', MassesMean);
%% Trimming at percentage
% Cut the selected peak if the number of sample in which this peak is
% present is low that indicated percentage.

if Percentage > 0 
    fprintf('\n%s %.1f %s\n', 'Performing Trimming at :', Percentage, ' perc');   
    CountsForMass = 0;
    NewColumn = 1;
    TotalNumberOfTrimmedPeaks = 0;
    for Column = 1:1:length(MassesMean)
        for Row = 1:1:NumberOfFiles 
            %Posizione del punto in cui è presente
            Buffer = find (Spectra(Row).MWAdj == MassesMean(Column));
            if ~isempty(Buffer)

                if length(Buffer) > 2
                    warning ('Error 1010');
                end
                CountsForMass = CountsForMass + 1;
            end
        end
        if ( CountsForMass <= (NumberOfFiles/100*Percentage) )
           TotalNumberOfTrimmedPeaks = TotalNumberOfTrimmedPeaks + 1;
           fprintf('%s %.1f %s %.3f\n', 'Find mass < ', Percentage, 'perc : ', MassesMean(Column));
        else    
           NewMassesMean(NewColumn)=MassesMean(Column);
           NewColumn = NewColumn + 1;
        end
        CountsForMass = 0;
    end
    fprintf('%s %.0f\n', 'Total Number of trimmed Peaks : ', TotalNumberOfTrimmedPeaks);
    MassesMean=NewMassesMean;
end
        
        


%% Check for Double charge
%Spectra(Index).MWAdj contains peak's MW.
%Check for double charge
DoubleChargeIndex = 1;
DoubleChargeMatrix = 0;
DoubleChargeBuffer = 0;
DoubleCharge = struct ('MWparental', {}, 'MWchild', {});


for MassesIndex = 1:1:length (MassesMean)
    DoubleChargeBuffer = find ( (MassesMean >= (MassesMean(MassesIndex)/2 - dMass/2)) & (MassesMean <= (MassesMean(MassesIndex)/2 + dMass/2)) );
    %if is not an empty matrix
    if ~isempty (DoubleChargeBuffer)
        DoubleCharge(DoubleChargeIndex).MWparental = MassesMean(MassesIndex);
        DoubleCharge(DoubleChargeIndex).MWchild = MassesMean(DoubleChargeBuffer);
        DoubleChargeIndex = DoubleChargeIndex+1;
    end
end

if DoubleChargeIndex > 1
    fprintf('\n%s %.0f\n', 'Found double charges. Total number of double charges = ', DoubleChargeIndex-1);
end
    
%Export DoubleCharge Structure to workspace so you can visual check
assignin('base', 'DoubleCharge', DoubleCharge);


%Transform Structure to Matrix.
DoubleChargeMatrix = 0;

for Column = 1:1:(DoubleChargeIndex-1)
    %For each double charge write the first row (parental charge) and 
    %second (or third, fourth ..) row as child charge.
    DoubleChargeMatrix (1,Column) = DoubleCharge(Column).MWparental;
    for Row = 1:1:length(DoubleCharge(Column).MWchild)
        %Ad other rows
        DoubleChargeMatrix (Row+1, Column) = DoubleCharge(Column).MWchild(Row);
    end
end

fprintf('\n%s\n', 'Writing double charges in the file DoubleCharge.csv in the current working directory');
%Write to file. It will use delimiter selected in the function
dlmwrite('DoubleCharge.csv', DoubleChargeMatrix, delimiterin);
    

%% Create Output Matrix
% Create the output matrix. The first colums is the SampleID
% The other columns are the m/z of the peak
% Each row represents the intensities of the peak 

%Create array of names. It's the first column of csv file

MatrixToWrite = {'SampleID'};

%Prepare first column
%Repeat n times as number of spectra
for Index = 1:1:NumberOfFiles
    %Split complete filename in name + extension
    [SampleName, Extension] = strtok(Spectra(Index).SpectrumName,'.');
    MatrixToWrite (Index+1,1) = cellstr(SampleName);
end

%%Adding first row as spectra MW Masses
for i=1:length(MassesMean)
    %Add a _ as first characted. It is useful if you want to import data
    %with spss. 
    %After _ was added, convert string to cell array
    MatrixToWrite (1,i+1) = cellstr(['_', num2str(MassesMean (i),'%.3f')]);
end

%Check if the mass is found. Set to FALSE
bCheck = false(1);
%Adding each row
for RowToAdd = 1:1:NumberOfFiles
    %for each Mass in MassesMean
    for IndexMassesMean=1:length(MassesMean)
        %Set bCheck
        bCheck = false(1);
        %Chech if it is present in almost one mass in MWAdj.
        for IndexMWAdj = 1:1:length(Spectra(RowToAdd).MWAdj)
            %If it is present add to matrix to write
            if (Spectra(RowToAdd).MWAdj(IndexMWAdj) == MassesMean(IndexMassesMean))
                MatrixToWrite (RowToAdd+1,IndexMassesMean+1) = num2cell(Spectra(RowToAdd).Intensity(IndexMWAdj));
                bCheck = true(1);
            end
        end
        %If bCheck == FALSE, the masse was not find. In this case insert a
        %0 intensity. Otherwise the array will be void.
        if (~bCheck)  
            MatrixToWrite (RowToAdd+1,IndexMassesMean+1)= num2cell(0);
        end
    end
    
end

%% Write output to file
% Write MatrixToWrite to a file.
% It is not possible to write directly to file because MatrixToWrite is a
% cell array. 


%Open file to write in txt mode.
fid=fopen(OutputFileName,'wt');

[rows,cols]=size(MatrixToWrite);

%Write each single cell to file.
for RowIndex=1:rows
    %Check each single cell until the cell before last 
    %if it is a number or a string and choose the
    %correct way to write to file.
    %Adding ; as delimiter you can correctly import data by Excel.
    for ColIndex=1:cols-1
        if ischar(MatrixToWrite{RowIndex,ColIndex})
            fprintf(fid,'%s;',MatrixToWrite{RowIndex,ColIndex});
        else
            fprintf(fid, '%.3f;', MatrixToWrite{RowIndex,ColIndex});
        end
    end
    %The last cell must contain \n = go to next line. So add it.
    if ischar(MatrixToWrite{RowIndex,cols})
        fprintf(fid,'%s\n',MatrixToWrite{RowIndex,cols});
    else
        fprintf(fid, '%.3f\n', MatrixToWrite{RowIndex,cols});
    end
end
%Close file.
fclose(fid);

%% Graph
% Create a plot with masses and log10 of intensities. A steam plot is
% overlapped and each steam indicates averaged masses.
% So you can visual check the effectiveness of the sliding windows.

StemY(1:length(MassesMean))=max(log(IntensityArray));
stem(MassesMean, StemY);
hold on
plot (MWMassesArray, log(IntensityArray), 'xr');
xlabel('m/z masses')
ylabel('log (a.i)')
title('Plot of Masses, log Intensities and Stems of Aligned Masses')
hold off

%% End of Function


end
