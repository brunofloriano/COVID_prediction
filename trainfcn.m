function net = trainfcn(XTrain,YTrain,nneurons,maxepochs)
% LSTM ARCHITECTURE
numFeatures = 1;
numResponses = 1;
numHiddenUnits = nneurons;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',maxepochs, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

% TRAIN
net = trainNetwork(XTrain,YTrain,layers,options);