% 设置控制点
p = [156, 31; 156, 126; 156, 226; 236, 101; 236, 161; 296, 86; 294, 181];
q = [212, 43; 156, 126; 101, 236; 236, 81; 236, 141; 296, 86; 296, 181];

alpha = 2;
control = false;
filename = "..\images\toy.jpg";
im = imread(filename, "jpg");   % 读取原始图像
im = rescale(im);

affine = Affine_deformation(im, p, q, alpha, control);          % 仿射变换
similarity = Similarity_deformation(im, p, q, alpha, control);  % 相似变换
rigid = Rigid_deformation(im, p, q, alpha, control);            % 刚体变换

affine_im = imwarp(im, affine, 'FillValues', 255);
affine_im(affine_im==255) = im(affine_im==255);

similarity_im = imwarp(im, similarity, 'FillValues', 255);
similarity_im(similarity==255) = im(similarity==255);

rigid_im = imwarp(im, rigid, 'FillValues', 255);
rigid_im(rigid==255) = im(rigid==255);

subplot('Position', [0 0 0.25 1]), imshow(im), title("Original figure");
subplot('Position', [0.25 0 0.25 1]), imshow(affine_im), title("Affine deformation");
subplot('Position', [0.5 0 0.25 1]), imshow(similarity_im), title("Similarity deformation");
subplot('Position', [0.75 0 0.25 1]), imshow(rigid_im), title("Rigid deformation");
