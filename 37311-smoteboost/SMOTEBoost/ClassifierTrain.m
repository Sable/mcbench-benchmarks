function model = ClassifierTrain(data,type)
% Training the classifier that would do the sample selection

javaaddpath('weka.jar');

CSVtoARFF(data,'train','train');
train_file = 'train.arff';
reader = javaObject('java.io.FileReader', train_file);
train = javaObject('weka.core.Instances', reader);
train.setClassIndex(train.numAttributes() - 1);
% options = javaObject('java.lang.String');

switch type
    case 'svm'
        model = javaObject('weka.classifiers.functions.SMO');
        kernel = javaObject('weka.classifiers.functions.supportVector.RBFKernel');
        model.setKernel(kernel);
    case 'tree'
        model = javaObject('weka.classifiers.trees.J48');
        % options = weka.core.Utils.splitOptions('-C 0.2');
        % model.setOptions(options);
    case 'knn'
        model = javaObject('weka.classifiers.lazy.IBk');
        model.setKNN(5);
    case 'logistic'
        model = javaObject('weka.classifiers.functions.Logistic');
end

model.buildClassifier(train);