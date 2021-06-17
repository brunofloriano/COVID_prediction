clear; close all; clc;

split = 0.9;
maxepochs = 250;
nneurons = 20;

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

%figure
%plot(dataTrain(1:end-1))
figure
plot(data)
xlabel("Dias")
ylabel("Média móvel de mortes")
title("Média móvel de mortes por COVID")
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
% hold off
% xlabel("Month")
% ylabel("Cases")
% title("Forecast")
legend(["Observação" "Predição"])

mean_difference = (mean(YPred) - mean(YTest))/mean(YTest)
correlation = corrcoef(YTest,YPred)
covariance = cov(YTest,YPred)

save_folder = 'results\';
save_mainname = 'covidbr ';

clocktime = clock;
time_now = [num2str(clocktime(1)) '-' num2str(clocktime(2)) '-' num2str(clocktime(3)) '-' num2str(clocktime(4)) '-' num2str(clocktime(5))];
savefolderlocal = [save_folder '\' save_mainname time_now];
save_file = [savefolderlocal '\' save_mainname  time_now '.mat'];

mkdir(savefolderlocal);
save(save_file);
saveas(gcf,[savefolderlocal '\' save_mainname  time_now '.jpg']);