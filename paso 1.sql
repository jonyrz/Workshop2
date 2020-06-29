CREATE OR REPLACE PACKAGE video_pkg IS PROCEDURE  
new_member(p_lname IN member.last_name%TYPE DEFAULT NULL,
 	  p_fname IN member.first_name%TYPE DEFAULT NULL,
 	  p_address IN member.address%TYPE DEFAULT NULL,
 	  p_city IN member.city%TYPE DEFAULT NULL,
 	  p_phone IN member.phone%TYPE DEFAULT NULL);
	FUNCTION
	new_rental(p_memberid  IN rental.member_id%TYPE,
	  p_titleid IN rental.title_id%TYPE) 
	RETURN  DATE;
	FUNCTION 
	new_rental(p_membername IN member.last_name%TYPE,
	  p_titleid IN rental.title_id%TYPE)
	RETURN DATE;
	PROCEDURE return_movie(p_titleid IN rental.title_id%TYPE,
	  p_copyid IN rental.copy_id%TYPE,
	  p_sts IN title_copy.status%TYPE);
END video_pkg;
/
SHOW ERRORS