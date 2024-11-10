extends MainLoop

class_name NoSceneTreeLoop

##The resource ID of the viewport
var viewport:RID #Viewport
##The resource ID of the 2D canvas
var canvas:RID #CanvasLayer

##The resource ID of the Godot icon. 
var godot_icon_item:RID #CanvasItem
##The resource ID of the Godot icon texture.
var godot_icon_item_texture:RID #Texture2D

var godot_svg:Image = preload("res://icon.svg").get_image()

##The position of the Godot icon. Feel free to change this, the Vector2 is basically
##the Node2D.position
var icon_pos:Transform2D = Transform2D(0.0, Vector2(400, 400))

##The angle of the Godot icon.
var icon_angle:float

##Set up the Godot icon.
func setup_godot_icon() -> void:
	#create the canvas item for the Godot icon.
	godot_icon_item = RenderingServer.canvas_item_create()
	#create the texture to attach to the aforementioned canvas item
	godot_icon_item_texture = RenderingServer.texture_2d_create(godot_svg)
	#set the position and rotation of the canvas item
	RenderingServer.canvas_item_set_transform(godot_icon_item, icon_pos)
	#Attach the texture to the canvas item
	RenderingServer.canvas_item_add_texture_rect(godot_icon_item, Rect2(Vector2.ZERO, godot_svg.get_size()), godot_icon_item_texture)
	#make sure the canvas item is visible
	RenderingServer.canvas_item_set_visible(godot_icon_item, true)
	#attach the canvas item to the canvas so that it will be rendered
	RenderingServer.canvas_item_set_parent(godot_icon_item, canvas)

##Do per-frame render things, like spinning the icon.
func render(delta:float) -> void:
	#spin the icon value
	icon_angle = wrapf(icon_angle + delta, 0.0, PI * 2)
	#actually change the icon's rotation based on the above
	RenderingServer.canvas_item_set_transform(godot_icon_item, Transform2D(icon_angle, icon_pos.origin))

#called when the engine initializes
func _initialize() -> void:
	#create our viewport so we have something to attach our 2D canvas to.
	viewport = RenderingServer.viewport_create()
	#make a 2D canvas to render to
	canvas = RenderingServer.canvas_create()
	#attach the viewport we made to the canvas we also made
	RenderingServer.viewport_attach_canvas(viewport, canvas)
	#set the viewport we made to be the active viewport
	RenderingServer.viewport_set_active(viewport, true)
	
	var screen_size:Rect2i = DisplayServer.screen_get_usable_rect()
	#set the viewport to be a 720x720 window.
	RenderingServer.viewport_set_size(viewport, int(screen_size.size.x), int(screen_size.size.y))
	#attach the viewport to the screen so we can see it. It uses the same region of the screen
	#as DisplayServer.screen_get_usable_rect(), regardless of viewport size.
	RenderingServer.viewport_attach_to_screen(viewport, Rect2(Vector2.ZERO, screen_size.size))
	
	setup_godot_icon()
	
	RenderingServer.render_loop_enabled = true

#this is called like _process in any other node, but unlike that callback, this returns
#a bool, which when true, ends the loop.
func _process(delta:float) -> bool:
	render(delta)
	return Input.get_mouse_button_mask() != 0 or Input.is_key_pressed(KEY_ESCAPE) or Input.is_key_pressed(KEY_ENTER)

#this is called like _physics_process in any other node, but unlike that callback, this returns
#a bool, which when true, ends the loop.
func _physics_process(delta: float) -> bool:
	return false

func _finalize() -> void:
	#detatch the canvas from the viewport. May not be strictly necessary, but 
	#a good precaution/cleanup step nonetheless
	RenderingServer.viewport_remove_canvas(viewport, canvas)
	
	#Free all the RIDs. This is necessary because they are manually managed.
	RenderingServer.free_rid(godot_icon_item_texture)
	RenderingServer.free_rid(godot_icon_item)
	RenderingServer.free_rid(canvas)
	RenderingServer.free_rid(viewport)
