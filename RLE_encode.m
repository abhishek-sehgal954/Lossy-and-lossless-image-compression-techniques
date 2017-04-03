% Run Length Encoder
 
function encoded = RLE_encode(input)
 encoded=zeros(0,2) ;
 flag=0 ;
length = size(input,2);
 run_length=0 ;
encoded(1,:)=[0,input(1)];
 j=1 ;
 if length > 1
for i=1:length
    
    if input(i) ==0
        if(isequal(input(i:length),zeros(1,length-i+1))==1)
          encoded(j,:)=[0,0] ;
          break
        end 
         if run_length==15
       encoded(j,:)=[15,0] ;
        run_length = 0;
        j=j+1 ;
        flag=1 ;
         end
       if run_length <=15&&flag==0
         run_length=run_length+1 ;  
       end   
       else
        encoded(j,:)=[run_length,input(i)];
        j=j+1 ;
        run_length=0 ;
    end
flag=0 ;     
end
else
    % Special case if input is of length 1
    encoded = [input(1),1];
 end
end

