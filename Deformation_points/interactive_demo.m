% 交互式图像变形
alpha = 2;
control = true;

% 读取并显示原始图像
filename = "..\images\monalisa.jpg";
im = imread(filename, "jpg");
im = rescale(im);
figure(1);
imshow(im);
axis off;

p = zeros(1, 2);
q = zeros(1, 2);
i = 1;
while 1
    % 交互式选择控制点集
    if waitforbuttonpress
        break;
    end
    p(i,:) = drawpoint('Color','b','MarkerSize',3).Position;    % 控制点p_i，蓝色
    q(i,:) = drawpoint('Color','r','MarkerSize',3).Position;    % 控制点q_i，红色
    i = i + 1;
end

p(:,[1 2]) = p(:,[2 1]);
q(:,[1 2]) = q(:,[2 1]);

mode = input("Please choose the deformation method: \na-affine    s-similarity    r-rigid\n", "s");
switch mode     % 选择变换方法
    case 'a'    % 仿射变换
        trans_tensor = Affine_deformation(im, p, q, alpha, control);
    case 's'    % 相似变换
        trans_tensor = Similarity_deformation(im, p, q, alpha, control);
    case 'r'    % 刚体变换
        trans_tensor = Rigid_deformation(im, p, q, alpha, control);
    otherwise   % 输入参数不合法
        fprintf("%s", "Invalid method mode!");
end

% 显示变换后的图像
figure(2);
new_im = imwarp(im, trans_tensor, 'FillValues', 255);
new_im(new_im==255) = im(new_im==255);  % 调整图像边界处可能出现的未被覆盖的点
imshow(new_im);
axis off;
% 
% 
% affine = Affine_deformation(im, p, q, alpha, control);          % 仿射变换
% similarity = Similarity_deformation(im, p, q, alpha, control);  % 相似变换
% rigid = Rigid_deformation(im, p, q, alpha, control);            % 刚体变换
% 
% affine_im = imwarp(im, affine, 'FillValues', 255);
% affine_im(affine_im==255) = im(affine_im==255);
% 
% similarity_im = imwarp(im, similarity, 'FillValues', 255);
% similarity_im(similarity==255) = im(similarity==255);
% 
% rigid_im = imwarp(im, rigid, 'FillValues', 255);
% rigid_im(rigid==255) = im(rigid==255);
% 
% subplot('Position', [0 0 0.25 1]), imshow(im), title("Original figure");
% subplot('Position', [0.25 0 0.25 1]), imshow(affine_im), title("Affine deformation");
% subplot('Position', [0.5 0 0.25 1]), imshow(similarity_im), title("Similarity deformation");
% subplot('Position', [0.75 0 0.25 1]), imshow(rigid_im), title("Rigid deformation");
