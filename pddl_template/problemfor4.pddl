;It's recommended to install the misc-pddl-generators plugin 
;and then use Network generator to create the graph
(define (problem p2-dangeon)
  (:domain Dangeon_4)
  (:objects
            cell1 cell2 cell3 cell4 cell5 cell6 cell7 cell8 cell9 cell10 cell11 cell12 cell13 cell14 - cells
            sword1 sword2 - swords
            hero1 hero2 - heros
            goal1 goal2 - goals
  )
  (:init
  
    ;Initial Hero Location
    (at-hero cell1 hero1)
    (at-hero cell9 hero2)
    ;Initial turn status
    (current-turn hero1)
    ;heros turn relation
    (next_action hero1 hero2)
    (next_action hero2 hero1)   
    
    ;He starts with a free arm
    (arm-free hero1)   
    (arm-free hero2) 
    
    ;Initial location of the swords
    (at-sword sword1 cell2)
    (at-sword sword1 cell4)
    (at-sword sword1 cell10)
    
    ;Initial location of Monsters
    (has-monster cell5)
    (has-monster cell11)
    (has-monster cell8) 
    ;Initial lcocation of Traps
    (has-trap cell3)
    (has-trap cell13)
    (has-trap cell7)  
    ;Initial goal condition for switch
    (at-goal hero1 cell6)
    (at-goal hero2 cell14)
    
    (goal-loc cell14)
    (goal-loc cell6)
    ;Graph Connectivity
    (connected cell1 cell9)
    (connected cell1 cell2)
    
    (connected cell2 cell1)
    (connected cell2 cell3)
    (connected cell2 cell9)

    (connected cell3 cell2) 
    (connected cell3 cell4)

    (connected cell4 cell3)
    (connected cell4 cell5)

    (connected cell5 cell4)
    (connected cell5 cell6)
    
    (connected cell6 cell5)
    (connected cell6 cell7)

    (connected cell7 cell6)
    (connected cell7 cell8)
    (connected cell7 cell14)
    
    (connected cell8 cell7)
    (connected cell8 cell9)

    (connected cell9 cell8)
    (connected cell9 cell2)
    (connected cell9 cell10)

    (connected cell10 cell9)
    (connected cell10 cell11)

    (connected cell11 cell10)
    (connected cell11 cell12)

    (connected cell12 cell13)
    (connected cell12 cell11)

    (connected cell13 cell12)
    (connected cell13 cell14)

    (connected cell14 cell7)
    (connected cell14 cell13)


  

  )
  (:goal (and
            ;Hero's Goal Location
            (at-hero cell6 hero1)
            (at-hero cell14 hero2)

  ))
  
)