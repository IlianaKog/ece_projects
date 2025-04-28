% Iliana Kogia
% Ergasia 3.2

close all;
clear all;

%% Load-Split
data = readmatrix("superconduct.csv");
preproc = 1;
[trnData, chkData, tstData] = split_scale(data,preproc);

%% params
numFeatures = 15; %features
radius = 0.3; % aktina

%% relief algorithm - select features
[indices, weights] = relieff(trnData(:,1:end-1),trnData(:,end),10);

%% train

x_trainData = trnData(:, indices(1:numFeatures));
y_trainData = trnData(:,end); %labels

x_valData = chkData(:, indices(1:numFeatures));
y_valData = chkData(:,end); %labels

x_tstData = tstData(:, indices(1:numFeatures));
y_tstData = tstData(:,end); %labels

fis = genfis2(x_trainData, y_trainData, radius); 

epochs = 100;
[trnFis,trnError,~,valFis,valError] = anfis([x_trainData y_trainData],fis,[epochs 0 0.01 0.9 1.1],[0,0,0,0],[x_valData y_valData]);

Y = evalfis(valFis, x_tstData);


%% METRICS
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);

R2 = Rsq(Y,tstData(:,end));
RMSE = sqrt(mse(Y,tstData(:,end)));
NMSE = 1 - R2;
NDEI = sqrt(NMSE);

Perf = [R2;RMSE;NMSE;NDEI];
%% Results Table
name = "Best Model";
varnames=name;
rownames={'R2','RMSE', 'NMSE', 'NDEI'};
Perf=array2table(Perf,'VariableNames',varnames,'RowNames',rownames);
Perf
%% MF
figure();
for j=1:6
    subplot(2,3,j);
    plotmf(valFis,'input',j);
end

%% Learning Curves
figure();
plot([trnError valError]);
legend('training error','validation error');
xlabel('Iterations');
ylabel('Error');
grid on;
titlos = "Best Model";
title(titlos);

%% Prediction Error
prediction_error = tstData(:,end) - Y;

figure();
plot(prediction_error);
grid on;
xlabel('samples');
ylabel('Prediction Error');
titlos = "Best Model";
title(titlos);



