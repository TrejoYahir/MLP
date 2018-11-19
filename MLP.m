function [w3,w2,w1,b3,b2,b1,e,a] = MLP(w3,w2,w1,b3,b2,b1,p,trainingSet,alfa,posAux,d,v2)
    %% ALGORITMO FEED FORWARD %%    
    if size(v2,2)==3
        a0=p(posAux);
        if v2(1)==1
            a1=purelin(w1*a0+b1);
            f1=1;
        elseif v2(1)==2
            a1=logsig(w1*a0+b1);
            f1=a1-a1.^2;
        elseif v2(1)==3
            a1=tansig(w1*a0+b1);
            f1=1-a1.^2;
        end        
        if v2(2)==1
            a2=purelin(w2*a1+b2);
            f2=1;
        elseif v2(2)==2
            a2=logsig(w2*a1+b2);
            f2=a2-a2.^2;
        elseif v2(2)==3
            a2=tansig(w2*a1+b2);
            f2=1-a2.^2;
        end        
        if v2(3)==1
            a3=purelin(w3*a2+b3);
            f3=1;
        elseif v2(3)==2
            a3=logsig(w3*a2+b3);
            f3=a3-a3.^2;
        elseif v2(3)==3
            a3=tansig(w3*a2+b3);
            f3=1-a3.^2;
        end        
        a=a3;
    elseif size(v2,2)==2
        a0=p(posAux);
        if v2(1)==1
            a1=purelin(w1*a0+b1);
            f1=1;
        elseif v2(1)==2
            a1=logsig(w1*a0+b1);
            f1=a1-a1.^2;
        elseif v2(1)==3
            a1=tansig(w1*a0+b1);
            f1=1-a1.^2;
        end
        if v2(2)==1
            a2=purelin(w2*a1+b2);
            f2=1;
        elseif v2(2)==2
            a2=logsig(w2*a1+b2);
            f2=a2-a2.^2;
        elseif v2(2)==3
            a2=tansig(w2*a1+b2);
            f2=1-a2.^2;
        end
        a=a2;
    end
  
    %% ALGORITMO BACKPROPAGATION %%
    
    e=trainingSet(posAux)-a;
    
    aux1=(zeros([size(a1,1)])+f1*eye(size(f1,2),size(f1,1)));
    aux1=diag(aux1(:,1));

    aux2=(zeros([size(a2,1)])+f2*eye(size(f2,2),size(f2,1)));
    aux2=diag(aux2(:,1));
    
    if size(v2,2)==3
        
        aux3=(zeros([size(a3,1)])+f3*eye(size(f3,2),size(f3,1)));
        aux3=diag(aux3(:,1));
        
        s3=-2*aux3*e;
        s2=aux2*transpose(w3)*s3;
        
    elseif size(v2,2)==2
        
        s2=-2*aux2*e;
       
    end
    
    s1=aux1*transpose(w2)*s2;

    %% NUEVOS VALORES DE W & B %%
    if d==1
        if size(v2,2)==3
            w3=w3-alfa*s3*transpose(a2);
            b3=b3-alfa*s3;
        end
        w2=w2-alfa*s2*transpose(a1);
        b2=b2-alfa*s2;
        w1=w1-alfa*s1*transpose(a0);
        b1=b1-alfa*s1;
    end
end