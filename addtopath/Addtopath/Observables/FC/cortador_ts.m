function [tseries_out,each_Tmax]=cortador_ts(tseries_in,Tmax)

    mm=1;
    
    for rr=1:size(tseries_in,2)
        
        if ~isequal(tseries_in{1,rr},[])
            Temporal_temp(1,mm)=tseries_in(1,rr);
            mm=mm+1;
        end
        
    end

    tseries_in=Temporal_temp;
    
    
    nIters=size(tseries_in,2);
    
    if Tmax==0
        for i=1:nIters
            
            tseries_out{i}=tseries_in{i};
            each_Tmax(i)=size(tseries_in{i},2);
            
        end
        
    else
        
        j=0;
        for i=1:nIters
            if size(tseries_in{i},2)>=Tmax

                j=j+1;
                tseries_out{j}(:,:)=tseries_in{i}(:,1:Tmax);
                each_Tmax(j)=Tmax;
            end
        end
    end
    
end