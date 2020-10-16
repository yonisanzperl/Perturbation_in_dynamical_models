function [FCD,fc_t]=FULL_FCD_ssim(tseries,twindow,tsupp,TR)

    if iscell(tseries)
        tseries=crea_tslong(tseries);
    end

    [FCD,fc_t]=fcdbuild_ssim(tseries,twindow,tsupp,TR);

end