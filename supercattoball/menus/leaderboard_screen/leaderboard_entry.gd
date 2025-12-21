extends HBoxContainer

@onready var rank: Label = $Rank
@onready var user: Label = $User
@onready var score: Label = $Score
@onready var time: Label = $Time

func _set_pos(pos: int) -> void:
	rank.text = rank.text.replace("{pos}", str(pos + 1))

func _set_username(username: String) -> void:
	user.text = user.text.replace("{username}", username)

func _set_score(total_score: int) -> void:
	score.text = score.text.replace("{score}", str(int(total_score)))

func _set_time(total_time: float) -> void:
	time.text = time.text.replace("{time}", str("%.2f" % total_time))

func set_data(entry: TaloLeaderboardEntry) -> void:
	_set_pos(entry.position)
	_set_username(entry.player_alias.identifier)
	_set_score(entry.score)
	_set_time(entry.total_time)
