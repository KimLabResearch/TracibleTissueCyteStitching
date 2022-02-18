function tile_weight = read_weight(boosted_folder)

list_txt = dir([boosted_folder,'/*.txt']);

NNNN = [list_txt(1).folder, '/', list_txt(1).name ];

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
        C{ii}=  strsplit(A{ii},";");
        
    end
    
end


for ii = 1:length(data_list)
    tile_name{ii} = [boosted_folder, '/',C{data_list(ii)}{1}];
    tile_image{ii} = imread(tile_name{ii});
end

for ii = 1:length(data_list)
tile_weight(ii) = nnz(tile_image{ii}(:)>2500.0)./length(tile_image{ii}(:));
end



