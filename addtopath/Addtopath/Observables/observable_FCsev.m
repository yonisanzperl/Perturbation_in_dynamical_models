function [FC_cell] = observable_FCsev(tseries)

Nsuj=size(tseries,2);

for i=1:Nsuj
    FC_cell{i}=observable_FC(tseries{i});
end

end

