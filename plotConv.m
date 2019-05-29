function plotConv(HA,nr,nc,S,gamma,alpha,epsilon,lambda,src, dest)
% 绘制收敛后的最短路径的图像
% -------------------------------------------------------------------------
%   
%   函数 :
%   plotConv(HA,nr,nc,S,gamma,alpha,epsilon,lambda,src,dest)
%   
%   输入 :
%   HA       - 日志矩阵 [1,max_episodes]
%   nr       - 地图的行数
%   nc       - 地图列数

%   src      - 起点[x,y]
%   dest     - 终点[x,y]



    % 获取最短的
    for i = 1:length(HA)
        T(i) = HA(i).T;
        minT(i) = HA(i).minT;
    end

    % 最长的路径
    maxT = max(T);


    
    
    
end