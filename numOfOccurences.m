%1
%traversal file
pathroot='G:\GranduationProject\sport\dFC\pingpong_dfc\FCM';
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

%����100���ز�����ȷ����ʼ���ȶ���
A_combain=[];
row_state=zeros(20,104);
%matrix_all_change=[];
for bstp = 1:101%���һ����ȫ��ԭʼ���ݲɼ�����֮��100��Ϊ�ز���
    length_subject = size(A,1);%�õ�20���˶�Ա
    if bstp == 1%��ԭʼ����ȡ��
        %��20���˵�104�����������
        for index = 1:20
             A_combain = [A_combain;squeeze(A(index,:,:))];
        end
        %kmeans���࣬��20���˵õ�104�����۵�����
        types = zeros(20*104);%�½�20���˸������ֵ���þ���
        center_points = zeros(6,116*116);%�½�20������������λ�þ���
        opts = statset('display','final');
        [idx, C]=kmeans(A_combain,6,'distance','cityblock',...
            'replicates',100,'options',opts);%squeezeѹ����������
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
        %�������и�ʱ�̸�״̬���ִ���
        label=zeros(6,104);
        for n = 1:6
            for m = 1:104
                state_n_ind=find(row(:,m)== n);%��ȷ��21���˸������ֵ�״̬����Ϊ���������ñ���������Ϊ������ɱ����ind[],ind=[ind xx],xxΪѭ���в������¼������ֵ; 
                num(m) = length(state_n_ind);%��ʱ����������
                label(n,m) =  num(m) ; 
            end
        end
        num_of_occurrences{bstp} = label;
        %����������ռ�ܾ����������
        fullrow=row(:);
        G=tabulate(fullrow);
        perc=(G(:,3));

        for i = 1:6
            mc{i} = reshape(center_points(i,:)',116,116);
        end

        %�õ�����������ͼ
        %sort_G=sort(G(:,3));%HC!!
        sort_G = G(:,3);%pingpong!!
        for u=1:1:6;
            ct=mc{u};
            s=num2str(round(sort_G(u)));%��������ȡ��round������ȡ��ceil()������ȡ��floor()
            titlename=strcat('state',num2str(u),'   (proportion',':',s,'%)');
            figure(u),imagesc(ct,[min(ct(:)) max(ct(:))]),colormap(jet),colorbar,ylabel('component'),xlabel('component'),title(titlename);%Ϊʹ�����������ԣ���ɫ�귶Χ��Ϊ-0.5~���ֵ��һ�������[min(ct(:) max(ct(:)]
            saveas(gcf,['G:\GranduationProject\sport\center_of_cluster(fig)\pingpong','\',num2str(u),'.jpg']);
        end
    else%�������
        randnumber = 1+fix(length_subject *rand(1, length_subject)); %rand����õ�60��1���ھ��ȷֲ���ʵ�� 1+fix(365*rand(1,60))�������60��1��365֮������� fixȥ��С������ȡ��
        for jj = 1:length(randnumber)%��size��ָά��������size(randnumber)Ϊ1����ɴ��󡣶�length��Ϊ��󳤶�
        squeezeA=squeeze(A(randnumber(jj),:,:));
        %matrix_all_change =[matrix_all_change;squeeze(A(randnumber(jj),:,:))];
            %��������������
            for m=1:104
                for ind=1:6
                %distance(n,:)=sqrt(sum((squeezeA(m,:))-center_points_mean()).^2);
                distance(ind)=pdist2(squeezeA(m,:),center_points(ind,:),'euclidean');
                end
                [mindist(m),idxx(m)]=min(distance);
                %row(jj,m)=find(distance==mindist);%�ҵ���̾��������
                row_state(jj,m)=(idxx(m));
            end
        end
        %��ʱ�̸�״̬���ִ���
        label=zeros(6,104);
        for n = 1:6
            for m = 1:104
                state_n_ind=find(row_state(:,m)== n);%��ȷ��21���˸������ֵ�״̬����Ϊ���������ñ���������cp_HCΪ������ɱ����ind[],ind=[ind xx],xxΪѭ���в������¼������ֵ; 
                num(m) = length(state_n_ind);%��ʱ����������
                label(n,m) =  num(m) ; 
            end
        end
    end
    %kmeans���࣬��20���˵õ�104�����ֱ�۵�����
%     types = zeros(20*104);%�½�21���˸������ֵ���þ���
%     center_points = zeros(6,116*116);%�½�21������������λ�þ���
    squeezeM=zeros(104,116*116);%ѹ����21��ľ���
    %row=zeros(20,104);%��ȡ����
     distance=zeros(1,6);%�����ľ���
%     for jj = 1:length(randnumber)%��size��ָά��������size(randnumber)Ϊ1����ɴ��󡣶�length��Ϊ��󳤶�
%         squeezeA=squeeze(A(randnumber(jj),:,:));
%         %matrix_all_change =[matrix_all_change;squeeze(A(randnumber(jj),:,:))];
%     end
%     [idx(jj), C]=kmeans(matrix_all_change,6);%squeezeѹ����������
%     row=reshape(idx(jj),104,20)';
%     center_points=C;
      %squeezeM=squeeze(matrix_all_change(jj,:,:));%squeeze(A(w,m,:))�ὫmҲѹ����
%      %����21���˸����������
%     for m=1:104
%         for ind=1:6
%             %distance(n,:)=sqrt(sum((squeezeA(m,:))-center_points_mean()).^2);
%             distance(ind)=pdist2(squeezeA(m,:),center_points(ind,:),'euclidean');
%         end
%         [mindist(m),idxx(m)]=min(distance);
%         %row(jj,m)=find(distance==mindist);%�ҵ���̾��������
%         row(jj,m)=(idxx(m));
%     end

    
    num_of_occurrences{bstp} = label;  
end  
