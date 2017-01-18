function [ value_of_density ] = ValueOfDensity(b,color)

%%%%%%%%%%%%%%%%%%%%%% function is not used! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% function was initially used in EvaluateBoard(), but did not improve our%
% player; intention: find information (%%) at end of file                %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

our_stones = sum(sum(b==color));
enemy_stones = sum(sum(b==-color));

percentage = our_stones/enemy_stones;

if (percentage < 0.25)
    value_of_density = 1;
else
    value_of_density = 0;
end

%% Information:
% Wir haben verschiedene Prozentsaetze versucht. Leider hilft das nicht.  %
% Wir haben daraufhin das Board in ValueOfBoard angepasst. Also zunaechst %
% die inneren 16 Werte durch 10 geteilt. Dadurch wird auch der Innenraum  %
% nicht mehr so wertvoll. Dadurch gelingt es uns weniger im Inneren,      %
% mehr in den aeusseren Bereichen zu spielen.

end

