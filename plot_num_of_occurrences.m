 %����״̬��ʱ��仯���ִ���ͼ
Time_point=104;
y=zeros(100,104);
for plotK=1:6
    for i= 2:length(num_of_occurrences)    
           x = 1:104;
           matrix_change = num_of_occurrences{i};
           y(i,:) =matrix_change(plotK,:);
           
           figure(plotK),plot(matrix_change(plotK,:),'color',[0.5 0.5 0.5]);%����ͼ��������ɫ���߿�
           title(['number of occurences of state  ',num2str(plotK),]);
           xlabel('Time(s)');
           ylabel('Number of occurrences');
%            set(gca,'YTick',[1:5:max( matrix_all_change(plotK,:))]);%����y��̶ȣ�gcaָ����ǰͼ����y����ӿ̶�
%            set(gca,'XTick',[0:10:104]);%����y��̶�
           box off;%ȥ�������߿�̶���
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
%        set(gca,'YTick',[1:4:size(matrix_change,1)]);%����y��̶ȣ�gcaָ����ǰͼ����y����ӿ̶�
%        set(gca,'XTick',[0:10:104]);%����y��̶�
       %axis([0 Time_point*(length(num_of_occurrences)-1)  0  1]);
       hold on    %ԭͼ�ϻ�ͼ
       arg = polyfit(x,y,1);
       S=polyval(arg,x);          %��ȡ��ϲ���
       plot(x,S,'r','LineWidth',2)%�Ӵ�
       box off;                 %ȥ���ұߺ�����ĺ���
       set(gcf,'Color',[1 1 1]) %���߿򲿷ֻ�ɫ��Ϊ��ɫ
       hold off;  %ԭͼ�ϻ�ͼ����
       gtext(['��=',num2str(arg(1))]) %����ʽ��дб��
       cd G:\GranduationProject\sport\num_of_occurrences\pingpong;
       saveas(gcf,['G:\GranduationProject\sport\num_of_occurrences\pingpong','\',num2str(plotK),'.jpg']); 
end
save('G:\GranduationProject\sport\num_of_occurrences\pingpong');
