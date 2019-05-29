function [Q, M, HA, HQ, HP] = q_learning(M, src, SR,SC, dest, seed,gamma,alpha,epsilon,lambda,maxIt,maxEp,doReport)
% Q学习(这里是Q(lambda))
% -------------------------------------------------------------------------
%   
%   函数 :
%   [Q,M,HA,HQ,HP] = q_learning(M, src, dest, seed, gamma, alpha, epsilon, lambda, maxIt, maxEp, doReport)
%   
%   输入 :
%   M        - 处理后的矩阵, 必须是 M[nrows, ncolumns, 4]
%   src      - 起点[x,y]
%   S        - 
%   dest     - 终点[x,y]
%   seed     - 随机数种子
%   gamma    - 折扣的长期回报的衰减因子
%   alpha    - 学习率, [0,1]
%   epsilon  - e-greedy 策略的探索的概率
%   lambda   - epsilon 的衰减因子
%   maxIt    - 一次 episode 的最大的步数
%   maxEp    - 最大的 episode 的数量
%   doReport - 打印相关的信息
%   
%   输出 :
%   Q        - Q值矩阵[nrows, ncolumns]
%   M        - 同 M
%   HA       - 记录 agent 的历史信息. episode 长度的结构体. 
%   HQ       - 每一 episode 的Q值, [nrows, ncolumns, max_episode]
%   HP       - 每一 episode 的策略, [states, a, max_episode] 

    % 地图的大小
    [nr,nc,~] = size(M);
    
    % 设置随机数发生器
    rng(seed);

    % 某一路径长度在 episodes 出现了多次,那么就认为是最优的
    repeats = 2 * max([nr,nc]);  

    % 每一个 grid 移动一次的回报
    rewardMove  = -1;
    
    % 如果到了终点的额外的附加回报
    rewardFinish = 0.1;
    
    % 初始的 e-greedy 的参数, 一开始主要进行探索之后再利用
    initEpsilon = epsilon;
    
    % 控制是否继续学习
    doLearn = 1;         
    
    % 强制 agent 收敛到最优
    doMinimum = 1;

    %　定义初始的回报矩阵
    R = rewardMove * ones(nr,nc);
    % 终点的回报是 0
    R(dest(1),dest(2)) = 0;

    % 初始的Q值矩阵: S->S
    Q = R;
    
    % Q学习开始
    tic; episode = 0; 
    dT(1) = 0; 
    cntMaxItt = 0; 
    dEpsilon = 0;
    max_states = size(SR, 2);
    while doLearn
        % 新的 episode
        episode = episode + 1;
        
        % 初始的点
        % s0 = src;
        r = randi(max_states, 1);
        s0 = [SR(r), SC(r)];
        fprintf("采样起点: %d,%d\n", s0(1), s0(2));
        % 构造记录策略的矩阵
        HP(:,:,episode) = zeros(nr, nc);
        % 循环开始
        % 轨迹 \tau
        cnt = 0; logAgent = s0;
        % 累积的回报
        reward = 0;
        % 规定最大的采样的长度
        for itt = 1:maxIt
            % 采样结束, 退出循环
            if s0(1) == dest(1) && s0(2) == dest(2)
                break;
            end
            
            % 定义选择动作空间: 4个动作 + 停止不动. 前四个动作取决于在点(s0(1),s0(2))的迷宫的前四层定义的可移动到的临界点的方向
            options = ones(1,5);
            options(1:4) = reshape(M(s0(1), s0(2), 1:4), [1,4]);  % 允许移动的方向, options(:,:,5) 表示
            
            % 计算当前的点可能的 Q值
            sOpt = zeros(5,2);
            qOpt = zeros(1,5);
            for i = 1:5
                if  options(i) == 1
                    % 移动到的临界点, 转移到新的状态 s'. 同时记录到 sOpt. 用于接下来的选择
                    sOpt(i,:) = s0 + actions(i);
                    % 计算Q值, 
                    qOpt(i)   = Q(sOpt(i,1),sOpt(i,2));
                else
                    qOpt(i) = NaN;
                end
            end
            
            % epsilon 贪心算法
            if rand() < epsilon
                % 探索
                [~,idxA] =  max(rand(1,5).*options);
            else
                % 利用, 选使得 Q最大的动作
                [~,idxA] =  max(qOpt);
            end
            
            % 采取行动 idxA 转移到指定的临界点(s')
            sP = sOpt(idxA,:);
            %
            HP(s0(1), s0(2), episode) = idxA;
            
            % RF 是采取行动 a0 转移到状态能够获得的即时回报
            RF = 0; if s0 == dest; RF = rewardFinish; end
            
            % 按照 MC 的方法, itt 是采样序列得到的
            if alpha < 0; stepsize = 1/itt; else; stepsize = alpha; end

            % 更新Q值矩阵
            Q(s0(1),s0(2)) = Q(s0(1),s0(2)) + ...
                stepsize * ( R(sP(1),sP(2)) + RF + ... 
                gamma * qOpt(idxA) - Q(s0(1),s0(2)) );
            reward = reward +  R(sP(1),sP(2));
            % 记录新状态的转移轨迹
            logAgent(itt,:) = s0;
            
            % 更新状态
            s0 = sP;
            
        end  % 内循环结束

        
        % 计时结束
        t_itt = toc;
        
        % 平衡现探索-利用
        % 如果到了最大的路径长度都没有到终点. 可能的原因:
        if itt == maxIt && epsilon < 0.1 * initEpsilon
            % 总是在利用, 这就会导致在某些地方来回的转
            cntMaxItt = cntMaxItt + 1;
            
            % 重置 epsilon 的标志
            if cntMaxItt == 2
                epsilon = initEpsilon;
                strMsg = '| 注重探索';
            end
            
        else
            % 总是在探索
            epsilon = epsilon * lambda;  % 衰减 epsilon
            strMsg = '| 注重利用';
            % 重新利用
            cntMaxItt = 0;
        end
        
        % 记录一次 episode 的步数计数
        T(episode) = itt;
        
        % 每一次采样的 episode 的最小步数
        minT = min(T);

        % 每次迭代轨迹的 Q表
        HQ(:,:,episode) = Q;
        
        % 用于记录日志
        HA(episode).logAgent = logAgent;
        HA(episode).steps    = itt;
        HA(episode).minT     = minT;
        HA(episode).T        = itt;
        HA(episode).r        = reward;
        if episode == maxEp
            doLearn = 0;
            strMsg = '< 终止 >';
        end
        % 是否打印日志
        if doReport
            fprintf(['[ #%04i ] epsilon = %3.2f | ' ...
                '采样长度 = %5i | 累计用时 = %5.1f [s]  %s\n'], ...
                episode, epsilon, itt-cnt, t_itt, strMsg);
            
        end
        
    end
    
end