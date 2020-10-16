function [fc_t_av, fc_t_by_suj] =observable_FCvent_av(tseries,twindow,tsupp,TR);
% hace FC(t) con el promedio de lo sujetos en cada estado

tmp_nodo=[];
fc_t_av =[];

for i=1:size(tseries,2)

    tmp(i,:)=observable_FCDvent(tseries{i},twindow,tsupp,TR);
    fc_t_by_suj=tmp;
    for j=1:size(tmp,2)
    tmp_nodo(:,:,j,i)=tmp{i,j};
    fc_t_av{j}=mean(tmp_nodo(:,:,j,i),4);
    end
        
end
