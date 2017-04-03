clear all
clc
N=8;                        % Block size for which DCT is Computed.
M=8;
I=imread('cameraman.tif');  
% Reading the input image file and storing intensity values in 2-D matrix I.
%I=rgb2gray(I);
I_dim=size(I);              % Finding the dimensions of the image file.
for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
         I_Trsfrm(i,j).block=zeros(N,M); % Initialising the DCT Coefficients Structure Matrix "I_Trsfrm" with the required dimensions.
    end
end

Norm_Mat=[16 11 10 16 24 40 51 61       % Normalization matrix (8 X 8) used to Normalize the DCT Matrix.
          12 12 14 19 26 58 60 55
          14 13 16 24 40 57 69 56
          14 17 22 29 51 87 80 62
          18 22 37 56 68 109 103 77
          24 35 55 64 81 104 113 92
          49 64 78 87 103 121 120 101
          72 92 95 98 112 100 103 99];
 fun1 = @(block_struct) dct2(block_struct.data);
I2 = blockproc(I,[8 8],fun1);     % processing the individual (8X8) blocks
for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
        for a=1:N
            for b=1:M
               I_Trsfrm(i,j).block(a,b)=I2(N*(i-1)+a,M*(j-1)+b) ;% Assigning the DCT Coefficients to the structure Matrix "I_Trsfrm".
            end
        end
    end
end
     

for a=1:I_dim(1)/N
    for b=1:I_dim(2)/M
        I_Trsfrm(a,b).block=round(I_Trsfrm(a,b).block./Norm_Mat);% Quantization(Lossy) step.
    end
end

for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
   
        I_zigzag(i,j).block=zeros(1,N*M);
          % Initialising the 64X1 vector for zigzag traversal.
         
    end
end

for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
      
        I_zigzag(i,j).block=zigzag(I_Trsfrm(i,j).block);
            %Zigzag traversal of the individual 8x8 blocks
         
    end
end
for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
   
        I_runlength(i,j).block=RLE_encode(I_zigzag(i,j).block);
       
          % Zero run length encoding the individual 64x1 vector obtained
          % from zigzag traversal
          
         
    end
end
array=[] ;
for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
   
        array=vertcat(array,RLE2huff_byte(I_runlength(i,j).block));
       
          %converting the run length pairs to a byte which is huffman coded next 
    end
end
[sig_encoded dict symbol] = huffman( array(:,3) ); % huffman coing the run length pairs
huffman_coded=[] ; %initialisng the jpeg bitstream in which the image will be stored.
for i=1:length(array)
  y1=huffmanenco(array(i,3),dict);
  if(array(i,2)>=0)
   y2=(de2bi(array(i,2)))';  
  elseif(array(i,2)<0)
    y2=not(de2bi(abs(array(i,2))))';
  end
  y=vertcat(y1,y2) ;
  huffman_coded=vertcat(huffman_coded,y) ;
end
%c save('compressed.txt','huffman_coded');
%/////////////////////////JPEG-Decoder//////////////////////////////
%{
c=huffman2rle(huffman_coded,dict,array );
arr=zeros(1,2) ;
r=1 ;
le=1 ;
for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
     for k=le:length(c)
        if isequal(c(k,:),[0 0])==1
          arr(r,:)=[0,0] ;
         I_runlength(i,j).block=arr ;
         arr=[] ;
         r=1 ;
         le=le+1 ;
         break
        else
         arr(r,:)=c(k,:);
         le=le+1 ;
         r=r+1;
    end
     end
    end
end
%}



for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
   
        I_runlengthdecode(i,j).block=RLE_decode(I_runlength(i,j).block,N*M);
       
          % Initialising the DCT Coefficients Structure Matrix "I_Trsfrm" with the required dimensions.
         
    end
end
for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
   
        I_zigzagdecode(i,j).block=izigzag(I_runlengthdecode(i,j).block,N,M);
       
          % Initialising the DCT Coefficients Structure Matrix "I_Trsfrm" with the required dimensions.
         
    end
end
for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
   
       
               I_Trsfrm_norminverse(i,j).block=round(I_zigzagdecode(i,j).block.*Norm_Mat);
          % Initialising the DCT Coefficients Structure Matrix "I_Trsfrm" with the required dimensions.
         
    end
end

for i=1:I_dim(1)/N
    for j=1:I_dim(2)/M
        for a=1:N
            for b=1:M
               I_rec(N*(i-1)+a,M*(j-1)+b)=I_Trsfrm_norminverse(i,j).block(a,b) ;
            end
        end
    end
end
fun2 = @(block_struct) idct2(block_struct.data);
I_rec = blockproc(I_rec,[8 8],fun2);

 
I_rec=mat2gray(I_rec);
figure(1);imshow(I);title('original image');
figure(2);imshow(I_rec);title('restored image from dct');









