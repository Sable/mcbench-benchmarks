function prediction = ClassifierPredict(data,model)
% Predicting the labels of the test instances
% Input: data = test data
%        model = the trained model
%        type = type of classifier
% Output: prediction = prediction labels

javaaddpath('weka.jar');

CSVtoARFF(data,'test','test');
test_file = 'test.arff';
reader = javaObject('java.io.FileReader', test_file);
test = javaObject('weka.core.Instances', reader);
test.setClassIndex(test.numAttributes() - 1);

prediction = [];
for i = 0 : size(data,1) - 1
    p = model.classifyInstance(test.instance(i));
    prediction = [prediction; p];
end