execute video_pkg.new_member('Haas', 'James', 'Chestnut Street', 'Boston', '617-123-4567')
execute video_pkg.new_member('Biri', 'Allan', 'Hiawatha Drive', 'New York', '516-123-4567')
EXEC DBMS_OUTPUT.PUT_LINE(video_pkg.new_rental(110,98))
EXEC DBMS_OUTPUT.PUT_LINE(video_pkg.new_rental(109,93))
EXEC DBMS_OUTPUT.PUT_LINE(video_pkg.new_rental(107,98))
EXEC DBMS_OUTPUT.PUT_LINE(video_pkg.new_rental('Biri',97))
EXEC DBMS_OUTPUT.PUT_LINE(video_pkg.new_rental(97,97))
--debe marcar error
EXEC DBMS_OUTPUT.PUT_LINE(video_pkg.new_rental(97,97));
END;