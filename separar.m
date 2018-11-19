%% SEPARACION DE DATASETS %%

function separar(prototipos, targets)
    s = input('Selecciona la separación de datasets: \n1)70-15-15\n2)80-10-10\n>> ');
    P = dlmread(prototipos);
    T = dlmread(targets);
    P_size =  size(P);
    indexs = 1:P_size(1);
    indexs = indexs(randperm(length(indexs)));
    if s == 1
        P_training_size = ceil(P_size(1)*0.70);
        P_test_size = floor(P_size(1)*0.15);
        P_verification_size = floor(P_size(1)*0.15);
    elseif s == 2
        P_training_size = ceil(P_size(1)*0.80);
        P_test_size = floor(P_size(1)*0.10);
        P_verification_size = floor(P_size(1)*0.10);
    end

    %% PROTOTIPOS %% 
    P_training = P(sort(indexs(1:P_training_size)),:);
    P_test = P(sort(indexs(P_training_size+1:P_training_size+P_test_size)),:);
    P_verification = P(sort(indexs(P_training_size+P_test_size+1:P_training_size+P_test_size+P_verification_size)),:);
    dlmwrite('ptraining.txt', P_training, ',');
    dlmwrite('ptest.txt', P_test, ',');
    dlmwrite('pverification.txt', P_verification, ',');

    %% TARGETS %%
    T_training = T(sort(indexs(1:P_training_size)),:);
    T_test = T(sort(indexs(P_training_size+1:P_training_size+P_test_size)),:);
    T_verification = T(sort(indexs(P_training_size+P_test_size+1:P_training_size+P_test_size+P_verification_size)),:);
    dlmwrite('ttraining.txt', T_training, ',');
    dlmwrite('ttest.txt', T_test, ',');
    dlmwrite('tverification.txt', T_verification, ',');
end