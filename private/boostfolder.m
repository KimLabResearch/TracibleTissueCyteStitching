function boostfolder(Normalized_folder, Channel_and_section_used_to_stitch, Boosting_folder)


dir_in = [Normalized_folder '/Z' sprintf('%03d',Channel_and_section_used_to_stitch(2)) ...
                            '_ch' sprintf('%02d',Channel_and_section_used_to_stitch(1))  ];
dir_out = Boosting_folder;
boost = 10.0;

list = dir(strcat(dir_in, '/*.tif'));

for ii = 1:length(list)


image = strcat(dir_in, '/', list(ii).name);
imageData = imread(image);
processedData = double(imageData)  .* boost ;
imageOut = strcat(dir_out, '/', list(ii).name);
imwrite(uint16(processedData),imageOut);


    
end

