function [fitresult, gof] = power1(num11, num12, num1)
%CREATEFIT(NUM11,NUM12)
%  创建一个拟合。
%
%  要进行 '无标题拟合 1' 拟合的数据:
%      X 输入: num11
%      Y 输出: num12
%  输出:
%      fitresult: 表示拟合的拟合对象。
%      gof: 带有拟合优度信息的结构体。
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 04-Nov-2023 20:25:00 自动生成


%% 拟合: '无标题拟合 1'。
[xData, yData] = prepareCurveData( num11, num12 );
% num11
% num12
% xData
% yData
% 设置 fittype 和选项。
ft = fittype( 'power1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
% opts.StartPoint = [0.0164734620745159 -1.17863323147059];

% 对数据进行模型拟合。
[fitresult, gof] = fit( xData, yData, ft, opts );

% 绘制数据拟合图。
% figure( 'Name', '无标题拟合 1' );
% h = plot( fitresult, num1(1,:), num1(2,:) );
% legend( h, 'num12 vs. num11', '无标题拟合 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % 为坐标区加标签
% xlabel( 'num11', 'Interpreter', 'none' ); 
% ylabel( 'num12', 'Interpreter', 'none' );
% grid on

% clc;
% clear;
% num1=xlsread('E:\社交软件记录\WeChat Files\wxid_sx1iqpw232k312\FileStorage\File\2023-06\有云-数据00-22.xlsx', 'data2','D3:E98');%无涡
% num2=xlsread('E:\社交软件记录\WeChat Files\wxid_sx1iqpw232k312\FileStorage\File\2023-06\有云-数据00-22.xlsx', 'data2','A3:B118');%有涡
% num1=num1';num2=num2';
% 
% 
% % %清洗数据
% n=length(num1);
% for i=1:n
%     if num1(2,i)==0
%         num1(1,i)=NaN;
%     end
% end
% [~,b1]=find(isnan(num1));
% [~,b2]=find(isnan(num2));
% num1(:,b1)=[];num2(:,b2)=[];
% n1=length(num1);
% n2=length(num2);
% num11=num1(1,:);
% num12=num1(2,:);
% num21=num2(1,:);
% num22=num2(2,:);
% 
% 
% %标准归一化
% [num11_re,~]=mapminmax(num11);
% [num12_re,~]=mapminmax(num12);
% [num21_re,~]=mapminmax(num21);
% [num22_re,~]=mapminmax(num22);
% num1_re(1,:)=num11_re;
% num1_re(2,:)=num12_re;
% num2_re(1,:)=num21_re;
% num2_re(2,:)=num22_re;
% % plot(num1_re(1,:),num1_re(2,:),'b*')
% % hold on
% % plot(num2_re(1,:),num2_re(2,:),'r*')
% % xlabel('归一化风速')
% % ylabel('归一化校正后的逆温强度')
% 
% %去除灰色地带数据
% %使用距离和函数
% % for i=1:n1
% %     num1_hos(i)=0;%num1距离和函数
% %     for j=1:n2
% %         num1_hos(i)=num1_hos(i)+sqrt((num1_re(1,i)-num2_re(1,j)).^2+(num1_re(2,i)-num2_re(2,j)).^2);
% %     end            
% % end
% % 
% % for i=1:n2
% %     num2_hos(i)=0;%num2距离和函数
% %     for j=1:n1
% %         num2_hos(i)=num2_hos(i)+sqrt((num2_re(1,i)-num1_re(1,j)).^2+(num2_re(2,i)-num1_re(2,j)).^2);
% %     end
% % end
% % 
% for i=1:n1
%     num1_hos(i)=10000;%num1距离和函数
%     for j=1:n2
%         num1_hos(i)=min(num1_hos(i),sqrt((num1_re(1,i)-num2_re(1,j)).^2+(num1_re(2,i)-num2_re(2,j)).^2));
%     end            
% end
% 
% for i=1:n2
%     num2_hos(i)=10000;%num2距离和函数
%     for j=1:n1
%         num2_hos(i)=min(num2_hos(i),sqrt((num2_re(1,i)-num1_re(1,j)).^2+(num2_re(2,i)-num1_re(2,j)).^2));
%     end
% end
% % 
% %找到干扰点
% k=20;m=1;
% [~,I1]=mink(num1_hos,k);%找到索引
% [~,I2]=mink(num2_hos,m*k);
% 
% num1_use = zeros(2,length(I1));
% num2_use = zeros(2,length(I2));
% 
% for i=1:k
%     
%     num1_use(:,i)=num1(:,I1(i));
% end
% 
% for i=1:m*k
%     num2_use(:,i)=num2(:,I2(i));
% end
% 
% n1=length(num1_use);
% n2=length(num2_use);
% 
% num11=num1_use(1,:);
% num12=num1_use(2,:);
% num21=num2_use(1,:);
% num22=num2_use(2,:);
% plot(num1_use(1,:),num1_use(2,:),'b*')
% hold on
% plot(num2_use(1,:),num2_use(2,:),'r*')
% xlabel('风速')
% ylabel('校正后的逆温强度')
% yline(0)
