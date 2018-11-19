%% REALIZA LA INICIALIZACION DE VALORES Y EL APRENDIZAJE DE LA RED %%

function [] = aproximacion(epochMax, alfa, minEtrain, valEpoch, numVal, P_training, T_training, P_test, T_test, P_verification, T_verification, P, T, v1, v2, leerAnterior)
    P_total=dlmread(P);
    T_total=dlmread(T);
    sumErrorMenor=100;
    epoch=1;
    e=0;
    flag=0;
    
    %% GENERAR W Y B DE MANERA ALEATORIA %%
    if leerAnterior == 1
        w1=[0];
        b1=[0];
        w2=[0];
        b2=[0];
        w3=[0];
        b3=[0];
        for index = 1:size(v1,2)-1

            if size(v2,2)==2
                if index == 1
                    w1=[[-1 + (1+1)*rand(v1(2),v1(1))]];
                    w1 = round(w1,2);
                    b1=[[-1 + (1+1)*rand(v1(2),v1(1))]];
                    b1 = round(b1, 2);
                end
                if index == 2
                    w2=[[-1 + (1+1)*rand(v1(3),v1(2))]];
                    w2 = round(w2, 2);
                    b2=[[-1 + (1+1)*rand(1,1)]];
                    b2 = round(b2,1);
                end
            end

            if size(v2,2)==3
                if index == 1
                    w1=[[-1 + (1+1)*rand(v1(2),v1(1))]];
                    w1 = round(w1,2);
                    b1=[[-1 + (1+1)*rand(v1(2),v1(1))]];
                    b1 = round(b1, 2);
                end
                if index == 2
                    w2=[[-1 + (1+1)*rand(v1(3),v1(2))]];
                    w2 = round(w2,2);
                    b2=[[-1 + (1+1)*rand(v1(3),1)]];
                    b2 = round(b2,2);
                end
                if index == 3
                    w3=[[-1 + (1+1)*rand(v1(4),v1(3))]];
                    w3 = round(w3, 2);
                    b3=[[-1 + (1+1)*rand(1,1)]];
                    b3 = round(b3,2);
                end
            end
             
        end
    
    %% CONTINUAR CON LA EJECUCION ANTERIOR %%
    elseif leerAnterior == 2
        w1=dlmread('w1Last.txt');
        b1=dlmread('b1Last.txt');
        w2=dlmread('w2Last.txt');
        b2=dlmread('b2Last.txt');
        if size(v2,2)==3
            w3=dlmread('w3Last.txt');
            b3=dlmread('b3Last.txt');
        else 
            w3=[0];
            b3=[0];
        end
    end
    %% FIN DE INCIALIZACION DE VARIABLES %%

    ct = 0;
    sumError = 0;
    validationError = 0;
    auxError = 0;
    %% CICLO DE APRENDIZAJE %%
    for epoch=1:epochMax
        if mod(epoch, valEpoch)==0
            %% EPOCA DE VALIDACION %%
            validationError=0;
            for q = 1:size(P_verification,1)
                [w3n,w2n,w1n,b3n,b2n,b1n,e,a]=MLP(w3,w2,w1,b3,b2,b1,P_verification,T_verification,alfa,q,0,v2);
                w3=w3n;
                w2=w2n;
                w1=w1n;
                b3=b3n;
                b2=b2n;
                b1=b1n;
                validationError=validationError+abs(e);
            end
            sumError_save = reshape((validationError/size(P_verification,1)).',1,[]);
            if epoch/valEpoch == 1
                guardar(sumError_save, 'validationErrors.txt','w');
            else
                guardar(sumError_save, 'validationErrors.txt','a');
            end
            currentError = abs(validationError/size(P_verification,1));
            if currentError > auxError                 
                ct=ct+1;
            else
                ct=0;
            end
            auxError = currentError;
            if ct >= numVal
                disp('Condición de finalización: Early Stopping');
                fprintf('%d aumentos de error consecutivos\n', ct);
                flag=1;
                break;
            end
        else
            %% EPOCA DE APRENDIZAJE %%
            sumError=0;
            for v = 1:size(P_training,1)
                [w3,w2,w1,b3,b2,b1,e,a]=MLP(w3,w2,w1,b3,b2,b1,P_training,T_training,alfa,v,1,v2);
                w3Aux = reshape(w3.',1,[]);
                w2Aux = reshape(w2.',1,[]);
                w1Aux = reshape(w1.',1,[]);
                b3Aux = reshape(b3.',1,[]);
                b2Aux = reshape(b2.',1,[]);
                b1Aux = reshape(b1.',1,[]);
                sumError=sumError+abs(e);
            end
            if epoch == 1
                guardar(w3Aux, 'w3Text.txt','w');
                guardar(w2Aux, 'w2Text.txt','w');
                guardar(w1Aux, 'w1Text.txt','w');
                guardar(b3Aux, 'b3Text.txt','w');
                guardar(b2Aux, 'b2Text.txt','w');
                guardar(b1Aux, 'b1Text.txt','w');
            else
                guardar(w3Aux, 'w3Text.txt','a');
                guardar(w2Aux, 'w2Text.txt','a');
                guardar(w1Aux, 'w1Text.txt','a');
                guardar(b3Aux, 'b3Text.txt','a');
                guardar(b2Aux, 'b2Text.txt','a');
                guardar(b1Aux, 'b1Text.txt','a');
            end            
            sumError_save = reshape((sumError/size(P_training,1)).',1,[]);            
            if epoch == 1
                guardar(sumError_save, 'trainingErrors.txt','w');
            else
                guardar(sumError_save, 'trainingErrors.txt','a');
            end            
            if sumError < sumErrorMenor
                sumErrorMenor = sumError;
            end            
            if abs(sumError/size(P_training,1)) < minEtrain
                disp('Condición de finalización: Eepoch < error_epoch_train');
                flag=1;
                break;
            end
        end
    end
    if flag==0
        disp('Condición de finalización: Se alcanzó epochmax');
    end
    disp('EPOCH:')
    disp(epoch)

    disp('Aprendizaje finalizado: ');
    disp(datetime('now'));

    %% EPOCA FINAL DE PRUEBAS %%
    testError = 0;
    archivo = fopen('it.txt','w');
    for v = 1:size(P_test,1)
       [w3,w2,w1,b3,b2,b1,e,a]=MLP(w3,w2,w1,b3,b2,b1,P_test,T_test,alfa,v,0,v2);
       testError = testError + abs(e);
       fprintf(archivo,'%2.4f ',a);
    end
    fclose(archivo);

    %% GRAFICAR TEST-SET %%
    grafica = dlmread('it.txt');
    hold on
    title('Grafica del dataset de prueba')
    y = plot(P_total, T_total);
    y = plot(P_test, T_test,'or');
    y = plot(P_test,grafica,'xb');
    hold off
    figure


    %% GRAFICAR LOS CAMBIOS EN W Y B %%

    if size(v2,2)==3
        dlmwrite('b3Last.txt', b3);
        xlabel('Iteracion');
        ylabel('Valor');
        b3Text = dlmread('b3Text.txt');
        x = [1:size(b3Text,1)];
        size(b3Text, 1);
        t = plot(x, b3Text');
        title('Evolucion de B3');
        figure

        dlmwrite('w3Last.txt', w3);
        xlabel('Iteracion');
        ylabel('Valor');
        w3Text = dlmread('w3Text.txt');
        x = [1:size(w3Text,1)];
        size(w3Text, 1);
        t = plot(x, w3Text');
        title('Evolucion de W3');
        figure
    end
    
    dlmwrite('b2Last.txt', b2);
    xlabel('Iteracion');
    ylabel('Valor');
    b2Text = dlmread('b2Text.txt');
    x = [1:size(b2Text,1)];
    size(b2Text, 1);
    t = plot(x, b2Text');
    title('Evolucion de B2');
    figure
    
    dlmwrite('w2Last.txt', w2);
    xlabel('Iteracion');
    ylabel('Valor');
    w2Text = dlmread('w2Text.txt');
    x = [1:size(w2Text,1)];
    size(w2Text, 1);
    t = plot(x, w2Text');
    title('Evolucion de W2');
    figure

    dlmwrite('b1Last.txt', b1);
    xlabel('Iteracion');
    ylabel('Valor');
    b1Text = dlmread('b1Text.txt');
    x = [1:size(b1Text,1)];
    size(b1Text, 1);
    t = plot(x, b1Text');
    title('Evolucion de B1');
    figure

    dlmwrite('w1Last.txt', w1);    
    xlabel('Iteracion');
    ylabel('Valor');
    w1Text = dlmread('w1Text.txt');
    x = [1:size(w1Text,1)];
    size(w1Text, 1);
    t = plot(x, w1Text');
    title('Evolucion de W1');
    figure

   %% CALCULAR ERRORES FINALES %%

    etraining = abs(sumError/(size(P_training,1)));
    evalidation = abs(auxError/(size(P_test,1)));
    etest = abs(testError/(size(P_test,1)));
    fprintf('Error de entrenamiento: %f\n',etraining);
    fprintf('Error de validacion: %f\n',evalidation);
    fprintf('Error de prueba: %f\n',etest);

    %% GRAFICAR ERRORES %%
    validationErrors = dlmread('validationErrors.txt');
    trainingErrors = dlmread('trainingErrors.txt');
    hold on
    x = [1:size(validationErrors,1)].*valEpoch;
    y = [1:size(trainingErrors,1)];
    title('Error de entrenamiento y error de validacion');
    t = plot(x, validationErrors', 'o');
    r = plot(y, trainingErrors');
    hold off

