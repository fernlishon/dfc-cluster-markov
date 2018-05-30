%stateofTime做随时间变化的状态图
subject_state=zeros(20,104);
for w=1:20;
    subject_state(w,:)=row(w,:);
    figure(w),plot(subject_state(w,:),'color','black','LineWidth',2);%做线图，设置颜色，线宽
    %axis
    title(['State of Subject',' ',num2str(w)]);
    xlabel('Time');
    ylabel('State (Cluster)');
    set(gca,'YTick',[1:1:7]);%设置y轴刻度，gca指代当前图，向y轴添加刻度
    set(gca,'XTick',[0:10:104]);%设置y轴刻度
    box off;%去除整个边框刻度线
    % xl=xlim;
    % yl=ylim;
    % line([xl(1),xl(2)],[yl(2),yl(2)],'color','w');%可用line添加上边线条
    % line([xl(2),xl(2)],[yl(1),yl(2)],'color','w');%可用line添加右边线条
    %hold on
    for i=1:1:6
        line([0 104],[i,i],'linestyle',':','color','k');
    end
    saveas(gcf,['G:\GranduationProject\sport\state_of_time(fig)\pingpong','\',num2str(w),'.jpg']);
end
save('G:\GranduationProject\sport\state_of_time(fig)\pingpong');