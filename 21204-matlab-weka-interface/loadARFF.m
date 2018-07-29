function wekaOBJ = loadARFF(filename)
% Load data from a weka .arff file into a java weka Instances object for
% use by weka classes. This can be converted for use in matlab by passing
% wekaOBJ to the weka2matlab function. 
%
% Written by Matthew Dunham

    if(~wekaPathCheck),wekaOBJ = []; return,end
    import weka.core.converters.ArffLoader;
    import java.io.File;
    
    loader = ArffLoader();
    loader.setFile(File(filename));
    wekaOBJ = loader.getDataSet();
    wekaOBJ.setClassIndex(wekaOBJ.numAttributes -1);
end