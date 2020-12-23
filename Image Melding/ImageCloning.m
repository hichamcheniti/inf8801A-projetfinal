clc;

clear options;
close all;

path(path, '.\Mexfiles'); % Contains the compiled functions for the search and vote algorithm of patches

global grad_weight; % lambda value in the paper

global max_val_B; %max brightness
global out_directory;  %directory name for saving intermediate files
resize_method = 'lanczos3'; % Interpolation Kernel for resizing

input_folder = 'Inputs/Image Cloning/'
results_folder = '.\Results\'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODIFY THIS SECTION FOR YOUR TEST IMAGES
out_directory = strcat(results_folder, 'squirrel'); %folder in which we store each iterative result
trg_file_name = strcat(input_folder, 'Squirrel_trg.png');%name of the target file
src_file_name = strcat(input_folder, 'Squirrel_src.png');%name of the source file
synth_file_mask = strcat(input_folder, 'Squirrel_synth_mask.png');%name of the mask representing the part for synthesis
src_file_mask = strcat(input_folder, 'Squirrel_src_mask.png');%name of the mask file representing the part we want to copy from the source.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist(out_directory, 'dir')
    mkdir(out_directory);
end

grad_weight = .75; %we fix a normal lambda value





[im1 im1_mask im1_src im2_src alpha_mask hole_mask src2_mask] = read_mask_ims(trg_file_name, src_file_name, src_file_mask, synth_file_mask); %reads the input image with black and white masks!

alpha_mask = make_blend_SShape(alpha_mask, 1.0);%generates the blend weight value alpha
options.parallel_iter = 2;%number of random search in Generalized PatchMatch (GPM)
options.patch_size = 10;
options.min_scale = 0.9;%minimum scale in GPM 
options.max_scale = 1.2;%maximum scale in GPM 
options.min_angle = -pi/4;%minimum rotation
options.max_angle = pi/4;%maximum rotation
options.min_relscale = 0.9;%minimum relative scale in GPM
options.max_relscale = 1.1;%maximum relative scale in GPM 
options.search_reflection = 0;

options.min_Bias = single([-10  ; -50  ;   -50;      0;0]);%minimum bias in Lab space.  The last two channels are related to gradients.  As gradients can be drived from colors, if you leave it as it's the algorithm automatically uses gain of color channels.
options.max_Bias = single([10  ; 50 ;  50;      0;0]);%maximum bias 
options.min_Gain = single([0.9  ; 0.9    ;   0.9;      1;1]);%minimum gain
options.max_Gain = single([1.5 ; 1.1   ;   1.1;    1;1]);%maximum gain

init_im = repmat(alpha_mask, [1 1 3]) .* im1_src + (1 - repmat(alpha_mask, [1 1 3])) .* im2_src; % initialiszing our result array with from a copy of the mask


options.coh_weigh = 1;%if set to 1 the algorithm gives more weight to the coherent regions.

options.normalize_weight = 1;%if set to 0 the algorithm ignores gain and bias adjustments
options.num_threads = 12;%number of threads
options.do_MinNNF = 2;%the algorithm does this number of random searches after merges previous NNF and current one.  Please refer to original PM for more details
options.is_Pixel_int = 0;
options.random_init = 0;%if it is turned to zero, GPM initializes the locations to be identity
options.window_size = 0.05 * sqrt(size(im1_src,1) *size(im1_src,2));%Specifies the local search
options.grad_weight = grad_weight;

num_pyrs = 10;%number of scaled pyramids algorithm needs for synthesis
is_log_upscale = 1; %upscale enable


start_scale = 55 / min(size(im1,1), size(im1,2));%the coasest scale

num_scales = 10;%number of scales for EM iterations
num_em = 20;%initial number of EM iterations at coarsest scale
decrease_factor = 2;%when we go to finer resolutions we reduce this number from number of EM iterations
min_scale = 4;%the minimum number of EM iterations 


%take input images into Lab space
C = makecform('srgb2lab'); % creates a color transformation structure C that defines the color space conversion specified by type.
im1 = applycform(im1, C); % applying the struct on the target image
im1_src = applycform(im1_src, C); % applying the struct on the first source image
im2_src = applycform(im2_src, C); % applying the struct on the second source  image


imG = zeros(size(im1,1),size(im1,2),5);


im1 = cat(3,im1, zeros(size(im1,1),size(im1,2),2)); 
im1_src = cat(3,im1_src, zeros(size(im1_src,1),size(im1_src,2),2));
im2_src = cat(3,im2_src, zeros(size(im2_src,1),size(im2_src,2),2));



options.vote_weight = single(ones(options.patch_size,options.patch_size));%instead of box filter in vote step you can apply other filters such as Gaussian

[trg_im,  src_Pyr, mask_Pyr, src_scales, true_src_sizes] = generate_scale_pyramid_forEM(im1, im1_mask, start_scale, num_scales,is_log_upscale); %generates all the source pyramids for every EM scale

% seting-up the mask for the target image
trg_mask = mask_Pyr{1}; 
[trg_im,trg_mask] = fix_downsampled_mask(trg_im, trg_mask); 
trg_im(:,:,1:3) = imresize(applycform(im2double(init_im), C),[size(trg_im,1),size(trg_im,2)]);%applycform(tmp_im, C);
max_val_B = max(trg_im(:));
cur_NN = [];
% performing image cloning on multiple iteration
for k = 1 : num_scales
   
    if k ~= 1
        
        trg_mask = imresize(trg_mask, true_src_sizes{k},resize_method);
        trg_im = imresize(cur_im, true_src_sizes{k},resize_method);
      
        
    end

    if k > 4
        
        opt.do_random_search = 0;
        options.do_MinNNF = 0;
    end

    opt = options;
    num_em = max(min_scale, num_em - decrease_factor);
    
    big_size =  [size(im1,1), size(im1,2)];
    [cur_im cur_NN] = do_EM_iter_twoSRC_cloning(trg_im, src_Pyr, mask_Pyr, trg_mask, src_scales, opt, num_em, k,big_size, im1, im1_mask, im1_src, im2_src, num_pyrs,alpha_mask,cur_NN,hole_mask, src2_mask);
    
 
    
end
