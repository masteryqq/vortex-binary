function [fitresult, gof] = exp1(num11, num12,num1)
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

%  由 MATLAB 于 04-Nov-2023 20:25:39 自动生成


%% 拟合: '无标题拟合 1'。
[xData, yData] = prepareCurveData( num11, num12 );

% 设置 fittype 和选项。
ft = fittype( 'exp1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
% opts.StartPoint = [0.0024049438784834 -0.0641958094089139];

% 对数据进行模型拟合。
[fitresult, gof] = fit( xData, yData, ft, opts );

% 绘制数据拟合图。
% figure( 'Name', '无标题拟合 1' );
% h = plot( fitresult,  num1(1,:), num1(2,:) );
% legend( h, 'num12 vs. num11', '无标题拟合 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% 为坐标区加标签
% xlabel( 'num11', 'Interpreter', 'none' );
% ylabel( 'num12', 'Interpreter', 'none' );
% grid on


