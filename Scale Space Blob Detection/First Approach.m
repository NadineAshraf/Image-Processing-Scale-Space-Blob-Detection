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
%-----------------Assume Number of of Widows For scale space-----------------%
k=15;
%----------------------------Assume Threshold Value--------------------------%
TH = 0.003;
%--------------------------Define scale Space 3D-Matrix----------------------%
scale_space_image = zeros(size(Image,1),size(Image,2),k);
%----------------------Apply LOG Filter on Each widow------------------------%
%----------------------Aplly Order Filter On the convolution output----------%
%----------------------Then Build The Scale Space Image----------------------%
for i = 1:k
    sigma = 2;
    sigma = sigma * 1.18^(i-1);
    Filter_Size = 2*ceil(3*sigma)+1;
    LOG_FILTER = sigma^2 * fspecial('log',Filter_Size,sigma);
    Filtered_Image = imfilter(Image, LOG_FILTER,'same','replicate');
    Filtered_Image = Filtered_Image.^2;
    scale_space_image(: ,: , i) = Filtered_Image;
    Pre_Thresholding_space(:,:,i) = ordfilt2(scale_space_image(: ,: , i),25,true(5));
end
%----------------------Non Maximum Supression Step --------------------------%
%----------------------Threshold the scale Space Image ----------------------%
%-------Detrmine The value of each local feature and its position -----------%
%----------------------Threshold the scale Space Image ----------------------%
    [M  , I] = max(Pre_Thresholding_space,[],3);
    M = repmat(M,1,1,k);
    Features_Positions=  scale_space_image .* ( scale_space_image == M);
    Indices = find(Features_Positions >= TH);
    [horizontal, vertical, ~] = ind2sub(size(Features_Positions),Indices);
    rad = zeros(size(horizontal,1),1);    
%---------------------Detrmine The Value Of the Raduis-----------------------%
    for m = 1:size(horizontal,1)
            ind = I(horizontal(m),vertical(m));
            sigma = 2;
            sigma = sigma * 1.18^(ind-1);
            radius = sigma*sqrt(2);
            rad(m)=radius;
    end
%----------------------------------Stop Timer--------------------------------%	
toc 
%------------Display red circles at the positions of the features------------%
show_all_circles(Image,vertical,horizontal,rad);
 
