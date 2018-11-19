clear all;
close all;
clc;

prototipos = input('Archivo de prototipos: ', 's');
targets = input('Archivo de targets: ', 's');

separar(prototipos, targets);    

P_training = dlmread('ptraining.txt');
T_training = dlmread('ttraining.txt');

P_test = dlmread('ptest.txt');
T_test = dlmread('ttest.txt');

P_verification = dlmread('pverification.txt');
T_verification = dlmread('tverification.txt');

leerAnterior = input('1) Generar W y B\n2) Usar valores finales de la ejecución anterior \n>> ');
v1 = input('V1 [1 S1 ... Sn 1]: \n>> ');
v2 = input('V2 [1 2 3]: \n>> ');
epochMax=input('epochMax: \n>> ');
alfa=input('alfa: \n>> ');
minEtrain=input('error_epoch_validation: \n>> ');
valEpoch=input('epochVal: \n>> ');
numVal=input('numVal: \n>> ');

interval = input('Intervalo de la función [l1 l2]: \n>> ');
disp('Aprendizaje iniciado: ');
disp(datetime('now'));
aproximacion(epochMax, alfa, minEtrain, valEpoch, numVal, P_training, T_training, P_test, T_test, P_verification, T_verification,prototipos, targets, v1, v2, leerAnterior)


    

