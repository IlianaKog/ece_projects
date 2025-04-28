% Iliana Kogia
% Ergasia 3.2

close all;
clear all;

%% Load-Split
data = readmatrix("superconduct.csv");
preproc = 1;
[trnData, chkData, tstData] = split_scale(data,preproc);

%% params
num_of_features = [5 8 12 15]; %features
ra = [0.3 0.5 0.7 0.9]; % aktina

n = length(num_of_features);
m = length(ra);

%% relief algorithm - select features
[indices, weights] = relieff(trnData(:,1:end-1),trnData(:,end),10);

%% Grid Search + Cross Validation

avg_RMSE = zeros(n,m);
rules = zeros(n,m);
grid_features = zeros(n,m);

for F = 1:n
    for r = 1:m

        numFeatures = num_of_features(F);
        radius = ra(r);
        cv = cvpartition(trnData(:,end),"KFold",5);

        %% 5-fold cross validation
        RMSE = zeros(5,1);
        for k = 1:cv.NumTestSets

            training_id = cv.training(k);
            testing_id = cv.test(k);

            x_trainData = trnData(training_id, indices(1:numFeatures));
            y_trainData = trnData(training_id,end); %labels

            x_valData = trnData(testing_id, indices(1:numFeatures));
            y_valData = trnData(testing_id,end); %labels

            fis = genfis2(x_trainData, y_trainData, radius); 

            epochs = 100;
            [trnFis,trnError,~,valFis,valError] = anfis([x_trainData y_trainData],fis,[epochs 0 0.01 0.9 1.1],[0,0,0,0],[x_valData y_valData]);

            Y = evalfis(valFis, x_valData);

            RMSE(k) = sqrt(mse(Y, y_valData));
        end

        rules(F,r) = size(valFis.Rules, 2);
        grid_features(F,r) = numFeatures;
        avg_RMSE(F,r) = sum(RMSE) / 5;
    end
end
count = 1;
for feature = num_of_features
    figure();
    plot( rules(count,:), avg_RMSE(count,:), '-o'); grid on;
    xlabel("rules");
    ylabel("error");
    titlos= "f: " + feature;
    title(titlos);
    count = count + 1;
end

count = 1;
for r = ra
    figure();
    plot(grid_features(:, count), avg_RMSE(:,count), '-o'); grid on;
    xlabel("num features");
    ylabel("error");
    titlos = "r = " + r;
    title(titlos);
    count = count + 1;
end

%% training best model

[min_value, min_index] = min(avg_RMSE(:));
[row, col] = ind2sub(size(avg_RMSE), min_index);
best_numFeatures = num_of_features(row);
best_radius = ra(col);

