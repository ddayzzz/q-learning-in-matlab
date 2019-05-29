
function plotMaze(OM, Q, HA, HP, src, dest, S, gamma, alpha,epsilon,lambda, only_path)
% 读取地图矩阵
% -------------------------------------------------------------------------
%   
%   函数 :
%   [M, OM] = plotMaze(OM, Q, HQ, HP, src, dest)
%   输入 :
%   OM       - 原始地图, 矩阵格式 [nrows,ncolumns] 1 表示不能进入 0 表示空
%   Q        - Q值矩阵
%   HA       - 每一 episode 的各种记录的信息, [struct, max_episode]
%   HP       - 每一 episode 的策略, [states, a, max_episode] 
%   src      - 采样的起点或者任意起点, 满足 OM(src(1), src(2)) ~= 1
%   dest     - 采样的终点
%   S        - 随机数种子
%   gamma    - 折扣的长期回报的衰减因子
%   alpha    - 学习率, [0,1]
%   epsilon  - e-greedy 策略的探索的概率
%   lambda   - epsilon 的衰减因子
%   only_path- 仅仅绘制探索的路径?
% 代码参考了例子: https://ww2.mathworks.cn/matlabcentral/answers/154877-how-to-plot-a-10-10-grid-map-and-how-to-number-the-grid-cells-sample-pic-is-attached-here

%% 参数处理
if(~exist('only_path') || only_path == 0)
    only_path = 0;
else
    only_path = 1;
end
%% 绘制Q值(平面)
[nr, nc, ~] = size(Q);
[~, ~, episodes] = size(HP);

if ~only_path
    figure();
    heatmap(Q);
    colorbar();

    title(sprintf('Q值矩阵, 终点(%i,%i)', dest(1), dest(2))); 
    xlabel('C');
    ylabel('R');
end
%% 平均的采样长度
if ~only_path
    figure();
    r = [HA.r].';
    % 采用滑动平均
    windowSize = 10;  % 定义窗口大小
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;
    t = linspace(1, episodes, episodes);
    y = filter(b,a,r);
    plot(t,r);
    hold on;
    plot(t,y);
    
    strMaze = sprintf('%ix%i',nr,nc);
    strProcess = sprintf([ ...
        '        地图: %10s\n', ...
        '       种子: %10i\n', ...
        '      gamma: %10.2f\n', ...
        '      alpha: %10.2f\n', ...
        '    epsilon: %10.2f\n', ...
        '     lambda: %10.2f\n', ...
        '   采样终点: (%i,%i)\n'], ...
        strMaze,S,gamma,alpha,epsilon,lambda, dest(1), dest(2));
    
    % 画图
    xlabel('episodes'), ylabel('累积回报')
    text(0.9,0.1,strProcess, ...
        'Units', 'Normalized', ...
        'HorizontalAlignment', 'Right', ...
        'VerticalAlignment', 'bottom')
    
    legend('采样得到的路径长度', '滑动平均', 'Location', 'best');
    title(sprintf('采样长度和平均采样长度, 滑动窗口为: %d', windowSize));
end
%% 绘制方向, 需要使用HP, 计算总体的探索轨迹
if ~only_path
    figure()
    [C, R] = meshgrid(1:nc, 1:nr);
    % 绘制箭头, 左上右下和静止
    arrows = ['×', '←', '↑', '→', '↓', 'o'];
    final_p = HP(:,:,1);
    final_p_text = strings(nr, nc);
    for i=2:episodes
        for j=1:nr
            for k=1:nc
                if(HP(j, k, i) ~= 0)
                    % 替换为新的值
                    final_p(j, k) = HP(j, k, i);
                end
                % 是否生成?
                if(i == episodes)
                    final_p_text(j ,k) = arrows(final_p(j, k) + 1);
                    
                end
            end
        end
    end
    % 绘制策略网络
    imagesc(final_p);
    % 行为的颜色映射. 左上右下和静止
    
    colormap(summer);
    % 修改起点和终点的显示
    final_p_text(dest(1), dest(2)) = 'd';  % d 的值是随机给定, 因为这个是终点, 不会出现被更新的情况
    
    text(C(:), R(:),final_p_text,'HorizontalAlignment','left');
    xlabel('C');
    ylabel('R');
    title(sprintf('每个网格对应的最优方向, 终点(%i,%i)', dest(1), dest(2)));
end
%% 绘制某个路径出来, 基于上图
if ~only_path
    figure;
    maze = OM;
    % 扫描路径
    s_t = src;
    
    while(1)
        maze(s_t(1), s_t(2)) = 2;  % 2 表示路径中的一点
        act = final_p(s_t(1),s_t(2));
        delta_direction = actions(act);
        s_t_plus_1 = s_t + delta_direction;
        if(s_t_plus_1(1) == dest(1) && s_t_plus_1(2) == dest(2))
            break;
        end
        s_t = s_t_plus_1;
    end
    maze(dest(1), dest(2)) = 2;
    imagesc(maze);
    % 行为的颜色映射. 左上右下和静止
    colormap([1,1,1;1,0,0;0,1,0]);
    % 绘制路径
    final_p_text(src(1), src(2)) = 's';
    
    text(C(:), R(:),final_p_text,'HorizontalAlignment','left');
    xlabel('C');
    ylabel('R');
    title(sprintf('(%i,%i)到(%i,%i)的路径', src(1), src(2), dest(1), dest(2)));
end
end