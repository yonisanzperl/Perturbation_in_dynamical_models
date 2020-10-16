function FCD=observable_FCDsev(tseries,twindow,tsupp,TR)


    Nsuj=size(tseries,2);

    for i=1:Nsuj
        FC_cell{i}=observable_FCD(tseries{i});
    end

end
