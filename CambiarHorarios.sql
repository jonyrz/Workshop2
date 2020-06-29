select sessiontimezone, to_char(CURRENT_DATE, 'DD-MON-YYYY HH24:MI')
curr_date
from dual;

alter session set time_zone ='-07:00';

execute video_pkg.new_member('Elias','Elliane', 'Vine street','California','789-123-4567');
begin video_pkg.new_member('Elias','Elliane', 'Vine street','California','789-123-4567');
end;
/

alter session set time_zone ='-00:00';
