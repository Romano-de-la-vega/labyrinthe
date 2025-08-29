extends CanvasLayer

@onready var timer_label: Label = $TimerLabel
@onready var message_label: Label = $MessageLabel

func update_timer(time_sec: float) -> void:
    timer_label.text = str(round(time_sec, 2))

func show_victory() -> void:
    message_label.text = "Victoire ! Appuyez sur R pour rejouer"
