# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Monster.destroy_all
@monster_1 = Monster.create( 
    up: "1",
    down: "1",
    left: "1",
    right: "1",
    rank: "1",name: "#1")

@monster_1.zones.push("A1")
@monster_1.save

@monster_2 = Monster.create( 
    up: "2",
    down: "2",
    left: "1",
    right: "1",
    rank: "1",name: "#2")

@monster_2.zones.push("A1")
@monster_2.save

@monster_3 = Monster.create( 
    up: "1",
    down: "1",
    left: "2",
    right: "2",
    rank: "1",name: "#3")

@monster_3.zones.push("A1")
@monster_3.zones.push("A2")
@monster_3.save

@monster_4 = Monster.create( 
    up: "2",
    down: "2",
    left: "2",
    right: "2",
    rank: "1",name: "#4")

@monster_4.zones.push("A1")
@monster_4.zones.push("A2")
@monster_4.save

@monster_5 = Monster.create( 
    up: "3",
    down: "1",
    left: "1",
    right: "1",
    rank: "1",name: "#5")

@monster_5.zones.push("A1")
@monster_5.zones.push("A2")
@monster_5.save

@monster_6 = Monster.create( 
    up: "1",
    down: "3",
    left: "1",
    right: "1",
    rank: "1",name: "#6")

@monster_6.zones.push("A1")
@monster_6.zones.push("A2")
@monster_6.save

@monster_7 = Monster.create( 
    up: "1",
    down: "1",
    left: "3",
    right: "1",
    rank: "1",name: "#7")

@monster_7.zones.push("A1")
@monster_7.zones.push("A2")
@monster_7.save

@monster_8 = Monster.create( 
    up: "1",
    down: "1",
    left: "1",
    right: "3",
    rank: "1",name: "#8")

@monster_8.zones.push("A2")
@monster_8.save

@monster_9 = Monster.create( 
    up: "1",
    down: "2",
    left: "3",
    right: "1",
    rank: "1",name: "#9")

@monster_9.zones.push("A2")
@monster_9.save

@monster_10 = Monster.create( 
    up: "3",
    down: "2",
    left: "3",
    right: "2",
    rank: "1",name: "#10")

@monster_10.zones.push("A3")
@monster_10.save

@monster_11 = Monster.create( 
    up: "2",
    down: "3",
    left: "2",
    right: "3",
    rank: "1",name: "#11")

@monster_11.zones.push("A3")
@monster_11.save

@monster_12 = Monster.create( 
    up: "2",
    down: "3",
    left: "3",
    right: "2",
    rank: "1",name: "#12")

@monster_12.zones.push("A3")
@monster_12.zones.push("A4")

@monster_12.save

@monster_13 = Monster.create( 
    up: "3",
    down: "2",
    left: "2",
    right: "3",
    rank: "1",name: "#13")

@monster_13.zones.push("A3")
@monster_13.zones.push("A4")

@monster_13.save

@monster_14 = Monster.create( 
    up: "3",
    down: "3",
    left: "2",
    right: "3",
    rank: "1",name: "#14")

@monster_14.zones.push("A3")
@monster_14.zones.push("A4")

@monster_14.save

@monster_15 = Monster.create( 
    up: "2",
    down: "3",
    left: "3",
    right: "3",
    rank: "1",name: "#15")

@monster_15.zones.push("A3")
@monster_15.zones.push("A4")

@monster_15.save

@monster_16 = Monster.create( 
    up: "3",
    down: "3",
    left: "3",
    right: "3",
    rank: "2",name: "#16")

@monster_16.zones.push("A3")
@monster_16.zones.push("A4")

@monster_16.save

@monster_17 = Monster.create( 
    up: "4",
    down: "4",
    left: "3",
    right: "3",
    rank: "2",name: "#17")

@monster_17.zones.push("A4")

@monster_17.save

@monster_18 = Monster.create( 
    up: "3",
    down: "3",
    left: "4",
    right: "4",
    rank: "2",name: "#18")

@monster_18.zones.push("A4")

@monster_18.save

@monster_19 = Monster.create( 
    up: "4",
    down: "4",
    left: "4",
    right: "4",
    rules: ["boss", "life"],
    rank: "3",name: "#19")

@monster_19.zones.push("A5")

@monster_19.save