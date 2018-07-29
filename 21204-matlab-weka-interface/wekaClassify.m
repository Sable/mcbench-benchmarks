function [predictedClass, classProbs] = wekaClassify(testData,classifier)
% Return the predicted classes for the instances of testData as well as the
% normalized class distributions. Entry classProbs(i,j) represents the
% probability that example i is in class j. Classes are indexed from 0 and
% if originally nominal, the returned values represent the enumerated
% indices. Supposing the training data is called 'data', the class label
% for class j is given by data.classAttribute.value(j). 
%
% classifier    - a trained weka classifier (i.e. trained via
%                 trainWekaClassifier()).
%
% testData      - a weka java Instances object holding the test data. Use
%                 the matlab2weka() function to convert from matlab data to
%                 weka data if necessary.
%
% classProbs    - a matlab n-by-d numeric array. Each row sums to one and
%                 entry classProbs(i,j) represents the probability that 
%                 example i is in class j.
% 
% Written by Matthew Dunham

    if(~wekaPathCheck),classProbs = []; return,end
    for t=0:testData.numInstances -1  
       classProbs(t+1,:) = (classifier.distributionForInstance(testData.instance(t)))';
    end
    [prob,predictedClass] = max(classProbs,[],2);
    predictedClass = predictedClass - 1;  
end