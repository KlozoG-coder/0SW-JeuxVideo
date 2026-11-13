extends CanvasLayer

var overlay: Control
var options: VBoxContainer
var main_buttons: VBoxContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	overlay = Control.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.75)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var holder := VBoxContainer.new()
	center.add_child(holder)
	main_buttons = VBoxContainer.new()
	holder.add_child(main_buttons)
	_label(main_buttons, "PAUSE")
	_button(main_buttons, "Reprendre", func(): resume())
	_button(main_buttons, "Options", func(): _show_options())
	_button(main_buttons, "Menu principal", func(): _main_menu())
	options = VBoxContainer.new()
	holder.add_child(options)
	_label(options, "VOLUME MUSIQUE")
	_slider(options, "Music")
	_label(options, "VOLUME EFFETS")
	_slider(options, "SFX")
	_button(options, "Retour", func(): _show_main())
	_show_main()
	overlay.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if overlay.visible: resume()
		else: pause()
		get_viewport().set_input_as_handled()

func pause() -> void:
	get_tree().paused = true
	overlay.show()
	_show_main()

func resume() -> void:
	overlay.hide()
	get_tree().paused = false

func _main_menu() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _show_main() -> void:
	options.hide()
	main_buttons.show()

func _show_options() -> void:
	main_buttons.hide()
	options.show()

func _label(parent: Node, value: String) -> void:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", Color("f9e3a4"))
	parent.add_child(label)

func _button(parent: Node, value: String, action: Callable) -> void:
	var button := Button.new()
	button.text = value
	button.custom_minimum_size = Vector2(290, 42)
	button.pressed.connect(func(): AudioManager.play_sfx("click"); action.call())
	parent.add_child(button)

func _slider(parent: Node, bus: String) -> void:
	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.01
	slider.value = AudioManager.get_volume(bus)
	slider.value_changed.connect(func(v: float): AudioManager.set_volume(bus, v))
	parent.add_child(slider)
