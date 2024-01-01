function [trans_tensor] = Rigid_deformation(im, p, q, alpha, control)
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
    trans_tensor = zeros(m, n, 2);
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
            p_orthogonal = [-p_hat(:,2), p_hat(:,1)];
            q_orthogonal = [-q_hat(:,2), q_hat(:,1)];
            
            % 计算系数mu_r
            A = .0;
            B = .0;
            for k = 1:t
                A = A + w(k)*q_hat(k,:)*p_hat(k,:)';
                B = B + w(k)*q_hat(k,:)*p_orthogonal(k,:)';
            end
            mu_r = sqrt(A^2 + B^2);
            
            M = zeros(2, 2);
            for i = 1:t
                M = M + w(i)*[p_hat(i, :); -p_orthogonal(i, :)]*[q_hat(i, :)', -q_orthogonal(i, :)'];
            end
            M = M/mu_r;
    
            new_v = (v-p_star)*M + q_star;
            if isfinite(new_v)
                % 如果new_v的值合法，对trans_tensor(a, b, :)赋值
                trans_tensor(a, b, :) = [-new_v(2)+b, -new_v(1)+a];
            end
        end
    end
end