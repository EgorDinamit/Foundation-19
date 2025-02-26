/datum/unarmed_attack/bite/sharp //eye teeth
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = FALSE
	sharp = TRUE
	edge = TRUE
	attack_name = "sharp bite"

/datum/unarmed_attack/diona
	attack_verb = list("lashed", "bludgeoned")
	attack_noun = list("tendril")
	eye_attack_text = "a tendril"
	eye_attack_text_victim = "a tendril"
	attack_name = "tendrils"

/datum/unarmed_attack/claws
	attack_verb = list("scratched", "clawed", "slashed")
	attack_noun = list("claws")
	eye_attack_text = "claws"
	eye_attack_text_victim = "sharp claws"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	sharp = TRUE
	edge = TRUE
	attack_name = "claws"
	var/blocked_by_gloves = TRUE

/datum/unarmed_attack/claws/is_usable(mob/living/carbon/human/user, mob/living/carbon/human/target, zone)
	if(user.gloves && blocked_by_gloves)
		var/obj/item/clothing/gloves/gloves = user.gloves
		if(istype(gloves) && !gloves.clipped)
			return 0
		else
			return 1
	else
		return 1

/datum/unarmed_attack/claws/show_attack(mob/living/carbon/human/user, mob/living/carbon/human/target, zone, attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	if (!affecting)
		to_chat(user, SPAN_WARNING("\The [target] does not have that bodypart!"))
		return

	attack_damage = Clamp(attack_damage, 1, 5)

	if(target == user)
		user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] \himself in the [affecting.name]!"))
		return 0

	switch(zone)
		if(BP_HEAD, BP_MOUTH, BP_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2) user.visible_message(SPAN_DANGER("[user] scratched [target] across \his cheek!"))
				if(3 to 4)
					user.visible_message(pick(
						80; user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] [target]'s [pick("face", "neck", affecting.name)]!")),
						20; user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] [pick("[target] in the [affecting.name]", "[target] across \his [pick("face", "neck", affecting.name)]")]!")),
						))
				if(5)
					user.visible_message(pick(
						SPAN_DANGER("[user] rakes \his [pick(attack_noun)] across [target]'s [pick("face", "neck", affecting.name)]!"),
						SPAN_DANGER("[user] tears \his [pick(attack_noun)] into [target]'s [pick("face", "neck", affecting.name)]!"),
						))
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)	user.visible_message(SPAN_DANGER("[user] [pick("scratched", "grazed")] [target]'s [affecting.name]!"))
				if(3 to 4)
					user.visible_message(pick(
						80; user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] [target]'s [affecting.name]!")),
						20; user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] [pick("[target] in the [affecting.name]", "[target] across \his [affecting.name]")]!")),
						))
				if(5)		user.visible_message(SPAN_DANGER("[user] tears \his [pick(attack_noun)] [pick("deep into", "into", "across")] [target]'s [affecting.name]!"))

/datum/unarmed_attack/claws/strong
	attack_verb = list("slashed")
	damage = 5
	shredding = TRUE
	attack_name = "strong claws"

/datum/unarmed_attack/claws/strong/gloves
	blocked_by_gloves = FALSE

/datum/unarmed_attack/bite/strong
	attack_verb = list("mauled")
	damage = 8
	shredding = TRUE
	attack_name = "strong bite"

/datum/unarmed_attack/slime_glomp
	attack_verb = list("glomped")
	attack_noun = list("body")
	damage = 2
	attack_name = "glomp"

/datum/unarmed_attack/slime_glomp/apply_effects(mob/living/carbon/human/user,mob/living/carbon/human/target,armour,attack_damage,zone)
	..()
	user.apply_stored_shock_to(target)

/datum/unarmed_attack/stomp/weak
	attack_verb = list("jumped on")
	attack_name = "weak stomp"

/datum/unarmed_attack/stomp/weak/get_unarmed_damage()
	return damage

/datum/unarmed_attack/stomp/weak/show_attack(mob/living/carbon/human/user, mob/living/carbon/human/target, zone, attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message(SPAN_WARNING("[user] jumped up and down on \the [target]'s [affecting.name]!"))
	playsound(user.loc, attack_sound, 25, 1, -1)

/datum/unarmed_attack/tail //generally meant for people like unathi
	attack_verb = list ("bludgeoned", "lashed", "smacked", "whapped")
	attack_noun = list ("tail")
	attack_name = "tail swipe"

/datum/unarmed_attack/tail/is_usable(mob/living/carbon/human/user, mob/living/carbon/human/target, zone) //ensures that you can't tail someone in the skull

	if(!(zone in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_GROIN)))

		return 0

	var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]

	if(E && !E.is_stump())

		return 1


	E = user.organs_by_name[BP_R_FOOT]

	if(E && !E.is_stump())

		return 1

	return 0

/datum/unarmed_attack/tail/show_attack(mob/living/carbon/human/user, mob/living/carbon/human/target, zone, attack_damage)

	var/obj/item/organ/external/affecting = target.get_organ(zone)

	var/organ = affecting.name
	attack_damage = Clamp(attack_damage, 1, 6)
	attack_damage = 3 + attack_damage - rand(1, 5)
	switch(attack_damage)

		if(1 to 5)	user.visible_message(SPAN_DANGER("[user] glanced [target] with their [pick(attack_noun)] in the [organ]!"))

		if(6 to 7)	user.visible_message(SPAN_DANGER("[user] [pick(attack_verb)] [target] in \his [organ] with their [pick(attack_noun)]!"))

		if(8)		user.visible_message(SPAN_DANGER("[user] landed a heavy blow with their [pick(attack_noun)] against [target]'s [organ]!"))

/datum/unarmed_attack/nabber
	attack_verb = list("mauled", "slashed", "struck", "pierced")
	attack_noun = list("forelimb")
	damage = 18
	shredding = TRUE
	sharp = TRUE
	edge = TRUE
	delay = 20
	eye_attack_text = "a forelimb"
	eye_attack_text_victim = "a forelimb"
	attack_name = "forelimb slash"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'

/datum/unarmed_attack/punch/starborn
	attack_verb = list("scorched", "burned", "fried")
	shredding = TRUE
	attack_name = "starborn strike"

/datum/unarmed_attack/punch/starborn/get_damage_type()
	return BURN

/datum/unarmed_attack/bite/venom
	attack_verb = list("bit", "sank their fangs into")
	attack_sound = 'sound/weapons/bite.ogg'
	damage = 5
	delay = 120
	attack_name = "venomous bite"

/datum/unarmed_attack/bite/venom/get_damage_type()
	return TOX
