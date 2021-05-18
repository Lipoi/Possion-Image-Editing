function [A,B]=create_AB(image_A,mask_A,image_B,mask_B) % 
%假设插入的图片为方形
%image_A为插入图片
%mask_A为背景图片的模子，待插入部分为0，不插入部分为1
global number
[hxb,lxb,~]=find(mask_B==0);%找出待插入区域
B=zeros(length(hxb),1);%创建B
s=[hxb';lxb'];%2*length的矩阵
[s1,id1]=sort(s(1,:));%待插入x坐标升序
s_z=[s1;s(2,id1)];%将行下标和列下标的顺序整理为行优先
hxb=s_z(1,:);
lxb=s_z(2,:);
min_x=min(hxb);
min_y=min(lxb);
max_x=max(hxb);
max_y=max(lxb);
k=2;
for i=1:length(hxb)
    mask_B(hxb(i),lxb(i))=k;
    k=k+1;
end
if number==1
A=sparse(zeros(length(hxb),length(hxb)));
end
if number~=1
    A=0;
end
k=1;%k为正在填写A矩阵的第k行
for i=min_x:max_x
    for j=min_y:max_y
        if i==min_x||i==max_x||j==min_y||j==max_y
            if number==1%如果第一次运行该求A函数
                A(k,k)=1;
            end
            B(k)=image_B(i,j);%边界点B为其像素值
            k=k+1;
        end
        if i~=min_x && i~=max_x&&j~=min_y&&j~=max_y
            if number ==1
                A(k,mask_B(i-1,j)-1)=1;
                
                A(k,mask_B(i,j-1)-1)=1;
                
                A(k,mask_B(i,j+1)-1)=1;
                
                A(k,mask_B(i+1,j)-1)=1;
                
                A(k,mask_B(i,j)-1)=-4;
            end
            k=k+1;
        end
    end
end
%%
%求散度,将B补充完全
[A_hxb,A_lxb,~]=find(mask_A==0);
min_Ax=min(A_hxb);
min_Ay=min(A_lxb);
max_Ax=max(A_hxb);
max_Ay=max(A_lxb);
k=1;
for i=min_Ax:max_Ax
    for j=min_Ay:max_Ay
        if i==min_Ax||i==max_Ax||j==min_Ay||j==max_Ay
            k=k+1;
            continue;
        end
        B(k)=image_A(i-1,j)+image_A(i,j-1)+image_A(i,j+1)+image_A(i+1,j)-4*image_A(i,j);%非边界点B为散度
        k=k+1;
    end
end
number=number+1;
end