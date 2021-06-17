clear; close all; clc;

split = 0.9;
maxepochs = 250;
nneurons = 20;

% LOAD DATA
data = datacollect;

% TRAIN/TEST PREP
numTimeStepsTrain = floor(split*numel(data));

dataTrain = data(1:end);
dataTest = dataTrain; %data(numTimeStepsTrain+1:end);

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
[net,YPred] = predictAndUpdateState(net,XTrain(1));

numTimeStepsTest = length(data);
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
end

%[net,YPred] = predictAndUpdateState(net,XTrain);

YPred = sig*YPred + mu;

% YTest = dataTest(2:end);
% rmse = sqrt(mean((YPred-YTest).^2));

%figure
%plot(dataTrain(1:end-1))
figure
plot(data)
xlabel("Dias")
ylabel("Média móvel de mortes")
title("Média móvel de mortes por COVID")
hold on
%idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
%plot(idx,[data(numTimeStepsTrain) YPred],'.-')
plot(YPred)
% hold off
% xlabel("Month")
% ylabel("Cases")
% title("Forecast")
legend(["Observação" "Predição"])

rmse = sqrt(mean((YPred-dataTrain).^2))
mean_difference = (mean(YPred) - mean(dataTrain))/mean(dataTrain)
correlation = corrcoef(dataTrain,YPred)
covariance = cov(dataTrain,YPred)

segunda_onda = dataTrain(261:443);
segunda_ondapred = YPred(261:443);

rmse2 = sqrt(mean((segunda_ondapred-segunda_onda).^2))
mean_difference2 = (mean(segunda_ondapred) - mean(segunda_onda))/mean(segunda_onda)
correlation2 = corrcoef(segunda_onda,segunda_ondapred)
covariance2 = cov(segunda_onda,segunda_ondapred)

primeira_onda = dataTrain(1:261);
primeira_ondapred = YPred(1:261);

rmse1 = sqrt(mean((primeira_ondapred-primeira_onda).^2))
mean_difference1 = (mean(primeira_ondapred) - mean(primeira_onda))/mean(primeira_onda)
correlation1 = corrcoef(primeira_onda,primeira_ondapred)
covariance1 = cov(primeira_onda,primeira_ondapred)

save_folder = 'results\';
save_mainname = 'covidbr ';

clocktime = clock;
time_now = [num2str(clocktime(1)) '-' num2str(clocktime(2)) '-' num2str(clocktime(3)) '-' num2str(clocktime(4)) '-' num2str(clocktime(5))];
savefolderlocal = [save_folder '\' save_mainname time_now];
save_file = [savefolderlocal '\' save_mainname  time_now '.mat'];

mkdir(savefolderlocal);
save(save_file);
saveas(gcf,[savefolderlocal '\' save_mainname  time_now '.jpg']);