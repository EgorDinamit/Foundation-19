/obj/item/device/floor_painter
	name = "paintgun"
	icon = 'icons/obj/device.dmi'
	icon_state = "flpainter"
	item_state = "fl_painter"
	desc = "A slender and none-too-sophisticated device capable of painting, erasing, and applying decals to most types of floors. It can also paint walls."
	description_info = "Use this item in your hand to access a menu in which you may change the type of decal, applied direction, and color. Click any accessible tile on the floor to apply your choice."
	description_fluff = "This ubiquitous maintenance-grade paintgun isn't as fancy or convenient as modern consumer models, but with an internal synthesizer it never runs out of pigment!"
	description_antag = "This thing would be perfect for vandalism. Could you write your name in the halls?"

	var/decal =        "remove all decals"
	var/paint_dir =    "precise"
	var/paint_colour = COLOR_WHITE

	var/color_picker = 0

	var/list/decals = list(
		"quarter-turf" =      list("path" = /obj/effect/floor_decal/corner, "precise" = 1, "coloured" = 1),
		"hazard stripes" =    list("path" = /obj/effect/floor_decal/industrial/warning),
		"corner, hazard" =    list("path" = /obj/effect/floor_decal/industrial/warning/corner),
		"hatched marking" =   list("path" = /obj/effect/floor_decal/industrial/hatch, "coloured" = 1),
		"dashed outline" =    list("path" = /obj/effect/floor_decal/industrial/outline, "coloured" = 1),
		"loading sign" =      list("path" = /obj/effect/floor_decal/industrial/loading),
		"mosaic, large" =     list("path" = /obj/effect/floor_decal/chapel),
		"1" =                 list("path" = /obj/effect/floor_decal/sign),
		"2" =                 list("path" = /obj/effect/floor_decal/sign/two),
		"A" =                 list("path" = /obj/effect/floor_decal/sign/a),
		"B" =                 list("path" = /obj/effect/floor_decal/sign/b),
		"C" =                 list("path" = /obj/effect/floor_decal/sign/c),
		"D" =                 list("path" = /obj/effect/floor_decal/sign/d),
		"M" =                 list("path" = /obj/effect/floor_decal/sign/m),
		"V" =                 list("path" = /obj/effect/floor_decal/sign/v),
		"CMO" =               list("path" = /obj/effect/floor_decal/sign/cmo),
		"Ex" =                list("path" = /obj/effect/floor_decal/sign/ex),
		"Psy" =               list("path" = /obj/effect/floor_decal/sign/p),
		"remove all decals" = list("path" = /obj/effect/floor_decal/reset)
		)
	var/list/paint_dirs = list(
		"north" =       NORTH,
		"northwest" =   NORTHWEST,
		"west" =        WEST,
		"southwest" =   SOUTHWEST,
		"south" =       SOUTH,
		"southeast" =   SOUTHEAST,
		"east" =        EAST,
		"northeast" =   NORTHEAST,
		"precise" = 0
		)

	var/list/preset_colors = list(
		"beasty brown" = 	COLOR_BEASTY_BROWN,
		"blue" = 			COLOR_BLUE_GRAY,
		"civvie green" =   	COLOR_CIVIE_GREEN,
		"command blue" = 	COLOR_COMMAND_BLUE,
		"cyan" =        	COLOR_CYAN,
		"green" =      		COLOR_GREEN,
		"NT red" =   		COLOR_NT_RED,
		"orange" = 			COLOR_ORANGE,
		"pale orange" =   	COLOR_PALE_ORANGE,
		"red" = 			COLOR_RED,
		"sky blue" =   		COLOR_DEEP_SKY_BLUE,
		"titanium" =     	COLOR_TITANIUM,
		"hull blue" = 		COLOR_HULL,
		"violet" = 			COLOR_VIOLET,
		"white" =        	COLOR_WHITE,
		"yellow" =       	COLOR_AMBER
		)


/obj/item/device/floor_painter/afterattack(atom/A, mob/user, proximity, params)
	if(!proximity)
		return

	if(color_picker)
		paint_colour = A.color
		to_chat(usr, SPAN_NOTICE("You set \the [src] to paint with <font color='[paint_colour]'>a new colour</font>."))
		return

	playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)

	var/turf/simulated/wall/W = A
	if(istype(W))
		W.paint_color = paint_colour
		W.update_icon()
		return

	var/obj/structure/wall_frame/WF = A
	if(istype(WF))
		WF.color = paint_colour
		WF.update_icon()
		return

	var/obj/machinery/door/airlock/D = A
	if(istype(D))
		var/choice
		if(!D.paintable)
			to_chat(user, SPAN_WARNING("You can't paint this airlock type."))
			return
		if(D.paintable == AIRLOCK_PAINTABLE)
			choice = "Paint"
		else if(D.paintable == AIRLOCK_STRIPABLE)
			choice = "Stripe"
		else if(D.paintable == AIRLOCK_PAINTABLE|AIRLOCK_STRIPABLE)
			choice = input(user, "What do you wish to paint?") as null|anything in list("Paint","Stripe")
		if(user.incapacitated())
			return
		if(choice == "Paint")
			D.paint_airlock(paint_colour)
		else if(choice == "Stripe")
			D.stripe_airlock(paint_colour)
		return

	var/turf/simulated/floor/F = A
	if(!istype(F))
		to_chat(user, SPAN_WARNING("\The [src] can only be used on floors, walls or certain airlocks."))
		return

	if(!F.flooring.can_paint || F.broken || F.burnt)
		to_chat(user, SPAN_WARNING("\The [src] cannot paint broken tiles."))
		return

	var/list/decal_data = decals[decal]
	var/config_error
	if(!islist(decal_data))
		config_error = 1
	var/painting_decal
	if(!config_error)
		painting_decal = decal_data["path"]
		if(!ispath(painting_decal))
			config_error = 1

	if(config_error)
		to_chat(user, SPAN_WARNING("\The [src] flashes an error light. You might need to reconfigure it."))
		return

	if(F.decals && F.decals.len > 5 && painting_decal != /obj/effect/floor_decal/reset)
		to_chat(user, SPAN_WARNING("\The [F] has been painted too much; you need to clear it off."))
		return

	var/painting_dir = 0
	if(paint_dir == "precise")
		if(!decal_data["precise"])
			painting_dir = user.dir
		else
			var/list/mouse_control = params2list(params)
			var/mouse_x = text2num(mouse_control["icon-x"])
			var/mouse_y = text2num(mouse_control["icon-y"])
			if(isnum(mouse_x) && isnum(mouse_y))
				if(mouse_x <= 16)
					if(mouse_y <= 16)
						painting_dir = WEST
					else
						painting_dir = NORTH
				else
					if(mouse_y <= 16)
						painting_dir = SOUTH
					else
						painting_dir = EAST
			else
				painting_dir = user.dir
	else if(paint_dirs[paint_dir])
		painting_dir = paint_dirs[paint_dir]

	var/painting_colour
	if(decal_data["coloured"] && paint_colour)
		painting_colour = paint_colour

	new painting_decal(F, painting_dir, painting_colour)

/obj/item/device/floor_painter/attack_self(mob/user)
	var/choice = input("What do you wish to change?") as null|anything in list("Decal","Direction", "Colour", "Preset Colour", "Mode")
	if(choice == "Decal")
		choose_decal()
	else if(choice == "Direction")
		choose_direction()
	else if(choice == "Colour")
		choose_colour()
	else if(choice == "Preset Colour")
		choose_preset_colour()
	else if(choice == "Mode")
		toggle_mode()

/obj/item/device/floor_painter/examine(mob/user)
	. = ..(user)
	to_chat(user, "It is configured to produce the '[decal]' decal with a direction of '[paint_dir]' using [paint_colour] paint.")

/obj/item/device/floor_painter/verb/choose_colour()
	set name = "Choose Colour"
	set desc = "Choose a paintgun colour."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_colour = input(usr, "Choose a colour.", "paintgun", paint_colour) as color|null
	if(new_colour && new_colour != paint_colour)
		paint_colour = new_colour
		to_chat(usr, SPAN_NOTICE("You set \the [src] to paint with <font color='[paint_colour]'>a new colour</font>."))

/obj/item/device/floor_painter/verb/choose_preset_colour()
	set name = "Choose Preset Colour"
	set desc = "Choose a paintgun colour."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_colour = input(usr, "Choose a colour.", "paintgun", paint_colour) as color|anything in preset_colors
	if(new_colour && new_colour != paint_colour)
		paint_colour = preset_colors[new_colour]
		to_chat(usr, SPAN_NOTICE("You set \the [src] to paint with <font color='[paint_colour]'>a new colour</font>."))

/obj/item/device/floor_painter/verb/choose_decal()
	set name = "Choose Decal"
	set desc = "Choose a paintgun decal."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_decal = input("Select a decal.") as null|anything in decals
	if(new_decal && !isnull(decals[new_decal]))
		decal = new_decal
		to_chat(usr, SPAN_NOTICE("You set \the [src] decal to '[decal]'."))

/obj/item/device/floor_painter/verb/choose_direction()
	set name = "Choose Direction"
	set desc = "Choose a paintgun direction."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_dir = input("Select a direction.") as null|anything in paint_dirs
	if(new_dir && !isnull(paint_dirs[new_dir]))
		paint_dir = new_dir
		to_chat(usr, SPAN_NOTICE("You set \the [src] direction to '[paint_dir]'."))

/obj/item/device/floor_painter/verb/toggle_mode()
	set name = "Toggle Painter Mode"
	set desc = "Choose a paintgun mode."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	color_picker = !color_picker
	if(color_picker)
		to_chat(usr, SPAN_NOTICE("You set \the [src] to color picker mode, scanning colors off objects."))
	else
		to_chat(usr, SPAN_NOTICE("You set \the [src] to painting mode."))
