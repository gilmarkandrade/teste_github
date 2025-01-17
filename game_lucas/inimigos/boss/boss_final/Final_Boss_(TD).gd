extends KinematicBody2D

var death = false 
var walking = true 
var atacking = false
var idlle_status = true
var life = 1000
var damage = 5 
var move = Vector2()
var velocity = 50
var attack_probability = RandomNumberGenerator.new()
var attack_type = 0
var pode_trocar = false
var shot = preload("res://inimigos/projeteis_inimigos/shot_final_boss/shot.tscn")
var missil = preload("res://inimigos/projeteis_inimigos/missil_final_boss/top_down/Missil(TD).tscn")
var laser = preload("res://inimigos/projeteis_inimigos/laser_final_boss/laser.tscn")
var impulse = false
var go_up = true

func _physics_process(delta):
	atributos_final_boss_singleton.walking = walking
	walking_mech()
	life = atributos_final_boss_singleton.life_boss
	if impulse == true:
		impulseTop()

func walking_mech():
	if walking == true:
		$animation.current_animation = "walking"
		move.x = 100
		$animation.current_animation = "walk_animaton"
		$delay_attack1.paused
		if global_position.y >= (450):
			go_up = false
		if global_position.y <= (100):
			go_up = true
		if go_up == true:
			move.y = 50
		else:
			move.y = -50
	else :
		move.x = 0
		move.y = 0
		$animation.current_animation = "idle"
		$delay_attack1.start()

	move = move_and_slide(move)

func random_attack():
	attack_probability.randomize()
	attack_type = attack_probability.randi_range(1,2)

func generate_attack():
	if pode_trocar == false:
		random_attack()
		pode_trocar = true
	walking = false
	if attack_type == 1 :
		$animation.current_animation = "missil_attack"
		#$animation.play("missil_attack")
		$delay_attack2.start()
	if attack_type == 2 :
		$delay_attack3.start()

func attack1():
	var TIRO1 = shot.instance()
	get_parent().add_child(TIRO1)
	TIRO1.position = $cannon_fire1.global_position
	var TIRO2 = shot.instance()
	get_parent().add_child(TIRO2)
	TIRO2.position = $cannon_fire2.global_position
	$delay_attack1.start()

func attack2():
	var DIS1 = missil.instance()
	get_parent().add_child(DIS1)
	DIS1.front = true
	DIS1.position = $missile_launcher.global_position
	
	var DIS2 = missil.instance()
	get_parent().add_child(DIS2)
	DIS2.down = true
	DIS2.position = $missile_launcher.global_position
	
	var DIS3 = missil.instance()
	get_parent().add_child(DIS3)
	DIS3.up = true
	DIS3.position = $missile_launcher.global_position
	$reload.start()

func attack3():
	var LAS = laser.instance()
	LAS.side = false
	LAS.scale.y = 4
	LAS.scale.x = 4
	get_parent().add_child(LAS)
	LAS.position = $cannon_fire3.global_position
	$reload.start()
	impulse = true
	$impulse.start()


func _on_delay_attack1_timeout():
	$delay_attack1.stop()
	attack1()

func _on_delay_attack2_timeout():
	$delay_attack2.stop()
	attack2()

func _on_delay_attack3_timeout():
	$delay_attack3.stop()
	attack3()

#func _on_animation_H_C_animation_finished(anim_name):
#	if anim_name == "death_animation":
#		queue_free()


func _on_change_attack_timeout():
	generate_attack()
	pode_trocar = false
	$change_attack.stop()
	


func _on_area_corpo_mech_area_entered(area):
	if area.is_in_group("arma_player") and death == false:
		life -= 10
		#life -= atributos_player_singleton.life_enemie_update
	if area.is_in_group("projetil_player") and death == false:
		life -= 10
		#life -= atributos_player_singleton.life_enemie_update
	atributos_final_boss_singleton.life_boss = life
	action_life()


func action_life():
	
	if life < 500 and life >= 250:
		get_tree().change_scene("res://fases/Fase_Final_Boss_Mech(SC).tscn")



func _on_reload_timeout():
	$reload.stop()
	walking = true
	$change_attack.start()

func impulseTop():
	move.x = 12
	move = move_and_slide(move)

func _on_impulse_timeout():
	impulse = false
	$impulse.stop()
