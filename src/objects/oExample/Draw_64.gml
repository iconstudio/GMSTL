/// @description Drawing preview
if !surface_exists(preview_surface)
	event_user(0)
else
	draw_surface(preview_surface, 0, 0)
