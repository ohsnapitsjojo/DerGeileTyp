function [result] = free2set_2(field, m, n, m_dir, n_dir, colour, mode)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
 
    %Zeigt die Richtung aus dem Spielfeld abbrechen
    if ((m + m_dir) > 8) || ((m + m_dir) < 1) || ((n + n_dir) > 8) || ((n + n_dir) < 1)
        result = 0;
        return;
    end

    if mode == 1
        if field(m + m_dir, n + n_dir) == colour
            %Grenzt in die Richtung die eigene Farbe an abbrechen
            result = 0;
            return;
        elseif field(m + m_dir, n + n_dir) == 0
            %Grenzt in die Richtung eine 0 abbrechen
            result = 0;
            return;
        else
            %Grenzt in die Richtung eine -1 weiter prüfen
            result = free2set_2(field, m + m_dir, n + n_dir, m_dir, n_dir, colour, 2);
            return;
        end
    end
    
    if mode == 2
        if field(m + m_dir, n + n_dir) == colour
            %Grenzt in die Richtung die eigene Farbe an abbrechen
            result = 1;
            return;
        elseif field(m + m_dir, n + n_dir) == 0
            %Grenzt in die Richtung eine 0 abbrechen
            result = 0;
            return;
        else
            %Grenzt in die Richtung eine -1 weiter prüfen
            result = free2set_2(field, m + m_dir, n + n_dir, m_dir, n_dir, colour, 2);
            return;
        end        
    end
    

end

