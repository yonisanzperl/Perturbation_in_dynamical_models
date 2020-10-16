function [val,idx]=resamplingID(long_total,TRsec,dt)

        
        t=1:dt:long_total*TRsec;
        %val=zeros(1,209);
        for i=1:long_total
            
            [~,idx]=min(abs(t-i*TRsec));
            val(i)=t(idx);
        end
               
        
end