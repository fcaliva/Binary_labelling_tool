function binary_labelling_tool()
% FRANCESCO CALIVA', 3/8/2018
% University of Lincoln (UK) fcaliva@lincoln.ac.uk
% If you use this tool, please cite our paper 
% An adaptable deep learning system for optical character verification in retail food packaging.
% De Sousa Ribeiro, F., Caliva, et al.   
% IEEE Conference on Evolving and Adaptive Intelligent Systems, (2018, May).
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION BINARY_LABELLING_TOOL()
% This function can be utilised to manually label data for binary problems.
% Instructions:
% 1) At the beginning the user is asked which folder wants to label files
% from. 
% 2) Subsequently the user is asked to define in which folder the user wants
% that the system creates a folder where files will be moved during the
% labelling process.
% 
% Command keys
% the left arrow - moves a file to class 0 folder
% the right arrow - moves a file to class 1 folder
% the down arrow - skips the file
% ESC - exits the function and skips the current file

waitfor(warndlg(sprintf('WELCOME! Before we start, here are some instructions:\n - Please select the location-folder from where you want to label images. \n')))

folder_original = uigetdir('./','Select LOCATION folder');
if folder_original == 0
    return
end
[~,location_name,~] = fileparts(folder_original);
answer = questdlg(sprintf(['Label folder: ' location_name,'\n ## Press Cancel to exit']),'Please Confirm');
if strcmp(answer,'Cancel')
    return
end
while strcmp(answer,'No')
    folder_original = uigetdir('./','Select LOCATION folder');
    if folder_original == 0
        return
    end
    
    [~,location_name,~] = fileparts(folder_original);
    answer = questdlg(sprintf(['Label files from folder: ' location_name ,'\n ## Press Cancel to exit']),'Please Confirm');
    if strcmp(answer,'Cancel')
        return
    end
end


% select location where to create the splits OK-NOT_OK
waitfor(warndlg(sprintf('Please select where you want to create a folder, where to move files while labelling. \n ###  It is not needed to create any folder, the system takes care of it!\n')))
folder_split = uigetdir('./','Select LOCATION split-folder destination');
if folder_split == 0
    return
end

[~,destination_name,~] = fileparts(folder_split);

answer = questdlg(sprintf(['Create a folder with labelled files in: ' destination_name,'\n ## Press Cancel to exit']),'Please Confirm');
if strcmp(answer,'Cancel')
    return
end
while strcmp(answer,'No')
    folder_split = uigetdir('./','Select LOCATION split-folder destination');
    if folder_split == 0
        return
    end
    [~,destination_name,~] = fileparts(folder_split);
    answer = questdlg(sprintf(['Create destination folder in: ' destination_name,'\n ## Press Cancel to exit']),'Please Confirm');
    if strcmp(answer,'Cancel')
        return
    end
end



folder_ok = fullfile(folder_split,location_name,'OK');
folder_not_ok = fullfile(folder_split,location_name,'NOT_OK');
mkdir(folder_ok);
mkdir(folder_not_ok);
button_pressed = 1;
%push ESC to stop
counter_OK = length(dir([folder_ok,'/*.jpeg']));
counter_NOT_OK = length(dir([folder_not_ok,'/*.jpeg']));
waitfor(warndlg(sprintf('Labelling commands:\n left_arrow = NOT_OK \n right_arrow = OK \n down_arrow = SKIP \n Esc = exit')))
last_name = '';

while button_pressed ~= 27
    list_files = dir([folder_original,'/*.jpeg']);
    l = length(list_files);
    if l == 0
        return
    end
    v = randperm(l,1);
    current_file = fullfile(list_files(v).folder,list_files(v).name);
    image = imread(current_file);
    
    txt1 = uicontrol('Style','text',...
        'Position',[1 1 80 20],...
        'String',sprintf('NOT_OK: %d',counter_NOT_OK));
    txt2 = uicontrol('Style','text',...
        'Position',[1 20 80 20],...
        'String',sprintf('OK: %d ',counter_OK));
    txt3 = uicontrol('Style','text',...
        'Position',[200 20 200 20],...
        'String',sprintf('Current image: %s ',list_files(v).name));
    txt4 = uicontrol('Style','text',...
        'Position',[200 1 200 20],...
        'String',sprintf('Last image: %s ',last_name));
    last_name = list_files(v).name;
    
    figure(1),cla, imshow(image)
    [~,~,button_pushed] = ginput(1);
    if ~isempty(button_pushed) && sum(button_pushed ==  [27 28 29 31]) %esc, left, right, down
        switch button_pushed
            case 28 % move to NOT_OK
                destination_file = fullfile(folder_not_ok,list_files(v).name);
                movefile(current_file,destination_file);
                counter_NOT_OK= counter_NOT_OK +1;
            case 29 % move to OK
                destination_file = fullfile(folder_ok,list_files(v).name);
                movefile(current_file,destination_file);
                counter_OK= counter_OK +1;
        end
    else
        
        while ~sum(button_pushed ==  [27 28 29 31])  %esc, left, right, down
            [~,~,button_pushed] = ginput(1);
            switch button_pushed
                case 28 % move to NOT_OK
                    destination_file = fullfile(folder_not_ok,list_files(v).name);
                    movefile(current_file,destination_file);
                    counter_NOT_OK= counter_NOT_OK +1;
                case 29 % move to OK
                    destination_file = fullfile(folder_ok,list_files(v).name);
                    movefile(current_file,destination_file);
                    counter_OK= counter_OK +1;
                    
            end
        end
    end
    button_pressed = button_pushed;
end
figure(1)
close(figure(1))
end
