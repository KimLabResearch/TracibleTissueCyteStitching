function  [Project] = readMosaic(NNNN)
%NNNN = 'G:\20190501_SS_SS99_OxtR_Iepd_M_p81\raw\Mosaic_20190501_SS_SS99_OxtR_Iepd_M_p81.txt';


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

for ii = 1:length(A)
    if ischar(A{ii})
    C{ii}=  strsplit(A{ii},':');
    if length(str2num(C{1,ii}{1,2})) ==1
    NumberC(ii) = str2double(C{1,ii}{1,2});
    end
    end
    
end
for ii = 1:length(C)
    if string(C{1,ii}{1,1}) == 'Sample ID'
        Project.name = C{1, ii}{1, 2};  
    end
    if string(C{1,ii}{1,1}) == 'mrows'
        Project.mrows = str2double(C{1,ii}{1,2});  
    end    
    if string(C{1,ii}{1,1}) == 'mcolumns'
        Project.mcolumns = str2double(C{1,ii}{1,2});  
    end    
    if string(C{1,ii}{1,1}) == 'channels'
        Project.channels = str2double(C{1,ii}{1,2});  
    end    
    if string(C{1,ii}{1,1}) == 'layers'
        Project.layers = str2double(C{1,ii}{1,2});  
    end    
    if string(C{1,ii}{1,1}) == 'sections'
        Project.sections = str2double(C{1,ii}{1,2});  
    end    
    if string(C{1,ii}{1,1}) == 'sectionres'
        Project.sectionres = str2double(C{1,ii}{1,2});  
    end    
    if string(C{1,ii}{1,1}) == 'rows'
        Project.rows = str2double(C{1,ii}{1,2});  
    end    
    if string(C{1,ii}{1,1}) == 'columns'
        Project.columns = str2double(C{1,ii}{1,2});  
    end    
    
    
    
    
end