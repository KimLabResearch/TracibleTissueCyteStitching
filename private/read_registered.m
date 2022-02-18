function ref_map = read_registered(NNNN)


fid = fopen(NNNN,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);

data_list  = 5:length(A)-1;
for ii = data_list
    if ischar(A{ii})
        C{ii}=  strsplit(A{ii},[";"; "_";".tif";"(";")";","]);
        
    end
    
end


for ii = 1:length(data_list)
    ref_map.sub_x(ii) = str2double(C{data_list(ii)}{2});
    ref_map.sub_y(ii) = str2double(C{data_list(ii)}{4});
    ref_map.x(ii) = str2double(C{data_list(ii)}{7});
    ref_map.y(ii) = str2double(C{data_list(ii)}{8});
    
end
