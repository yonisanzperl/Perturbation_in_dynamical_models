function FCD=observable_FCD(tseries,twindow,tsupp,TR)

    if iscell(tseries)
        tseries=crea_tslong(tseries);
    end

    FCD=fcdbuild(tseries,twindow,tsupp,TR);

end
