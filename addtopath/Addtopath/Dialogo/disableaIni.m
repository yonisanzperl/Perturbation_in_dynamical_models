function disableaIni(h,k)

    if get(h(k),'Value')==1

        set(h(k+1),'visible','off'); 

    else 

        set(h(k+1),'visible','on');

    end

end