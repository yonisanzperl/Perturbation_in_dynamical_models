function tseries_out=AAL2Deco_FC(matrix)
  
%Este codigo toma filas de tseries y las reordena  Deco-->AAL90
id_aal=linspace(1,90,90);
id_deco=[linspace(1,89,45) fliplr(linspace(2,90,45))];
j=0;

%Aca lo que puedo hacer es tseriesDeco(id_deco)=tseries(id_aal);

if iscell(matrix)
    
        for i=1:length(matrix)
            if ~isequal(matrix{1,i},[])
                tseries_out{i}(:,:)=matrix{i}(id_deco,id_deco);
            else
                tseries_out{i}=[];
            end
        end
    
else
    tseries_out(:,:)=matrix(id_deco,id_deco);
end

