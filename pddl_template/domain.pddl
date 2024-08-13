(define (domain Dangeon)

    (:requirements
        :typing
        :negative-preconditions
        ;for or conditions
        :disjunctive-preconditions
    )

    (:types
        swords cells
    )

    (:predicates
        ;Hero's cell location
        (at-hero ?loc - cells)
        
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
        (arm-free)
        
        ;Hero's holding a sword
        (holding ?s - swords)
    
        ;It becomes true when a trap is disarmed
        (trap-disarmed ?loc - cells)
        
    )

    ;Hero can move if the
    ;    - hero is at current location
    ;    - cells are connected, 
    ;    - there is no trap in current loc, and 
    ;    - destination does not have a trap/monster/has-been-destroyed
    ;Effects move the hero, and destroy the original cell. No need to destroy the sword.
    (:action move
        :parameters (?from ?to - cells)
        :precondition (and 
            (at-hero ?from)
            (connected ?from ?to)
            ; safly move from a room with a trap
            (imply 
                (has-trap ?from)
                (trap-disarmed ?from)                
            )
            ; safly move from a room with a monster
            (imply
                (has-monster ?from)
                (not (arm-free))
            )
            (and
                (not (has-trap ?to))
                (not (has-monster ?to))
                (not (is-destroyed ?to))
                
            )
                                                        
        )
        :effect (and
                    (at-hero ?to)
                    (not (at-hero ?from))
                    (is-destroyed ?from)
                           
                )
    )
    
    ;When this action is executed, the hero gets into a location with a trap
    (:action move-to-trap
        :parameters (?from ?to - cells)
        :precondition (and 
            (at-hero ?from)
            (has-trap ?to)
            (connected ?from ?to)
            ; safly move from a room with a trap
            (imply 
                (has-trap ?from)
                (trap-disarmed ?from) 
            )
            ; safly move from a room with a monster
            (imply
                (has-monster ?from)
                (not (arm-free))
            )
            (and
                (arm-free)
                (not (is-destroyed ?to))                
            )
                                                        
        )
        :effect (and 
                    (at-hero ?to)
                    (not (at-hero ?from))
                    (is-destroyed ?from)                             
                )
    )

    ;When this action is executed, the hero gets into a location with a monster
    (:action move-to-monster
        :parameters (?from ?to - cells ?s - swords)
        :precondition (and 
            (at-hero ?from)
            (connected ?from ?to)
            (holding ?s)
            ; safly move from a room with a trap
            (imply 
                (has-trap ?from)
                (trap-disarmed ?from)                 
            )
            ; safly move from a room with a monster
            (imply
                (has-monster ?from)
                (not (arm-free))
            )
            (and
                (has-monster ?to)
                (not (is-destroyed ?to))                
            )                            
        )
        :effect (and 
                    (at-hero ?to)
                    (not (at-hero ?from))
                    (is-destroyed ?from)                                                         
                )
    )
    
    ;Hero picks a sword if he's in the same location
    (:action pick-sword
        :parameters (?loc - cells ?s - swords)
        :precondition (and 
            (at-hero ?loc)
            (arm-free)
            (at-sword ?s ?loc)
                            
        )
        :effect (and
            (not (arm-free))
            (holding ?s)
            (not (at-sword ?s ?loc))
                            
        )
    )
    
    ;Hero destroys his sword. 
    (:action destroy-sword
        :parameters (?loc - cells ?s - swords)
        :precondition (and 
            (at-hero ?loc)
            (holding ?s)
            (not (has-monster ?loc))
            (not (has-trap ?loc))                            
        )
        :effect (and
            (arm-free)
            (not (holding ?s))
            (is-destroyed ?s)
                            
        )
    )
    
    ;Hero disarms the trap with his free arm
    (:action disarm-trap
        :parameters (?loc - cells)
        :precondition (and 
        (at-hero ?loc)
        (arm-free)
        (has-trap ?loc)                           
        )
        :effect (and
            (trap-disarmed ?loc)                    
                )
    )
    
)