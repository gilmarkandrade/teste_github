extends KinematicBody2D


var speed = 1.2
var seguir = true
var death = false
var attacking = false
var damage = 5
var life = 100
var move = Vector2(0,0)
var target = atributos_player_singleton.pos_player_update

func _ready():
	seguir = true
	death = false
	
	
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
		
func _on_corpo_h_c_area_entered(area):
	if area.is_in_group("arma_player") and death == false:
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


func _on_animation_H_C_animation_finished(anim_name):
	if anim_name == "death_animation":
		queue_free()
	if anim_name == "atack_animation":
		if seguir == false :
			attacking = false





