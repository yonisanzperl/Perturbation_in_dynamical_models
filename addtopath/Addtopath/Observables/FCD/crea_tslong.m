
function tslong  = crea_tslong(tseries)

nSubs=size(tseries,2);

tslong=tseries{1};
 
    for i = 2:nSubs
      
        ts = tseries{i}; 
        tslong=[tslong ts];
        

    end
end
