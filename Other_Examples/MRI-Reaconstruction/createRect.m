function rect = createRect(width, total)
    rect(1:(total/2-width/2)) = 0;
    rect((total/2-width/2)+1:(total/2+width/2)) = 1;
    rect((total/2+width/2+1):total) = 0;
end
