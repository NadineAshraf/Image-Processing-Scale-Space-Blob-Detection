clear;
close all;
clc;
%----------------------------------------------------------------------------%
%----------------------------------Restart Timer-----------------------------%
tic
%---- Read Image ---- Convert Into grayscale ---- Into Double Data Type -----% 
Image = imread('sunflowers.jpg');
Image = rgb2gray(Image);
Image = im2double(Image);
%------------------------------Calculate Image Size--------------------------%
h = size(Image,1);
w = size(Image,2);
k=15;
TH = 0.003;
%----------------------------Downsample the image----------------------------%
%----------------------Apply LOG Filter on Each window-----------------------%
%----------------------Apply LOG Filter on Each window-----------------------%
%------------------------------UP Scale The Result---------------------------%
%----------------------Then Build The Scale Space Image----------------------%
for i = 1:k
    Downsample_Image = imresize(Image,  1/(1.18^(i-1)));
    filt_size = 2*ceil(3*2)+1;
    Filter_Size = 2^2 * fspecial('log',filt_size,2);
    Filtered_Image = imfilter(Downsample_Image, Filter_Size,'same','replicate');
    Filtered_Image = Filtered_Image.^2;
    scale_space_image(:,:,i) = imresize(Filtered_Image, [h w]);
end
%----------------------Aplly Order Filter On the convolution output----------%
for i = 1:k
    Pre_Thresholding_space(:,:,i) = ordfilt2(scale_space_image(:,:,i),9,true(3));
end
%----------------------Non Maximum Supression Step --------------------------%
%----------------------Threshold the scale Space Image ----------------------%
%-------Detrmine The value of each local feature and its position -----------%
%----------------------Threshold the scale Space Image ----------------------%
   [M, I] = max(Pre_Thresholding_space,[],3);
    M = repmat(M,1,1,k); 
    Features_Positions=  scale_space_image .* ( scale_space_image == M);
    Indices = find(Features_Positions >= TH);
    [horizontal, Vertical, ~] = ind2sub(size(Features_Positions),Indices);
    rad = zeros(size(horizontal,1),1);
%---------------------Detrmine The Value Of the Raduis-----------------------% 
    for m = 1:size(horizontal,1)
            ind = I(horizontal(m),Vertical(m));
            sigma = 2;
            sigma = sigma * 1.18^(ind-1);
            radius = sigma*sqrt(2);
            rad(m)=radius;
    end
%----------------------------------Stop Timer--------------------------------%		
toc
%------------Display red circles at the positions of the features------------%
show_all_circles(Image,Vertical,horizontal,rad);




