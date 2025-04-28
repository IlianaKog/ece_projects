%Iliana Kogia
%Ergasia 4_2

close all;
clear all;

data = readmatrix('epileptic_seizure_data.csv');
data = data(:,2:end);

preproc=1;
[trnData,chkData,tstData] = split_scale(data,preproc);

%% relief algorithm - select features
[indices, weights] = relieff(trnData(:,1:end-1),trnData(:,end),10);

%% Grid Search + Cross Validation
numFeatures = 8;
radius = 0.5;

x_trainData = trnData(:, indices(1:numFeatures));
y_trainData = trnData(:,end); %labels

train_data = [x_trainData y_trainData];

x_valData = chkData(:, indices(1:numFeatures));
y_valData = chkData(:,end); %labels

val_data = [x_valData y_valData];

x_testData = tstData(:, indices(1:numFeatures));
y_testData = tstData(:,end); %labels

test_data = [x_testData y_testData];

[c1,sig1] = subclust(train_data(train_data(:,end)== 1,:),radius);
[c2,sig2] = subclust(train_data(train_data(:,end)== 2,:),radius);
[c3,sig3] = subclust(train_data(train_data(:,end)== 3,:),radius);
[c4,sig4] = subclust(train_data(train_data(:,end)== 4,:),radius);
[c5,sig5] = subclust(train_data(train_data(:,end)== 5,:),radius);
num_rules = size(c1,1) + size(c2,1)+ size(c3,1) + size(c4,1) + size(c5,1);

fis = newfis('FIS_SC','sugeno');

%% Add Input-Output Variables
names_in={};
for i=1:size(train_data,2)-1
    names_in{i} = "in" + i;
    fis = addvar(fis,'input',names_in{i},[0 1]);
end
fis = addvar(fis,'output','out1',[0 1]);

%% Add Input Membership Functions (#5)
count = 0;
for i=1:size(train_data,2)-1
    for j=1:size(c1,1)
        count = count + 1;
        name = "MF" + count;
        fis = addmf(fis,'input',i,name,'gaussmf',[sig1(i) c1(j,i)]);
    end
    for j=1:size(c2,1)
        count = count + 1;
        name = "MF" + count;
        fis = addmf(fis,'input',i,name,'gaussmf',[sig2(i) c2(j,i)]);
    end
    for j=1:size(c3,1)
        count = count + 1;
        name = "MF" + count;
        fis = addmf(fis,'input',i,name,'gaussmf',[sig3(i) c3(j,i)]);
    end
    for j=1:size(c4,1)
        count = count + 1;
        name = "MF" + count;
        fis = addmf(fis,'input',i,name,'gaussmf',[sig4(i) c4(j,i)]);
    end
    for j=1:size(c5,1)
        count = count + 1;
        name = "MF" + count;
        fis = addmf(fis,'input',i,name,'gaussmf',[sig5(i) c5(j,i)]);
    end
end

%% Add Output Membership Functions
params=[zeros(1,size(c1,1)) zeros(1,size(c2,1))+0.25 zeros(1,size(c3,1))+0.5 zeros(1,size(c4,1))+0.75 ones(1,size(c5,1))];
for i=1:num_rules
    name = "MF" + i;
    fis = addmf(fis,'output',1,name,'constant',params(i)); %output constant not linear
end

%% Add FIS Rule Base
ruleList = zeros(num_rules,size(train_data,2));
for i=1:size(ruleList,1)
    ruleList(i,:) = i;
end
ruleList=[ruleList ones(num_rules,2)];
fis=addrule(fis,ruleList);

%% Train & Evaluate ANFIS
[trnFis,trnError,~,valFis,valError] = anfis(train_data,fis,[100 0 0.01 0.9 1.1],[0,0,0,0], val_data);

Y=evalfis(valFis, test_data(:,1:end-1));
Y = round(Y);
Y(Y<1) = 1;
Y(Y>5) = 5;

diff = test_data(:,end)-Y;
OA = (length(diff)-nnz(diff))/length(Y)*100;

Perf1 = [OA;];

name = "Best Model";
varnames=name;
rownames={'OA'};
Perf1=array2table(Perf1,'VariableNames',varnames,'RowNames',rownames);
Perf1

figure();
plot([trnError valError],'LineWidth',2); grid on;
legend('Training Error','Validation Error');
xlabel('# of Epochs');
ylabel('Error');
