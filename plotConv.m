function plotConv(HA,nr,nc,S,gamma,alpha,epsilon,lambda,src, dest)
% ��������������·����ͼ��
% -------------------------------------------------------------------------
%   
%   ���� :
%   plotConv(HA,nr,nc,S,gamma,alpha,epsilon,lambda,src,dest)
%   
%   ���� :
%   HA       - ��־���� [1,max_episodes]
%   nr       - ��ͼ������
%   nc       - ��ͼ����

%   src      - ���[x,y]
%   dest     - �յ�[x,y]



    % ��ȡ��̵�
    for i = 1:length(HA)
        T(i) = HA(i).T;
        minT(i) = HA(i).minT;
    end

    % ���·��
    maxT = max(T);


    
    
    
end