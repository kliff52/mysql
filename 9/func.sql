drop FUNCTION if exists second_format;
create FUNCTION second_format(seconds INT)
returns VARCHAR(255) deterministic
begin 
	declare days, hours, minutes int;
	set days = FLOOR (seconds / 86400);
	set seconds = seconds - days * 86400;
	set hours = FLOOR (seconds / 3600);
	set seconds = seconds - hours * 3600;
	set minutes = FLOOR(seconds / 60);
	set seconds = seconds - minuts * 60;
	
	return CONCAT(days, 'days',
				hours, 'hours',
				minutes, 'minuts',
				seconds, 'seconds');
end;