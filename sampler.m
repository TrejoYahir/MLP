%% ARCHIVO PARA MUESTREAR FUNCIONES %%

intervalo = 0.04;
l1 = -2;
l2 = 2;

parch = fopen('p_generated.txt','w');
tarch = fopen('t_generated.txt','w');

i = 2;

for j=l1:intervalo:l2
    p = j;
    fprintf(parch,'%0.4f\n',p);
    
    g = 1 + sin(((i*pi)/4)*p);
    fprintf(tarch,'%0.4f\n',g);
end