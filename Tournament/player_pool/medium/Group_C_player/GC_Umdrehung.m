function Brett = GC_Umdrehung( Brett,color,Pos_naechst_Zug)

    Brett(Pos_naechst_Zug(1),Pos_naechst_Zug(2))=color;
    %------------Spalte nach unten 
    Anzahl=0;
    flag=0;
    for k=Pos_naechst_Zug(1)+1:8
        %----------------------------------------------
        if Brett(k,Pos_naechst_Zug(2))==0
            flag=0; 
            break;
        end;
        %----------------------------------------------
        if Brett(k,Pos_naechst_Zug(2))==color
            flag=1; 
            break;
        end;
        %----------------------------------------------
        Anzahl=Anzahl+1;
        %----------------------------------------------
    end;
    if flag~=0
        Brett((Pos_naechst_Zug(1)+1):(Pos_naechst_Zug(1)+Anzahl),...
            Pos_naechst_Zug(2))=color;
    end;
    
    %------------Spalte nach oben
    Anzahl=0;
    flag=0;
    for k=Pos_naechst_Zug(1)-1:-1:1
        %----------------------------------------------
        if Brett(k,Pos_naechst_Zug(2))==0
            flag=0; 
            break;
        end;
        %----------------------------------------------
        if Brett(k,Pos_naechst_Zug(2))==color
            flag=1; 
            break;
        end;
        %----------------------------------------------
        Anzahl=Anzahl+1;
        %----------------------------------------------
    end;
    if flag~=0
        Brett((Pos_naechst_Zug(1)-Anzahl):(Pos_naechst_Zug(1)-1),...
            Pos_naechst_Zug(2))=color;
    end;
    %------------Zeile nach rechts
    Anzahl=0;
    flag=0;
    for k=Pos_naechst_Zug(2)+1:8
        %----------------------------------------------
        if Brett(Pos_naechst_Zug(1),k)==0
            flag=0;
            break;
        end;
        %----------------------------------------------
        if Brett(Pos_naechst_Zug(1),k)==color
            flag=1;
            break;
        end;
        %----------------------------------------------
        Anzahl=Anzahl+1;
        %----------------------------------------------
    end;
    if flag~=0
        Brett(Pos_naechst_Zug(1),(Pos_naechst_Zug(2)+1):...
             (Pos_naechst_Zug(2)+Anzahl))=color;
    end;
    %------------Zeile nach links
    Anzahl=0;
    flag=0;
    for k=Pos_naechst_Zug(2)-1:-1:1
        %----------------------------------------------
        if Brett(Pos_naechst_Zug(1),k)==0
            flag=0; 
            break;
        end;
        %----------------------------------------------
        if Brett(Pos_naechst_Zug(1),k)==color
            flag=1; 
            break;
        end;
        %----------------------------------------------
        Anzahl=Anzahl+1;
        %----------------------------------------------
    end;
    if flag~=0
        Brett(Pos_naechst_Zug(1),(Pos_naechst_Zug(2)-Anzahl):...
             (Pos_naechst_Zug(2)-1))=color;
    end;
    %------------Diagonal nach unten rechts
    Anzahl=0;
    flag=0;
    k=Pos_naechst_Zug(1)+1;
    m=Pos_naechst_Zug(2)+1;
    while k<9 && m<9
        %----------------------------------------------
        if Brett(k,m)==0
           flag=0;
            break;
        end;
        %----------------------------------------------
        if Brett(k,m)==color
           flag=1;
            break;
        end;
        %----------------------------------------------
        Anzahl=Anzahl+1;
        %----------------------------------------------
    k=k+1;
    m=m+1;
    end;
    if flag~=0
        for k=1:Anzahl
        Brett(Pos_naechst_Zug(1)+k,Pos_naechst_Zug(2)+k)=color;
        end;
    end;
    %------------Diagonal nach oben links
    Anzahl=0;
    flag=0;
    k=Pos_naechst_Zug(1)-1;
    m=Pos_naechst_Zug(2)-1;
    while k>0 && m>0
        %----------------------------------------------
        if Brett(k,m)==0
            flag=0; 
            break;
        end;
        %----------------------------------------------
        if Brett(k,m)==color
            flag=1;
            break;
        end;
        %----------------------------------------------
        Anzahl=Anzahl+1;
        %----------------------------------------------
    k=k-1;
    m=m-1;
    end;
    if flag~=0
        for k=1:Anzahl
        Brett(Pos_naechst_Zug(1)-k,Pos_naechst_Zug(2)-k)=color;
        end;
    end;

    %------------Diagonal nach unten links
    Anzahl=0;
    flag=0;
    k=Pos_naechst_Zug(1)+1;
    m=Pos_naechst_Zug(2)-1;
    while k<9 && m>0
        %----------------------------------------------
        if Brett(k,m)==0
           flag=0;
            break;
        end;
        %----------------------------------------------
        if Brett(k,m)==color
            flag=1;
            break;
        end;
        %----------------------------------------------
        Anzahl=Anzahl+1;
        %----------------------------------------------
    k=k+1;
    m=m-1;
    end;
    if flag~=0
        for k=1:Anzahl
        Brett(Pos_naechst_Zug(1)+k,Pos_naechst_Zug(2)-k)=color;
        end;
    end;
  %------------Diagonal nach oben rechts
    Anzahl=0;
    flag=0;
    k=Pos_naechst_Zug(1)-1;
    m=Pos_naechst_Zug(2)+1;
    while k>0 && m<9
        %----------------------------------------------
        if Brett(k,m)==0
           flag=0;
            break;
        end;
        %----------------------------------------------
        if Brett(k,m)==color
           flag=1;
            break;
        end;
        %----------------------------------------------
        Anzahl=Anzahl+1;
        %----------------------------------------------
    k=k-1;
    m=m+1;
    end;
    if flag~=0
        for k=1:Anzahl
        Brett(Pos_naechst_Zug(1)-k,Pos_naechst_Zug(2)+k)=color;
        end;
    end;
end

