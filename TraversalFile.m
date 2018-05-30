
%traversal file
pathroot='G:\GranduationProject\sport\dFC\HC_dfc\FCM';
list=dir(fullfile(pathroot));%�õ�20���˶�Ա�����ļ�����
index=1;
A=zeros(20,104,116*116);%�õ�20��104*��116*116���ľ���
for i=3:size(list,1)
    traversalFileName=list(i).name;%�õ�20���˶�Ա�ļ������ļ���
    sublist=dir(fullfile([pathroot,'\',list(i).name]));
    for j=3:size(sublist,1)
        load([pathroot,'\',list(i).name,'\',sublist(j).name]);%�õ�����20�˶�Ա����dFC���104������116���������FC������ļ���   
        for u=1:1:104
            t=full(FCM. Matrix{u}) ;
            %�������䱾������ȫ��صģ������ｫ���ϵ������Խ���Ԫ����Ϊ0����������Ӱ�����ս��������ʹ��ͬ��������໥��ϵ��������
            t=t-diag(diag(t));
            b=t(:,:);
            for v=1:(116*116)
                A(index,u,v)=b(v);
            end
        end
         index=index+1;
    end
end
%��20���˵�104�����������
A_combain=[];
for index = 1:20
     A_combain = [A_combain;squeeze(A(index,:,:))];
end

%kmeans���࣬��20���˵õ�104�����۵�����
types = zeros(20*104);%�½�20���˸������ֵ���þ���
center_points = zeros(6,116*116);%�½�20������������λ�þ���
[idx, C]=kmeans(A_combain,6);%squeezeѹ����������
center_points=C;
row = reshape(idx,104,20)';

%����������ռ�ܾ����������
fullrow=row(:);
G=tabulate(fullrow);
perc=(G(:,3));

for i = 1:6
    mc{i} = reshape(center_points(i,:)',116,116);
end

%�õ�����������ͼ
sort_G=sort(G(:,3));
for u=1:1:6;
    ct=mc{u};
    s=num2str(round(sort_G(u)));%��������ȡ��round������ȡ��ceil()������ȡ��floor()
    titlename=strcat('state',num2str(u),'   (proportion',':',s,'%)');
    figure(u),imagesc(ct,[min(ct(:)) max(ct(:))]),colormap(jet),colorbar,ylabel('component'),xlabel('component'),title(titlename);%Ϊʹ�����������ԣ���ɫ�귶Χ��Ϊ-0.5~���ֵ��һ�������[min(ct(:) max(ct(:)]
    saveas(gcf,['G:\GranduationProject\sport\center_of_cluster(fig)\HC','\',num2str(u),'.jpg']);
end
