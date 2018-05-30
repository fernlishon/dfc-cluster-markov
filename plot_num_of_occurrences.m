 %作各状态随时间变化出现次数图
Time_point=104;
y=zeros(100,104);
for plotK=1:6
    for i= 2:length(num_of_occurrences)    
           x = 1:104;
           matrix_change = num_of_occurrences{i};
           y(i,:) =matrix_change(plotK,:);
           
           figure(plotK),plot(matrix_change(plotK,:),'color',[0.5 0.5 0.5]);%做线图，设置颜色，线宽
           title(['number of occurences of state  ',num2str(plotK),]);
           xlabel('Time(s)');
           ylabel('Number of occurrences');
%            set(gca,'YTick',[1:5:max( matrix_all_change(plotK,:))]);%设置y轴刻度，gca指代当前图，向y轴添加刻度
%            set(gca,'XTick',[0:10:104]);%设置y轴刻度
           box off;%去除整个边框刻度线
           %figure(plotK),plot(x,y,'Color',[0.5 0.5 0.5]);
           %axis([0 Time_point 0 size(matrix_all_change,1)]); 
           hold on
    end    
   
       matrix_change = num_of_occurrences{1};
       x=1:Time_point;
       %y = matrix_change(plotK,:);
       %y=[y;matrix_change(plotK,:)];
       y=y(plotK,:);
       plot(matrix_change(plotK,:),'LineWidth',2);
%        set(gca,'YTick',[1:4:size(matrix_change,1)]);%设置y轴刻度，gca指代当前图，向y轴添加刻度
%        set(gca,'XTick',[0:10:104]);%设置y轴刻度
       %axis([0 Time_point*(length(num_of_occurrences)-1)  0  1]);
       hold on    %原图上绘图
       arg = polyfit(x,y,1);
       S=polyval(arg,x);          %获取拟合参数
       plot(x,S,'r','LineWidth',2)%加粗
       box off;                 %去掉右边和上面的黑线
       set(gcf,'Color',[1 1 1]) %将边框部分灰色改为白色
       hold off;  %原图上绘图结束
       gtext(['β=',num2str(arg(1))]) %交互式填写斜率
       cd G:\GranduationProject\sport\num_of_occurrences\pingpong;
       saveas(gcf,['G:\GranduationProject\sport\num_of_occurrences\pingpong','\',num2str(plotK),'.jpg']); 
end
save('G:\GranduationProject\sport\num_of_occurrences\pingpong');
