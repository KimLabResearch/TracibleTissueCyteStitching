function write_stitch_file(NNN, final_map)



A{1} = '# Define the number of dimensions we are working on';
A{2} = 'dim = 2';
A{3} = '';
A{4} = '# Define the image coordinates';

for ii = 1:length(final_map.x)
    
    A{ii+4} = ['x_', num2str(final_map.sub_x(ii) ,'%d'), ...
               '_y_', num2str(final_map.sub_y(ii) ,'%d'), ...
               '.tif; ; (', num2str(final_map.x(ii) ,'%.10f'), ...
               ', ', num2str(final_map.y(ii) ,'%.10f'), ...
               ')'];
    
end

A{ii+5} = '';
A{ii+6} = -1;

fid = fopen(NNN,'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
fclose(fid);