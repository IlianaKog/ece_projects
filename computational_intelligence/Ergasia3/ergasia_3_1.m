% Iliana Kogia
% Ergasia 3.1

close all;
clear all;

%% import data
data = load("airfoil_self_noise.dat");

%% split and preprocess
preproc = 1;
[trnData, chkData, tstData] = split_scale(data,preproc);

%% Fis with grid partition
init_fis(1) = genfis1(trnData,2,'gbellmf', 'constant');
init_fis(2) = genfis1(trnData,3,'gbellmf', 'constant');
init_fis(3) = genfis1(trnData,2,'gbellmf', 'linear');
init_fis(4) = genfis1(trnData,3,'gbellmf', 'linear');

%% select model: 1/2/3/4
ID = 4;

%% Plot MFs before training
figure();
for j=1:5
    subplot(2,3,j);
    plotmf(init_fis(ID),'input',j);
end

epochs = 100;
[trnFis,trnError,~,valFis,valError] = anfis(trnData,init_fis(ID),[epochs 0 0.01 0.9 1.1],[0,0,0,0],chkData);

%% Plot MFs after training
figure();
for j=1:5
    subplot(2,3,j);
    plotmf(valFis,'input',j);
end

%% Evaluation

Y = evalfis(valFis, tstData(:,1:end-1)); 

%% METRICS
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);

R2 = Rsq(Y,tstData(:,end));
RMSE = sqrt(mse(Y,tstData(:,end)));
NMSE = 1 - R2;
NDEI = sqrt(NMSE);

Perf = [R2;RMSE;NMSE;NDEI];
%% Results Table
name = "Model " + ID;
varnames=name;
rownames={'R2','RMSE', 'NMSE', 'NDEI'};
Perf=array2table(Perf,'VariableNames',varnames,'RowNames',rownames);
Perf

%% Learning Curves
figure();
plot([trnError valError]);
legend('training error','validation error');
xlabel('Iterations');
ylabel('Error');
grid on;
titlos = "Model " + ID;
title(titlos);

%% Prediction Error
prediction_error = tstData(:,end) - Y;

figure();
plot(prediction_error);
grid on;
xlabel('samples');
ylabel('Prediction Error');
titlos = "Model " + ID;
title(titlos);

