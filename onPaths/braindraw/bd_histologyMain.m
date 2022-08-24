%% ~~ Histology main ~~ %% 

%% Images info %% 
myPaths; 
myPaths; 
animal = 'JF070';
% get in 'AP' format: histology_ccf.mat with tv_slices, av_slices,
% plane_ap, plane_ml, plane_dv 
allen_atlas_path = [allenAtlasPath 'allenCCF'];
tv = readNPY([allen_atlas_path, filesep, 'template_volume_10um.npy']);
%tv = permute(tv, [2,1,3]);
av = readNPY([allen_atlas_path, filesep, 'annotation_volume_10um_by_index.npy']);
%av = permute(av, [2,1,3]);
st = loadStructureTreeJF([allen_atlas_path, filesep, 'structure_tree_safe_2017.csv']);
bregma = [540,0,570];
slice_path = [extraHDPath,animal,'/slices'];

%% Open dialog box, select images to register + template and load 
[filename,filepath]=uigetfile([brainsawPath '*.tif'],'Select autofluorescence channel imaged brain'); %select green channel
[filenameref,filepathref]=uigetfile({[allenAtlasPath '*.tif']},'Select reference'); %template.tif 
greenChannel = loadtiff([filepath, filename]);
redChannel = loadtiff([filepath, filename(1:end-11), '1_red.tif']);
allenAtlas = loadtiff([filepathref, filenameref]);
allenAtlas10um = readNPY([allenAtlasPath 'allenCCF' filesep 'template_volume_10um.npy']);
allenAtlas10um = flipud(rot90(permute(allenAtlas10um, [3,2,1])));

%% Load in images and template %% 

%% Register %% 

%% Manually check and adjust registration %% 

%% Draw probes %% 

%% Save data %%