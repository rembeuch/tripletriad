class PnjObjectivesManager
    def create_objectives(pnj)
        pnj.zone.nil? ? zone = 'A0' : zone = pnj.zone

        PNJ_OBJECTIVES[zone].each do |objective_data|
          PnjObjective.create(
            pnj: @pnj,
            name: objective_data[:name],
            condition: objective_data[:condition],
            completed: objective_data[:completed],
            reveal: objective_data[:reveal]
          )
        end
    end

    PNJ_OBJECTIVES = {
        #Kosmos
        A0: [

        ],
        #Aries
        A1: 
            [
                { name: "Try", condition: -> { pnj.try >= 10}, completed: false}, 
                { name: "Victory", condition: -> { pnj.victory >= 3 } },
                { name: "Perfect", condition: -> { pnj.perfect >= 1 } },
                # Ajouter d'autres objectifs ici...
            ]
    }
end