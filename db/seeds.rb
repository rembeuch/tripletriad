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
@monster_1 = Monster.create( up: "1",
    down: "1",
    left: "1",
    right: "1",
    rank: "1",name: "#1")

@monster_1.zones.push("A1")
@monster_1.save

@monster_2 = Monster.create( up: "2",
    down: "2",
    left: "1",
    right: "1",
    rank: "1",name: "#2")

@monster_2.zones.push("A1")
@monster_2.save

@monster_3 = Monster.create( up: "1",
    down: "1",
    left: "2",
    right: "2",
    rank: "1",name: "#3")

@monster_3.zones.push("A1")
@monster_3.save

@monster_4 = Monster.create( up: "2",
    down: "2",
    left: "2",
    right: "2",
    rank: "1",name: "#4")

@monster_4.zones.push("A1")
@monster_4.save