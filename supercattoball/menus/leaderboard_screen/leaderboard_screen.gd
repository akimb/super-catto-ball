extends Control

@export var leaderboard_internal_name: String = ""
@export var include_archived: bool

@onready var leaderboard_name: Label = %"Leaderboard Name"
@onready var entries_container: VBoxContainer = %Entries
@onready var username: LineEdit = %Username
@onready var info_label: Label = %"Debug Label"
@onready var skip_button: GenericButton = $"Skip Button"


var _entries_error: bool
var _filter: String = "All"

var entry_scene = preload("res://menus/leaderboard_screen/leaderboard_entry.tscn")
const main_menu : PackedScene = preload("res://menus/main_menu/main_menu.tscn")

func _ready() -> void:
	GameManager.debug_printer()
	leaderboard_name.text = leaderboard_name.text.replace("{leaderboard}", leaderboard_internal_name)
	username.editable = true
	await _load_entries()
	_set_entry_count()

func _set_entry_count():
	if entries_container.get_child_count() == 0:
		info_label.text = "no entries yet!" if not _entries_error else "Failed loading leaderboard %s. Does it exist?" % leaderboard_internal_name
	else:
		info_label.text = "%s entries" % entries_container.get_child_count()
		if _filter != "All":
			info_label.text += " (%s team)" % _filter

func _create_entry(entry: TaloLeaderboardEntry) -> void:
	var entry_instance = entry_scene.instantiate()
	entries_container.add_child(entry_instance)
	entry_instance.set_data(entry)

func _build_entries() -> void:
	for child in entries_container.get_children():
		child.queue_free()

	var entries = Talo.leaderboards.get_cached_entries(leaderboard_internal_name)
	if _filter != "All":
		entries = entries.filter(func (entry: TaloLeaderboardEntry): return entry.get_prop("team", "") == _filter)

	for entry in entries:
		entry.position = entries.find(entry)
		_create_entry(entry)

func _load_entries() -> void:
	var page := 0
	var done := false

	while !done:
		var options := Talo.leaderboards.GetEntriesOptions.new()
		options.page = page
		options.include_archived = include_archived

		var res := await Talo.leaderboards.get_entries(leaderboard_internal_name, options)

		if not is_instance_valid(res):
			_entries_error = true
			return

		var is_last_page := res.is_last_page

		if is_last_page:
			done = true
		else:
			page += 1

	_build_entries()

func _on_username_text_submitted(new_text: String) -> void:
	username.editable = false
	skip_button.disabled = true
	skip_button.text = "please wait"
	await Talo.players.identify("username", new_text)
	var score : int = GameManager.total_score
	var props: Dictionary[String, Variant] = {
		"GameManager.total_time": GameManager.total_time
		}
	await Talo.leaderboards.add_entry(leaderboard_internal_name, score, props)
	_build_entries()
	skip_button.disabled = false
	skip_button.text = "to main menu"

func _on_skip_button_pressed() -> void:
	GameManager.reset_all_gameplay_data()
	get_tree().change_scene_to_packed(main_menu)
