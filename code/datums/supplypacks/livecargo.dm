/decl/hierarchy/supply_pack/livecargo
	name = "Live cargo"
	containertype = /obj/structure/closet/crate/hydroponics

/decl/hierarchy/supply_pack/livecargo/monkey
	name = "Inert - Monkey cubes"
	contains = list (/obj/item/storage/box/monkeycubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "monkey crate"

/decl/hierarchy/supply_pack/livecargo/farwa
	name = "Inert - Farwa cubes"
	contains = list (/obj/item/storage/box/monkeycubes/farwacubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "farwa crate"

/decl/hierarchy/supply_pack/livecargo/skrell
	name = "Inert - Neaera cubes"
	contains = list (/obj/item/storage/box/monkeycubes/neaeracubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "neaera crate"

/decl/hierarchy/supply_pack/livecargo/stok
	name = "Inert - Stok cubes"
	contains = list (/obj/item/storage/box/monkeycubes/stokcubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "stok crate"

/decl/hierarchy/supply_pack/livecargo/spidercubes
	name = "Inert - Spiders"
	contains = list(/obj/item/storage/box/monkeycubes/spidercubes)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Spiderling crate"
	contraband = 1
	security_level = null


//actual live animals

/decl/hierarchy/supply_pack/livecargo/corgi
	name = "Live - Corgi"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/animal/corgi
	containername = "corgi crate"

/decl/hierarchy/supply_pack/livecargo/cat
	name = "Live - Cat"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/animal/cat
	containername = "cat crate"

/decl/hierarchy/supply_pack/livecargo/snek
	name = "Live - Snake"
	contains = list()
	cost = 25
	containertype = /obj/structure/largecrate/animal/snek
	containername = "snake crate"

//farm animals - useless and annoying, but potentially a good source of food. expensive because they're live animals and their produce is available cheaper
/decl/hierarchy/supply_pack/livecargo/cow
	name = "Live - Cow"
	cost = 80
	containertype = /obj/structure/largecrate/animal/cow
	containername = "cow crate"
	access = ACCESS_HYDROPONICS

/decl/hierarchy/supply_pack/livecargo/goat
	name = "Live - Goat"
	cost = 75
	containertype = /obj/structure/largecrate/animal/goat
	containername = "goat crate"
	access = ACCESS_HYDROPONICS

/decl/hierarchy/supply_pack/livecargo/sheep
	name = "Live - Sheep"
	cost = 60
	containertype = /obj/structure/largecrate/animal/sheep
	containername = "sheep crate"
	access = ACCESS_HYDROPONICS

/decl/hierarchy/supply_pack/livecargo/goose
	name = "Live - Goose"
	cost = 75
	containertype = /obj/structure/largecrate/animal/goose
	containername = "goose containment unit"
	access = ACCESS_HYDROPONICS

/decl/hierarchy/supply_pack/livecargo/chicken
	name = "Live - Chicken"
	cost = 70
	containertype = /obj/structure/largecrate/animal/chick
	containername = "chicken crate"
	access = ACCESS_HYDROPONICS
