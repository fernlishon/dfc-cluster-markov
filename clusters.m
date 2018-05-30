% load('G:\GranduationProject\sport\dFC\FCM\Chang_Dingtong\TV_Chang_Dingtong_FCM.mat')
% A=zeros(104,116*116);
% for i=1:1:104
%     t=full(FCM. Matrix{i});
%     B=reshape(t,1,116*116);%ת����������
%     A(i,116*116)=B(i);
% end
% 
% [idx,C] = kmeans(A,6);
% [idxbest,Cbest, sumDbest, Dbest]=kmeans(A,6);  [idx,C,sumd,D] = kmeans(___) returns distances from each point to every centroid in the n-by-k matrix D.

%��һ����104�������о���
load('G:\GranduationProject\sport\dFC\FCM\Chang_Dingtong\TV_Chang_Dingtong_FCM.mat')
%��106��116*116�ľ���Ϊ104�С�116*116�ľ��󣬽�104��������
A=zeros(104,116*116);
for i=1:1:104
    t=full(FCM. Matrix{i}) ;
    %�������䱾������ȫ��صģ������ｫ���ϵ������Խ���Ԫ����Ϊ0����������Ӱ�����ս��������ʹ��ͬ��������໥��ϵ��������
    t=t-diag(diag(t));
    b=t(:);
    for j=1:(116*116)
        A(i,j)=b(j);
    end
end




%kmeans���࣬��104��������
[idx, C, sumD, D]=kmeans(A,6);

%����������ռ�ܾ����������
G=tabulate(idx);
vl=G(:,1);
ct=G(:,2);
perc=(G(:,3));

%�õ�ÿ�������ľ���
%��matrix����ÿ�г���Ϊ116*116��6�о��󣩲�ֳ�6��116*116�ľ���
E=C';
F=reshape(E,116,[]);%�õ�116*��116*6���ľ���
m=116*ones(1,6);
mc=mat2cell(F,116,m);%mat2cell�ֿ�

%�õ�����������ͼ
for u=1:1:6;
    ct=mc{1,u};
    s=num2str(round(G(u,3)));%��������ȡ��round������ȡ��ceil()������ȡ��floor()
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
 
