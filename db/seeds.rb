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
    rank: "2",name: "#19")

@monster_19.zones.push("A5")

@monster_19.save

@monster_36 = Monster.create( 
    up: "5",
    down: "5",
    left: "4",
    right: "4",
    rank: "3",name: "#36")

@monster_36.zones.push("A6")

@monster_36.save

@monster_37 = Monster.create( 
    up: "4",
    down: "4",
    left: "5",
    right: "5",
    rank: "3",name: "#37")

@monster_37.zones.push("A6")

@monster_37.save

@monster_38 = Monster.create( 
    up: "5",
    down: "4",
    left: "5",
    right: "4",
    rank: "3",name: "#38")

@monster_38.zones.push("A6")
@monster_38.zones.push("A7")

@monster_38.save

@monster_39 = Monster.create( 
    up: "4",
    down: "5",
    left: "4",
    right: "5",
    rank: "3",name: "#39")

@monster_39.zones.push("A6")
@monster_39.zones.push("A7")

@monster_39.save

@monster_40 = Monster.create( 
    up: "5",
    down: "5",
    left: "4",
    right: "5",
    rank: "3",name: "#40")

@monster_40.zones.push("A6")
@monster_40.zones.push("A7")

@monster_40.save

@monster_41 = Monster.create( 
    up: "4",
    down: "5",
    left: "5",
    right: "5",
    rank: "3",name: "#41")

@monster_41.zones.push("A6")
@monster_41.zones.push("A7")

@monster_41.save

@monster_42 = Monster.create( 
    up: "5",
    down: "5",
    left: "5",
    right: "5",
    rank: "4",name: "#42")

@monster_42.zones.push("A6")
@monster_42.zones.push("A7")

@monster_42.save

@monster_43 = Monster.create( 
    up: "6",
    down: "6",
    left: "5",
    right: "5",
    rank: "4",name: "#43")

@monster_43.zones.push("A7")

@monster_43.save

@monster_44 = Monster.create( 
    up: "5",
    down: "5",
    left: "6",
    right: "6",
    rank: "4",name: "#44")

@monster_44.zones.push("A7")

@monster_44.save

@monster_45 = Monster.create( 
    up: "5",
    down: "6",
    left: "5",
    right: "6",
    rank: "4",name: "#45")

@monster_45.zones.push("A8")

@monster_45.save

@monster_46 = Monster.create( 
    up: "6",
    down: "5",
    left: "6",
    right: "5",
    rank: "4",name: "#46")

@monster_46.zones.push("A8")

@monster_46.save

@monster_47 = Monster.create( 
    up: "6",
    down: "4",
    left: "5",
    right: "6",
    rank: "4",name: "#47")

@monster_47.zones.push("A8")
@monster_47.zones.push("A9")

@monster_47.save

@monster_48 = Monster.create( 
    up: "4",
    down: "6",
    left: "6",
    right: "5",
    rank: "4",name: "#48")

@monster_48.zones.push("A8")
@monster_48.zones.push("A9")

@monster_49.save

@monster_49 = Monster.create( 
    up: "6",
    down: "6",
    left: "6",
    right: "5",
    rank: "5",name: "#49")

@monster_49.zones.push("A8")
@monster_49.zones.push("A9")

@monster_49.save

@monster_50 = Monster.create( 
    up: "6",
    down: "5",
    left: "6",
    right: "6",
    rank: "5",name: "#50")

@monster_50.zones.push("A8")
@monster_50.zones.push("A9")

@monster_50.save

@monster_51 = Monster.create( 
    up: "5",
    down: "6",
    left: "6",
    right: "6",
    rank: "5",name: "#51")

@monster_51.zones.push("A8")
@monster_51.zones.push("A9")

@monster_51.save

@monster_52 = Monster.create( 
    up: "6",
    down: "6",
    left: "5",
    right: "6",
    rank: "5",name: "#52")

@monster_52.zones.push("A9")

@monster_52.save

@monster_53 = Monster.create( 
    up: "6",
    down: "6",
    left: "6",
    right: "6",
    rank: "6",name: "#53")

@monster_53.zones.push("A9")

@monster_53.save

@monster_54 = Monster.create( 
    up: "7",
    down: "7",
    left: "7",
    right: "7",
    rules: ["boss", "life"],
    rank: "7",name: "#54")

@monster_54.zones.push("A10")

@monster_54.save

# ZONE B //////////////////////////////////////////////////

@monster_20 = Monster.create( 
    up: "1",
    down: "2",
    left: "1",
    right: "2",
    rank: "1",name: "#20")

@monster_20.zones.push("B2")

@monster_20.save

@monster_21 = Monster.create( 
    up: "2",
    down: "1",
    left: "2",
    right: "1",
    rank: "1",name: "#21")

@monster_21.zones.push("B2")

@monster_21.save

@monster_22 = Monster.create( 
    up: "2",
    down: "1",
    left: "1",
    right: "3",
    rank: "1",name: "#22")

@monster_22.zones.push("B2")
@monster_22.zones.push("B3")


@monster_22.save

@monster_23 = Monster.create( 
    up: "2",
    down: "2",
    left: "1",
    right: "2",
    rank: "1",name: "#23")

@monster_23.zones.push("B2")
@monster_23.zones.push("B3")

@monster_23.save

@monster_24 = Monster.create( 
    up: "1",
    down: "3",
    left: "1",
    right: "3",
    rank: "1",name: "#24")

@monster_24.zones.push("B2")
@monster_24.zones.push("B3")


@monster_24.save

@monster_25 = Monster.create( 
    up: "2",
    down: "1",
    left: "4",
    right: "1",
    rank: "1",name: "#25")

@monster_25.zones.push("B2")
@monster_25.zones.push("B3")


@monster_25.save

@monster_26 = Monster.create( 
    up: "3",
    down: "2",
    left: "2",
    right: "1",
    rank: "1",name: "#26")

@monster_26.zones.push("B2")
@monster_26.zones.push("B3")

@monster_26.save

@monster_27 = Monster.create( 
    up: "4",
    down: "3",
    left: "1",
    right: "2",
    rank: "1",name: "#27")

@monster_27.zones.push("B3")

@monster_27.save

@monster_28 = Monster.create( 
    up: "3",
    down: "3",
    left: "4",
    right: "2",
    rank: "2",name: "#28")

@monster_28.zones.push("B3")

@monster_28.save

@monster_29 = Monster.create( 
    up: "2",
    down: "2",
    left: "3",
    right: "4",
    rank: "1",name: "#29")

@monster_29.zones.push("B4")

@monster_29.save

@monster_30 = Monster.create( 
    up: "3",
    down: "3",
    left: "4",
    right: "1",
    rank: "1",name: "#30")

@monster_30.zones.push("B4")

@monster_30.save

@monster_31 = Monster.create( 
    up: "1",
    down: "3",
    left: "4",
    right: "4",
    rank: "2",name: "#31")

@monster_31.zones.push("B4")

@monster_31.save

@monster_32 = Monster.create( 
    up: "3",
    down: "4",
    left: "3",
    right: "2",
    rank: "2",name: "#32")

@monster_32.zones.push("B4")

@monster_32.save

@monster_33 = Monster.create( 
    up: "2",
    down: "4",
    left: "3",
    right: "4",
    rank: "2",name: "#33")

@monster_33.zones.push("B4")

@monster_33.save

@monster_34 = Monster.create( 
    up: "4",
    down: "4",
    left: "4",
    right: "1",
    rank: "2",name: "#34")

@monster_34.zones.push("B4")

@monster_34.save

@monster_35 = Monster.create( 
    up: "4",
    down: "4",
    left: "4",
    right: "3",
    rank: "2",name: "#35")

@monster_35.zones.push("B4")

@monster_35.save

@monster_55 = Monster.create( 
    up: "3",
    down: "2",
    left: "2",
    right: "9",
    rank: "3",name: "#55")

@monster_55.zones.push("B6")

@monster_55.save

@monster_56 = Monster.create( 
    up: "2",
    down: "9",
    left: "4",
    right: "4",
    rank: "3",name: "#56")

@monster_56.zones.push("B6")

@monster_56.save

@monster_57 = Monster.create( 
    up: "4",
    down: "7",
    left: "1",
    right: "7",
    rank: "3",name: "#57")

@monster_57.zones.push("B6")

@monster_57.save

@monster_58 = Monster.create( 
    up: "8",
    down: "2",
    left: "3",
    right: "6",
    rank: "3",name: "#58")

@monster_58.zones.push("B6")

@monster_58.save

@monster_59 = Monster.create( 
    up: "7",
    down: "7",
    left: "5",
    right: "1",
    rank: "4",name: "#59")

@monster_59.zones.push("B6")

@monster_59.save

@monster_60 = Monster.create( 
    up: "6",
    down: "3",
    left: "5",
    right: "7",
    rank: "4",name: "#60")

@monster_60.zones.push("B6")

@monster_60.save

@monster_61 = Monster.create( 
    up: "8",
    down: "2",
    left: "7",
    right: "4",
    rank: "4",name: "#61")

@monster_61.zones.push("B6")

@monster_61.save

@monster_62 = Monster.create( 
    up: "6",
    down: "4",
    left: "3",
    right: "7",
    rank: "4",name: "#62")

@monster_62.zones.push("B7")

@monster_62.save

@monster_63 = Monster.create( 
    up: "8",
    down: "1",
    left: "3",
    right: "8",
    rank: "4",name: "#63")

@monster_63.zones.push("B7")

@monster_63.save

@monster_64 = Monster.create( 
    up: "3",
    down: "4",
    left: "6",
    right: "8",
    rank: "4",name: "#64")

@monster_64.zones.push("B7")

@monster_64.save

@monster_65 = Monster.create( 
    up: "6",
    down: "4",
    left: "8",
    right: "3",
    rank: "4",name: "#65")

@monster_65.zones.push("B7")

@monster_65.save

@monster_66 = Monster.create( 
    up: "6",
    down: "4",
    left: "9",
    right: "2",
    rank: "4",name: "#66")

@monster_66.zones.push("B7")

@monster_66.save

@monster_67 = Monster.create( 
    up: "4",
    down: "9",
    left: "8",
    right: "1",
    rank: "4",name: "#67")

@monster_67.zones.push("B7")

@monster_67.save

@monster_68 = Monster.create( 
    up: "6",
    down: "6",
    left: "9",
    right: "1",
    rank: "4",name: "#68")

@monster_68.zones.push("B7")

@monster_68.save

@monster_69 = Monster.create( 
    up: "1",
    down: "9",
    left: "6",
    right: "7",
    rank: "5",name: "#69")

@monster_69.zones.push("B8")

@monster_69.save

@monster_70 = Monster.create( 
    up: "2",
    down: "9",
    left: "8",
    right: "4",
    rank: "5",name: "#70")

@monster_70.zones.push("B8")

@monster_70.save

@monster_71 = Monster.create( 
    up: "2",
    down: "9",
    left: "9",
    right: "3",
    rank: "5",name: "#71")

@monster_71.zones.push("B8")

@monster_71.save

@monster_72 = Monster.create( 
    up: "5",
    down: "7",
    left: "9",
    right: "2",
    rank: "5",name: "#72")

@monster_72.zones.push("B8")

@monster_72.save

@monster_73 = Monster.create( 
    up: "8",
    down: "3",
    left: "3",
    right: "9",
    rank: "5",name: "#73")

@monster_73.zones.push("B8")

@monster_73.save

@monster_74 = Monster.create( 
    up: "8",
    down: "6",
    left: "5",
    right: "4",
    rank: "5",name: "#74")

@monster_74.zones.push("B8")

@monster_74.save

@monster_75 = Monster.create( 
    up: "9",
    down: "8",
    left: "4",
    right: "2",
    rank: "5",name: "#75")

@monster_75.zones.push("B8")

@monster_75.save

@monster_76 = Monster.create( 
    up: "1",
    down: "5",
    left: "9",
    right: "9",
    rank: "6",name: "#76")

@monster_76.zones.push("B9")

@monster_76.save

@monster_77 = Monster.create( 
    up: "6",
    down: "8",
    left: "2",
    right: "8",
    rank: "6",name: "#77")

@monster_77.zones.push("B9")

@monster_77.save

@monster_78 = Monster.create( 
    up: "7",
    down: "5",
    left: "3",
    right: "9",
    rank: "6",name: "#78")

@monster_78.zones.push("B9")

@monster_78.save

@monster_79 = Monster.create( 
    up: "7",
    down: "7",
    left: "7",
    right: "3",
    rank: "6",name: "#79")

@monster_79.zones.push("B9")

@monster_79.save

@monster_80 = Monster.create( 
    up: "9",
    down: "4",
    left: "6",
    right: "5",
    rank: "6",name: "#80")

@monster_80.zones.push("B9")

@monster_80.save

@monster_81 = Monster.create( 
    up: "9",
    down: "5",
    left: "4",
    right: "6",
    rank: "6",name: "#81")

@monster_81.zones.push("B9")

@monster_81.save

@monster_82 = Monster.create( 
    up: "9",
    down: "9",
    left: "5",
    right: "1",
    rank: "6",name: "#82")

@monster_82.zones.push("B9")

@monster_82.save