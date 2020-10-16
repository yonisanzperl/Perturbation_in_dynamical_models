function selection=dialoguemos(labels)


[selection,tf] = listdlg('ListString',labels, 'SelectionMode','single');%falta hacer que el tipo cancele todo si no elige;

if tf==0
    
    error('No se seleccionó ninguna opción')
    
end


fprintf('Usted ha elegido %s',labels{selection});