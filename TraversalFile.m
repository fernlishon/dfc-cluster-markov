
%traversal file
pathroot='G:\GranduationProject\sport\dFC\HC_dfc\FCM';
list=dir(fullfile(pathroot));%得到20个运动员被试文件夹名
index=1;
A=zeros(20,104,116*116);%得到20个104*（116*116）的矩阵
for i=3:size(list,1)
    traversalFileName=list(i).name;%得到20个运动员文件夹子文件名
    sublist=dir(fullfile([pathroot,'\',list(i).name]));
    for j=3:size(sublist,1)
        load([pathroot,'\',list(i).name,'\',sublist(j).name]);%得到包含20运动员计算dFC后的104个窗的116个脑区间的FC矩阵的文件夹   
        for u=1:1:104
            t=full(FCM. Matrix{u}) ;
            %脑区与其本身是完全相关的，在这里将相关系数矩阵对角线元素设为0，不但不会影响最终结果，而且使不同脑区间的相互关系更加显著
            t=t-diag(diag(t));
            b=t(:,:);
            for v=1:(116*116)
                A(index,u,v)=b(v);
            end
        end
         index=index+1;
    end
end
%将20个人的104个窗按行组合
A_combain=[];
for index = 1:20
     A_combain = [A_combain;squeeze(A(index,:,:))];
end

%kmeans聚类，将20个人得到104个窗聚得六类
types = zeros(20*104);%新建20个人各窗所分的类得矩阵
center_points = zeros(6,116*116);%新建20个人六类质心位置矩阵
[idx, C]=kmeans(A_combain,6);%squeeze压缩无用数据
center_points=C;
row = reshape(idx,104,20)';

%计算各类矩阵占总矩阵个数比例
fullrow=row(:);
G=tabulate(fullrow);
perc=(G(:,3));

for i = 1:6
    mc{i} = reshape(center_points(i,:)',116,116);
end

%得到的质心做彩图
sort_G=sort(G(:,3));
for u=1:1:6;
    ct=mc{u};
    s=num2str(round(sort_G(u)));%四舍五入取整round，向上取整ceil()，向下取整floor()
    titlename=strcat('state',num2str(u),'   (proportion',':',s,'%)');
    figure(u),imagesc(ct,[min(ct(:)) max(ct(:))]),colormap(jet),colorbar,ylabel('component'),xlabel('component'),title(titlename);%为使分类结果更明显，将色标范围设为-0.5~最大值，一般情况用[min(ct(:) max(ct(:)]
    saveas(gcf,['G:\GranduationProject\sport\center_of_cluster(fig)\HC','\',num2str(u),'.jpg']);
end
