
function plotQ(QE, episode, dest, prefix)
% 根据一次历史记录得到相应的图像
% -------------------------------------------------------------------------
%   
%   函数 :
%   [M, OM] = plotMaze(QE, episode)
%   QE        - Q值矩阵
%% 绘制Q值(平面)
    f = figure();set(f, 'Visible', 'off', 'Position', [0,0,800, 600]);
    digits(3);  % 保留三位
    heatmap(QE(:, :, episode));
    colorbar();
    title(sprintf('Q值矩阵, 终点(%i,%i), 迭代次数=%i', dest(1), dest(2), episode)); 
    xlabel('C');
    ylabel('R');
    saveas(f, sprintf('%s/q_at_episode_%i.jpg', prefix, episode), 'jpg');
end