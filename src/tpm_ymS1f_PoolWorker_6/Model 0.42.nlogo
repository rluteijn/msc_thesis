extensions [profiler]


;; <<<<<<<<<<<<<<<<<<<< Variable definitions and Breed creation >>>>>>>>>>>>>>>>>>>>>>>>>>>

breed [states state]
undirected-link-breed  [Alliances Alliance]
undirected-link-breed  [DiplomaticRelations DiplomaticRelation]
directed-link-breed [Exports Export]

patches-own [
  my-state
  patch-population
  patch-GDPperCapita
  economic-size
  my-neighbors
  resource-type
  Resource-present?
  capital?
]

states-own [ 
  my-provinces
  count-provinces
  GDP
  GDPpercapita
  MilitaryCapabilities
  MilitarySpending
  Decision-spending
  Population
  neighbor-states
  power
  tradingpartners
  ExportSize
  ImportSize
  hostile-states
  friendly-states
  resource-allocation
  senseofsecurity
  rank
  initial-rank
  received-rank?
  received-FPR-rank?
  Decision
  Major-Power?
  Invaluable-partners
  FPR-benefits
  expected-FPR-benefits
  FPR-rank
  FPR-satisfaction
  w1 w2 w3 w4 w5
]

Alliances-own [ ] 

DiplomaticRelations-own [
  Attitude 
  conflict 
  time-of-last-conflict  
  type-of-last-conflict
  counter-round
  interdependence-magnitude
  decision-first
  decision-second
  conflict-memory
]

exports-own [ 
  tradevolume
]

globals [ total-population current-amount-of-states total-Militarycapabilities total-GDP total-area Hegemon power-transition war-counter major-power-war-counter]

;; <<<<<<<<<<<<<<<<<<<< Setup >>>>>>>>>>>>>>>>>>>>>>>>>>>

to setup
  clear-all
  reset-ticks
  creating-states
  set-capitals
  grow-states
  setup-patch-variables
  setup-state-variables  
  create-diplomaticnetwork
  create-tradenetwork      
  rank-states
  setup-globals
  set-neighborstates
end

;; <<<<<<<<<<<<<<<<<<<< Setup 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to creating-states
  create-States amount-of-states [
    setxy round random-xcor round random-ycor ;; the world is NOT wrapped, i.e. the world as depicted is flat
    set color (([who] of self) * (130 / amount-of-states)) ;; purely meant to assign a range of colors to states, even if there are only a few states. 140 is the amount of available colors, 130 is used to prevent duplicates
    set shape "x"
    set GDPpercapita random-float Max-initial-GDPperCapita
  ]
end

;; <<<<<<<<<<<<<<<<<<<< Setup 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to set-capitals
  ask states
  [
    while [any? other states-here] [ move-to one-of patches ] ;; each state is the sole occupant of the patch it is on. If so, this province becomes its capital. 
    ask patch-here
    [
      set my-state myself ;; every patch has a variable identifying the state it is part of
      set capital? true
    ]
  ] 
end

;; <<<<<<<<<<<<<<<<<<<< Setup 3 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to grow-states
  while [any? patches with [my-state = 0]] [ ;; as long as there are any patches without an owner, perform this method
    ask patches with [ my-state != 0 ] ;; ask states that DO have an owner
    [
      let my-new-patch one-of neighbors4 with [my-state = 0] ;; ask the 4 neighbors of such a patch
      if (my-new-patch != nobody) ;; if any of these 4 neighbors has no owner, it will join the state
      [ 
        let the-state my-state
        ask my-new-patch
        [
          set my-state the-state
          set pcolor ([color] of my-state) ;; They get the same color for identification purposes.
        ]
      ]
    ]
  ]
end

;; <<<<<<<<<<<<<<<<<<<< Setup 4 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to setup-patch-variables
  ask patches [    
    set patch-population random Max-initial-patch-population 
    set patch-GDPperCapita [GDPpercapita] of my-state
    set economic-size (patch-population * patch-GDPperCapita)
    
    if (capital? != true ) [set capital? false ]
    
  ]  
  ask n-of (count patches * likelihoodofresourcespresent) patches [ ;; based on the likelihood that a patch contains resources
    set resource-type ((random 5) + 1) ;; assign type of resources 1 - 5
    set resource-present? true
  ]
end

;; <<<<<<<<<<<<<<<<<<<< Setup 5 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to setup-state-variables
  ask states [
    set my-provinces patches with [my-state = myself] ;; helpful list containing all patches owned by current state
    set count-provinces count my-provinces
    set GDP (sum [ economic-size] of my-provinces) ;; GDP of provinces owned summarised into a single GDP variable
    set Population sum [patch-population] of my-provinces ;; Population of provinces owned summarised into a single Population variable
    set MilitaryCapabilities random-normal mean-initial-military-capabilities SD-initial-military-capabilities
    if (MilitaryCapabilities < 0) [set MilitaryCapabilities 0]  ;; making sure military capabilities are non negative  
    set MilitarySpending random-normal mean-military-spending SD-military-spending
    set received-rank? false
    set received-FPR-rank? false
    set FPR-satisfaction 0
    set Decision-spending false
    set Major-Power? false
    set power-transition []
    set tradingpartners [other-end] of my-in-exports
    set Invaluable-partners []
    set w1 10
    set w2 5
    set w3 1
    set w4 1
    set w5 10
  ]  
end

;; <<<<<<<<<<<<<<<<<<<< Setup 6 >>>>>>>>>>>>>>>>>>>>>>>>>>>


to create-tradenetwork
  ask states [
    foreach friendly-states [
      create-export-to ? [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume hide-link]  ;; every state can trade with every state  
    ]
  ]  
end

;; <<<<<<<<<<<<<<<<<<<< Setup 7 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to create-diplomaticnetwork
  ask states[ create-DiplomaticRelations-with other states ] ;; every state can exchange attitude with every other state
  ask DiplomaticRelations [
    hide-link
    set conflict false
    set decision-first 0
    set decision-second 0
    set counter-round 0
    set conflict-memory []
    set attitude random 11
    ifelse (attitude > 5) [
      set color green] ;; positive attitude green
    [set color red]  ;; negative attitude red
  ]
  ask states [ let friendly-links my-DiplomaticRelations with [attitude >= 5]
    set friendly-states [other-end] of friendly-links 
  ]
end

;; <<<<<<<<<<<<<<<<<<<< Setup 8 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to setup-globals
  set total-population sum[population] of states
  set current-amount-of-states count states
  set total-Militarycapabilities sum[MilitaryCapabilities] of states
  set total-GDP sum[GDP] of states
  set total-area count patches
  ask states [set power set-power
    if (any? states with [power > Threshold-major-power ]) [ ask states with [power > Threshold-major-power ] [set Major-Power? true ]]]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Go Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go
  rank-states
  foreign-policy-role
  setup-globals
  create-conflict
  update-attributes
  set-neighborstates
  decide
  interact
  observe
  change-traderelations
  update-attitudes
  conflictmemory
  tick  
end


to update-attributes ;; endogenous growth of variables since last tick
  ask patches [
    set patch-population (patch-population * (random-normal mean-population-growth SD-population-growth + 1))
    set patch-GDPperCapita (patch-GDPperCapita * (random-normal mean-GDP-growth SD-GDP-growth + 1)) ;; gdp per capita for country as a whole? or take GDP per capita + standard deviation as patch GDP
    set economic-size (patch-population * patch-GDPperCapita)
    if ( patch-population < 0) [set patch-population 0]
    if ( patch-GDPperCapita < 0) [set patch-GDPperCapita 0]
  ]
  
  ask states [ ;; update variables with endogeneous growth, set total values of import and export, set internal resource allocations
    set my-provinces patches with [my-state = myself]
    set count-provinces count my-provinces
    set ExportSize sum [tradevolume] of my-out-exports
    set ImportSize sum [tradevolume] of my-in-exports
    
    set GDP (sum [ economic-size] of my-provinces) + Exportsize - Importsize
    if (GDP <= 0) [ set GDP 0.1 ]
    set Population (sum [patch-population] of my-provinces)
    let normal random-normal mean-military-spending SD-military-spending
    let senseofsecurity-effects 1
    carefully [set senseofsecurity-effects (1 / senseofsecurity)] [set senseofsecurity-effects 0 ] ;; high sense of security means lower militar spending
    let compensation-current-size (militarycapabilities / 10) / GDP
    let increase 0
    if ( Decision-spending = true ) [ set increase increased-mil-spending set Decision-spending false]
    set MilitarySpending normal + (senseofsecurity-effects - compensation-current-size + increase ) * MilitaryCapabilities
         set MilitaryCapabilities (MilitaryCapabilities + MilitarySpending)
    if (militarycapabilities < random-normal mean-initial-military-capabilities SD-initial-military-capabilities) [ set militarycapabilities random-normal mean-initial-military-capabilities SD-initial-military-capabilities]
    if (MilitaryCapabilities < 0) [ set MilitaryCapabilities 0 ]
    set power set-power
    
    set resource-allocation [resource-type] of my-provinces with [resource-present? = true]
    set resource-allocation remove-duplicates resource-allocation
    set Invaluable-partners remove-duplicates Invaluable-partners
    
    set decision 0
    set Major-Power? false
    
    if (any? states with [power > Threshold-major-power ]) [ ask states with [power > Threshold-major-power ] [set Major-Power? true ]]    
  ]
  
  ask Exports [ set tradevolume tradevolume * random-normal mean-tradevolume-growth SD-tradevolume-growth] ;; update exports with mean growth
end

to observe ;; identify threats, potential allies, etc.
  ask states [
    ifelse (any? my-DiplomaticRelations with [attitude < 5]) [
      let hostile-links my-DiplomaticRelations with [attitude < 5]
      set hostile-states [other-end] of hostile-links ]
    [ set hostile-states []]
    
    ifelse (any? my-DiplomaticRelations with [attitude >= 5]) [
      let friendly-links my-DiplomaticRelations with [attitude >= 5]
      set friendly-states [other-end] of friendly-links]
    [ set friendly-states []]
    
    set senseofsecurity find-senseofsecurity self nobody "nothing"
  ]
end

to decide 
  ask states [
    if (any? my-diplomaticrelations with [conflict = true])
      [ 
        if (any? my-diplomaticrelations with [conflict = true AND attitude > 5]) [
          ask my-diplomaticrelations with [conflict = true and attitude > 5] [
            set time-of-last-conflict ticks
            set type-of-last-conflict "friendly"
            set conflict false
          ]]]
    
    if (any? my-diplomaticrelations with [conflict = true]) [
      let target [other-end] of my-diplomaticrelations with [conflict = true]
      let first-state self
      foreach target [
        let power-differential [militarycapabilities] of ? - militarycapabilities
        let chance-winning pWinning self ? nobody
        let expected-spoils reparations-factor * count [my-provinces] of ? 
        let expected-losses reparations-factor * count my-provinces
        let military-losses attritionrate * [militarycapabilities] of ? 
        let loss-of-trade-direct interdependence self ? 
        let potential-allies request-alliance self ? 
        let fight-security find-senseofsecurity self ? "fight"
        let submit-security find-senseofsecurity self ? "submit"
        let nothing-security find-senseofsecurity self ? "nothing"
        let enemy ?
                      
        ifelse ( [counter-round] of diplomaticrelation who [who] of ? >= threshold-counter ) [
          let u-fight w1 * chance-winning * expected-spoils - w2 * expected-losses * (1 - chance-winning) - w3 * military-losses - w4 * loss-of-trade-direct + w5 * fight-security
          let u-submit w5 * submit-security + w2 * (reparations-factor - give-in-compensation) * count my-provinces
          
          ifelse ( u-fight > u-submit )
          [ask diplomaticrelation who [who] of ? [ set counter-round 0 ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
          [ask diplomaticrelation who [who] of ? [ set counter-round 0 ifelse (first-state = end1) [set decision-first "submit"][set decision-second "submit"]]]]
        
        [ ifelse (chance-winning  < 0.38) [ ;; you're screwed, your only option is to get a major power to defend you
          ifelse ( potential-allies != [] ) [ 
            let max-chance-winning chance-winning
            let alliance-choice nobody
            foreach potential-allies [
              let chance-winning-alliance pWinning self enemy ?
              if ( chance-winning-alliance > max-chance-winning ) [
                set max-chance-winning chance-winning-alliance
                set alliance-choice ?]]
            if (alliance-choice != nobody) [
              create-alliance-with alliance-choice
              ask diplomaticrelation who [who] of ? [set counter-round counter-round + 1]
          ]]
          ;; to be added change in sense of security                                            
          ;;if ( [FPR-benefits] of ? > FPR-benefits) [] ;; increase in FPR satisfaction
          [
            let u-fight w1 * chance-winning * expected-spoils - w2 * expected-losses * (1 - chance-winning) - w3 * military-losses - w4 * loss-of-trade-direct + w5 * fight-security
            let u-submit w5 * submit-security + w2 * (reparations-factor - give-in-compensation) * count my-provinces
            ifelse ( u-fight > u-submit )
            [ask diplomaticrelation who [who] of ? [ ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
            [ifelse (count my-provinces <= 2) [ask diplomaticrelation who [who] of ? [ ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
              [ask diplomaticrelation who [who] of ? [ ifelse (first-state = end1) [set decision-first "submit"][set decision-second "submit"]]]]      
          ]]
        
        [
          ifelse (chance-winning > 0.62)
            [  ;; you're going to win, no need to worry. Try to extract some profit from the conflict.                 
              let u-fight w1 * chance-winning * expected-spoils - w2 * expected-losses * (1 - chance-winning) - w3 * military-losses - w4 * loss-of-trade-direct + w5 * fight-security
              let u-nothing w5 * nothing-security
              
              ifelse ( u-fight > u-nothing ) 
              [ask diplomaticrelation who [who] of ? [ ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
              [ask diplomaticrelation who [who] of ? [ ifelse (first-state = end1) [set decision-first "nothing"][set decision-second "nothing"]]]
            ]
            [
              ;; Opponent has no decisive military advantage or disadvantage
              let max-chance-winning chance-winning
              let alliance-choice nobody
              let u-alliance-fight -1000
              if ( potential-allies != [] ) [ 
                foreach potential-allies [
                  let chance-winning-alliance pWinning self enemy ?
                  if ( chance-winning-alliance > max-chance-winning ) [
                    set max-chance-winning 0
                    set alliance-choice ?]]]
              if ( alliance-choice != nobody) [
                let powershare power / (power + [power] of alliance-choice)
                let expected-spoils2 (reparations-factor * count [my-provinces] of ?) / powershare
                let expected-losses2 (reparations-factor * (count my-provinces + count [my-provinces] of alliance-choice )) / powershare
                let military-losses2 attritionrate * [militarycapabilities] of ? 
                let loss-of-trade-direct2 interdependence self ?
                set u-alliance-fight w1 * max-chance-winning * expected-spoils2 - w2 * expected-losses2 * (1 - max-chance-winning) - w3 * military-losses2 - w4 * loss-of-trade-direct2 + w5 * fight-security]
              
              let u-fight w1 * chance-winning * expected-spoils - w2 * expected-losses * (1 - chance-winning) - w3 * military-losses - w4 * loss-of-trade-direct + w5 * fight-security
              let u-submit w5 * submit-security + w2 * (reparations-factor - give-in-compensation) * count my-provinces
              let u-nothing w5 * nothing-security
              let max-utility max ( list u-alliance-fight u-fight u-submit u-nothing )
              
              ;;show ( list u-alliance-fight u-fight u-submit u-nothing )
            
              if ( u-fight = max-utility ) [ask diplomaticrelation who [who] of ? [ ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
              if ( u-submit = max-utility ) [ifelse (count my-provinces <= 2) [ask diplomaticrelation who [who] of ? [ ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
              [ask diplomaticrelation who [who] of ? [ ifelse (first-state = end1) [set decision-first "submit"][set decision-second "submit"]]]]  
              
              if ( u-nothing = max-utility ) [ask diplomaticrelation who [who] of ? [ ifelse (first-state = end1) [set decision-first "militarycapabilities"][set decision-second "militarycapabilities"]]]
              if ( u-alliance-fight = max-utility ) [
                create-alliance-with alliance-choice
                ask diplomaticrelation who [who] of ? [set counter-round counter-round + 1]
              ]]]]]]]
end

to interact
  ask diplomaticrelations [
    if (conflict = true)[
      if ( decision-first = "mobilise & fight" AND decision-second = "mobilise & fight" ) [ set counter-round 0 set conflict false wage-war end1 end2 set type-of-last-conflict "armedconflict"  set decision-first 0 set decision-second 0];; show "1"]
      if ( decision-first = "submit" AND decision-second = "submit") [ set counter-round 0 set conflict false set type-of-last-conflict "submitted" set decision-first 0 set decision-second 0];; show "2"]
      
      if (decision-first = "mobilise & fight" AND decision-second = "submit") [ set conflict false structural-change end1 end2 "submit" set type-of-last-conflict "bargaining" set decision-first 0 set decision-second 0];; show "3"]
      if (decision-second = "mobilise & fight" AND decision-first = "submit" ) [set conflict false structural-change end2 end1 "submit" set type-of-last-conflict "bargaining" set decision-first 0 set decision-second 0];; show "4" ] 
      
      if ( decision-first = "mobilise & fight" AND decision-second = "militarycapabilities") [ ;; states now have the choice: fight or submit
        set counter-round 0
        let expected-spoils reparations-factor * count [my-provinces] of end1
        let expected-losses reparations-factor * count [my-provinces] of end2
        let military-losses attritionrate * [militarycapabilities] of end1
        let loss-of-trade-direct interdependence end1 end2
        ifelse ( pwinning end2 end1 nobody * expected-spoils - expected-losses * pwinning end2 end1 nobody - military-losses - loss-of-trade-direct > (reparations-factor - give-in-compensation) * count [my-provinces] of end2)
        [ set decision-second "mobilise & fight"] [set decision-second "submit" ]];; show "5" ] 
      
      if (decision-second = "mobilise & fight" AND decision-first = "militarycapabilities" ) [ 
        set counter-round 0
        let expected-spoils reparations-factor * count [my-provinces] of end2
        let expected-losses reparations-factor * count [my-provinces] of end1
        let military-losses attritionrate * [militarycapabilities] of end2
        let loss-of-trade-direct interdependence end2 end1
        ifelse ( pwinning end1 end2 nobody * expected-spoils - expected-losses * pwinning end1 end2 nobody - military-losses - loss-of-trade-direct > (reparations-factor - give-in-compensation) * count [my-provinces] of end1)
        [ set decision-first "mobilise & fight"] [set decision-first "submit" ]];; show "6"]
              
      if (decision-first = "submit" AND decision-second = "militarycapabilities") [ set conflict false  set decision-first 0 set decision-second 0];; show "7"] ;; very weak bargaining game here, what happens?
      if (decision-second = "submit" AND decision-first = "militarycapabilities" ) [ set conflict false  set decision-first 0 set decision-second 0];; show "8"]
      
      ifelse ( (decision-first = "militarycapabilities" ) AND (decision-second = "militarycapabilities" )) [
        set counter-round counter-round + 1
        ;;show "9" 
        set decision-first 0 set decision-second 0
     ask end1 [ set Decision-spending true ]
]      [ask end2 [set Decision-spending true]]   
    ]
  ]   
end

to wage-war [ #first #second ];; fight wars etc.
  
  set war-counter war-counter + 1                           
  if ( export [who] of #first [who] of #second != nobody) [
    ask export [who] of #first [who] of #second [die]
    ask export [who] of #second [who] of #first [die]]
  
  ;; let exports between allies and enemies die too?
  
  let winner nobody
  let loser nobody
  let pWinningFirst pwinning #first #second nobody
  let pWinningSecond pwinning #second #first nobody 
 
  let first-alliance [alliance-neighbors] of #first
  let first-alliance-power [MilitaryCapabilities] of #first + sum [MilitaryCapabilities] of first-alliance 
  let second-alliance [alliance-neighbors] of #second
  let second-alliance-power [MilitaryCapabilities] of #second + sum [MilitaryCapabilities] of second-alliance
  
  ifelse ( pWinningFirst > pWinningSecond ) [ set winner #first set loser #second] [set winner #second set loser #first]
  ;; generate battle damage
  
  if ( ([major-power?] of #first = true OR [major-power?] of first-alliance = true) AND ([major-power?] of #second = true OR [major-power?] of second-alliance = true)) [ set major-power-war-counter major-power-war-counter + 1 show "major power war!!!!!!!!!!"]
  
  let new-first-alliance-power first-alliance-power - attritionrate * second-alliance-power
  let new-second-alliance-power second-alliance-power - attritionrate * first-alliance-power

  carefully [ 
  ask #first [ let powershare militarycapabilities / first-alliance-power
    set militarycapabilities powershare * new-first-alliance-power
    ]
  ask first-alliance [ let powershare militarycapabilities / first-alliance-power
    set militarycapabilities powershare * new-first-alliance-power
    ]
  
  ask #second [let powershare militarycapabilities / second-alliance-power
    set militarycapabilities powershare * new-second-alliance-power]
  ask second-alliance [let powershare militarycapabilities / second-alliance-power
    set militarycapabilities powershare * new-second-alliance-power]]
  [ ]
  
  ;; call structural change to distribute spoils
  structural-change winner loser "war"
  
  ask diplomaticrelation [who] of #first [who] of #second[ set decision-first 0 set decision-second 0 set type-of-last-conflict "armedconflict" set conflict false ]
end 

to test 
  ask state 1 [ create-alliance-with state 3 ]
  ask state 2 [ create-alliance-with state 4 ]
  wage-war state 1 state 2   
end

to structural-change [ #winner #loser #type ] ;; update landscape according to the actions. If a war was fought and won, or bargaining process was done, may field different types of transfers of resources. 
                                              ;; the percentage of provinces that changes ownership is an input
  let total-spoilsize 0
  let total-provinces count patches with [my-state = #loser]
  let allies (list [alliance-neighbors] of #loser)
  let first-alliance-power [MilitaryCapabilities] of #winner
  let second-alliance-power [MilitaryCapabilities] of #loser
  
  if ( empty? allies = false) [
    foreach allies [ set total-provinces total-provinces + length [my-provinces] of ?]
    let second-alliance [alliance-neighbors] of #loser
    set second-alliance-power [MilitaryCapabilities] of #loser + sum [MilitaryCapabilities] of second-alliance]
  if (any? [alliance-neighbors] of #winner ) [
    let first-alliance [alliance-neighbors] of #winner
    set first-alliance-power first-alliance-power + sum [MilitaryCapabilities] of first-alliance]
  
  if (#type = "war") [ 
    set total-spoilsize round (reparations-factor * total-provinces)]
  if (#type = "submit") [
    set total-spoilsize round ((reparations-factor - give-in-compensation) * total-provinces)]
  if (total-spoilsize = 0 ) [ set total-spoilsize 1]
    
  let victors []
  set victors lput #winner victors
  ask [alliance-neighbors] of #winner [ set victors lput self victors ]
  ;;show victors
  
  let losers []
  set losers lput #loser losers
  ask [alliance-neighbors] of #loser [ set losers lput self losers ]
  ;;show losers
  let counter-spoilsize total-spoilsize
  
  
    foreach victors [
      let powershare 0
      carefully [set powershare [MilitaryCapabilities] of ? / first-alliance-power] [ set powershare 1 ]
      ;;show powershare
      let state-at-hand ?
      let spoilsize 0
      ifelse ( ? = last victors ) [ set spoilsize counter-spoilsize ] [ set spoilsize round (total-spoilsize *  powershare)]
      set counter-spoilsize (counter-spoilsize - spoilsize)
      ;;show total-spoilsize
      ;;show state-at-hand
      ;;show spoilsize
      
      foreach losers [
        if ( ? != nobody ) [
          let powershare-loser 0
          carefully [set powershare-loser [MilitaryCapabilities] of ? / second-alliance-power] [ set powershare-loser 1 ]
          ;;show powershare-loser
          let spoilshare 0
          ifelse ( ? = last losers ) [ set spoilshare spoilsize ] [ set spoilshare round (spoilsize *  powershare-loser)]
          if ( spoilshare > [count my-provinces ] of ? ) [ set spoilshare [count my-provinces ] of ? ]
          set spoilsize (spoilsize - spoilshare)
          
          repeat spoilshare [          
            ifelse (any? patches with [ my-state = ? AND capital? = false and any? neighbors4 with [my-state = state-at-hand]] )
              [ let potentials patches with [ my-state = ? AND capital? = false and any? neighbors4 with [my-state = state-at-hand]]
                let nearest min-one-of potentials [ distance state-at-hand ]
                ask nearest
                [ set my-state state-at-hand
                  set pcolor ([color] of my-state)
                  ;;show spoilsize
                  ;;show spoilshare
                  ;;show state-at-hand
                  ;;show ?                
                ]]
            
              [ if ( any? states with [self = ?] AND any? states with [self = state-at-hand] ) [
                ifelse (any? patches with [ my-state = ? AND capital? = false] )[
                  let potentials patches with [ my-state = ? AND capital? = false AND any? neighbors4 with [my-state != ? ]]
                  let nearest min-one-of potentials [ distance state-at-hand ]
                  ask nearest 
                  [ set my-state state-at-hand
                    set pcolor ([color] of my-state)
                    ;;show spoilsize
                    ;;show spoilshare
                    ;;show state-at-hand
                    ;;show ?
                  ]]           
                [ 
                  ask patches with [my-state = ?] [
                    set capital? false 
                    set my-state state-at-hand
                    set pcolor [color] of my-state] 
                  ask ? [die]
                ]]]]
        ]] 
      ]
end

to change-traderelations
  ;; evaluate current trade relations. Are you losing money on any of these trades? if so, are any of these relationships with friendly nations, then do nothing, hostile nations, can you live without them?
  ask states [
    set tradingpartners [other-end] of my-in-exports
    if ( length resource-allocation < 5 )[ ;; not all resources are present within territory of the state
      let missing-list [1 2 3 4 5]
      let all-resources []
      foreach tradingpartners [
        set all-resources lput [resource-allocation] of ? all-resources]
      if ( empty? all-resources = false) [ set all-resources flatten all-resources set all-resources remove-duplicates all-resources]
      foreach resource-allocation [ 
        set missing-list remove ? missing-list ]
      foreach all-resources [ 
        set missing-list remove ? missing-list ]
      if ( length missing-list < 5 )[
        foreach missing-list [
          if ( any? states with [ member? ? resource-allocation ]) [ 
            let potentials [who] of states with [ member? ? resource-allocation ] 
            ifelse (length potentials = 1 ) [ ;; you have no choice but to forge a trade relationship with this state
              create-export-to state item 0 potentials [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume show-link] ;;hide-link] 
              create-export-from state item 0 potentials [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume show-link] ;;hide-link]
              set Invaluable-partners lput item 0 potentials Invaluable-partners
            ] 
            [ let choice nobody
              let choice-utility -10000000
              foreach potentials [
                let otherstate one-of states with [who = ?]
                let attitude-aspect [attitude] of diplomaticrelation [who] of self [who] of otherstate
                let distance-aspect distance otherstate
                let cost distance-aspect * cost-per-distance + cost-of-new-trade
                let utility attitude-aspect - cost
                if ( utility > choice-utility ) [
                  set choice otherstate
                  set choice-utility utility]       
              ]
              create-export-to choice [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume hide-link] 
              create-export-from choice [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume hide-link]
              set tradingpartners [other-end] of my-in-exports
            ]]]]]
    
    let exportshare 0 
    let importshare 0
    let unprofitable-trades []
    foreach [other-end] of my-in-exports [ ;; how does the cost of maintaining work here?
      set importshare [tradevolume] of in-export-from ?
      set exportshare [tradevolume] of out-export-to ?
      if ( importshare > exportshare ) [ set unprofitable-trades lput ? unprofitable-trades ]
    ]      
    foreach friendly-states [ 
      set unprofitable-trades remove ? unprofitable-trades ] ;; just the hostile nations are left now
    foreach Invaluable-partners [
      set unprofitable-trades remove ? unprofitable-trades ]
    if ( empty? unprofitable-trades = false ) [ 
      foreach unprofitable-trades [
        ask export [who] of self [who] of ? [ die ]
        ask export [who] of ? [who] of self [ die ]
      ]
    ]
    foreach friendly-states [ 
      let trade-distance distance ?
      if ( member? ? tradingpartners = false ) [ 
        create-export-to ? [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume hide-link] 
        create-export-from ? [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume hide-link]
      ]]]
end


to update-attitudes ;; if a war occured, or a bargaining process etc, attitudes are changed
  ask DiplomaticRelations [ ;; update attitudes
    ifelse ( random 1000 <= (attitude / 10) * 1000) [
      set attitude ((attitude * 9) + (random 5 + 6)) / 10
    ]
    [  set attitude ((attitude * 9) + random 5) / 10
    ]
    ifelse (attitude > 5) [
      set color green] ;; positive attitude green
    [set color red]  ;; negative attitude red
    if (time-of-last-conflict = ticks) [ ;; this is just for updating one's own attitude
      if (type-of-last-conflict = "armedconflict") [set attitude attitude * (1 - attitude-decrease-war)]
      if (type-of-last-conflict = "bargaining") [set attitude attitude *  (1 - attitude-decrease-bargain)]
      if (type-of-last-conflict = "submitted") [set attitude attitude * (1 - attitude-decrease-submitted)]
      if (type-of-last-conflict = "friendly") [set attitude attitude * (1 - attitude-decrease-friendly)]
    ]
    if ( alliance [who] of end1 [who] of end2 = true) [ 
      ask alliance [who] of end1 [who] of end2 [die] 
      set attitude attitude *  (1 + attitude-increase-alliance)]
    
    if (attitude > 10) [ set attitude 10 ]    
    ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; To-report Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to show-DiplomaticRelations  
  ask DiplomaticRelations [ show-link]
end

to show-tradenetwork
  ask Exports [ show-link]      
end 

to-report interdependence [ #self #victim]
  let exportshare 0 
  let importshare 0
  ifelse ( #self != #victim AND ([GDP] of #self + [GDP] of #victim ) != 0) [
    ask #self [  
      if (member? #victim out-export-neighbors ) [
        set exportshare [tradevolume] of out-export-to #victim
        set importshare [tradevolume] of in-export-from #victim]
    ]
    report (exportshare + importshare) / ([GDP] of #self + [GDP] of #victim )
  ]
  [ report 0 ]
 
end

to-report set-power 
  let critical-mass ( (population /  total-population) + (count-provinces / total-area) ) * current-amount-of-states
  let economic-strength (GDP / total-GDP) * current-amount-of-states
  let military-strength 0
  carefully [set military-strength (MilitaryCapabilities / total-Militarycapabilities) * current-amount-of-states][ set military-strength 0 ]  
  report (critical-mass + economic-strength + military-strength) / 4
end

to-report rankinglist
  report sort-on [rank] states    
end

to-report flatten [#lstlst] ;; method that helps reduce list of lists to a single list
  report reduce sentence #lstlst
end


to-report pWinning [ #self #victim #potentialally]
  let victim-power [MilitaryCapabilities * random-normal mean-Perception SD-perception] of #victim 
  let victim-alliance [alliance-neighbors] of #victim
  let victim-alliance-power sum [MilitaryCapabilities * random-normal mean-Perception SD-perception ] of victim-alliance
  
  let self-power [MilitaryCapabilities * random-normal mean-Perception SD-perception] of #self
  if ( #potentialally != nobody ) 
  [ set self-power self-power + [MilitaryCapabilities] of #potentialally * random-normal mean-Perception SD-perception]
  let self-alliance [alliance-neighbors] of #self
  let self-alliance-power sum [MilitaryCapabilities * random-normal mean-Perception SD-perception] of self-alliance
  
  ifelse ((self-power + self-alliance-power) != 0 AND (victim-power + victim-alliance-power) != 0) 
  [
    report 1 / ( 1 + exp(-((self-power + self-alliance-power) - (victim-power + victim-alliance-power)) /  ((self-power + self-alliance-power) + (victim-power + victim-alliance-power))))
  ]
  [ifelse ((self-power + self-alliance-power) = 0 AND (victim-power + victim-alliance-power) != 0) 
    [
      report 0 ;; you have no military forces, thus defeat is guaranteed
    ]
    [ report 1 ;; victim has no military forces, thus victory is guaranteed
    ]
  ]
end

to-report find-senseofsecurity [#self #target #typeofchange] 
  let enemy-power 0
  let own-power [power] of #self * random-normal mean-Perception SD-perception
  if ( own-power < 0) [ set own-power 0]
  let friendly-power own-power
  if ( hostile-states != 0 ) [
    foreach hostile-states [
      let extra [power] of ? * random-normal mean-Perception SD-perception
      if ( extra < 0) [ set extra 0]
      set enemy-power enemy-power + extra
    ]]
  if ( friendly-states != 0 ) [
    foreach friendly-states [
      let extra [power] of ? * random-normal mean-Perception SD-perception
      if ( extra < 0) [ set extra 0] 
      set friendly-power friendly-power + extra
    ]]
  let initial-sense 0
  ifelse (enemy-power != 0) [set initial-sense (friendly-power / enemy-power)] [set initial-sense 1]
  
  ifelse (#typeofchange = "nothing") [
    report initial-sense ]
  [ let military-strength 0
    let count-provinces2 0
    let population2 0
    let gdp2 0
    ifelse (#typeofchange = "fight") [
      set population2 population + reparations-factor * [population] of #target
      set count-provinces2 count patches with [ my-state = #self ] + reparations-factor * count patches with [ my-state = #target ]
      set GDP2 GDP + reparations-factor * [GDP] of #target
      carefully [set military-strength ((MilitaryCapabilities - [MilitaryCapabilities] of #target * attritionrate) / total-Militarycapabilities)][set military-strength 0 ]
    ]
    [if (#typeofchange = "submit") [
      let reparations reparations-factor - give-in-compensation
      set population2 population + reparations * [population] of #target
      set count-provinces2 count patches with [ my-state = #self ] + reparations * count patches with [ my-state = #target ]
      set GDP2 GDP + reparations * [GDP] of #target
      carefully [set military-strength (MilitaryCapabilities / total-Militarycapabilities)][set military-strength 0 ]
    ]
    let critical-mass ( (population2 /  total-population) + (count-provinces2 / total-area) ) * current-amount-of-states
    let economic-strength (GDP2 / total-GDP) * current-amount-of-states
    set own-power (critical-mass + economic-strength + military-strength) / 4
    ]
    set friendly-power friendly-power - [power * random-normal mean-Perception SD-perception ] of #self + own-power
    ifelse (enemy-power != 0) [report friendly-power / enemy-power] [report 1]]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; Environment Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to set-neighborstates
  ask patches [
    set my-neighbors [my-state] of neighbors4 with [my-state != myself] ;; create a list of the owners of neighboring patches
    set my-neighbors remove-duplicates my-neighbors    ;; remove duplicates of the list
  ]
  ask states [
    set neighbor-states [my-neighbors] of my-provinces ;; summation of lists of neighbors of patches
    set neighbor-states flatten neighbor-states ;; flatten list of lists into a single list
    set neighbor-states remove-duplicates neighbor-states
    set neighbor-states remove my-state neighbor-states  ;; remove yourself from list of neighbors
  ]  
end

to create-conflict ;; stochasticly create conflicts among states, with a randomised chance of a conflict for each relation, no matter alliances and attitudes
  let amount count DiplomaticRelations
  let amount-states count states
  let sum-rank sum [rank] of states
  let repeater round (1 + random-pAttack * amount)
  let repeater2 round (count diplomaticrelations * interdependence-pAttack)
  
  while [repeater > 0] [
    let a nobody
    let b nobody
    ask states [ 
      if (random 1000 <= (( amount-states - rank ) / sum-rank) * 1000) [ 
        set a who] 
      if (random 1000 <= (( amount-states - rank ) / sum-rank) * 1000) [ 
        set b who] 
    ]
    if ( a != b AND A != nobody AND B != nobody) [ if ([conflict] of diplomaticrelation a b = false) [ set repeater repeater - 1 ask diplomaticrelation a b [set conflict true set time-of-last-conflict ticks ]]]  
  ]
  
  ask diplomaticrelations [
    set interdependence-magnitude abs (interdependence end1 end2)
  ]
  
  repeat repeater2 [
    let value 0
    if (any? diplomaticrelations with [conflict = false ]) [set value max [interdependence-magnitude] of diplomaticrelations with [conflict = false ]]
    ;;show value
    ask diplomaticrelations with [interdependence-magnitude = value AND conflict = false] [ set conflict true set time-of-last-conflict ticks ]
  ]
  ;;  Among dissatisfied major powers, create conflicts with neighbors
  ;;  Ask major powers with negative attitude vs #1 
  ;;  Create conflict with one-of random neighbors with negative attitude
end

to conflictmemory
  ask diplomaticrelations [
    if (time-of-last-conflict = ticks)[
    set conflict-memory lput ticks conflict-memory]
    let comparison ticks - memory-duration
    if (empty? conflict-memory = false AND first conflict-memory = comparison) [set conflict-memory remove (first conflict-memory) conflict-memory]
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; FPR Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to rank-states ;; derived from  restaurant model in modelling commons. Is there a quicker way of doing this?
  let old-hegemon hegemon
  let num-ranks (length (remove-duplicates ([power] of states)))
  let rank# count states
  
  repeat num-ranks
  [ let min-rev min [power] of states with [not received-rank?]
    let rankee states with [power = min-rev]
    let num-tied count rankee
    ask rankee
    [ set rank rank#
      set received-rank? true ]
    set rank# rank# - num-tied ]
  
  ask states
  [ set received-rank? false ]
  
  ask states [
    if (ticks = 0) [set initial-rank rank]
    if (rank = 1 AND major-power? = true) [ set Hegemon self]
    if ( old-hegemon != Hegemon ) [set power-transition lput ticks power-transition]
  ]
  
  set power-transition remove-duplicates power-transition
End

to foreign-policy-role
  let total sum[initial-rank] of states
  ask states  [ ;; assign FPR-benefits
    set expected-FPR-benefits (count states) - rank
    set FPR-benefits (count states) - initial-rank
    if (FPR-benefits < 0) [ set FPR-benefits 0]
  ]
  if ( redistribute-FPR = true OR any? states with [initial-rank = 1] = false) [redistribute-FPR-benefits]
  if (sum [FPR-satisfaction] of states < -100) [reset-FPR]
  ask states
  [ 
    set FPR-satisfaction (FPR-benefits - expected-FPR-benefits) * power
  ]
end

to redistribute-FPR-benefits
  if (hegemon != 0 AND hegemon != nobody) [ask hegemon [
    set FPR-benefits FPR-benefits + 1
    if ( empty? friendly-states = false ) [
      foreach friendly-states[
        ask ? [
          set FPR-benefits FPR-benefits + 1
        ]]]
    
    if ( empty? hostile-states = false ) [
      foreach hostile-states [
        ask ? [
          set FPR-benefits FPR-benefits - 1
        ]]]
  ]]  
end

to reset-FPR
  let first-state [who] of states with [initial-rank = 1]
  let second-state [who] of states with [rank = 1]
  ;;show first-state
  ;;show second-state
  
  if ( first-state != second-state and empty? first-state = false) [
  ask diplomaticrelation (first first-state) (first second-state)
  [
     set conflict true
  ]]
  ask states [
    set initial-rank rank]  
  ;;show "reset-FPR"
end

to-report request-alliance [ #self #enemy ]
  let potentials []
  if (hostile-states != 0 AND friendly-states != 0 AND empty? hostile-states = false AND empty? friendly-states = false ) [
  set potentials [who] of states with [member? #enemy hostile-states AND member? #self friendly-states]]
  foreach potentials [
    ask states with [who = ?] [
      let powershare power / (power + [power] of #self)
      let chance-winning pwinning self #enemy #self
      let expected-spoils (reparations-factor * count [my-provinces] of #enemy) / powershare
      let expected-losses (reparations-factor * (count my-provinces + count [my-provinces] of #self )) / powershare
      let military-losses attritionrate * [militarycapabilities] of #enemy 
      let loss-of-trade-direct interdependence self #enemy
      ifelse ( chance-winning * expected-spoils - expected-losses * (1 - chance-winning) - military-losses - loss-of-trade-direct < 0 ) 
      [ set potentials remove ? potentials]   
      [ set potentials remove ? potentials
        set potentials lput self potentials]
    ]]
  report potentials
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; Need work Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to-report change-in-GDP [ #self #victim ]
  let exportshare 0 
  let importshare 0
  ifelse ( #self != #victim ) [
    ask #self [  
      set exportshare [tradevolume] of out-export-to #victim
      set importshare [tradevolume] of in-export-from #victim
    ]
    report (- exportshare + importshare) / [GDP] of #self
  ]
  [ report 0 ] 
  
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
649
470
16
16
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
27
38
90
71
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
11
183
166
243
amount-of-states
25
1
0
Number

BUTTON
135
39
198
72
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
26
91
90
124
go 10
repeat 10 [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
699
12
854
72
mean-population-growth
0.0010
1
0
Number

INPUTBOX
699
74
854
134
mean-GDP-growth
0.0010
1
0
Number

INPUTBOX
856
12
1011
72
SD-population-growth
0.1
1
0
Number

INPUTBOX
856
74
1011
134
SD-GDP-growth
0.1
1
0
Number

INPUTBOX
698
447
853
507
likelihoodofresourcespresent
0.1
1
0
Number

INPUTBOX
857
318
1012
378
random-pAttack
0.1
1
0
Number

INPUTBOX
854
382
1009
442
SD-perception
0.7
1
0
Number

INPUTBOX
699
318
854
378
attritionrate
0.5
1
0
Number

BUTTON
23
369
163
402
NIL
show-tradenetwork
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
26
307
197
340
NIL
show-DiplomaticRelations
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1056
290
1288
441
Histogram power states
Power of states
Amount of states
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 0.1 1 -16777216 true "" "histogram [power] of states"

PLOT
1316
290
1551
440
Amount of major powers
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count states with [major-power? = true]"

INPUTBOX
699
257
854
317
Max-initial-patch-population
10
1
0
Number

INPUTBOX
857
257
1012
317
Max-initial-GDPperCapita
1
1
0
Number

INPUTBOX
698
135
853
195
mean-initial-military-capabilities
100
1
0
Number

INPUTBOX
856
135
1011
195
SD-initial-military-capabilities
50
1
0
Number

INPUTBOX
700
196
855
256
mean-initial-trade-volume
10
1
0
Number

INPUTBOX
857
196
1012
256
SD-initial-trade-volume
4
1
0
Number

INPUTBOX
697
382
853
442
mean-Perception
1
1
0
Number

INPUTBOX
859
448
1014
508
reparations-factor
0.3
1
0
Number

BUTTON
130
93
200
126
go 100
repeat 100 [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
1013
11
1168
71
mean-tradevolume-growth
1
1
0
Number

INPUTBOX
1170
11
1325
71
SD-tradevolume-growth
0.1
1
0
Number

INPUTBOX
1018
448
1173
508
give-in-compensation
0.15
1
0
Number

BUTTON
14
138
204
172
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1068
113
1268
263
Number of states
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count states"

INPUTBOX
1330
10
1485
70
mean-military-spending
0.01
1
0
Number

INPUTBOX
1331
72
1486
132
SD-military-spending
0.0010
1
0
Number

INPUTBOX
9
244
164
304
Threshold-major-power
3
1
0
Number

INPUTBOX
1512
10
1667
70
attitude-decrease-war
0.75
1
0
Number

INPUTBOX
1512
76
1667
136
attitude-decrease-bargain
0.3
1
0
Number

INPUTBOX
1669
74
1824
134
attitude-decrease-submitted
0.1
1
0
Number

PLOT
1295
135
1495
285
attitudes of diplomaticrelations
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 0.5 1 -16777216 true "" "histogram [attitude] of diplomaticrelations"

INPUTBOX
1670
10
1825
70
attitude-decrease-friendly
0.2
1
0
Number

INPUTBOX
1515
144
1670
204
increased-mil-spending
0.25
1
0
Number

MONITOR
368
538
638
583
NIL
count diplomaticrelations with [conflict = true ]
17
1
11

INPUTBOX
1177
449
1332
509
interdependence-pAttack
0.01
1
0
Number

INPUTBOX
1337
448
1493
508
cost-of-new-trade
0
1
0
Number

INPUTBOX
1552
469
1708
529
cost-per-distance
0
1
0
Number

PLOT
35
493
235
643
FPR satisfaction
NIL
NIL
-10.0
10.0
0.0
2.0
true
false
"" ""
PENS
"default" 0.5 1 -16777216 true "" "histogram [FPR-satisfaction] of states"

MONITOR
372
620
571
665
NIL
mean [FPR-satisfaction] of states
17
1
11

SWITCH
43
423
183
456
redistribute-FPR
redistribute-FPR
1
1
-1000

PLOT
684
516
884
666
sense of security
NIL
NIL
0.0
5.0
0.0
10.0
true
false
"" ""
PENS
"default" 0.1 1 -16777216 true "" "histogram [senseofsecurity] of states"

INPUTBOX
1335
540
1491
600
threshold-counter
5
1
0
Number

MONITOR
366
489
448
534
NIL
war-counter
17
1
11

MONITOR
372
677
560
722
NIL
min [FPR-satisfaction] of states
17
1
11

MONITOR
588
680
835
725
NIL
[fpr-satisfaction] of states with [rank = 1]
17
1
11

MONITOR
895
684
1174
729
NIL
[fpr-satisfaction] of states with [initial-rank = 1]
17
1
11

INPUTBOX
1065
527
1221
587
memory-duration
10
1
0
Number

INPUTBOX
1683
148
1838
208
attitude-increase-alliance
0.5
1
0
Number

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="false">
    <setup>setup
profiler:start</setup>
    <go>go</go>
    <final>profiler:stop
print profiler:report  
profiler:reset</final>
    <timeLimit steps="1000"/>
    <metric>count states</metric>
    <metric>war-counter</metric>
    <metric>major-power-war-counter</metric>
    <enumeratedValueSet variable="attitude-decrease-bargain">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attitude-decrease-submitted">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Threshold-major-power">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="likelihoodofresourcespresent">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD-initial-trade-volume">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="memory-duration">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-GDP-growth">
      <value value="0.0010"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD-population-growth">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-military-spending">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-pAttack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-new-trade">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="amount-of-states">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD-military-spending">
      <value value="0.0010"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attitude-decrease-friendly">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD-initial-military-capabilities">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Max-initial-patch-population">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reparations-factor">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD-GDP-growth">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Max-initial-GDPperCapita">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-initial-trade-volume">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="threshold-counter">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-Perception">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD-tradevolume-growth">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-tradevolume-growth">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-population-growth">
      <value value="0.0010"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="redistribute-FPR">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="increased-mil-spending">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="give-in-compensation">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attritionrate">
      <value value="0.3"/>
      <value value="0.5"/>
      <value value="0.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="interdependence-pAttack">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="attitude-decrease-war">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mean-initial-military-capabilities">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SD-perception">
      <value value="0.1"/>
      <value value="0.3"/>
      <value value="0.5"/>
      <value value="0.7"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-per-distance">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
