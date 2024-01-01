function [trans_tensor] = Affine_deformation(im, p, q, alpha, control)
    % im-读入的原始图像
    % p-原始的控制点集
    % q-变换后的控制点集
    % alpha-权重指数
    % control-是否固定图像顶点，true-固定；false-不固定
    % return: trans-tensor-变换tensor，3维
    [m, n, ~] = size(im);
    if control
        % 固定图像顶点位置
        p = [p; [1 1]; [1 n]; [m, 1]; [m, n]];
        q = [q; [1 1]; [1 n]; [m, 1]; [m, n]];
    end
    t = size(p, 1);    % 控制点的数量
    w = zeros(1, t);    % 初始化权重向量
    trans_tensor = zeros(m, n, 2);  % 初始化图像迁移张量
    for a = 1:m
        for b = 1:n
            v = [a, b];
            for i = 1:t
                % 计算权重向量w
                w(i) = 1 / ( (p(i,1)-a)^2 + (p(i,2)-b)^2 )^alpha;
            end
            p_star = zeros(1, 2);
            q_star = zeros(1, 2);
            for i = 1:t
                p_star(1) = p_star(1) + w(i)*p(i, 1);
                p_star(2) = p_star(2) + w(i)*p(i, 2);
                q_star(1) = q_star(1) + w(i)*q(i, 1);
                q_star(2) = q_star(2) + w(i)*q(i, 2);
            end
            p_star = p_star/sum(w);
            q_star = q_star/sum(w);
            p_hat = p - p_star;
            q_hat = q - q_star;
            A = zeros(2, 2);
            B = zeros(2, 2);
            for i = 1:t
                A = A + p_hat(i, :)'*w(i)*p_hat(i, :);
                B = B + p_hat(i, :)'*w(i)*q_hat(i, :);
            end
            d = det(A);
            A = [A(2,2), -A(1,2); -A(2,1), A(1,1)]/d;
            M = A*B;
            new_v = (v-p_star)*M + q_star;
            if isfinite(new_v)
                % 当new_v数值合法时，对trans_tensor(a, b, :)赋值
                trans_tensor(a, b, :) = [-new_v(2)+b, -new_v(1)+a];
            end
        end
    end
end
