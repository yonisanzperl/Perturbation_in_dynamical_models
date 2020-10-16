function [ts_fc_t_cell] = obtain_TS_fct(tseries,twindow,tsupp,TR)

    if iscell(tseries)
        tseries=crea_tslong(tseries);
    end

    [~,~,ts_fc_t_cell]=fcdbuild(tseries,twindow,tsupp,TR);
       
    
end
