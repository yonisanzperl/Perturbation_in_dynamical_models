function fct=observable_fct(tseries,twindow,tsupp,TR)

    if iscell(tseries)
        tseries=crea_tslong(tseries);
    end

    [~,fct]=fcdbuild(tseries,twindow,tsupp,TR);

end
