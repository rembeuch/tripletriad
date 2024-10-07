class DialoguesManager
    def self.calcul_dialogues(pnj, event, player)
        pnj.zone.nil? ? zone = 'A0' : zone = pnj.zone
        if pnj.try == 0
            dialogue_case = :welcome
        end
        if event == "boss"
            dialogue_case = :boss
            #mettre plusieurs cas
        end
        if event == "defeat"
            dialogue_case = :defeat
            #mettre plusieurs cas random?
        end
        if event == "victory"
            dialogue_case = :victory
            #mettre plusieurs cas random?
        end
        @dialogue = CASE_DIALOGUES[zone.to_sym][dialogue_case]
    end

    CASE_DIALOGUES = {
        #Kosmos
        A0: {
          welcome: {
            dialogues: [
                "Oh Welcome young sealer, I am Kosmos!", 
                "Thank you to answer positively to my request",
                "Take the Magic Compass!", 
                "Go check your monster!"
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1728032580/Cosmos_jst1aj.webp",
                "https://res.cloudinary.com/dsiamykrd/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1728032580/Cosmos_jst1aj.webp",
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728113281/compass_b9qu84.webp",
                "https://res.cloudinary.com/dsiamykrd/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1728032580/Cosmos_jst1aj.webp",
            ]
          },
          demo: {
            dialogues: [
                "Bien tu as des monstres tu vas pouvoir y aller, regardes les règles des combats avant, c'est plus prudent!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1728032580/Cosmos_jst1aj.webp",
            ]
          },
          in_fight: {
            dialogues: [
                "Courage! si tu remportes la bataille, le Compass pourras sceller un de ces spirits", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1728032580/Cosmos_jst1aj.webp",
            ]
          },
          boss: {
            dialogues: [
                "Certains Spirits on parfois accumulé plus d'énergie et sont plus difficile à sceller. Observe les bien et tu trouveras surement comment les vaincre!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1728032580/Cosmos_jst1aj.webp",
            ]
          },
          defeat: {
            dialogues: [
                "Ces spirits sont coriaces! Heureusement le compass te ramèneras toujours au sanctuaire en cas de danger", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1728032580/Cosmos_jst1aj.webp",
            ]
          },
          victory: {
            dialogues: [
                "Bravo tu as réussi à capturer un Spirit", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/w_1000,ar_1:1,c_fill,g_auto,e_art:hokusai/v1728032580/Cosmos_jst1aj.webp",
            ]
          },
        },
        #Aries
        A1: {
          welcome: {
            dialogues: [
                "Salut, moi c'est Aries! C'est Kosmos qui t'envoie?", 
                "il y a du monstres a sceller par ici!",
                "Sois prudent.", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728198070/b%C3%A9lier_jdidsq.webp",
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728198070/b%C3%A9lier_jdidsq.webp",
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728198070/b%C3%A9lier_jdidsq.webp",
            ]
          },
          in_fight: {
            dialogues: [
                "Affrontes ces Spirits pour en sceller un! Tu peux y arriver!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728198070/b%C3%A9lier_jdidsq.webp",
            ]
          },
          boss: {
            dialogues: [
                "t'es tombé sur un gros morceau on dirait!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728198070/b%C3%A9lier_jdidsq.webp",
            ]
          },
          defeat: {
            dialogues: [
                "Arf ils t'ont pas loupé! Te décourages pas!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728198070/b%C3%A9lier_jdidsq.webp",
            ]
          },
          victory: {
            dialogues: [
                "Un de moins! Bien joué!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728198070/b%C3%A9lier_jdidsq.webp",
            ]
          },
        },
      }
  end
  