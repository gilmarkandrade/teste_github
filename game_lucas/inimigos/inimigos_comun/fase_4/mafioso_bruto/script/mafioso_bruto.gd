extends KinematicBody2D


var speed = 1.2
var seguir = true
var death = false
var attacking = false
var damage = 5
var life = 110
var move = Vector2(0,0)
var target = atributos_player_singleton.pos_player_update
var item_vida = preload("res://player/Itens_player/vida/item_vida.tscn")
var item_mana = preload("res://player/Itens_player/municao_mana/item_municao.tscn")
var item_probability = RandomNumberGenerator.new()
var item_type = 0

func _ready():
	seguir = true
	death = false
	atributos_fase_singleton.add_enemie_limit_in_game(1)
	
	
func _physics_process(delta):
	target = atributos_player_singleton.pos_player_update
	if seguir == true and death == false :
		perseguir(delta)
	
	elif seguir == false and attacking == false and death == false:
		$animation_H_C.current_animation = "idlle_animation" 
	
func init(pos):
	position = pos
 
# pega direcao menos a posiçaõ do player vezes a velocidade para seguir o player
func perseguir(delta):
	look_at(target)
	var direction = target - position 
	var motion = direction *speed* delta
	position += motion
	if attacking == false:
		$animation_H_C.current_animation = "walk_animation"

func _on_area_ataque_body_entered(body):
	if body.is_in_group("player") and death == false:
		seguir = false
		$delay_atack.start()
	
func _on_area_ataque_body_exited(body):
	if body.is_in_group("player") and death == false:
		seguir = true 
	
			

func damage_death():
	
	if life <= 0:
		death = true 
		$animation_H_C. play("death_animation")
	else:
		$animation_H_C.play("damage_animation")
func _on_corpo_h_c_area_entered(area):
	
	if area.is_in_group("arma_player") and death == false:
		life -= atributos_player_singleton.life_enemie_update
		damage_death()
		
		
	if area.is_in_group("projetil_player"):
		life -= atributos_player_singleton.life_enemie_update
		damage_death()
		
		
func _on_arma_inimigo_body_entered(body):
	if body.is_in_group("player") and death == false:
		atributos_player_singleton.player_life_update(damage)

func _on_AI_perception_body_exited(body):
	if body.is_in_group("player") and death == false:
		seguir = true
		attacking = false
		$delay_atack.stop()
	
		
func atack():
	$animation_H_C.current_animation = "atack_animation"
	


func _on_delay_atack_timeout():
	  
	if seguir == true and death == false:
		$delay_atack.stop()
		attacking = false
	elif seguir == false and death == false :
		attacking = true 
		atack()

func random_item():
	item_probability. randomize()
	var random_item = item_probability. randi_range(1,4)
	item_type = random_item

func spaw_item():
	random_item()
	if item_type == 1 :
		var IV = item_vida.instance()
		get_parent().add_child(IV)
		IV.scale.x = 0.6
		IV.scale.y = 0.6
		IV.position = $".".global_position
	if item_type == 2: #and atributos_fase_singleton.get_weapom_away == true:
		var IM = item_mana.instance()
		get_parent().add_child(IM)
		IM.scale.x = 0.6
		IM.scale.y = 0.6
		IM.position = $".".global_position

func _on_animation_H_C_animation_finished(anim_name):
	if anim_name == "death_animation":
		atributos_fase_singleton.update_enemie_dead(1)
		atributos_fase_singleton.subtract_enemie_ingame(1)
		spaw_item()
		queue_free()
	if anim_name == "atack_animation":
		if seguir == false :
			attacking = false






