class PnjObjectivesManager
    def self.create_objectives(pnj)
        pnj.zone.nil? ? zone = 'A0' : zone = pnj.zone

        PNJ_OBJECTIVES[zone.to_sym].each do |objective_data|
          PnjObjective.create(
            pnj: pnj,
            name: objective_data[:name],
            condition: objective_data[:condition],
            reveal: objective_data[:reveal],
          )
        end
    end

    PNJ_OBJECTIVES = {
        #Kosmos
        A0: [
            { name: "try", condition: "100", reveal: false}, 
            { name: "victory", condition: "50", reveal: false },
            { name: "perfect", condition: "30", reveal: false },
            { name: "boss", condition: "30", reveal: false },
            { name: "monsters", condition: "129", reveal: false },
            { name: "awake", condition: "27", reveal: false },
        ],
        #Aries
        A1: 
            [
                { name: "try", condition: "10", reveal: true}, 
                { name: "victory", condition: "5", reveal: true },
                { name: "perfect", condition: "3", reveal: true },
                { name: "boss", condition: "3", reveal: true },
                { name: "monsters", condition: "7", reveal: true },
                { name: "awake", condition: "1", reveal: false },
                { name: "pnj", condition: "B1", reveal: false },
                { name: "pnj2", condition: "B1", reveal: false },
                # Ajouter d'autres objectifs ici...
            ],
         #Taurus
         A2: 
         [
             { name: "try", condition: "10", reveal: true}, 
             { name: "victory", condition: "5", reveal: true },
             { name: "perfect", condition: "3", reveal: true },
             { name: "boss", condition: "3", reveal: true },
             { name: "monsters", condition: "7", reveal: true },
             { name: "awake", condition: "1", reveal: false },
             { name: "pnj", condition: "B2", reveal: false },
             { name: "pnj2", condition: "B2", reveal: false },
             # Ajouter d'autres objectifs ici...
         ],
    }
end