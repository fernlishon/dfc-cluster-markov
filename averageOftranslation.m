%averageTM
subject_state=zeros(20,104);
a=zeros(20,6,6);
avg=zeros(6,6);
a_all_subject=zeros(6,6);
for w=1:20
    subject_state(w,:)=row(w,:);
    for m=1:1:103
        for i=1:1:6
            for j=1:1:6
                if (i==subject_state(w,m) && j==subject_state(w,m+1))
                    a(w,i,j)= a(w,i,j)+1;
                end
            end
            %avg(i,j)=a(i,j)/(sum(a(i,:)));%jÃ¿´ÎÎª6£¡
        end
    end
    a_all_subject=a_all_subject+squeeze(a(w,:,:));
end

for i = 1:6
    for j = 1:6
        avg(i,j) = a_all_subject(i,j)/sum(a_all_subject(i,:));
    end
end
save('G:\GranduationProject\sport\averageTM\pingpong\transMatrix','avg');
avg_n=zeros(6,6);
nn=0;
while(avg_n==0)
    avg_n=avg*avg;
    nn=nn+1;
end
save('G:\GranduationProject\sport\averageTM\pingpong\transMatrix','nn','avg_n');
avg_diag_zero=avg;
for i=1:6
    avg_diag_zero(i,i)=0;
end
        
%plotforAverage
figure(22),imagesc(avg_diag_zero,[min(avg_diag_zero(:)) max(avg_diag_zero(:))]),colormap(jet),colorbar,xlabel('state at t+1'),ylabel('state at t'),title('Average Transition Matrix');
saveas(gcf,['G:\GranduationProject\sport\averageTM\pingpong\averageTM.jpg']);
save('G:\GranduationProject\sport\averageTM\pingpong');
     