function [Q, M, HA, HQ, HP] = q_learning(M, src, SR,SC, dest, seed,gamma,alpha,epsilon,lambda,maxIt,maxEp,doReport)
% Qѧϰ(������Q(lambda))
% -------------------------------------------------------------------------
%   
%   ���� :
%   [Q,M,HA,HQ,HP] = q_learning(M, src, dest, seed, gamma, alpha, epsilon, lambda, maxIt, maxEp, doReport)
%   
%   ���� :
%   M        - �����ľ���, ������ M[nrows, ncolumns, 4]
%   src      - ���[x,y]
%   S        - 
%   dest     - �յ�[x,y]
%   seed     - ���������
%   gamma    - �ۿ۵ĳ��ڻر���˥������
%   alpha    - ѧϰ��, [0,1]
%   epsilon  - e-greedy ���Ե�̽���ĸ���
%   lambda   - epsilon ��˥������
%   maxIt    - һ�� episode �����Ĳ���
%   maxEp    - ���� episode ������
%   doReport - ��ӡ��ص���Ϣ
%   
%   ��� :
%   Q        - Qֵ����[nrows, ncolumns]
%   M        - ͬ M
%   HA       - ��¼ agent ����ʷ��Ϣ. episode ���ȵĽṹ��. 
%   HQ       - ÿһ episode ��Qֵ, [nrows, ncolumns, max_episode]
%   HP       - ÿһ episode �Ĳ���, [states, a, max_episode] 

    % ��ͼ�Ĵ�С
    [nr,nc,~] = size(M);
    
    % ���������������
    rng(seed);

    % ĳһ·�������� episodes �����˶��,��ô����Ϊ�����ŵ�
    repeats = 2 * max([nr,nc]);  

    % ÿһ�� grid �ƶ�һ�εĻر�
    rewardMove  = -1;
    
    % ��������յ�Ķ���ĸ��ӻر�
    rewardFinish = 0.1;
    
    % ��ʼ�� e-greedy �Ĳ���, һ��ʼ��Ҫ����̽��֮��������
    initEpsilon = epsilon;
    
    % �����Ƿ����ѧϰ
    doLearn = 1;         
    
    % ǿ�� agent ����������
    doMinimum = 1;

    %�������ʼ�Ļر�����
    R = rewardMove * ones(nr,nc);
    % �յ�Ļر��� 0
    R(dest(1),dest(2)) = 0;

    % ��ʼ��Qֵ����: S->S
    Q = R;
    
    % Qѧϰ��ʼ
    tic; episode = 0; 
    dT(1) = 0; 
    cntMaxItt = 0; 
    dEpsilon = 0;
    max_states = size(SR, 2);
    while doLearn
        % �µ� episode
        episode = episode + 1;
        
        % ��ʼ�ĵ�
        % s0 = src;
        r = randi(max_states, 1);
        s0 = [SR(r), SC(r)];
        fprintf("�������: %d,%d\n", s0(1), s0(2));
        % �����¼���Եľ���
        HP(:,:,episode) = zeros(nr, nc);
        % ѭ����ʼ
        % �켣 \tau
        cnt = 0; logAgent = s0;
        % �ۻ��Ļر�
        reward = 0;
        % �涨���Ĳ����ĳ���
        for itt = 1:maxIt
            % ��������, �˳�ѭ��
            if s0(1) == dest(1) && s0(2) == dest(2)
                break;
            end
            
            % ����ѡ�����ռ�: 4������ + ֹͣ����. ǰ�ĸ�����ȡ�����ڵ�(s0(1),s0(2))���Թ���ǰ�Ĳ㶨��Ŀ��ƶ������ٽ��ķ���
            options = ones(1,5);
            options(1:4) = reshape(M(s0(1), s0(2), 1:4), [1,4]);  % �����ƶ��ķ���, options(:,:,5) ��ʾ
            
            % ���㵱ǰ�ĵ���ܵ� Qֵ
            sOpt = zeros(5,2);
            qOpt = zeros(1,5);
            for i = 1:5
                if  options(i) == 1
                    % �ƶ������ٽ��, ת�Ƶ��µ�״̬ s'. ͬʱ��¼�� sOpt. ���ڽ�������ѡ��
                    sOpt(i,:) = s0 + actions(i);
                    % ����Qֵ, 
                    qOpt(i)   = Q(sOpt(i,1),sOpt(i,2));
                else
                    qOpt(i) = NaN;
                end
            end
            
            % epsilon ̰���㷨
            if rand() < epsilon
                % ̽��
                [~,idxA] =  max(rand(1,5).*options);
            else
                % ����, ѡʹ�� Q���Ķ���
                [~,idxA] =  max(qOpt);
            end
            
            % ��ȡ�ж� idxA ת�Ƶ�ָ�����ٽ��(s')
            sP = sOpt(idxA,:);
            %
            HP(s0(1), s0(2), episode) = idxA;
            
            % RF �ǲ�ȡ�ж� a0 ת�Ƶ�״̬�ܹ���õļ�ʱ�ر�
            RF = 0; if s0 == dest; RF = rewardFinish; end
            
            % ���� MC �ķ���, itt �ǲ������еõ���
            if alpha < 0; stepsize = 1/itt; else; stepsize = alpha; end

            % ����Qֵ����
            Q(s0(1),s0(2)) = Q(s0(1),s0(2)) + ...
                stepsize * ( R(sP(1),sP(2)) + RF + ... 
                gamma * qOpt(idxA) - Q(s0(1),s0(2)) );
            reward = reward +  R(sP(1),sP(2));
            % ��¼��״̬��ת�ƹ켣
            logAgent(itt,:) = s0;
            
            % ����״̬
            s0 = sP;
            
        end  % ��ѭ������

        
        % ��ʱ����
        t_itt = toc;
        
        % ƽ����̽��-����
        % �����������·�����ȶ�û�е��յ�. ���ܵ�ԭ��:
        if itt == maxIt && epsilon < 0.1 * initEpsilon
            % ����������, ��ͻᵼ����ĳЩ�ط����ص�ת
            cntMaxItt = cntMaxItt + 1;
            
            % ���� epsilon �ı�־
            if cntMaxItt == 2
                epsilon = initEpsilon;
                strMsg = '| ע��̽��';
            end
            
        else
            % ������̽��
            epsilon = epsilon * lambda;  % ˥�� epsilon
            strMsg = '| ע������';
            % ��������
            cntMaxItt = 0;
        end
        
        % ��¼һ�� episode �Ĳ�������
        T(episode) = itt;
        
        % ÿһ�β����� episode ����С����
        minT = min(T);

        % ÿ�ε����켣�� Q��
        HQ(:,:,episode) = Q;
        
        % ���ڼ�¼��־
        HA(episode).logAgent = logAgent;
        HA(episode).steps    = itt;
        HA(episode).minT     = minT;
        HA(episode).T        = itt;
        HA(episode).r        = reward;
        if episode == maxEp
            doLearn = 0;
            strMsg = '< ��ֹ >';
        end
        % �Ƿ��ӡ��־
        if doReport
            fprintf(['[ #%04i ] epsilon = %3.2f | ' ...
                '�������� = %5i | �ۼ���ʱ = %5.1f [s]  %s\n'], ...
                episode, epsilon, itt-cnt, t_itt, strMsg);
            
        end
        
    end
    
end