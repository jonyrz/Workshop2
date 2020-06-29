create or replace procedure time_check is
	BEGIN
	if  ((To_char(SYSDATE,'D') between 1 And 6) and (To_char(SYSDATE,'hh24') not
		between 8 and 22))
		or ((to_char(SYSDATE,'D')=7) and (to_char(SYSDATE,'hh24')  not between
		8 and 24)) THEN
		RAISE_APPLICATION_ERROR(-20999, 'Cambio de datos solo disponible en horas de trabajo');
		end if;
end time_check;
/
show errors

create or replace trigger member_trig
	before insert or update or delete on member
call time_check
/

create or replace trigger rental_trig
	before insert or update or delete on rental
call time_check
/

create or replace trigger title_copy_trig
	before insert or update or delete on title_copy
call time_check
/

create or replace trigger title_trig
	before insert or update or delete on title
call time_check
/

create or replace trigger reservation_trig
	before insert or update or delete on reservation
call time_check
/
