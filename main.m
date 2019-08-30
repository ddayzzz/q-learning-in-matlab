close all;
%% 构造地图
[M, OM, SR, SC] = readMaze();
[nr, nc, ~] = size(M);
%% 参数
seed  = randi(2^32);

gamma   = 0.9;  % 长期回报的衰减因子
alpha   = 1/10;  % 更新Q的学习率
epsilon = 0.8;  % e-greedy 的探索因子
lambda  = 0.98;  % 探索因子的衰减率
maxIt   = nr*nc;  % 最大的采样长度(最大是maze的grid个数, 因为表示这最大的最短路径长度)
maxEp   = 1000;  % 最大的 episode
showQInterval = 100;  % 每多少个 episode 保存Q
dest = [2,7];  % 目标
%% Q学习
[Q, M, HA, HQ, HP] = q_learning(M, SR, SC, dest,seed,gamma,alpha,epsilon,lambda,maxIt,maxEp,1);

%% 绘制Q值、policy和最短路径。第五个参数可以指定任意的起点，但目标是确定的
start = [2,3];
plotMaze(OM, Q, HA, HP, start, dest, seed, gamma, alpha,epsilon,lambda);
%% 保存一些中间结果
for i=1:showQInterval:maxEp
    plotQ(HQ, i, dest, 'images');
end

