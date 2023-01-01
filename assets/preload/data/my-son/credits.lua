function onEndSong()
	if not allowEnd then
		startVideo('credits');
		allowEnd = true;
		return Function_Stop;
	end
	return Function_Continue;
end