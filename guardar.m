%% GUARDAR ITERACION EN ARCHIVO %%

function guardar(a, archivo, modo)
    fid = fopen(archivo,modo);
    g=sprintf('%d ', a);
    g(end) = [];
    fprintf(fid,'%s\n',g);
    fclose(fid);
end