CREATE OR REPLACE PACKAGE Body video_pkg IS
	PROCEDURE exception_handler(errcode IN NUMBER, context IN
		VARCHAR2) IS
	BEGIN
		IF errcode= -1 THEN
			RAISE_APPLICATION_ERROR(-20001,'El numero ya fue asignado a otro usario intente con otro');
		ELSIF errcode=-2291 THEN
			RAISE_APPLICATION_ERROR(-20002,context||'intento usar una FK invalida');
		ELSE
			RAISE_APPLICATION_ERROR(-20999,'Error no controlado in '|| context||' contacta al aldminsitrador con la siguiente informacion: '||CHR(13)||SQLERRM);
		END IF;
	END exception_handler;	
	PROCEDURE reserve_movie
		( memberid IN reservation.member_id%TYPE,
		  titleid IN reservation.title_id%TYPE
		) IS CURSOR rented_crs IS
			SELECT exp_ret_date
				FROM rental
				WHERE title_id=titleid
				AND act_ret_date IS NULL;
	BEGIN
		INSERT INTO reservation(res_date,member_id,title_id)
		VALUES (SYSDATE,memberid,titleid);
		COMMIT;
		FOR rented_rec IN rented_crs LOOP
			DBMS_OUTPUT.PUT_LINE('Pelicula reservada hasta: '||rented_rec.exp_ret_date);
			EXIT WHEN rented_crs%found;
		END LOOP;
  	EXCEPTION 
  		WHEN OTHERS THEN
  			exception_handler(SQLCODE, 'Pelicula reservada ');
  	END reserve_movie;

 	PROCEDURE return_movie
 	( titleid IN rental.title_id%TYPE,
 	  copyid IN rental.copy_id%TYPE,
 	  sts IN title_copy.status%TYPE
 	) IS v_dummy VARCHAR2(1);
 		CURSOR rented_crs IS
 			SELECT *
 			FROM reservation
 			WHERE title_id=titleid;
 	BEGIN
 		SELECT '' INTO v_dummy
 			FROM title
 			WHERE title_id=titleid;
 		UPDATE rental
 			SET act_ret_date = SYSDATE
 			WHERE title_id=titleid
 			AND copy_id=copyid AND act_ret_date IS NULL;
 		UPDATE title_copy
 			SET status=UPPER(sts)
 			WHERE title_id=titleid AND copy_id=copyid;
 		FOR res_rec IN rented_crs LOOP
 			IF rented_crs%FOUND THEN
 				DBMS_OUTPUT.PUT_LINE('Pelicula en espera fue reservada por el usuario: '||res_rec.member_id);
 			END IF;
 		END LOOP;
 	EXCEPTION
 		WHEN OTHERS THEN
 			exception_handler(SQLCODE,'Pelicula devuelta');
 	END return_movie;

 FUNCTION new_rental(memberid IN rental.member_id%TYPE,
 	titleid IN rental.title_id%TYPE) RETURN DATE IS CURSOR copy_csr IS 
 		SELECT  * FROM title_copy
 		WHERE title_id = titleid
 		FOR UPDATE;
 	flag BOOLEAN := FALSE;
 BEGIN
 	
 	FOR copy_rec IN copy_csr LOOP
 		IF copy_rec.status = 'AVAILABLE' THEN
 			UPDATE title_copy
 				SET status = 'RENTED'
 				WHERE CURRENT OF copy_csr;
 			INSERT INTO rental (book_date, copy_id, member_id, title_id, exp_ret_date)
 			VALUES (SYSDATE, copy_rec.copy_id, memberid, titleid, SYSDATE + 3);
 			flag := TRUE;
 			EXIT;
 		END IF;
 	END LOOP;
 	COMMIT;
 	IF flag THEN
 		RETURN (SYSDATE + 3);
 	ELSE
 		reserve_movie (memberid, titleid);
 		RETURN NULL;
 	END IF;
 EXCEPTION
 	WHEN OTHERS THEN
 		exception_handler(SQLCODE, 'NUEVO ALQUILER');
 END new_rental;

 FUNCTION new_rental(membername IN member.last_name%TYPE,
 	titleid IN rental.title_id%TYPE) RETURN DATE IS CURSOR copy_csr IS
 		SELECT * FROM title_copy
 			WHERE title_id = titleid
 			FOR UPDATE;
 		flag BOOLEAN := FALSE;
 		memberid member.member_id%TYPE;
 		CURSOR member_csr IS
 			SELECT member_id, last_name, first_name
 				FROM member
 				WHERE lower (last_name) = LOWER (membername)
 				ORDER BY last_name, first_name;
BEGIN 
	SELECT member_id INTO memberid
		FROM member
		WHERE lower (last_name) = lower (membername);
	FOR copy_rec IN copy_csr LOOP
		IF copy_rec.status = 'AVAILABLE' THEN
			UPDATE title_copy
				SET status = 'RENTED'
				WHERE CURRENT OF copy_csr;
			INSERT INTO rental (book_date, copy_id, member_id, title_id,exp_ret_date)
			VALUES ( SYSDATE, copy_rec.copy_id,memberid, titleid, SYSDATE  + 3);
			flag := TRUE;
			EXIT;
		END IF;
	END LOOP;
	COMMIT;
	IF flag THEN
		RETURN (SYSDATE +3);
	ELSE
		reserve_movie (memberid, titleid);
		RETURN NULL;
	END IF;
 EXCEPTION
 	WHEN TOO_MANY_ROWS THEN
 		DBMS_OUTPUT.PUT_LINE(
 		'Precaución más de un usuario tiene este nombre.');
 		FOR member_rec IN member_csr LOOP
 			DBMS_OUTPUT.PUT_LINE (member_rec.member_id || CHR (9) || member_rec.last_name || ', '|| member_rec.first_name);
 		END LOOP;
 		RETURN NULL;
 	WHEN OTHERS THEN
 		exception_handler (SQLCODE, 'NUEVO ALQUILER');
 END new_rental; 
 PROCEDURE new_member (
 	lname IN member.last_name%TYPE,
 	fname IN member.first_name% TYPE  DEFAULT NULL,
 	address IN member.address%TYPE DEFAULT NULL,
 	city IN member.city%TYPE DEFAULT NULL,
 	phone IN member.phone%TYPE DEFAULT NULL) IS 
BEGIN 
	INSERT INTO member(member_id, last_name, first_name,
				address, city, phone, join_date)
	VALUES(member_id_seq.NEXTVAL, lname, fname, address, city, phone, SYSDATE);
	COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
			exception_handler(SQLCODE, 'new_member');
		end new_member;
	end video_pkg;
/
show errors