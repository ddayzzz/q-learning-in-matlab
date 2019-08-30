# Q学习的 Matlab 实现
本项目是基于迷宫环境. 与最短路径算法不同, Q学习算法使`agent`能够通过与环境交互(采取四个方向的动作), 计算从给定的起点到**固定的**终点的最短路径. 
## 文件结构
1. `readMaze.m`: 读取迷宫数据, 目前存储为矩阵的形式
2. `q_learning.m`: Q学习的核心算法
3. `plotMaze.m`: 绘制平均路径, 地图和各个点的最佳方向
4. `actions.m`: 定义动作空间

## 需求
基于 Matlab 2019a 开发. 需要使用部分函数进行绘图:

函数|Matlab版本的最低需求
-|-
heatmap|Matlab 2017a
strings|Matlab 2016b
