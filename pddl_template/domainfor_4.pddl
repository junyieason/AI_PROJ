(define (domain Dangeon_4)

    (:requirements
        :typing
        :negative-preconditions
        ;for or conditions
        :disjunctive-preconditions
    )

    (:types
        swords cells heros goals
    )

    (:predicates
        ;goal location
        (goal-loc ?loc - cells)
              
        ;Hero's cell location
        (at-hero ?loc - cells ?single_hero -heros)
        
        ;Sword cell location
        (at-sword ?s - swords ?loc - cells)
        
        ;Indicates if a cell location has a monster
        (has-monster ?loc - cells)
        
        ;Indicates if a cell location has a trap
        (has-trap ?loc - cells)
        
        ;Indicates if a chell or sword has been destroyed
        (is-destroyed ?obj)
        
        ;connects cells
        (connected ?from ?to - cells)
        
        ;Hero's hand is free
        (arm-free ?single_hero -heros)
        
        ;Hero's holding a sword
        (holding ?s - swords ?single_hero -heros)
        ;Hero standing in a cell
        (cell_full ?loc - cells)
    
        ;It becomes true when a trap is disarmed
        (trap-disarmed ?loc - cells)
        
        ;determine wheather the current hero reach the goal or not
        (at-goal ?single_hero - heros ?loc - cells)

        ;represent turn for each hero
        (current-turn ?single_hero - heros)
        ;justify the next hero who needs to take action
        (next_action ?single_hero - heros ?next_hero - heros)

        ;expire hero who reach goal
        (hero-expired ?single_hero - heros)     
    )

    ;Hero can move if the
    ;    - hero is at current location
    ;    - cells are connected, 
    ;    - there is no trap in current loc, and 
    ;    - destination does not have a trap/monster/has-been-destroyed
    ;Effects move the hero, and destroy the original cell. No need to destroy the sword.
     ;Hero disarms the trap with his free arm
    
    
    ;switch the turn for finished hero
    (:action switch_turn
        :parameters (?current_hero - heros ?connected_hero - heros ?goalcell - cells)
        :precondition (and 
          (current-turn ?current_hero)
          (next_action ?current_hero ?connected_hero) 
          (hero-expired ?current_hero)                   
        )
        :effect (and  
            (not(current-turn ?current_hero)) 
            (current-turn ?connected_hero)   
            )
    )   
      
    (:action move
        :parameters (?from ?to - cells ?single_hero - heros ?next_hero - heros)
        :precondition (and 
            (at-hero ?from ?single_hero)
            (connected ?from ?to)
            (current-turn ?single_hero)
            (not (hero-expired ?single_hero))
            (next_action ?single_hero ?next_hero)          
            ; safly move from a room with a trap
            (imply 
                (has-trap ?from)
                (trap-disarmed ?from)                
            )
            ; safly move from a room with a monster
            (imply
                (has-monster ?from)
                (not (arm-free ?single_hero))
            )
            (and
                (not (has-trap ?to))
                (not (has-monster ?to))
                (not (is-destroyed ?to)) 
                (not (cell_full ?to))               
            )
                                                        
        )
        :effect (and
                    (at-hero ?to ?single_hero)
                    (cell_full ?to)
                    (not (at-hero ?from ?single_hero))
                    (is-destroyed ?from) 
                    (not (current-turn ?single_hero))
                    (current-turn ?next_hero)  
                                        
                )
    )
    (:action move_next_goal
        :parameters (?from ?to - cells ?single_hero - heros ?next_hero - heros)
        :precondition (and 
            (at-hero ?from ?single_hero)
            (connected ?from ?to)
            (current-turn ?single_hero)
            (goal-loc ?to)                    
            ; safly move from a room with a trap
            (imply 
                (has-trap ?from)
                (trap-disarmed ?from)                
            )
            ; safly move from a room with a monster
            (imply
                (has-monster ?from)
                (not (arm-free ?single_hero))
            )
            (and
                (not (has-trap ?to))
                (not (has-monster ?to))
                (not (is-destroyed ?to)) 
                (not (cell_full ?to))               
            )
                                                        
        )
        :effect (and
                    (at-hero ?to ?single_hero)
                    (cell_full ?to)
                    (not (at-hero ?from ?single_hero))
                    (is-destroyed ?from) 
                    (not (current-turn ?single_hero))
                    (current-turn ?next_hero)
                    (hero-expired ?single_hero)
                )
    )
    
    ;When this action is executed, the hero gets into a location with a trap
    (:action move-to-trap
        :parameters (?from ?to - cells ?single_hero - heros ?next_hero - heros)
        :precondition (and 
            (at-hero ?from ?single_hero)
            (has-trap ?to)
            (connected ?from ?to)
            (current-turn ?single_hero)
            (not (hero-expired ?single_hero))
            (next_action ?single_hero ?next_hero)  
            ; safly move from a room with a trap
            (imply 
                (has-trap ?from)
                (trap-disarmed ?from) 
            )
            ; safly move from a room with a monster
            (imply
                (has-monster ?from)
                (not (arm-free ?single_hero))
            )
            (and
                (arm-free ?single_hero)
                (not (is-destroyed ?to))
                (not (cell_full ?to))                
            )
                                                        
        )
        :effect (and 
                    (at-hero ?to ?single_hero)
                    (cell_full ?to)
                    (not (at-hero ?from ?single_hero))
                    (is-destroyed ?from) 
                    (not (current-turn ?single_hero))
                    (current-turn ?next_hero)                            
                )
    )

    ;When this action is executed, the hero gets into a location with a monster
    (:action move-to-monster
        :parameters (?from ?to - cells ?s - swords ?single_hero - heros ?next_hero - heros)
        :precondition (and 
            (at-hero ?from ?single_hero)
            (connected ?from ?to)
            (holding ?s ?single_hero)
            (current-turn ?single_hero)
            (not (hero-expired ?single_hero))
            (next_action ?single_hero ?next_hero)  
            ; safly move from a room with a trap
            (imply 
                (has-trap ?from)
                (trap-disarmed ?from)                 
            )
            ; safly move from a room with a monster
            (imply
                (has-monster ?from)
                (not (arm-free ?single_hero))
            )
            (and
                (has-monster ?to)
                (not (is-destroyed ?to))
                (not (cell_full ?to))                
            )                            
        )
        :effect (and 
                    (at-hero ?to ?single_hero)
                    (cell_full ?to)
                    (not (at-hero ?from ?single_hero))
                    (is-destroyed ?from) 
                    (not (current-turn ?single_hero))
                    (current-turn ?next_hero)  
                                                                         
                )
    )
    
    ;Hero picks a sword if he's in the same location
    (:action pick-sword
        :parameters (?loc - cells ?s - swords ?single_hero - heros ?next_hero - heros)
        :precondition (and 
            (at-hero ?loc ?single_hero)
            (arm-free ?single_hero)
            (at-sword ?s ?loc)
            (current-turn ?single_hero)
            (not (at-goal ?single_hero ?loc))   
            (next_action ?single_hero ?next_hero)             
        )
        :effect (and
            (not (arm-free ?single_hero))
            (holding ?s ?single_hero)
            (not (at-sword ?s ?loc))
            (not (current-turn ?single_hero))
            (current-turn ?next_hero)
           
                            
        )
    )
    
    ;Hero destroys his sword. 
    (:action destroy-sword
        :parameters (?loc - cells ?s - swords ?single_hero - heros ?next_hero - heros)
        :precondition (and 
            (at-hero ?loc ?single_hero)
            (holding ?s ?single_hero)
            (not (has-monster ?loc))
            (not (has-trap ?loc))   
            (current-turn ?single_hero)
            (not (at-goal ?single_hero ?loc))   
            (next_action ?single_hero ?next_hero)                      
        )
        :effect (and
            (arm-free ?single_hero)
            (not (holding ?s ?single_hero))
            (is-destroyed ?s)
            (not (current-turn ?single_hero))
            (current-turn ?next_hero)
          
                            
        )
    )
    
    ;Hero disarms the trap with his free arm
    (:action disarm-trap
        :parameters (?loc - cells ?single_hero - heros ?next_hero - heros)
        :precondition (and 
        (at-hero ?loc ?single_hero)
        (arm-free ?single_hero)
        (has-trap ?loc) 
        (current-turn ?single_hero)
        (not (at-goal ?single_hero ?loc)) 
        (next_action ?single_hero ?next_hero)                         
        )
        :effect (and
            (trap-disarmed ?loc)
            (not (current-turn ?single_hero))
            (current-turn ?next_hero)                           
        )
    )
   
)