%limtingBistribution
%averageTM
subject_state=zeros(20,104);
a=zeros(6,6);
avg=zeros(6,6);
for w=1:20
    subject_state(w,:)=row(w,:);
    for m=1:1:103
        for i=1:1:6
            for j=1:1:6
                if (i==subject_state(w,m) && j==subject_state(w,m+1))
                    a(i,j)= a(i,j)+1;
                end
            end
            %avg(i,j)=a(i,j)/(sum(a(i,:)));%jÿ��Ϊ6��
        end
    end
end

for i = 1:6
    for j = 1:6
        avg(i,j) = a(i,j)/sum(a(i,:));
    end
end
%limiting distribution
avg_tranposition=(avg)';
avg_add=[];
constantM=zeros(6,1);
for j=1:6
    avg_add=[avg_add 1];%pi1+pi2+pi3+...=1 ��ԭ����������һ��
    avg_tranposition(j,j)=avg_tranposition(j,j)-1;%��δ֪piԪ��ϵ���Ƶ�ϵ�������У�ת��Ϊ��������󣬷���ֱ�����
end
constantM=[constantM;1];
avg_add1=[avg_tranposition; avg_add];
%pi = pinv(avg_add1)*constantM;%����������ʹ��pinv
avg_add_constantM=[avg_add1 constantM];%�õ��������
det_avg=det(avg_add_constantM);
if det_avg ~= 0
    disp('this matix has solution');
else
    disp('no solution');
end

ravg=rref(avg_add_constantM);
Aavg=ravg(1:6,1:6);
bavg=ravg(1:6,7);
pi=Aavg\bavg;
pi_transposition=(pi)';
ccc=pi_transposition * avg;%��֤�Ƿ���ȷ
disp('the limting distribution has an unique solution.');
x=[1,2,3,4,5,6];
pi_100=pi*100;%���ջ����ٷֱ�ͼ
figure(23),scatter(x,pi_100,'r','o');%����ͼ��������ɫ������ԲȦ
title('Steady-state Behavior');
xlabel('State');
ylabel('Stationary probability(%)');
set(gca,'YTick',[0:((max(pi_100)-min(pi_100))/6):max(pi_100)]);%����y��̶ȣ�gcaָ����ǰͼ����y����ӿ̶�
set(gca,'XTick',[0:1:6]);%����x��̶�
box off;%ȥ�������߿�̶���
hold on
saveas(gcf,['G:\GranduationProject\sport\averageTM\pingpong\Steady_stateBehavior.jpg']);
save('G:\GranduationProject\sport\averageTM\pingpong','pi');
save('G:\GranduationProject\sport\averageTM\pingpong');
