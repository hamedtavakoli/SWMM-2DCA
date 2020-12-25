function [ value ] = GetSwmmElementsName( outFile)

    Fout = fopen(outFile, 'r');

    SEEK_SET = fseek(Fout,-24, 'eof');
    offset = fread(Fout,1,'uint');
    StartPos = fread(Fout,1,'uint');


    SEEK_SET = fseek(Fout, offset, 'bof');
    k=1;
    position = ftell(Fout);

    while position<StartPos
      n = fread(Fout,1,'uint');
      m = fread(Fout,n,'uchar=>char');
      value{k} = m;
      k=k+1;
      position = ftell(Fout);
    end  

    fclose(Fout);
  

end

