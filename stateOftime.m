%stateofTime����ʱ��仯��״̬ͼ
subject_state=zeros(20,104);
for w=1:20;
    subject_state(w,:)=row(w,:);
    figure(w),plot(subject_state(w,:),'color','black','LineWidth',2);%����ͼ��������ɫ���߿�
    %axis
    title(['State of Subject',' ',num2str(w)]);
    xlabel('Time');
    ylabel('State (Cluster)');
    set(gca,'YTick',[1:1:7]);%����y��̶ȣ�gcaָ����ǰͼ����y����ӿ̶�
    set(gca,'XTick',[0:10:104]);%����y��̶�
    box off;%ȥ�������߿�̶���
    % xl=xlim;
    % yl=ylim;
    % line([xl(1),xl(2)],[yl(2),yl(2)],'color','w');%����line����ϱ�����
    % line([xl(2),xl(2)],[yl(1),yl(2)],'color','w');%����line����ұ�����
    %hold on
    for i=1:1:6
        line([0 104],[i,i],'linestyle',':','color','k');
    end
    saveas(gcf,['G:\GranduationProject\sport\state_of_time(fig)\pingpong','\',num2str(w),'.jpg']);
end
save('G:\GranduationProject\sport\state_of_time(fig)\pingpong');