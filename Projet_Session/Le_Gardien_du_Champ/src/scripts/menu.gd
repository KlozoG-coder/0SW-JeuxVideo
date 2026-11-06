extends Control

var main_panel: VBoxContainer
var options_panel: VBoxContainer
var instructions_panel: VBoxContainer

func _ready() -> void:
    var background := ColorRect.new()
    background.color = Color("143c36")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)
    var center := CenterContainer.new()
    center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(center)
    var holder := VBoxContainer.new()
    holder.add_theme_constant_override("separation", 15)
    center.add_child(holder)
    main_panel = _panel(holder)
    _heading(main_panel, "LE GARDIEN DU CHAMP")
    _heading(main_panel, "Protégez les récoltes du village !")
    _button(main_panel, "Jouer", func(): _start())
    _button(main_panel, "Instructions", func(): _show(instructions_panel))
    _button(main_panel, "Options", func(): _show(options_panel))
    _button(main_panel, "Quitter", func(): get_tree().quit())
    options_panel = _panel(holder)
    _heading(options_panel, "OPTIONS")
    _slider(options_panel, "Musique", "Music")
    _slider(options_panel, "Effets sonores", "SFX")
    _button(options_panel, "Retour", func(): _show(main_panel))
    instructions_panel = _panel(holder)
    _heading(instructions_panel, "INSTRUCTIONS")
    _heading(instructions_panel, "A / D : avancer     Espace : sauter")
    _heading(instructions_panel, "J ou clic gauche : lancer des graines")
    _heading(instructions_panel, "Échap : pause     Ctrl+M : couper le son")
    _heading(instructions_panel, "Protégez les cultures et éliminez 3 vagues par niveau.")
    _button(instructions_panel, "Retour", func(): _show(main_panel))
    _show(main_panel)

func _panel(parent: Node) -> VBoxContainer:
    var panel := VBoxContainer.new()
    panel.add_theme_constant_override("separation", 12)
    parent.add_child(panel)
    return panel

func _heading(parent: Node, title: String) -> void:
    var label := Label.new()
    label.text = title
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_color_override("font_color", Color("f9e3a4"))
    label.add_theme_font_size_override("font_size", 22)
    parent.add_child(label)

func _button(parent: Node, label: String, action: Callable) -> void:
    var button := Button.new()
    button.text = label
    button.custom_minimum_size = Vector2(300, 46)
    button.pressed.connect(func(): AudioManager.play_sfx("click"); action.call())
    parent.add_child(button)

func _slider(parent: Node, title: String, bus: String) -> void:
    _heading(parent, title)
    var slider := HSlider.new()
    slider.min_value = 0.0
    slider.max_value = 1.0
    slider.step = 0.01
    slider.value = AudioManager.get_volume(bus)
    slider.value_changed.connect(func(v: float): AudioManager.set_volume(bus, v))
    parent.add_child(slider)

func _show(active: VBoxContainer) -> void:
    main_panel.visible = active == main_panel
    options_panel.visible = active == options_panel
    instructions_panel.visible = active == instructions_panel

func _start() -> void:
    get_tree().change_scene_to_file("res://scenes/Main.tscn")
