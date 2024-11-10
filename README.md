# SceneTree-less Godot 4 demo
This is a basic project demonstrating how to use the `RenderingServer` and a custom `MainLoop` child class in Godot 4 in order to have a project that does not use the SceneTree whatsoever. 

It also serves, on a sidenote, as a demonstration of how small Godot binaries can get while still being usable for very basic things. 

This project was made with Godot 4.4 dev_2, but it can probably be downgraded to 4.3 or possibly even lower without issue.

## Contents:
* `icon.svg`: The bundled Godot icon. The demo spins this around in a circle.
* `custom_loop.gd`: The `MainLoop` implementation, which also loads, sets up, and spins the icon. 
* `dummy_scene.tscn`: Godot still requires a default scene in order to boot, so this scene is set as that. It just contains a scriptless `Node`.
