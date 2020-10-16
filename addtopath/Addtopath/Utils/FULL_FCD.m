function [FCD,fc_t]=FULL_FCD(tseries,twindow,tsupp,TR)

    if iscell(tseries)
        tseries=crea_tslong(tseries);
    end

    [FCD,fc_t]=fcdbuild(tseries,twindow,tsupp,TR);

end