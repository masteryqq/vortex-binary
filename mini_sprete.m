%筛选拟合点

clc;
clear;
warning off;
num1=xlsread('E:\社交软件记录\WeChat Files\wxid_sx1iqpw232k312\FileStorage\File\2023-06\有云-数据00-22.xlsx', 'data2','D3:E98');%无涡
num2=xlsread('E:\社交软件记录\WeChat Files\wxid_sx1iqpw232k312\FileStorage\File\2023-06\有云-数据00-22.xlsx', 'data2','A3:B118');%有涡
num1=num1';num2=num2';


% %清洗数据
n=length(num1);
for i=1:n
    if num1(2,i)==0
        num1(1,i)=NaN;
    end
end
[~,b1]=find(isnan(num1));
[~,b2]=find(isnan(num2));
num1(:,b1)=[];num2(:,b2)=[];
n1=length(num1);
n2=length(num2);
num11=num1(1,:);
num12=num1(2,:);
num21=num2(1,:);
num22=num2(2,:);


%标准归一化
[num11_re,~]=mapminmax(num11);
[num12_re,~]=mapminmax(num12);
[num21_re,~]=mapminmax(num21);
[num22_re,~]=mapminmax(num22);
num1_re(1,:)=num11_re;
num1_re(2,:)=num12_re;
num2_re(1,:)=num21_re;
num2_re(2,:)=num22_re;
% plot(num1_re(1,:),num1_re(2,:),'b*')
% hold on
% plot(num2_re(1,:),num2_re(2,:),'r*')
% xlabel('归一化风速')
% ylabel('归一化校正后的逆温强度')

% % 去除灰色地带数据
% % 使用距离和函数
% for i=1:n1
%     num1_hos(i)=0;%num1距离和函数
%     for j=1:n2
%         num1_hos(i)=num1_hos(i)+sqrt((num1_re(1,i)-num2_re(1,j)).^2+(num1_re(2,i)-num2_re(2,j)).^2);
%     end            
% end
% 
% for i=1:n2
%     num2_hos(i)=0;%num2距离和函数
%     for j=1:n1
%         num2_hos(i)=num2_hos(i)+sqrt((num2_re(1,i)-num1_re(1,j)).^2+(num2_re(2,i)-num1_re(2,j)).^2);
%     end
% end


%使用最大距离函数
for i=1:n1
    num1_hos(i)=10000;%num1距离和函数
    for j=1:n2
        num1_hos(i)=min(num1_hos(i),sqrt((num1_re(1,i)-num2_re(1,j)).^2+(num1_re(2,i)-num2_re(2,j)).^2));
    end            
end

for i=1:n2
    num2_hos(i)=10000;%num2距离和函数
    for j=1:n1
        num2_hos(i)=min(num2_hos(i),sqrt((num2_re(1,i)-num1_re(1,j)).^2+(num2_re(2,i)-num1_re(2,j)).^2));
    end
end
% 
%找到干扰点


accuracy_11 = 0;
accuracy_21 = 0;
accuracy_12 =0;
accuracy_22 = 0;
accuracy_13 = 0;
accuracy_23 = 0;
k1=0;q1=0;
k2=0;q2=0;




%%%%%%%%%%%%%%%%%%%%%%%%%%上面曲线
for k = 10:2:36
%     for m=1:0.5:2.5

    
    [~,I1]=mink(num1_hos,k);%找到索引
    num1_use = zeros(2,length(I1));
    for i=1:k
        
        num1_use(:,i)=num1(:,I1(i));
    end

    n1=length(num1_use);
    num11=num1_use(1,:);
    num12=num1_use(2,:);


%     [~,I2]=mink(num2_hos,m*k);
%     num2_use = zeros(2,length(I2));
% 
%     for i=1:m*k
%         num2_use(:,i)=num2(:,I2(i));
%     end
% 
%     n2=length(num2_use);
%     num21=num2_use(1,:);
%     num22=num2_use(2,:);
    % plot(num1_use(1,:),num1_use(2,:),'b*')
    % hold on
    % plot(num2_use(1,:),num2_use(2,:),'r*')
    % xlabel('风速')
    % ylabel('校正后的逆温强度')
    % yline(0)
    
    %%%%统计出曲线上下的点的个数for 
    %%%%%%%%%%%%%%%%%power
    [fitresult1, ~] = power1(num11, num12, num1);
    y1=fitresult1(num1(1,:));
    ans1=y1'>num1(2,:);%曲线上方的点为错误，0是错
    y2=fitresult1(num2(1,:));
    ans2=y2'>num2(2,:);%曲线下方的点为错误，1是错
    
    sum1 = sum(ans1);
    sum2 = sum(ans2);

    if sum1/(sum1+sum2)>accuracy_11
        accuracy_11 = sum1/(sum1+sum2);%%%越大越好
        fitresult = fitresult1;
        accuracy_12 = sum1/(length(ans1));%%%%%越大越好
        accuracy_13 = sum2/length(ans2);%%%%越小越好

        k1=k;q1=1;
    else if sum1/(sum1+sum2)==accuracy_11
            if sum1/(length(ans1))>accuracy_12
                fitresult = fitresult1;
                accuracy_12 = sum1/(length(ans1));%%%%%越大越好
                accuracy_13 = sum2/length(ans2);%%%%越小越好
                k1=k;q1=1;
            else if sum1/(length(ans1))==accuracy_12
                    if accuracy_13<sum2/length(ans2) %%%%越小越好
                        fitresult = fitresult1;
                        accuracy_13 = sum2/length(ans2);%%%%越小越好
                        k1=k;q1=1;
                    end
            end
            end
    end
    end

    
    %%%%%%%%%%%%%%%%%exp1
    [fitresult1, ~] = exp1(num11, num12, num1);
    y1=fitresult1(num1(1,:));
    ans1=y1'>num1(2,:);%曲线上方的点为错误，0是错
    y2=fitresult1(num2(1,:));
    ans2=y2'>num2(2,:);%曲线下方的点为错误，1是错
    
    sum1 = sum(ans1);
    sum2 = sum(ans2);
    
    if sum1/(sum1+sum2)>accuracy_11
        accuracy_11 = sum1/(sum1+sum2);%%%越大越好
        fitresult = fitresult1;
        accuracy_12 = sum1/(length(ans1));%%%%%越大越好
        accuracy_13 = sum2/length(ans2);%%%%越小越好

        k1=k;q1=2;
    else if sum1/(sum1+sum2)==accuracy_11
            if sum1/(length(ans1))>accuracy_12
                fitresult = fitresult1;
                accuracy_12 = sum1/(length(ans1));%%%%%越大越好
                accuracy_13 = sum2/length(ans2);%%%%越小越好
                k1=k;q1=2;
            else if sum1/(length(ans1))==accuracy_12
                    if accuracy_13<sum2/length(ans2) %%%%越小越好
                        fitresult = fitresult1;
                        accuracy_13 = sum2/length(ans2);%%%%越小越好
                        k1=k;q1=2;
                    end
            end
            end
    end
    end
    
    %%%%%%%%%%%%%%%%%rat1
%     [fitresult1, ~] = rat1(num11, num12, num1);
%     y1=fitresult1(num1(1,:));
%     ans1=y1'>num1(2,:);%曲线上方的点为错误，0是错
%     y2=fitresult1(num2(1,:));
%     ans2=y2'>num2(2,:);%曲线下方的点为错误，1是错
%     
%     sum1 = sum(ans1);
%     sum2 = sum(ans2);
%     
%     if sum1/(sum1+sum2)>accuracy_11
%         accuracy_11 = sum1/(sum1+sum2);%%%越大越好
%         fitresult = fitresult1;
%         accuracy_12 = sum1/(length(ans1));%%%%%越大越好
%         accuracy_13 = sum2/length(ans2);%%%%越小越好
% 
%         k1=k;q1=3;
%     else if sum1/(sum1+sum2)==accuracy_11
%             if sum1/(length(ans1))>accuracy_12
%                 fitresult = fitresult1;
%                 accuracy_12 = sum1/(length(ans1));%%%%%越大越好
%                 accuracy_13 = sum2/length(ans2);%%%%越小越好
%                 k1=k;q1=3;
%             else if sum1/(length(ans1))==accuracy_12
%                     if accuracy_13<sum2/length(ans2) %%%%越小越好
%                         fitresult = fitresult1;
%                         accuracy_13 = sum2/length(ans2);%%%%越小越好
%                         k1=k;q1=3;
%                     end
%             end
%             end
%     end
%     end
    
    %%%%%%%%%%%%%%%%%weibull1
    [fitresult1, ~] = weibull1(num11, num12, num1);
    y1=fitresult1(num1(1,:));
    ans1=y1'>num1(2,:);%曲线上方的点为错误，0是错
    y2=fitresult1(num2(1,:));
    ans2=y2'>num2(2,:);%曲线下方的点为错误，1是错
    
    sum1 = sum(ans1);
    sum2 = sum(ans2);
    
    if sum1/(sum1+sum2)>accuracy_11
        accuracy_11 = sum1/(sum1+sum2);%%%越大越好
        fitresult = fitresult1;
        accuracy_12 = sum1/(length(ans1));%%%%%越大越好
        accuracy_13 = sum2/length(ans2);%%%%越小越好

        k1=k;q1=4;
    else if sum1/(sum1+sum2)==accuracy_11
            if sum1/(length(ans1))>accuracy_12
                fitresult = fitresult1;
                accuracy_12 = sum1/(length(ans1));%%%%%越大越好
                accuracy_13 = sum2/length(ans2);%%%%越小越好
                k1=k;q1=4;
            else if sum1/(length(ans1))==accuracy_12
                    if accuracy_13<sum2/length(ans2) %%%%越小越好
                        fitresult = fitresult1;
                        accuracy_13 = sum2/length(ans2);%%%%越小越好
                        k1=k;q1=4;
                    end
            end
            end
    end
    end
%    end
end










%%%%%%%%%%%%%%%%%%%%%%%%%%下面曲线
for k = 10:5:30
     for m=1:3

    
%     [~,I1]=mink(num1_hos,k);%找到索引
%     num1_use = zeros(2,length(I1));
%     for i=1:k
%         
%         num1_use(:,i)=num1(:,I1(i));
%     end
% 
%     n1=length(num1_use);
%     num11=num1_use(1,:);
%     num12=num1_use(2,:);


    [~,I2]=mink(num2_hos,m*k);
    num2_use = zeros(2,length(I2));

    for i=1:m*k
        num2_use(:,i)=num2(:,I2(i));
    end

    n2=length(num2_use);
    num21=num2_use(1,:);
    num22=num2_use(2,:);
    % plot(num1_use(1,:),num1_use(2,:),'b*')
    % hold on
    % plot(num2_use(1,:),num2_use(2,:),'r*')
    % xlabel('风速')
    % ylabel('校正后的逆温强度')
    % yline(0)
    
    %%%%统计出曲线上下的点的个数for 
    %%%%%%%%%%%%%%%%%power
    [fitresult1, ~] = power1(num21, num22, num1);
    y2=fitresult1(num2(1,:));
    ans1=y2'<num2(2,:);%曲线上方的点为对，0是错
    y1=fitresult1(num1(1,:));
    ans2=y1'<num1(2,:);%曲线上方的点为错，1是错
    
    sum1 = sum(ans1);
    sum2 = sum(ans2);
    
    if sum1/(sum1+sum2)>accuracy_21
        accuracy_21 = sum1/(sum1+sum2);%%%越大越好
        fitresult_d = fitresult1;
        accuracy_22 = sum1/(length(ans1));%%%%%越大越好
        accuracy_23 = sum2/length(ans2);%%%%越小越好

        k2=m*k;q2=1;
    else if sum1/(sum1+sum2)==accuracy_21
            if sum1/(length(ans1))>accuracy_22
                fitresult_d = fitresult1;
                accuracy_22 = sum1/(length(ans1));%%%%%越大越好
                accuracy_23 = sum2/length(ans2);%%%%越小越好
                k2=m*k;q2=1;
            else if sum1/(length(ans1))==accuracy_22
                    if accuracy_23<sum2/length(ans2) %%%%越小越好
                        fitresult_d = fitresult1;
                        accuracy_23 = sum2/length(ans2);%%%%越小越好
                        k2=m*k;q2=1;
                    end
            end
            end
    end
    end
    
    %%%%%%%%%%%%%%%%%exp1
    [fitresult1, ~] = exp1(num21, num22, num1);
    y2=fitresult1(num2(1,:));
    ans1=y2'<num2(2,:);%曲线上方的点为对，0是错
    y1=fitresult1(num1(1,:));
    ans2=y1'<num1(2,:);%曲线上方的点为错，1是错
    
    sum1 = sum(ans1);
    sum2 = sum(ans2);
    
    if sum1/(sum1+sum2)>accuracy_21
        accuracy_21 = sum1/(sum1+sum2);%%%越大越好
        fitresult_d = fitresult1;
        accuracy_22 = sum1/(length(ans1));%%%%%越大越好
        accuracy_23 = sum2/length(ans2);%%%%越小越好

        k2=m*k;q2=1;
    else if sum1/(sum1+sum2)==accuracy_21
            if sum1/(length(ans1))>accuracy_22
                fitresult_d = fitresult1;
                accuracy_22 = sum1/(length(ans1));%%%%%越大越好
                accuracy_23 = sum2/length(ans2);%%%%越小越好
                k2=m*k;q2=1;
            else if sum1/(length(ans1))==accuracy_22
                    if accuracy_23<sum2/length(ans2) %%%%越小越好
                        fitresult_d = fitresult1;
                        accuracy_23 = sum2/length(ans2);%%%%越小越好
                        k2=m*k;q2=1;
                    end
            end
            end
    end
    end
    
    %%%%%%%%%%%%%%%%rat1
    [fitresult1, ~] = rat1(num21, num22, num1);
    y2=fitresult1(num2(1,:));
    ans1=y2'<num2(2,:);%曲线上方的点为对，0是错
    y1=fitresult1(num1(1,:));
    ans2=y1'<num1(2,:);%曲线上方的点为错，1是错
    
    sum1 = sum(ans1);
    sum2 = sum(ans2);
    
    if sum1/(sum1+sum2)>accuracy_21
        accuracy_21 = sum1/(sum1+sum2);%%%越大越好
        fitresult_d = fitresult1;
        accuracy_22 = sum1/(length(ans1));%%%%%越大越好
        accuracy_23 = sum2/length(ans2);%%%%越小越好

        k2=m*k;q2=1;
    else if sum1/(sum1+sum2)==accuracy_21
            if sum1/(length(ans1))>accuracy_22
                fitresult_d = fitresult1;
                accuracy_22 = sum1/(length(ans1));%%%%%越大越好
                accuracy_23 = sum2/length(ans2);%%%%越小越好
                k2=m*k;q2=1;
            else if sum1/(length(ans1))==accuracy_22
                    if accuracy_23<sum2/length(ans2) %%%%越小越好
                        fitresult_d = fitresult1;
                        accuracy_23 = sum2/length(ans2);%%%%越小越好
                        k2=m*k;q2=1;
                    end
            end
            end
    end
    end
    
    %%%%%%%%%%%%%%%%%weibull1
    [fitresult1, ~] = weibull1(num21, num22, num1);
    y2=fitresult1(num2(1,:));
    ans1=y2'<num2(2,:);%曲线上方的点为对，0是错
    y1=fitresult1(num1(1,:));
    ans2=y1'<num1(2,:);%曲线上方的点为错，1是错
    
    sum1 = sum(ans1);
    sum2 = sum(ans2);
    
    if sum1/(sum1+sum2)>accuracy_21
        accuracy_21 = sum1/(sum1+sum2);%%%越大越好
        fitresult_d = fitresult1;
        accuracy_22 = sum1/(length(ans1));%%%%%越大越好
        accuracy_23 = sum2/length(ans2);%%%%越小越好

        k2=m*k;q2=1;
    else if sum1/(sum1+sum2)==accuracy_21
            if sum1/(length(ans1))>accuracy_22
                fitresult_d = fitresult1;
                accuracy_22 = sum1/(length(ans1));%%%%%越大越好
                accuracy_23 = sum2/length(ans2);%%%%越小越好
                k2=m*k;q2=1;
            else if sum1/(length(ans1))==accuracy_22
                    if accuracy_23<sum2/length(ans2) %%%%越小越好
                        fitresult_d = fitresult1;
                        accuracy_23 = sum2/length(ans2);%%%%越小越好
                        k2=m*k;q2=1;
                    end
            end
            end
    end
    end


    end
end


x=2:0.25:22;
plot(num1(1,:),num1(2,:),'r*')
hold on
plot(x,fitresult(x))
hold on
plot(num2(1,:),num2(2,:),'b*')
hold on
plot(x,fitresult_d(x))

% hold on
% plot(num2(1,:),num2(2,:),'r*');
% hold off 
% 
% [fitresult2, ~] = exp1(num11, num12, num1);
% hold on
% plot(num2(1,:),num2(2,:),'r*');
% hold off 
% 
% [fitresult3, ~] = rat1(num11, num12, num1);
% hold on
% plot(num2(1,:),num2(2,:),'r*');
% hold off 
% 
% 
% [fitresult4, ~] = weibull1(num11, num12, num1);
% hold on
% plot(num2(1,:),num2(2,:),'r*');
% hold off 
% 
% [fitresult5, ~] = power1(num21, num22, num2);
% hold on
% plot(num1(1,:),num1(2,:),'r*');
% hold off 
% 
% [fitresult6, ~] = exp1(num21, num22, num2);
% hold on
% plot(num1(1,:),num1(2,:),'r*');
% hold off 
% 
% [fitresult7, ~] = rat1(num21, num22, num2);
% hold on
% plot(num1(1,:),num1(2,:),'r*');
% hold off 
% 
% 
% [fitresult8, ~] = weibull1(num21, num22, num2);
% hold on
% plot(num1(1,:),num1(2,:),'r*');
% hold off 
% 
% end




% % 删除距离最小的k个值
% for i=1:k
%     num1(2,I1(i))=NaN;
% end
% 
% for i=1:m*k
%     num2(2,I2(i))=NaN;
% end
% 
% % % 删除超过区域的点
% % [~,I2_1]=mink(num2(2,:),5);
% % for j=1:5
% %     num(2,I2_1(j))=NaN;
% % end
% % 
% %得到去除干扰点之后的散点分布
% [~,b1]=find(isnan(num1));
% [~,b2]=find(isnan(num2));
% num1(:,b1)=[];num2(:,b2)=[];
% % % % 
% %保证80%的的同类点都被曲线包裹
% k=0.4;
% n1=length(num1);
% n11=floor(k*n1);
% n2=length(num2);
% n22=floor(k*n2);
% [~,I1_2]=mink(num1(1,:).*num1(2,:),n11);
% [~,I2_2]=maxk(num2(1,:).*num2(2,:),n22);%位于曲线下方的点进行保留，使用乘积判断
% num1_val1=num1(1,I1_2');num1_val2=num1(2,I1_2');num2_val1=num2(1,I2_2');num2_val2=num2(2,I2_2');%保留结果60%de的点
% for j=1:n11
%     num1(2,I1_2(j))=NaN;
% end
% for j=1:n22
%     num2(2,I2_2(j))=NaN;
% end
% [~,b1]=find(isnan(num1));
% [~,b2]=find(isnan(num2));
% 
% num1(:,b1)=[];num2(:,b2)=[];
% 
% %使用各20-30对点进行拟合，调整轮廓
% n1=length(num1);
% n2=length(num2);
% 
% num11=num1(1,:);
% num12=num1(2,:);
% num21=num2(1,:);
% num22=num2(2,:);
% plot(num1(1,:),num1(2,:),'b*')
% hold on
% plot(num2(1,:),num2(2,:),'r*')
% xlabel('风速')
% ylabel('校正后的逆温强度')
% yline(0)




