
function plotQ(QE, episode, dest, prefix)
% ����һ����ʷ��¼�õ���Ӧ��ͼ��
% -------------------------------------------------------------------------
%   
%   ���� :
%   [M, OM] = plotMaze(QE, episode)
%   QE        - Qֵ����
%% ����Qֵ(ƽ��)
    f = figure();set(f, 'Visible', 'off', 'Position', [0,0,800, 600]);
    digits(3);  % ������λ
    heatmap(QE(:, :, episode));
    colorbar();
    title(sprintf('Qֵ����, �յ�(%i,%i), ��������=%i', dest(1), dest(2), episode)); 
    xlabel('C');
    ylabel('R');
    saveas(f, sprintf('%s/q_at_episode_%i.jpg', prefix, episode), 'jpg');
end