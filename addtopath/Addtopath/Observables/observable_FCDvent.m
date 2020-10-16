function [fc_t_cell] = observable_FCDvent(tseries,twindow,tsupp,TR)

    if iscell(tseries)
        tseries=crea_tslong(tseries);
    end

    [~,~,ts_fc_t_cell]=fcdbuild(tseries,twindow,tsupp,TR);
       
    fc_t_cell=observable_FCsev(ts_fc_t_cell);
    
end

