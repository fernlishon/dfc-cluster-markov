% load('G:\GranduationProject\sport\dFC\FCM\Chang_Dingtong\TV_Chang_Dingtong_FCM.mat')
% A=zeros(104,116*116);
% for i=1:1:104
%     t=full(FCM. Matrix{i});
%     B=reshape(t,1,116*116);%转成了向量！
%     A(i,116*116)=B(i);
% end
% 
% [idx,C] = kmeans(A,6);
% [idxbest,Cbest, sumDbest, Dbest]=kmeans(A,6);  [idx,C,sumd,D] = kmeans(___) returns distances from each point to every centroid in the n-by-k matrix D.

%对一个人104个窗进行聚类
load('G:\GranduationProject\sport\dFC\FCM\Chang_Dingtong\TV_Chang_Dingtong_FCM.mat')
%将106个116*116的矩阵化为104行、116*116的矩阵，将104个窗整合
A=zeros(104,116*116);
for i=1:1:104
    t=full(FCM. Matrix{i}) ;
    %脑区与其本身是完全相关的，在这里将相关系数矩阵对角线元素设为0，不但不会影响最终结果，而且使不同脑区间的相互关系更加显著
    t=t-diag(diag(t));
    b=t(:);
    for j=1:(116*116)
        A(i,j)=b(j);
    end
end




%kmeans聚类，将104个窗分类
[idx, C, sumD, D]=kmeans(A,6);

%计算各类矩阵占总矩阵个数比例
G=tabulate(idx);
vl=G(:,1);
ct=G(:,2);
perc=(G(:,3));

%得到每个类中心矩阵
%将matrix（即每行长度为116*116的6行矩阵）拆分成6个116*116的矩阵
E=C';
F=reshape(E,116,[]);%得到116*（116*6）的矩阵
m=116*ones(1,6);
mc=mat2cell(F,116,m);%mat2cell分块

%得到的质心做彩图
for u=1:1:6;
    ct=mc{1,u};
    s=num2str(round(G(u,3)));%四舍五入取整round，向上取整ceil()，向下取整floor()
    titlename=strcat('state',num2str(u),'   (proportion',':',s,'%)');
    figure(u),imagesc(ct,[min(ct(:)) max(ct(:))]),colormap(jet),colorbar,ylabel('component'),xlabel('component'),title(titlename);
end



% load('G:\GranduationProject\sport\dFC\FCM\Chang_Dingtong\TV_Chang_Dingtong_FCM.mat')
% A=zeros(104,116*116);
% for i=1:1:104
%     t=full(FCM. Matrix{i});
%     B=reshape(t,1,116*116);
%     for j=1:(116*116)
%            A(i,j)=B(j);
%     end
% end
% 
% [idx,C] = kmeans(A,6);
% % [idxbest,Cbest, sumDbest, Dbest]=kmeans(A,6);  
% [idx,C,sumd,D] = kmeans(___) returns distances from each point to every centroid in the n-by-k matrix D.
 
