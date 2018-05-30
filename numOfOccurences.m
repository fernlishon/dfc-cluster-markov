%1
%traversal file
pathroot='G:\GranduationProject\sport\dFC\pingpong_dfc\FCM';
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

%进行100次重采样，确定初始类稳定性
A_combain=[];
row_state=zeros(20,104);
%matrix_all_change=[];
for bstp = 1:101%因第一次是全部原始数据采集，故之后100次为重采样
    length_subject = size(A,1);%得到20个运动员
    if bstp == 1%按原始数据取出
        %将20个人的104个窗按行组合
        for index = 1:20
             A_combain = [A_combain;squeeze(A(index,:,:))];
        end
        %kmeans聚类，将20个人得到104个窗聚得六类
        types = zeros(20*104);%新建20个人各窗所分的类得矩阵
        center_points = zeros(6,116*116);%新建20个人六类质心位置矩阵
        opts = statset('display','final');
        [idx, C]=kmeans(A_combain,6,'distance','cityblock',...
            'replicates',100,'options',opts);%squeeze压缩无用数据
        center_points=C;
        t1 = tabulate(idx);
        
        %get two groups center points
        %not change for following 8 rows!
        tf = strcmp(pathroot,'G:\GranduationProject\sport\dFC\HC_dfc\FCM');
        if tf == 1
            row = reshape(idx,104,20)';
            cp_pingpong = zeros(6,116*116);
            cp_HC = center_points;
            save('G:\GranduationProject\sport\center_of_cluster(fig)\HC','cp_HC','row');
            save('G:\GranduationProject\sport\center_of_cluster(fig)\HC');
        else
            cp_pingpong = center_points;
            %two center points exist,compute two centriods' correlation,unifies
            %the class
            if norm(cp_pingpong) ~= 0 & isempty(cp_HC) == 0 
                cp_HC_t=(cp_HC)';
                cp_pingpong_t = (cp_pingpong)';
                [corr_HC_pingpong,pval] = corr(cp_HC_t,cp_pingpong_t,'type','pearson');
                idx_idx = zeros(20*104,1);
                for i = 1:6
                    [max_row_i,max_column_i] = find(corr_HC_pingpong == max(max(corr_HC_pingpong)));
                    index = find(idx == max_column_i);
                    idx_idx(index) = max_row_i;
                    corr_HC_pingpong(max_row_i,:) = 0;
                    corr_HC_pingpong(:,max_column_i) =0;
                end
                t2 = tabulate(idx_idx);
                row = reshape(idx_idx,104,20)';
                save('G:\GranduationProject\sport\center_of_cluster(fig)\pingpong','cp_pingpong','row');
                save('G:\GranduationProject\sport\center_of_cluster(fig)\pingpong');
            end
        end
        %聚类结果中各时刻各状态出现次数
        label=zeros(6,104);
        for n = 1:6
            for m = 1:104
                state_n_ind=find(row(:,m)== n);%不确定21个人各窗出现的状态，若为向量，则用本方法。若为矩阵设可变矩阵ind[],ind=[ind xx],xx为循环中产生的新加入的新值; 
                num(m) = length(state_n_ind);%各时间点出现人数
                label(n,m) =  num(m) ; 
            end
        end
        num_of_occurrences{bstp} = label;
        %计算各类矩阵占总矩阵个数比例
        fullrow=row(:);
        G=tabulate(fullrow);
        perc=(G(:,3));

        for i = 1:6
            mc{i} = reshape(center_points(i,:)',116,116);
        end

        %得到的质心做彩图
        %sort_G=sort(G(:,3));%HC!!
        sort_G = G(:,3);%pingpong!!
        for u=1:1:6;
            ct=mc{u};
            s=num2str(round(sort_G(u)));%四舍五入取整round，向上取整ceil()，向下取整floor()
            titlename=strcat('state',num2str(u),'   (proportion',':',s,'%)');
            figure(u),imagesc(ct,[min(ct(:)) max(ct(:))]),colormap(jet),colorbar,ylabel('component'),xlabel('component'),title(titlename);%为使分类结果更明显，将色标范围设为-0.5~最大值，一般情况用[min(ct(:) max(ct(:)]
            saveas(gcf,['G:\GranduationProject\sport\center_of_cluster(fig)\pingpong','\',num2str(u),'.jpg']);
        end
    else%随机采样
        randnumber = 1+fix(length_subject *rand(1, length_subject)); %rand随机得到60个1以内均匀分布的实数 1+fix(365*rand(1,60))随机产生60个1到365之间的正数 fix去除小数部分取整
        for jj = 1:length(randnumber)%用size是指维数，这里size(randnumber)为1，造成错误。而length则为最大长度
        squeezeA=squeeze(A(randnumber(jj),:,:));
        %matrix_all_change =[matrix_all_change;squeeze(A(randnumber(jj),:,:))];
            %计算各窗所属类别
            for m=1:104
                for ind=1:6
                %distance(n,:)=sqrt(sum((squeezeA(m,:))-center_points_mean()).^2);
                distance(ind)=pdist2(squeezeA(m,:),center_points(ind,:),'euclidean');
                end
                [mindist(m),idxx(m)]=min(distance);
                %row(jj,m)=find(distance==mindist);%找到最短距离的索引
                row_state(jj,m)=(idxx(m));
            end
        end
        %各时刻各状态出现次数
        label=zeros(6,104);
        for n = 1:6
            for m = 1:104
                state_n_ind=find(row_state(:,m)== n);%不确定21个人各窗出现的状态，若为向量，则用本方法。若cp_HC为矩阵设可变矩阵ind[],ind=[ind xx],xx为循环中产生的新加入的新值; 
                num(m) = length(state_n_ind);%各时间点出现人数
                label(n,m) =  num(m) ; 
            end
        end
    end
    %kmeans聚类，将20个人得到104个窗分别聚的六类
%     types = zeros(20*104);%新建21个人各窗所分的类得矩阵
%     center_points = zeros(6,116*116);%新建21个人六类质心位置矩阵
    squeezeM=zeros(104,116*116);%压缩了21后的矩阵
    %row=zeros(20,104);%获取索引
     distance=zeros(1,6);%到质心距离
%     for jj = 1:length(randnumber)%用size是指维数，这里size(randnumber)为1，造成错误。而length则为最大长度
%         squeezeA=squeeze(A(randnumber(jj),:,:));
%         %matrix_all_change =[matrix_all_change;squeeze(A(randnumber(jj),:,:))];
%     end
%     [idx(jj), C]=kmeans(matrix_all_change,6);%squeeze压缩无用数据
%     row=reshape(idx(jj),104,20)';
%     center_points=C;
      %squeezeM=squeeze(matrix_all_change(jj,:,:));%squeeze(A(w,m,:))会将m也压缩掉
%      %计算21个人各窗所属类别
%     for m=1:104
%         for ind=1:6
%             %distance(n,:)=sqrt(sum((squeezeA(m,:))-center_points_mean()).^2);
%             distance(ind)=pdist2(squeezeA(m,:),center_points(ind,:),'euclidean');
%         end
%         [mindist(m),idxx(m)]=min(distance);
%         %row(jj,m)=find(distance==mindist);%找到最短距离的索引
%         row(jj,m)=(idxx(m));
%     end

    
    num_of_occurrences{bstp} = label;  
end  
