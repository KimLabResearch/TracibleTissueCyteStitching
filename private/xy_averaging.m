function xy_averaging(Aberation_folder, Averaging_folder, Number_of_cores)


dir_in = Aberation_folder;
%dir_out = uigetdir('Z:\', 'output folder');
dir_ref = Averaging_folder;


ii = 0;
Folder_N = 0;
for channel = 1:3
   for z = 0:9
       ii = ii + 1;
       list{ii} = dir(strcat(dir_in, '/*', sprintf('%d',z), '_*ch', sprintf('%02d',channel)));
       folder_index.channel(ii) = channel;
       folder_index.z(ii) = z;
       Folder_N = Folder_N + length(list{ii});
   end
end
hbar = parfor_progressbar(Folder_N,'Computing average...');  %create the progress bar




parfor (ii = 1:1:length(list),Number_of_cores)
    if ~isempty(list{ii})
    template = strcat(dir_in, '\', list{ii}(1).name, '\x_', sprintf('%01d',1),'_y_', sprintf('%01d',1),'.tif');
    templateEven = uint32(imread(template));
    templateOdd = uint32(imread(template));
    listy = dir(strcat(list{ii}(1).folder, '/', list{ii}(1).name, '/*x_1_y*'));
    listx = dir(strcat(list{ii}(1).folder, '/', list{ii}(1).name, '/*y_1.*'));

    for jj = 1:length(list{ii})
        for x = 1:length(listx)
            for y = 1:length(listy)
                template = strcat(dir_in, '\', list{ii}(jj).name, '\x_', sprintf('%01d',x),'_y_', sprintf('%01d',y),'.tif');
                if mod(x,2) == 0
                    templateEven = templateEven+ uint32(imread(template));
                else
                    templateOdd = templateOdd+  uint32(imread(template));
                end
            end
        end
        hbar.iterate(1);   % update progress by one iteration
    end
    imwrite(uint16(templateEven./length(list{ii})./80),strcat(dir_ref, '\Z_', sprintf('%02d',folder_index.z(ii)),'_ch_', sprintf('%02d',folder_index.channel(ii)),'_even.tif'));
    imwrite(uint16(templateOdd./length(list{ii})./80),strcat(dir_ref, '\Z_', sprintf('%02d',folder_index.z(ii)),'_ch_', sprintf('%02d',folder_index.channel(ii)),'_odd.tif'));
    end
end
close(hbar);

