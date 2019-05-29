
function plotMaze(OM, Q, HA, HP, src, dest, S, gamma, alpha,epsilon,lambda, only_path)
% ��ȡ��ͼ����
% -------------------------------------------------------------------------
%   
%   ���� :
%   [M, OM] = plotMaze(OM, Q, HQ, HP, src, dest)
%   ���� :
%   OM       - ԭʼ��ͼ, �����ʽ [nrows,ncolumns] 1 ��ʾ���ܽ��� 0 ��ʾ��
%   Q        - Qֵ����
%   HA       - ÿһ episode �ĸ��ּ�¼����Ϣ, [struct, max_episode]
%   HP       - ÿһ episode �Ĳ���, [states, a, max_episode] 
%   src      - �������������������, ���� OM(src(1), src(2)) ~= 1
%   dest     - �������յ�
%   S        - ���������
%   gamma    - �ۿ۵ĳ��ڻر���˥������
%   alpha    - ѧϰ��, [0,1]
%   epsilon  - e-greedy ���Ե�̽���ĸ���
%   lambda   - epsilon ��˥������
%   only_path- ��������̽����·��?
% ����ο�������: https://ww2.mathworks.cn/matlabcentral/answers/154877-how-to-plot-a-10-10-grid-map-and-how-to-number-the-grid-cells-sample-pic-is-attached-here

%% ��������
if(~exist('only_path') || only_path == 0)
    only_path = 0;
else
    only_path = 1;
end
%% ����Qֵ(ƽ��)
[nr, nc, ~] = size(Q);
[~, ~, episodes] = size(HP);

if ~only_path
    figure();
    heatmap(Q);
    colorbar();

    title(sprintf('Qֵ����, �յ�(%i,%i)', dest(1), dest(2))); 
    xlabel('C');
    ylabel('R');
end
%% ƽ���Ĳ�������
if ~only_path
    figure();
    r = [HA.r].';
    % ���û���ƽ��
    windowSize = 10;  % ���崰�ڴ�С
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;
    t = linspace(1, episodes, episodes);
    y = filter(b,a,r);
    plot(t,r);
    hold on;
    plot(t,y);
    
    strMaze = sprintf('%ix%i',nr,nc);
    strProcess = sprintf([ ...
        '        ��ͼ: %10s\n', ...
        '       ����: %10i\n', ...
        '      gamma: %10.2f\n', ...
        '      alpha: %10.2f\n', ...
        '    epsilon: %10.2f\n', ...
        '     lambda: %10.2f\n', ...
        '   �����յ�: (%i,%i)\n'], ...
        strMaze,S,gamma,alpha,epsilon,lambda, dest(1), dest(2));
    
    % ��ͼ
    xlabel('episodes'), ylabel('�ۻ��ر�')
    text(0.9,0.1,strProcess, ...
        'Units', 'Normalized', ...
        'HorizontalAlignment', 'Right', ...
        'VerticalAlignment', 'bottom')
    
    legend('�����õ���·������', '����ƽ��', 'Location', 'best');
    title(sprintf('�������Ⱥ�ƽ����������, ��������Ϊ: %d', windowSize));
end
%% ���Ʒ���, ��Ҫʹ��HP, ���������̽���켣
if ~only_path
    figure()
    [C, R] = meshgrid(1:nc, 1:nr);
    % ���Ƽ�ͷ, �������º;�ֹ
    arrows = ['��', '��', '��', '��', '��', 'o'];
    final_p = HP(:,:,1);
    final_p_text = strings(nr, nc);
    for i=2:episodes
        for j=1:nr
            for k=1:nc
                if(HP(j, k, i) ~= 0)
                    % �滻Ϊ�µ�ֵ
                    final_p(j, k) = HP(j, k, i);
                end
                % �Ƿ�����?
                if(i == episodes)
                    final_p_text(j ,k) = arrows(final_p(j, k) + 1);
                    
                end
            end
        end
    end
    % ���Ʋ�������
    imagesc(final_p);
    % ��Ϊ����ɫӳ��. �������º;�ֹ
    
    colormap(summer);
    % �޸������յ����ʾ
    final_p_text(dest(1), dest(2)) = 'd';  % d ��ֵ���������, ��Ϊ������յ�, ������ֱ����µ����
    
    text(C(:), R(:),final_p_text,'HorizontalAlignment','left');
    xlabel('C');
    ylabel('R');
    title(sprintf('ÿ�������Ӧ�����ŷ���, �յ�(%i,%i)', dest(1), dest(2)));
end
%% ����ĳ��·������, ������ͼ
if ~only_path
    figure;
    maze = OM;
    % ɨ��·��
    s_t = src;
    
    while(1)
        maze(s_t(1), s_t(2)) = 2;  % 2 ��ʾ·���е�һ��
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
    % ��Ϊ����ɫӳ��. �������º;�ֹ
    colormap([1,1,1;1,0,0;0,1,0]);
    % ����·��
    final_p_text(src(1), src(2)) = 's';
    
    text(C(:), R(:),final_p_text,'HorizontalAlignment','left');
    xlabel('C');
    ylabel('R');
    title(sprintf('(%i,%i)��(%i,%i)��·��', src(1), src(2), dest(1), dest(2)));
end
end