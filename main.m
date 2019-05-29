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
src = [1,2];  % Qѧϰ��������� s_0
dest = [2,7];  % Ŀ��
%% Qѧϰ
[Q, M, HA, HQ, HP] = q_learning(M,src, SR, SC, dest,seed,gamma,alpha,epsilon,lambda,maxIt,maxEp,1);

%% ���ƻر�ֵ����
plotConv(HA,nr,nc,seed,gamma,alpha,epsilon,lambda, src, dest);
%% ����Qֵ��policy�����·�����������������ָ���������㣬��Ŀ����ȷ����
start = [9,3];
plotMaze(OM, Q, HA, HP, start, dest, seed, gamma, alpha,epsilon,lambda);
% plotMaze(OM, Q, HQ, HP, src, dest, src);