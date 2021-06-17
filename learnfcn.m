function rmse = learnfcn(param)

split = 0.9;
maxepochs = 250;
nneurons = param;

% LOAD DATA
data = datacollect;

% TRAIN/TEST PREP
numTimeStepsTrain = floor(split*numel(data));

dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);

% STANDARDIZE DATA
mu = mean(dataTrain);
sig = std(dataTrain);

dataTrainStandardized = (dataTrain - mu) / sig;

% TRAIN SET
XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);

% TRAIN
net = trainfcn(XTrain,YTrain,nneurons,maxepochs);

% FORECAST FUTURE
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);

net = predictAndUpdateState(net,XTrain);
[net,YPred] = predictAndUpdateState(net,YTrain(end));

numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
end

YPred = sig*YPred + mu;

YTest = dataTest(2:end);
rmse = sqrt(mean((YPred-YTest).^2));
