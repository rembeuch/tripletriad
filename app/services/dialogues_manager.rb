class DialoguesManager
    def self.calcul_dialogues(pnj, player)
        pnj.zone.nil? ? zone = 'A0' : zone = pnj.zone
        if pnj.try == 0
            dialogue_case = :case_1
          else
            dialogue_case = :case_2
          end
        dialogues = CASE_DIALOGUES[zone.to_sym][dialogue_case]
        pnj.update(dialogue: @dialogue)
    end

    CASE_DIALOGUES = {
        A0: {
          case_1: ["Oh Welcome young sealer", "Thank you to answer positively to my request"],
          case_2: ["Vous avez déjà bien progressé dans la zone 1."]
        },
        A1: {
          case_1: ["Bienvenue dans la zone 1, les dangers sont plus grands ici."],
          case_2: ["Ah, vous avez survécu jusqu'à la zone 1 ! Félicitations."]
        },
        # Ajoute plus de zones et de cas ici
      }
  end
  