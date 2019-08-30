close all;
%% �����ͼ
[M, OM, SR, SC] = readMaze();
[nr, nc, ~] = size(M);
%% ����
seed  = randi(2^32);

gamma   = 0.9;  % ���ڻر���˥������
alpha   = 1/10;  % ����Q��ѧϰ��
epsilon = 0.8;  % e-greedy ��̽������
lambda  = 0.98;  % ̽�����ӵ�˥����
maxIt   = nr*nc;  % ���Ĳ�������(�����maze��grid����, ��Ϊ��ʾ���������·������)
maxEp   = 1000;  % ���� episode
showQInterval = 100;  % ÿ���ٸ� episode ����Q
dest = [2,7];  % Ŀ��
%% Qѧϰ
[Q, M, HA, HQ, HP] = q_learning(M, SR, SC, dest,seed,gamma,alpha,epsilon,lambda,maxIt,maxEp,1);

%% ����Qֵ��policy�����·�����������������ָ���������㣬��Ŀ����ȷ����
start = [2,3];
plotMaze(OM, Q, HA, HP, start, dest, seed, gamma, alpha,epsilon,lambda);
%% ����һЩ�м���
for i=1:showQInterval:maxEp
    plotQ(HQ, i, dest, 'images');
end

