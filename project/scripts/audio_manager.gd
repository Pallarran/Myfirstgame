# Global audio orchestration. Autoload singleton.
#
# Provides:
#   - `play_music(path)`  — looping background track. Use `stop_music()` to
#     end. Crossfade is one-shot replace for slice 1.
#   - `play_sfx(name)`    — registered one-shot effect by name.
#   - Volume controls (master / music / sfx) clamped to [0, 1].
#
# If a referenced audio file doesn't exist yet, play is silent — the
# architecture is in place, and dropping `.ogg` / `.wav` files at the
# expected paths is all the user needs to do to hear them. See
# `SFX_PATHS` for the registry slice 1 hooks expect.
#
# Diegetic 3D audio (campfire crackle, chopping, footsteps) lives on
# per-building AudioStreamPlayer3D nodes inside the relevant scenes —
# not managed here.
extends Node

const SFX_PATHS: Dictionary = {
	"build_complete": "res://assets/audio/sfx/build_complete.wav",
	"boost":          "res://assets/audio/sfx/boost.wav",
	"notification":   "res://assets/audio/sfx/notification.wav",
	"button_click":   "res://assets/audio/sfx/button_click.wav",
	"level_up":       "res://assets/audio/sfx/level_up.wav",
}

const MUSIC_PATH_AMBIENT_CAMP: String = "res://assets/audio/music/camp_ambient.ogg"

var _music_player: AudioStreamPlayer
var _sfx_player: AudioStreamPlayer

var _master_volume: float = 1.0
var _music_volume: float = 0.65
var _sfx_volume: float = 0.85

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	_music_player.bus = "Master"
	add_child(_music_player)
	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.name = "SFXPlayer"
	_sfx_player.bus = "Master"
	add_child(_sfx_player)
	_apply_volumes()

# --- Public API ---------------------------------------------------------

func play_music(path: String) -> void:
	if not ResourceLoader.exists(path):
		return
	var stream: AudioStream = load(path)
	if stream == null:
		return
	if stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = true
	elif stream is AudioStreamMP3:
		(stream as AudioStreamMP3).loop = true
	# WAVs declared loopable in import settings will already loop.
	_music_player.stream = stream
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()

func play_sfx(sfx_name: String) -> void:
	var path: String = SFX_PATHS.get(sfx_name, "")
	if path == "" or not ResourceLoader.exists(path):
		return  # no file dropped in yet — silent
	var stream: AudioStream = load(path)
	if stream == null:
		return
	_sfx_player.stream = stream
	_sfx_player.play()

# --- Volume controls ---------------------------------------------------

func set_master_volume(v: float) -> void:
	_master_volume = clampf(v, 0.0, 1.0)
	_apply_volumes()

func set_music_volume(v: float) -> void:
	_music_volume = clampf(v, 0.0, 1.0)
	_apply_volumes()

func set_sfx_volume(v: float) -> void:
	_sfx_volume = clampf(v, 0.0, 1.0)
	_apply_volumes()

func _apply_volumes() -> void:
	if _music_player != null:
		_music_player.volume_db = linear_to_db(_master_volume * _music_volume)
	if _sfx_player != null:
		_sfx_player.volume_db = linear_to_db(_master_volume * _sfx_volume)
