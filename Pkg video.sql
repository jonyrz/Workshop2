create or replace package video_pkg is
	procedure new_member(
		lname in member.last_name%type,
		fname in member.first_name%type default null,
		address in member.address%type default null,
		city in member.city%type default null,
		phone in member.phone%type default null
		);
	function new_rental(
		memberid in rental.member_id%type,
		titleid in rental.title_id%type)
		return date;
	function new_rental
	(membername in member.last_name%type,
		titleid in rental.title_id%type)
		return date;
	procedure return_movie
	(titleid in rental.title_id%type,
	 copyid in rental.copy_id%type,
	 sts in title_copy.status%type
		);
	end video_pkg;
	/