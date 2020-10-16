function tseries_out=Deco2AAL(tseries)

%%
%Este codigo toma filas de tseries y las reordena  Deco-->AAL90
id_aal=linspace(1,90,90)%id de AAL visto desde AAL
id_deco=[linspace(1,89,45) fliplr(linspace(2,90,45))]%id de Deco visto desde AAL
j=0;

%Aca lo que puedo hacer es tseriesAAL(:)=tseries(iddeco);

if iscell(tseries)
    for i=1:length(tseries)
        tseries_out{i}(id_deco,:)=tseries{i}(:,:);
    end
else
    tseries_out(id_deco,:)=tseries(:,:);
end

