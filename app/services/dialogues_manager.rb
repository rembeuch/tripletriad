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
                "Go check your Spirits!"
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728462370/Kosmos_b0kkjt.jpg",
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728462370/Kosmos_b0kkjt.jpg",
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728113281/compass_b9qu84.webp",
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728462370/Kosmos_b0kkjt.jpg",
            ]
          },
          demo: {
            dialogues: [
                "Bien tu as des monstres tu vas pouvoir y aller, regardes les règles des combats avant, c'est plus prudent!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728462370/Kosmos_b0kkjt.jpg",
            ]
          },
          in_fight: {
            dialogues: [
                "Courage! si tu remportes la bataille, le Compass pourras sceller un de ces spirits", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728462370/Kosmos_b0kkjt.jpg",
            ]
          },
          boss: {
            dialogues: [
                "Certains Spirits on parfois accumulé plus d'énergie et sont plus difficile à sceller. Observe les bien et tu trouveras surement comment les vaincre!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728462370/Kosmos_b0kkjt.jpg",
            ]
          },
          defeat: {
            dialogues: [
                "Ces spirits sont coriaces! Heureusement le compass te ramèneras toujours au sanctuaire en cas de danger", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728462370/Kosmos_b0kkjt.jpg",
            ]
          },
          victory: {
            dialogues: [
                "Bravo tu as réussi à capturer un Spirit", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728462370/Kosmos_b0kkjt.jpg",
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
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728461717/Aries_pevfjc.jpg",
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728461717/Aries_pevfjc.jpg",
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728461717/Aries_pevfjc.jpg",
            ]
          },
          in_fight: {
            dialogues: [
                "Affrontes ces Spirits pour en sceller un! Tu peux y arriver!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728461717/Aries_pevfjc.jpg",
            ]
          },
          boss: {
            dialogues: [
                "t'es tombé sur un gros morceau on dirait!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728461717/Aries_pevfjc.jpg",
            ]
          },
          defeat: {
            dialogues: [
                "Arf ils t'ont pas loupé! Te décourages pas!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728461717/Aries_pevfjc.jpg",
            ]
          },
          victory: {
            dialogues: [
                "Un de moins! Bien joué!", 
            ],
            images: [
                "https://res.cloudinary.com/dsiamykrd/image/upload/v1728461717/Aries_pevfjc.jpg",
            ]
          },
        },
        #Taurus
        A2: {
            welcome: {
              dialogues: [
                  "Salut, moi c'est Taurus! Le cousin d'Aries, t'as du le croiser.", 
                  "Tu arrives à maitriser le Compass?",
                  "Profites en pour sceller des monstres de plus en plus puissant!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1728465369/Taurus_oqxqc1.jpg",
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1728465369/Taurus_oqxqc1.jpg",
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1728465369/Taurus_oqxqc1.jpg",
              ]
            },
            in_fight: {
              dialogues: [
                  "Ah ah ça cogne dur!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1728465369/Taurus_oqxqc1.jpg",
              ]
            },
            boss: {
              dialogues: [
                  "t'es tombé sur un gros morceau on dirait!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1728465369/Taurus_oqxqc1.jpg",
              ]
            },
            defeat: {
              dialogues: [
                  "Te revoila! va faloir muscler ton jeu!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1728465369/Taurus_oqxqc1.jpg",
              ]
            },
            victory: {
              dialogues: [
                  "Oh tu en as scellé un!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1728465369/Taurus_oqxqc1.jpg",
              ]
            },
        },
        #Gem / ini
         A3: {
            welcome: {
              dialogues: [
                  "S'il te plait M'sieur, aides moi, mon frère Ini à disparu", 
                  "Papy Kosmos nous à demandé de veiller sur cette zone",
                  "Mais tout seul je ne vais pas y arriver", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729517450/gemini_z7aazp.webp",
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729517450/gemini_z7aazp.webp",
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729517450/gemini_z7aazp.webp",
              ]
            },
            in_fight: {
              dialogues: [
                  "Essaye de passer cette zone pour accéder à la prochaine M'sieur!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729517450/gemini_z7aazp.webp",
              ]
            },
            boss: {
              dialogues: [
                  "attention à celui la M'sieur, tu n'auras pas de seconde chance!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729517450/gemini_z7aazp.webp",
              ]
            },
            defeat: {
              dialogues: [
                  "Ne baissez pas les bras M'sieur, il faut retrouver mon frère!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729517450/gemini_z7aazp.webp",
              ]
            },
            victory: {
              dialogues: [
                  "Alors M'sieur? Tu as pu découvrir de nouvelles zones et obtenir des informations sur mon frère?", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729517450/gemini_z7aazp.webp",
              ]
            },
        },
        #Cancer
        A4: {
            welcome: {
              dialogues: [
                  "Yoho matelos!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729597604/Cancer_kjzcnh.jpg",
              ]
            },
            in_fight: {
              dialogues: [
                  "A l'abordage!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729597604/Cancer_kjzcnh.jpg",
              ]
            },
            boss: {
              dialogues: [
                  "Un Gros poisson!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729597604/Cancer_kjzcnh.jpg",
              ]
            },
            defeat: {
              dialogues: [
                  "T'as bu la tasse matelos!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729597604/Cancer_kjzcnh.jpg",
              ]
            },
            victory: {
              dialogues: [
                  "Belle Prise! Fêtons ça matelos!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729597604/Cancer_kjzcnh.jpg",
              ]
            },
        },
         #Rat
         B1: {
            welcome: {
              dialogues: [
                  "Yo!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729614709/Rat_fodvjv.webp",
              ]
            },
            in_fight: {
              dialogues: [
                  "Bagarre!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729614709/Rat_fodvjv.webp",
              ]
            },
            boss: {
              dialogues: [
                  "Boss!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729614709/Rat_fodvjv.webp",
              ]
            },
            defeat: {
              dialogues: [
                  "Perdu!!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729614709/Rat_fodvjv.webp",
              ]
            },
            victory: {
              dialogues: [
                  "Gagné!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729614709/Rat_fodvjv.webp",
              ]
            },
        },
        #Cthulhu
          A5: {
            welcome: {
              dialogues: [
                  "Blblblblblb!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729525050/Cthulhu_cwmjkd.jpg",
              ]
            },
            in_fight: {
              dialogues: [
                  "Blblblblblb!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729525050/Cthulhu_cwmjkd.jpg",
              ]
            },
            boss: {
              dialogues: [
                  "Blblblblblb!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729525050/Cthulhu_cwmjkd.jpg",
              ]
            },
            defeat: {
              dialogues: [
                  "Blblblblblb!!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729525050/Cthulhu_cwmjkd.jpg",
              ]
            },
            victory: {
              dialogues: [
                  "Blblblblblb!", 
              ],
              images: [
                  "https://res.cloudinary.com/dsiamykrd/image/upload/v1729525050/Cthulhu_cwmjkd.jpg",
              ]
            },
        },
    }
  end
  