%Iliana Kogia
%Ergasia 4.1
close all;
clear all;

data = load('haberman.data');

preproc=1;
[trnData,chkData,tstData] = split_scale(data,preproc);

%%   Clustering per Class

radius = [0.2, 0.9];
for r = 1:size(radius,2)

    [c1,sig1] = subclust(trnData(trnData(:,end)== 1,:),radius(r));
    [c2,sig2] = subclust(trnData(trnData(:,end)== 2,:),radius(r));
    num_rules = size(c1,1) + size(c2,1);
    
    %Build FIS From Scratch
    fis = newfis('FIS_SC','sugeno');
    
    %% Add Input-Output Variables
    names_in={'in1','in2','in3'};
    for i=1:size(trnData,2)-1
        fis = addvar(fis,'input',names_in{i},[0 1]);
    end
    fis = addvar(fis,'output','out1',[0 1]);
    
    %% Add Input Membership Functions
    count = 0;
    for i=1:size(trnData,2)-1
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
    end
    
    %% Add Output Membership Functions
    params=[zeros(1,size(c1,1)) ones(1,size(c2,1))];
    for i=1:num_rules
        name = "MF" + i;
        fis = addmf(fis,'output',1,name,'constant',params(i)); %output constant not linear
    end
    
    %% Add FIS Rule Base
    ruleList = zeros(num_rules,size(trnData,2));
    for i=1:size(ruleList,1)
        ruleList(i,:) = i;
    end
    ruleList=[ruleList ones(num_rules,2)];
    fis=addrule(fis,ruleList);
    
    %% Train & Evaluate ANFIS
    [trnFis,trnError,~,valFis,valError] = anfis(trnData,fis,[100 0 0.01 0.9 1.1],[0,0,0,0],chkData);
    figure();
    plot([trnError valError],'LineWidth',2); grid on;
    legend('Training Error','Validation Error');
    xlabel('# of Epochs');
    ylabel('Error');
    titlos = "Class-dependent - r " + radius(r);
    title(titlos);
    %Y = evalfis(tstData(:,1:end-1),valFis);
    Y=evalfis(valFis, tstData(:,1:end-1));
    Y = round(Y);
    Y(Y<1) = 1;
    Y(Y>2) = 2;

    diff=tstData(:,end)-Y;
    %Acc=(length(diff)-nnz(diff))/length(Y)*100;

    Error_Matrix = confusionmat(tstData(:,end), Y) .' ; %transpose the true and predicted

    x11 = Error_Matrix(1,1);
    x12 = Error_Matrix(1,2);
    x21 = Error_Matrix(2,1);
    x22 = Error_Matrix(2,2);

    N = size(tstData, 1);
    OA = 100*(x11 + x22) / N ;
    
    PA_1 = 100*x11 / (x11 + x21);
    PA_2 = 100*x22 / (x12 + x22);

    UA_1 = 100*x11 / (x11 + x12);
    UA_2 = 100*x22 / (x22 + x21);
    
    k = ( N * (x11 + x22) - ((x11 + x12)*(x11 + x21) + (x12 + x22) * (x22 + x21)) ) / (N^2 - ((x11 + x12)*(x11 + x21) + (x12 + x22) * (x22 + x21)) );
    
    Perf1 = [OA;PA_1;PA_2;UA_1;UA_2;k];
    
    %% Class-Independent Scatter Partition
    
    fis = genfis2(trnData(:,1:end-1),trnData(:,end),radius(r));
    [trnFis,trnError,~,valFis,valError] = anfis(trnData,fis,[100 0 0.01 0.9 1.1],[0,0,0,0],chkData);
    figure();
    plot([trnError valError],'LineWidth',2); grid on;
    legend('Training Error','Validation Error');
    xlabel('# of Epochs');
    ylabel('Error');
    titlos = "Class-Independent - r " + radius(r);
    title(titlos);
    
    %Y=evalfis(tstData(:,1:end-1),valFis);
    Y=evalfis(valFis, tstData(:,1:end-1));
    Y=round(Y);
    Y(Y<1) = 1;
    Y(Y>2) = 2;

    diff=tstData(:,end)-Y;
    %Acc=(length(diff)-nnz(diff))/length(Y)*100;

    Error_Matrix = confusionmat(tstData(:,end), Y) .' ; %transpose the true and predicted

    x11 = Error_Matrix(1,1);
    x12 = Error_Matrix(1,2);
    x21 = Error_Matrix(2,1);
    x22 = Error_Matrix(2,2);

    N = size(tstData, 1);
    OA = 100*(x11 + x22) / N ;
    
    PA_1 = 100*x11 / (x11 + x21);
    PA_2 = 100*x22 / (x12 + x22);

    UA_1 = 100*x11 / (x11 + x12);
    UA_2 = 100*x22 / (x22 + x21);
    
    k = ( N * (x11 + x22) - ((x11 + x12)*(x11 + x21) + (x12 + x22) * (x22 + x21)) ) / (N^2 - ((x11 + x12)*(x11 + x21) + (x12 + x22) * (x22 + x21)) );
    
    Perf2 = [OA;PA_1;PA_2;UA_1;UA_2;k];

    name = "Class-dependent - r: " + radius(r);
    varnames=name;
    rownames={'OA','PA_1', 'PA_2', 'UA_1', 'UA_2', 'k'};
    Perf1=array2table(Perf1,'VariableNames',varnames,'RowNames',rownames);
    Perf1

    name = "Class-Independent - r: " + radius(r);
    varnames=name;
    rownames={'OA','PA_1', 'PA_2', 'UA_1', 'UA_2', 'k'};
    Perf2=array2table(Perf2,'VariableNames',varnames,'RowNames',rownames);
    Perf2

end
