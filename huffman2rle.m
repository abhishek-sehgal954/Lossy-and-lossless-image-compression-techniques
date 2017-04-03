function [ c] = huffman2rle(huffman_coded,dict,array )
i=1;
l=1 ;
c=zeros(1,2) ;
while(i <=length(huffman_coded))
flag=0 ;
for j=0:12
    for k=1:size(dict,1)
    if(isequal(huffman_coded(i:i+j),dict{k,2}')==1)
        flag=1 ; 
        huffman_coded(i:i+j);
        i;
        j ;
        break
    end
    end
    if(flag==1)
        break
    end
end
  a=huffman_coded(i:i+j);
  num=huffmandeco(a,dict);
   arr=de2bi(num,8);
   
  c(l,1)=bi2de(arr(1:4)) ;
  len=bi2de(arr(5:8));
  if(isequal((huffman_coded(i+j+1:i+j+len)'),de2bi(bi2de(huffman_coded(i+j+1:i+j+len)')))==0)
      val=not(huffman_coded(i+j+1:i+j+len));
      c(l,2)= -bi2de(val');
  else
  c(l,2)=bi2de(huffman_coded(i+j+1:i+j+len)');
  end
  i=i+j+len+1 ;
 l=l+1 ;
end
for i=1:length(array)
    if(isequal(array(i,2),c(i,2))==0)
        c(i,2)=-1 ;
    end
end
end

