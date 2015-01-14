;;extensions [nw array]

;; <<<<<<<<<<<<<<<<<<<< Variable definitions and Breed creation >>>>>>>>>>>>>>>>>>>>>>>>>>>

breed [states state]
undirected-link-breed  [Alliances Alliance]
undirected-link-breed  [DiplomaticRelations DiplomaticRelation]
directed-link-breed [Exports Export]

patches-own [
  my-state
  patch-population
  patch-GDPperCapita
  Population-growth
  GDPpercapita-growth
  economic-size
  resource-type
  Resource-present?
  capital?
  water
]

states-own [ 
  Ideology
  my-provinces
  count-provinces
  GDP
  GDP-E+I
  GDPpercapita
  technological-advancement
  MilitaryCapabilities
  MilitarySpending
  fighting-strength
  Decision-spending
  Population
  power
  Power-memory
  Power-growth-memory
  Power-growth-memory-derivation
  mean-power-growth-derivation
  tradingpartners
  ExportSize
  ImportSize
  hostile-states
  friendly-states
  resource-allocation
  senseofsecurity
  rank
  received-rank?
  Major-Power?
  Invaluable-partners
  FPR-satisfaction
  epower
  risk-averseness
  w1
  w2
  w3
  w4
  w5
  inflectionpoint-category
]

Alliances-own [ ] 

DiplomaticRelations-own [
  Attitude
  ideology-similarity 
  conflict 
  conflict-level
  time-of-last-conflict  
  type-of-last-conflict
  time-of-decision
  source-of-last-conflict
  counter-round
  interdependence-magnitude
  decision-first
  decision-second
  conflict-memory
]

exports-own [ 
  tradevolume
]

globals [ 
  power-transition-counter
  war-counter 
  major-power-war-counter  
  amount-conflicts
  
  multiple-MP1
  multiple-MP2
  Inflection-point-end1
  Inflection-point-end2
  FPR-end1
  FPR-end2
  Power-end1
  Power-end2
  Interdependence-end1end2
  Conflict-level-end1end2
  polarity
  power-transition
  polarisation
  polarisation2
  polarisation3
  polarisation4
  polarisation5
  polarisation6
  
  Output-Inflection-point-end1
  Output-Inflection-point-end2
  Output-FPR-end1
  Output-FPR-end2
  Output-Power-end1
  Output-Power-end2
  Output-Interdependence-end1end2
  Output-Conflict-level-end1end2
  Output-polarity
  Output-power-transition
  Output-polarisation
  
  inflection-state1 
  FPR-satisfaction-state1
  power-1
  interdependence-1
  amount-of-conflicts1
  amount-of-conflicts2
  
  conflict-no-interaction
  conflict-too-long
  
  states-missing-resources
  trade-severed
  
  count-1
  count-2
  count-3
  count-4
  count-5
  count-6
  count-7 
  count-8
  count-9
  
  interact-1   
  interact-2   
  interact-3   
  interact-4   
  interact-5   
  interact-6   
  interact-7   
  interact-8   
  interact-9   
  interact-10   
  interact-11   
  interact-12   
  interact-13   
  interact-14   
  interact-15   
  interact-16    
  interact-17   
  interact-18   
  interact-19   
  interact-20   
  interact-21   
  interact-22   
  interact-23  
  
  inflection-1
  inflection-2
  inflection-3
  inflection-4
  inflection-5
  inflection-6
  inflection-7
  
  def-patches-water 
  should-patches-water 
  min-GDPpercapita 
  max-GDPpercapita 
  amount-capitals 
  min-state 
  max-state 
  unassigned-patches 
  min-patch-population 
  max-patch-population 
  min-patch-GDPperCapita 
  max-patch-GDPperCapita 
  min-GDPpercapita-growth 
  max-GDPpercapita-growth 
  min-Population-growth 
  max-Population-growth
  min-economic-size 
  max-economic-size 
  should-patches-resources
  def-patches-resources
  max-GDP 
  min-GDP 
  max-Population 
  min-Population 
  max-MilitaryCapabilities 
  min-MilitaryCapabilities 
  max-MilitarySpending 
  min-MilitarySpending 
  min-tradepartners 
  max-tradepartners 
  min-DiplomaticRelations 
  max-DiplomaticRelations 
  min-friendly-states 
  max-friendly-states 
  
  
  total-population current-amount-of-states total-Militarycapabilities total-GDP total-area mean-GDP-cap Hegemon 
]

;; <<<<<<<<<<<<<<<<<<<< Setup >>>>>>>>>>>>>>>>>>>>>>>>>>>

to setup
  clear-all
  reset-ticks
  carefully [resize-world-method] [  print "resize-world-method " print error-message]
  carefully [create-water] [ print "create-water "  print error-message]
  carefully [creating-states] [ print "creating-states "  print error-message]
  carefully [set-capitals] [ print "set-capitals "  print error-message]
  carefully [grow-states] [ print "grow-states"  print error-message]
  carefully [setup-patch-variables] [ print "setup-patch-variables "  print error-message]
  carefully [setup-state-variables  ] [  print " setup-state-variables" print error-message]
  carefully [create-diplomaticnetwork] [ print " create-diplomaticnetwork"  print error-message]
  carefully [create-tradenetwork      ] [ print " create-tradenetwork"  print error-message]
  carefully [rank-states ] [ print "rank-states" print error-message]
  carefully [setup-globals] [ print "setup-globals " print error-message]
  ;;test-setup
  setup-output
end

;; <<<<<<<<<<<<<<<<<<<< Setup 1 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to create-water
  ask patches [set water false]
  let counter round (water-percentage * count patches)
  repeat round (counter / 8) [
    ask one-of patches [ 
      set water true set pcolor blue set my-state nobody 
      set counter counter - 1
      ask neighbors [ 
        set water true set pcolor blue set my-state nobody
        set counter counter - 1
      ]]]
end

;; <<<<<<<<<<<<<<<<<<<< Setup 2 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to creating-states
  create-States amount-of-states [
    setxy round random-xcor round random-ycor ;; the world is NOT wrapped, i.e. the world as depicted is flat
    set color (([who] of self) * (130 / amount-of-states)) ;; purely meant to assign a range of colors to states, even if there are only a few states. 140 is the amount of available colors, 130 is used to prevent duplicates
    set shape "x"
    set GDPpercapita random-float Max-initial-GDPperCapita
  ]
end

;; <<<<<<<<<<<<<<<<<<<< Setup 3 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to set-capitals
  ask states
  [
    if (any? other states-here OR [water = true] of patch-here) [ 
      let location one-of patches with [water = false AND any? states-here = false AND my-state = 0]
      move-to location ] ;; each state is the sole occupant of the patch it is on. If so, this province becomes its capital. 
    ask patch-here
    [
      set my-state myself ;; every patch has a variable identifying the state it is part of
      set capital? true
    ]
  ] 
end

;; <<<<<<<<<<<<<<<<<<<< Setup 4 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to grow-states
  repeat worldsize ^ 2 [ ;; as long as there are any patches without an owner, perform this method
    if (any? patches with [ any? neighbors with [water = false] = false]) [
      ask patches with [ any? neighbors with [water = false] = false][
        set water true set pcolor blue set my-state nobody]
    ]    
    ask patches with [ my-state != 0 and my-state != nobody ] ;; ask states that DO have an owner
    [
      repeat count neighbors with [my-state = 0] [
        let my-new-patch one-of neighbors with [my-state = 0] ;; ask the 4 neighbors of such a patch
        if (my-new-patch != nobody) ;; if any of these 4 neighbors has no owner, it will join the state
        [ 
          let the-state my-state
          ask my-new-patch
          [
            set my-state the-state
            set pcolor ([color] of my-state) ;; They get the same color for identification purposes.
          ]]]]]  
  if (any? patches with [my-state = 0]) [ ask patches with [my-state = 0][ set water true set pcolor blue set my-state nobody ]]
end

;; <<<<<<<<<<<<<<<<<<<< Setup 5 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to setup-patch-variables
  ask patches with [my-state != nobody][    
    set patch-population random Max-initial-patch-population 
    set patch-GDPperCapita [GDPpercapita] of my-state * random-normal 1 0.1
    set GDPpercapita-growth random-normal mean-GDP-growth SD-GDP-growth
    set Population-growth random-normal mean-population-growth SD-population-growth
    set economic-size (patch-population * patch-GDPperCapita)    
    if (capital? != true ) [set capital? false ]    
  ]  
  ask n-of (count patches * likelihoodofresourcespresent) patches with [my-state != nobody][ ;; based on the likelihood that a patch contains resources
    set resource-type ((random 5) + 1) ;; assign type of resources 1 - 5
    set resource-present? true
  ]
end

;; <<<<<<<<<<<<<<<<<<<< Setup 6 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to setup-state-variables
  ask states [
    set my-provinces patches with [my-state = myself] ;; helpful list containing all patches owned by current state
    set count-provinces count my-provinces
    set GDP (sum [ economic-size] of my-provinces) ;; GDP of provinces owned summarised into a single GDP variable
    set Population sum [patch-population] of my-provinces ;; Population of provinces owned summarised into a single Population variable
    set technological-advancement 1
    set MilitaryCapabilities random-normal mean-initial-military-capabilities SD-initial-military-capabilities
    if (MilitaryCapabilities < 0) [set MilitaryCapabilities 0]  ;; making sure military capabilities are non negative  
    set MilitarySpending random-normal mean-military-spending SD-military-spending
    set fighting-strength technological-advancement * MilitaryCapabilities
    set received-rank? false
    set FPR-satisfaction 0
    set Decision-spending false
    set Major-Power? false
    set tradingpartners [other-end] of my-in-exports
    set Invaluable-partners []
    set power-transition []
    set power-memory []
    set power-growth-memory []
    set Power-growth-memory-derivation []
    set w1 uw1
    set w2 uw2
    set w3 uw3
    set w4 uw4
    set w5 uw5 
    set risk-averseness w2 / w1
    set ideology []
    repeat Length_of_culture_list [ set ideology lput (random 10) ideology ]
  ]  
end

;; <<<<<<<<<<<<<<<<<<<< Setup 7 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to create-tradenetwork
  ask states [
    foreach friendly-states [
      create-export-to ? [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume hide-link]  ;; every state can trade with every state  
    ]
  ]  
end

;; <<<<<<<<<<<<<<<<<<<< Setup 8 >>>>>>>>>>>>>>>>>>>>>>>>>>>

to create-diplomaticnetwork
  ask states[ create-DiplomaticRelations-with other states ] ;; every state can exchange attitude with every other state
  ask DiplomaticRelations [
    determine-similarity    
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

;; <<<<<<<<<<<<<<<<<<<< Setup 9 >>>>>>>>>>>>>>>>>>>>>>>>>>

to setup-globals
  set total-population sum[population] of states
  set current-amount-of-states count states
  set total-Militarycapabilities sum[fighting-strength] of states
  set total-GDP sum[GDP] of states
  set total-area count patches with [water = false ]
  set mean-GDP-cap total-GDP / total-population
  ask states [    
    if (ticks = 0) [set power set-power] 
    if (any? states with [power > Threshold-major-power ]) [ ask states with [power > Threshold-major-power ] [set Major-Power? true ]]]
  ifelse ( count states with [Major-Power? = true] = 1) [ set polarity 1 ] [ ifelse(count states with [Major-Power? = true] = 2) [set polarity 2 ] [set polarity 3] ]
  
  ;;set mean-interdependence mean ([interdependence-magnitude] of diplomaticrelations)
  ;;set mean-PFR-satisfaction mean [FPR-satisfaction] of states
  if ( power-transition != 0) [set power-transition-counter length power-transition]
  set amount-conflicts count diplomaticrelations with [conflict = true]
end

;; <<<<<<<<<<<<<<<<<<<< Setup 10 >>>>>>>>>>>>>>>>>>>>>>>>>>

to resize-world-method  
  resize-world (- worldsize) worldsize (- worldsize) worldsize    
end

to setup-output  
  set multiple-MP1 []
  set multiple-MP2 []
  set Inflection-point-end1 []
  set Inflection-point-end2 []
  set FPR-end1 []
  set FPR-end2 []
  set Power-end1 []
  set Power-end2 []
  set Interdependence-end1end2 []
  set Conflict-level-end1end2 []
  set polarisation []
  set polarisation2 []
  set polarisation3 []
  set polarisation4 []
  set polarisation5 []
  set polarisation6 []
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Go Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go
  carefully [rank-states] [ print "rank-states" print error-message]
  carefully [setup-globals] [ print "setup-globals" print error-message]
  carefully [create-conflict] [ print "create-conflict" print error-message]
  carefully [observe] [ print "observe" print error-message]
  carefully [update-attributes] [ print "update-attributes" print error-message]
  carefully [decide] [ print "decide" print error-message]  
  carefully [test-decide][ print "decide test" print error-message]
  carefully [test-inflectionpoint][ print "inflection test" print error-message]
  carefully [interact  ] [ print "interact" print error-message]
  carefully [change-traderelations] [ print "change-traderelations" print error-message]
  carefully [update-attitudes] [ print "update-attitudes" print error-message]
  carefully [conflictmemory] [ print "conflictmemory" print error-message]
  carefully [foreign-policy-role] [ print "foreign-policy-role" print error-message]
  ;;produce-final-output
  tick  
end


to update-attributes ;; endogenous growth of variables since last tick
  
  carefully [
    ask patches with [water = false][
      let change-in_GDPpercapita-growth random-normal 0 0.01
      set GDPpercapita-growth (GDPpercapita-growth + change-in_GDPpercapita-growth) 
      let change-in_Population-growth population-GDP-factor * change-in_GDPpercapita-growth
      set Population-growth Population-growth + change-in_Population-growth
      set patch-population (patch-population * Population-growth)
      set patch-GDPperCapita (patch-GDPperCapita * GDPpercapita-growth)    
      set economic-size (patch-population * patch-GDPperCapita)
      if ( patch-population < 0) [set patch-population 0]
      if ( patch-GDPperCapita < 0) [set patch-GDPperCapita 0]
    ]
  ] [ print "patches" print error-message]
  
  carefully [
    ask states [ ;; update variables with endogeneous growth, set total values of import and export, set internal resource allocations
      set my-provinces patches with [my-state = myself]
      set count-provinces count my-provinces
      set ExportSize sum [tradevolume] of my-out-exports
      set ImportSize sum [tradevolume] of my-in-exports
      
      carefully [set GDP-E+I (sum [ economic-size] of my-provinces) ] [set GDP-E+I GDP-E+I  ]
      carefully [set GDP GDP-E+I + Exportsize - Importsize] [set GDP GDP]
      if (GDP <= 0) [ set GDP 1 ]
      carefully [set Population (sum [patch-population] of my-provinces)] [ set population population ]
      if (Population <= 0) [ set Population 1 ]
      set GDPpercapita GDP / population
      carefully [set technological-advancement GDPpercapita / mean-GDP-cap] [ set technological-advancement 1]
      
      let normal random-normal mean-military-spending SD-military-spending
      let senseofsecurity-effects 1
      carefully [ifelse (1 / senseofsecurity > 3) [set senseofsecurity-effects 3][set senseofsecurity-effects (1 / senseofsecurity)]] [set senseofsecurity-effects 0 ] ;; high sense of security means lower militar spending
      let compensation-current-size (fighting-strength / GDP)
      let increase 0
      if ( Decision-spending = true ) [ set increase increased-mil-spending set Decision-spending false]
      
      let change senseofsecurity-effects - compensation-current-size
      set MilitarySpending (1 + increase) + normal + (change / 5)
      carefully [set MilitaryCapabilities (MilitaryCapabilities * MilitarySpending)] [ set MilitaryCapabilities MilitaryCapabilities]
      if (MilitaryCapabilities <= 0) [ 
        ifelse (change < 0) [
          set MilitaryCapabilities 0 ]
        [
          set MilitaryCapabilities change
        ]]    
      
      set fighting-strength technological-advancement * MilitaryCapabilities
      
      setup-globals
      
      let old-growth 0
      let power-growth 0
      let power-growth-growth 0
      let old-power power
      if (ticks > 1) [set old-growth last Power-growth-memory]
      
      set power set-power
      
      carefully [set power-growth ((power - old-power) / old-power)][set power-growth 0]
      
      carefully [ set power-growth-growth ((power-growth - old-growth) / old-growth)] [set power-growth-growth 0]
      
      if (length power-memory >= memory-length) [ set power-memory remove-item 0 power-memory ]
      if (length Power-growth-memory >= memory-length) [ set Power-growth-memory remove-item 0 Power-growth-memory ]
      if (length Power-growth-memory-derivation >= memory-length) [ set Power-growth-memory-derivation remove-item 0 Power-growth-memory-derivation ]
      
      set power-memory lput power power-memory
      set Power-growth-memory lput power-growth Power-growth-memory
      set Power-growth-memory-derivation lput power-growth-growth Power-growth-memory-derivation
      
      let mean-growth mean Power-growth-memory
      let mean-growth-derivation mean Power-growth-memory-derivation
      
      let mean-growth-abs abs mean-growth
      let mean-growth-derivation-abs abs mean-growth-derivation
      
      
      if (ticks > (memory-length)) [
        ifelse  ( mean-growth-abs <= inflection-point-deviation-zero) [
          set inflectionpoint-category 1
          set inflection-1 inflection-1 + 1      
        ]
        [ 
          ifelse  ( mean-growth-derivation-abs <= inflection-point-deviation-zero) [ 
            ifelse (mean-growth > 0)
            [set inflectionpoint-category 3 set inflection-3 inflection-3 + 1]
            [set inflectionpoint-category 6 set inflection-6 inflection-6 + 1]
          ]
          [
            ifelse (mean-growth > 0) 
            [ifelse (mean-growth-derivation >= 0)
              [set inflectionpoint-category 2 set inflection-2 inflection-2 + 1]
              [set inflectionpoint-category 4 set inflection-4 inflection-4 + 1]
            ]
            [ifelse (mean-growth-derivation > 0)
              [set inflectionpoint-category 7 set inflection-7 inflection-7 + 1]
              [set inflectionpoint-category 5 set inflection-5 inflection-5 + 1]
            ]]]
        if ( inflectionpoint-category = 0 ) [ show mean-growth show mean-growth-derivation]
      ]
      
      
      
      set resource-allocation [resource-type] of my-provinces with [resource-present? = true]
      set resource-allocation remove-duplicates resource-allocation
      set Invaluable-partners remove-duplicates Invaluable-partners
      
      set Major-Power? false
      
      if (any? states with [power > Threshold-major-power ]) [ ask states with [power > Threshold-major-power ] [set Major-Power? true ]] 
      
      if (ticks > memory-length) [
        let mean-FPR mean [FPR-satisfaction] of states
        set w1 (uw1 + FPR-impact * (FPR-satisfaction - mean-FPR))
        set w2 (uw2 - FPR-impact * (FPR-satisfaction + mean-FPR))
        
        if (w1 < 0) [ set w1 0]
        if (w2 < 0) [ set w2 0]
      ]
      
      if (any? alliance-neighbors) [
        let potentials [who] of alliance-neighbors
        foreach potentials [
          if ([attitude < 5] of diplomaticrelation ? who) [
            ask alliance ? who [ die ]
          ]]]
      
      ifelse (any? my-DiplomaticRelations with [attitude >= 5]) [
        let friendly-links my-DiplomaticRelations with [attitude >= 5]
        set friendly-states [other-end] of friendly-links]
      [ set friendly-states []]
      
      if ( (random 1000 < (amount_of_ideology_change * 1000)) AND friendly-states != []) [
        let x one-of friendly-states
        let choice random (Length_of_culture_list - 1)
        let value item choice ([ideology] of x)
        let own-value item choice ideology
        if ( own-value != value) [
          ifelse ( own-value > value)
          [ set ideology (replace-item choice ideology (own-value - 1)) ] 
          [ set ideology (replace-item choice ideology (own-value + 1))]
        ]
        ask diplomaticrelation ([who] of x) who [ determine-similarity] 
      ]]
    
  ] [ print "states" print error-message]
  
  carefully [
    ask Exports [ 
      ;;let state-at-hand end2
      let relevant-patches [my-provinces] of end2
      carefully [let growth mean [GDPpercapita-growth] of relevant-patches set tradevolume tradevolume * growth][ die ]
    ]  
  ] [ print "exports" print error-message] 
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
  if (any? states AND any? diplomaticrelations) [  
    ask states [
      if (any? my-diplomaticrelations with [conflict = true]) [
        let target []
        carefully [set target [other-end] of my-diplomaticrelations with [conflict = true]]
        [ print error-message print "target"]
        let first-state self
        
        foreach target [
          let enemy ?
          let target-diplomaticrelation nobody 
          carefully [ set target-diplomaticrelation diplomaticrelation who ([who] of enemy)]
          [ print error-message print "target-diplomaticrelation" stop]
          
          carefully [if ( target-diplomaticrelation = nobody ) [ print "target-diplomaticrelation is nobody" stop]
          if ( enemy = nobody ) [ print "enemy is nobody" stop]
          if ( enemy = first-state ) [ print "state is dead" stop]] [ print error-message print 121 stop ]
          
          let chance-winning 0
          carefully [ set chance-winning pWinning self enemy nobody ] [ print error-message print 122 stop ]
          
          let actual-reparations-factor 0
          let actual-attrition-rate 0        
          carefully [
          if ([conflict-level] of target-diplomaticrelation = 1) [
            set actual-reparations-factor reparations-1
            set actual-attrition-rate attrition-1
          ]
          if ([conflict-level] of target-diplomaticrelation = 2) [
            set actual-reparations-factor reparations-2
            set actual-attrition-rate attrition-2
          ]
          if ([conflict-level] of target-diplomaticrelation = 3) [
            set actual-reparations-factor reparations-3
            set actual-attrition-rate attrition-3
          ]
          if ([conflict-level] of target-diplomaticrelation = 4) [
            set actual-reparations-factor reparations-4
            set actual-attrition-rate attrition-4
          ]
          if ([conflict-level] of target-diplomaticrelation = 5) [
            set actual-reparations-factor reparations-5
            set actual-attrition-rate attrition-5
          ]]
          [ print error-message print 113 stop ]
          
          let military-losses 0
          let loss-of-trade-direct 0 
          let potential-allies 0
          let fight-security 0
          let submit-security 0
          let nothing-security 0
          let choice-other 0
          let expected-spoils 0 
          let expected-losses 0
          
          carefully [ set military-losses actual-attrition-rate * ([fighting-strength] of enemy )] [ print error-message print 126 stop ]
          carefully [ set loss-of-trade-direct interdependence self enemy ] [ print error-message print 127 stop ]
          carefully [ set potential-allies request-alliance self enemy ] [ print error-message print 128 stop ]
          carefully [ set fight-security find-senseofsecurity self enemy "fight"] [ print error-message print 129 stop ]
          carefully [ set submit-security find-senseofsecurity self enemy "submit"] [ print error-message print 130 stop ]
          carefully [ set nothing-security find-senseofsecurity self enemy "nothing"] [ print error-message print 131 stop ]
          
          carefully [  
            set choice-other ((1 - chance-winning) * uw1 * actual-reparations-factor * count my-provinces) - (chance-winning * uw2 * actual-reparations-factor * (count [my-provinces] of enemy))
          ] [ print error-message print 123 stop ]
          
          carefully [ if ( choice-other < 0) [ 
            set actual-reparations-factor (actual-reparations-factor * (1 - give-in-compensation)) 
            set fight-security submit-security
            set submit-security nothing-security 
            set military-losses 0
            set loss-of-trade-direct 0  ]       
          ] [ print error-message print 124 stop ]
          
          carefully [
            set expected-spoils actual-reparations-factor * (count [my-provinces] of enemy )
            set expected-losses actual-reparations-factor * count my-provinces
          ] [ print error-message print 125 stop ]
          let n/c 0
          carefully [set n/c (w1 * expected-spoils) / (w2 * expected-losses)] [ set n/c 2]        
          
          carefully [If (n/c < threshold-deescalate) [
            ask target-diplomaticrelation [ 
              ifelse (first-state = end1) 
              [set decision-first "de-escalate"][set decision-second "de-escalate"]]]   ] 
          [ print error-message print 111 stop ]    
          
          
            Ifelse (n/c > threshold-escalate) [          
              carefully [
              ask target-diplomaticrelation [ 
                ifelse (first-state = end1) 
                [set decision-first "escalate"][set decision-second "escalate"]]] [ print error-message print 112 stop ]]
                   
          
          
          [ifelse ( [counter-round] of target-diplomaticrelation >= threshold-counter ) [
            carefully [
              let u-fight w1 * chance-winning * expected-spoils - w2 * expected-losses * (1 - chance-winning) - w3 * military-losses - w4 * loss-of-trade-direct + w5 * fight-security
              let u-submit w5 * submit-security + w2 * (actual-reparations-factor * (1 - give-in-compensation)) * count my-provinces
              
              ifelse ( u-fight > u-submit )
              [ask target-diplomaticrelation [ set counter-round 0 ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
              [ask target-diplomaticrelation [ set counter-round 0 ifelse (first-state = end1) [set decision-first "submit"][set decision-second "submit"]]]
            ] [ print error-message print 1 stop ]
          ]
          
          [ ifelse (chance-winning  < (1 - pWinning-factor)) [ ;; you're screwed, your only option is to get a major power to defend you
            carefully [
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
                  ask target-diplomaticrelation [
                    ifelse (first-state = end1) [set decision-first "alliance"][set decision-second "alliance"]
                    set counter-round counter-round + 1]
                ]]                                       
              [
                let u-fight w1 * chance-winning * expected-spoils - w2 * expected-losses * (1 - chance-winning) - w3 * military-losses - w4 * loss-of-trade-direct + w5 * fight-security
                let u-submit w5 * submit-security + w2 * (actual-reparations-factor * (1 - give-in-compensation)) * count my-provinces
                ifelse ( u-fight > u-submit )
                [ask target-diplomaticrelation [ ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
                [ifelse (count my-provinces <= 2) [ask target-diplomaticrelation [ ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
                  [ask target-diplomaticrelation [ ifelse (first-state = end1) [set decision-first "submit"][set decision-second "submit"]]]]      
              ]
            ] [ print error-message print 2 stop ]]
          
          [
            ifelse (chance-winning > pWinning-factor)
            [  ;; you're going to win, no need to worry. Try to extract some profit from the conflict.                 
              carefully[
                let u-fight w1 * chance-winning * expected-spoils - w2 * expected-losses * (1 - chance-winning) - w3 * military-losses - w4 * loss-of-trade-direct + w5 * fight-security
                let u-nothing w5 * nothing-security
                
                ifelse ( u-fight > u-nothing ) 
                [ask target-diplomaticrelation [ ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
                [ask target-diplomaticrelation [ ifelse (first-state = end1) [set decision-first "nothing"][set decision-second "nothing"]]]
              ] [ print error-message print 3 stop ]
            ]
            [ carefully[
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
                let powershare 0
                carefully [set powershare power / (power + [power] of alliance-choice)] [ set powershare 0.5 ]
                let expected-spoils2 (actual-reparations-factor * (count [my-provinces] of ?)) * powershare
                let expected-losses2 (actual-reparations-factor * (count my-provinces + count [my-provinces] of alliance-choice )) * powershare
                let military-losses2 actual-attrition-rate * ([fighting-strength] of ? )
                let loss-of-trade-direct2 interdependence self ?
                set u-alliance-fight w1 * max-chance-winning * expected-spoils2 - w2 * expected-losses2 * (1 - max-chance-winning) - w3 * military-losses2 - w4 * loss-of-trade-direct2 + w5 * fight-security]
              
              let u-fight w1 * chance-winning * expected-spoils - w2 * expected-losses * (1 - chance-winning) - w3 * military-losses - w4 * loss-of-trade-direct + w5 * fight-security
              let u-submit w5 * submit-security + w2 * (actual-reparations-factor * (1 - give-in-compensation)) * count my-provinces
              let u-nothing w5 * nothing-security
              let max-utility max ( list u-alliance-fight u-fight u-submit u-nothing )
              
              if ( u-fight = max-utility ) [ ask target-diplomaticrelation[ ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
              if ( u-submit = max-utility ) [ifelse (count my-provinces <= 2) [ask target-diplomaticrelation [ ifelse (first-state = end1) [set decision-first "mobilise & fight"][set decision-second "mobilise & fight"]]]
                [ask target-diplomaticrelation [ ifelse (first-state = end1) [set decision-first "submit"][set decision-second "submit"]]]]  
              
              if ( u-nothing = max-utility ) [ask target-diplomaticrelation [ ifelse (first-state = end1) [set decision-first "militarycapabilities"][set decision-second "militarycapabilities"]]]
              if ( u-alliance-fight = max-utility ) [
                create-alliance-with alliance-choice
                ask target-diplomaticrelation [
                  ifelse (first-state = end1) [set decision-first "alliance"][set decision-second "alliance"]
                  set counter-round counter-round + 1]
              ]              
            ] [ print error-message print 4 stop ]
            ]]]]]]]]
end

to interact
  ask diplomaticrelations [
    if (conflict = true)[
      
      if (decision-first != 0 AND decision-second = 0) [ set decision-first 0 ]
      if (decision-second != 0 AND decision-first = 0) [ set decision-second 0 ]     
      
      carefully [
        if ( decision-first = "escalate" AND decision-second = "escalate" ) [ set decision-first 0 set decision-second 0 set interact-1 interact-1 + 1 set conflict-level conflict-level + 1 if (conflict-level > 5) [ set conflict-level 5 set time-of-decision ticks set counter-round 0 set conflict false wage-war end1 end2 set type-of-last-conflict "armedconflict"  set decision-first 0 set decision-second 0 ]]
        if ( decision-first = "escalate" AND decision-second = "mobilise & fight" ) [ set decision-first 0 set decision-second 0 set interact-1 interact-1 + 1 set conflict-level conflict-level + 1 if (conflict-level > 5) [ set conflict-level 5 set time-of-decision ticks set counter-round 0 set conflict false wage-war end1 end2 set type-of-last-conflict "armedconflict" ]]
        if ( decision-first = "mobilise & fight" AND decision-second = "escalate" ) [ set decision-first 0 set decision-second 0 set interact-1 interact-1 + 1 set conflict-level conflict-level + 1 if (conflict-level > 5) [ set conflict-level 5 set time-of-decision ticks set counter-round 0 set conflict false wage-war end1 end2 set type-of-last-conflict "armedconflict" ]]
        
        if ( decision-first = "de-escalate" AND decision-second = "de-escalate" ) [ set interact-2 interact-2 + 1 set conflict-level conflict-level - 1 if (conflict-level < 1) [ set time-of-decision ticks set counter-round 0 set conflict false set type-of-last-conflict "submitted" set decision-first 0 set decision-second 0]]
        if ( decision-first = "mobilise & fight" AND decision-second = "mobilise & fight" ) [set interact-3 interact-3 + 1 set time-of-decision ticks set counter-round 0 set conflict false carefully [wage-war end1 end2] [print 51] set type-of-last-conflict "armedconflict"  set decision-first 0 set decision-second 0];; show "1"]
      ] [ print error-message print 31 ]
      carefully [ 
        if ((decision-first = "nothing" OR decision-first = "submit" OR decision-first = "de-escalate") AND (decision-second = "submit" OR decision-second = "nothing" OR decision-second = "de-escalate")) [
          set interact-4 interact-4 + 1 set time-of-decision ticks set counter-round 0 set conflict false set type-of-last-conflict "submitted" set decision-first 0 set decision-second 0]
        if ((decision-first = "escalate" AND decision-second = "de-escalate") OR (decision-first = "de-escalate" AND decision-second = "escalate")) [
          set interact-5 interact-5 + 1 set counter-round counter-round + 1  set decision-first 0 set decision-second 0]
      ] [ print error-message print 36 ]  
      
      
      carefully [
        if (( decision-first = "mobilise & fight" AND decision-second = "militarycapabilities") OR (decision-first = "mobilise & fight" AND decision-second = "alliance") OR ( decision-first = "escalate" AND decision-second = "militarycapabilities" ) OR ( decision-first = "escalate" AND decision-second = "alliance" )) [ ;; states now have the choice: fight or submit
          set interact-14 interact-14 + 1
          set counter-round 0
          set time-of-decision ticks
          
          let actual-reparations-factor actual-reparations
          let actual-attrition-rate actual-attrition
          
          let expected-spoils actual-reparations-factor * count [my-provinces] of end1
          let expected-losses actual-reparations-factor * count [my-provinces] of end2
          let military-losses actual-attrition-rate * [fighting-strength] of end1
          let loss-of-trade-direct interdependence end1 end2
          ifelse ( pwinning end2 end1 nobody * expected-spoils - expected-losses * pwinning end2 end1 nobody - military-losses - loss-of-trade-direct > (actual-reparations-factor * (1 - give-in-compensation)) * count [my-provinces] of end2)
          [ set time-of-decision ticks set counter-round 0 set conflict false wage-war end2 end1 set type-of-last-conflict "armedconflict"  set decision-first 0 set decision-second 0] 
          [set decision-second "submit" ]];; show "5" ] 
      ] [ print error-message print 32 ]
      
      carefully [
        if ((decision-second = "mobilise & fight" AND decision-first = "militarycapabilities") OR (decision-first = "alliance" AND decision-second = "mobilise & fight") OR ( decision-second = "escalate" AND decision-first = "militarycapabilities" ) OR ( decision-second = "escalate" AND decision-first = "alliance" )) [ 
          set interact-15 interact-15 + 1
          set counter-round 0
          set time-of-decision ticks
          let actual-reparations-factor actual-reparations
          let actual-attrition-rate actual-attrition
          let expected-spoils actual-reparations-factor * count [my-provinces] of end2
          let expected-losses actual-reparations-factor * count [my-provinces] of end1
          let military-losses actual-attrition-rate * [fighting-strength] of end2
          let loss-of-trade-direct interdependence end2 end1
          ifelse ( pwinning end1 end2 nobody * expected-spoils - expected-losses * pwinning end1 end2 nobody - military-losses - loss-of-trade-direct > (actual-reparations-factor * (1 - give-in-compensation)) * count [my-provinces] of end1)
          [  set time-of-decision ticks set counter-round 0 set conflict false wage-war end1 end2 set type-of-last-conflict "armedconflict"  set decision-first 0 set decision-second 0] 
          [set decision-first "submit" ]];; show "6"]
      ] [ print error-message print 33 ]
      
      carefully [ 
        if ((decision-first = "mobilise & fight" AND decision-second = "submit") OR (decision-first = "mobilise & fight" AND decision-second = "nothing") OR (decision-first = "mobilise & fight" AND decision-second = "de-escalate")) [ 
          set interact-12 interact-12 + 1 set time-of-decision ticks set conflict false structural-change end1 end2 "submit" set type-of-last-conflict "bargaining" set decision-first 0 set decision-second 0];; show "3"]
        if (decision-second = "mobilise & fight" AND decision-first = "submit" OR (decision-second = "mobilise & fight" AND decision-first = "nothing") OR (decision-second = "mobilise & fight" AND decision-first = "de-escalate")) [ 
          set interact-13 interact-13 + 1 set time-of-decision ticks set conflict false structural-change end2 end1 "submit" set type-of-last-conflict "bargaining" set decision-first 0 set decision-second 0];; show "4" ] 
      ] [ print error-message print 38 ]
      
      if (decision-first = "submit" AND decision-second = "militarycapabilities" OR (decision-second = "militarycapabilities" AND decision-first = "nothing") OR (decision-second = "militarycapabilities" AND decision-first = "de-escalate")) [
        set interact-16 interact-16 + 1 set counter-round counter-round + 1  set decision-first 0 set decision-second 0];; show "7"] 
      if (decision-second = "submit" AND decision-first = "militarycapabilities" OR (decision-first = "militarycapabilities" AND decision-second = "nothing") OR (decision-first = "militarycapabilities" AND decision-second = "de-escalate")) [ 
        set interact-17 interact-17 + 1 set counter-round counter-round + 1  set decision-first 0 set decision-second 0];; show "8"]
      
      carefully [
        if ( (decision-first = "militarycapabilities" ) AND (decision-second = "militarycapabilities" )) [
          
          set interact-18 interact-18 + 1
          set counter-round counter-round + 1
          ;;show "9" 
          set decision-first 0 set decision-second 0
          if ( is-state? end1 = true) [
            ask end1 [ set Decision-spending true ]]        
          if ( is-state? end2 = true) [
            ask end2 [set Decision-spending true]]]
        
      ] [ print error-message print 34 ]
      
      if ( decision-first = "de-escalate" AND decision-second != "escalate" AND decision-second != "de-escalate" AND decision-second != "nothing") [set interact-10 interact-10 + 1  set decision-first "submit"]
      if ( decision-second = "de-escalate" AND decision-first != "escalate" AND decision-first != "de-escalate" AND decision-first != "nothing") [ set interact-11 interact-11 + 1 set decision-second "submit"]
      
      if (decision-first = "escalate" AND decision-second = "submit") [
        set decision-first 0 
        set decision-second 0 
        set interact-6 interact-6 + 1 
        set counter-round counter-round + 1 
      ]  
      
      if (decision-second = "escalate" AND decision-first = "submit") [
        set decision-first 0 
        set decision-second 0 
        set interact-7 interact-7 + 1 
        set counter-round counter-round + 1  
      ]
      
      
      if (decision-first = "escalate" AND decision-second = "nothing") [set decision-first 0 set decision-second 0 set interact-6 interact-6 + 1 set counter-round counter-round + 1 ]
      if (decision-second = "escalate" AND decision-first = "nothing") [set decision-first 0 set decision-second 0 set interact-7 interact-7 + 1 set counter-round counter-round + 1 ]
      
      
      carefully [
        if (decision-first = "alliance" AND decision-second = "militarycapabilities" AND is-state? end2 = true) [set interact-19 interact-19 + 1 set counter-round counter-round + 1 ask end2 [ set Decision-spending true ] set decision-first 0 set decision-second 0]
        if (decision-second = "alliance" AND decision-first = "militarycapabilities" AND is-state? end1 = true) [set interact-20 interact-20 + 1 set counter-round counter-round + 1 ask end1 [ set Decision-spending true ] set decision-first 0 set decision-second 0]
        if (decision-first = "alliance" AND decision-second = "alliance") [set interact-21 interact-21 + 1 set counter-round counter-round + 1 set decision-first 0 set decision-second 0]
        
        if ((decision-first = "alliance" AND decision-second = "submit") OR (decision-first = "alliance" AND decision-second = "nothing") OR (decision-first = "alliance" AND decision-second = "de-escalate")) [
          set interact-22 interact-22 + 1 set counter-round counter-round + 1  set decision-first 0 set decision-second 0]
        if ((decision-second = "alliance" AND decision-first = "submit") OR (decision-second = "alliance" AND decision-first = "nothing") OR (decision-second = "alliance" AND decision-first = "de-escalate")) [
          set interact-23 interact-23 + 1 set counter-round counter-round + 1  set decision-first 0 set decision-second 0]
      ] [ print error-message print 35 ]
      if ( decision-first != 0 OR decision-second != 0) [ show decision-first show decision-second  set conflict-no-interaction conflict-no-interaction + 1 set decision-first 0 set decision-second 0]
      if ( counter-round > (threshold-counter + 1)) [set conflict-too-long conflict-too-long + 1] 
    ]]   
end

to wage-war [ #first #second ];; fight wars etc.
  if ( is-state? #first = true AND is-state? #second = true) [
    
    set war-counter war-counter + 1                           
    let winner nobody
    let loser nobody 
    let first-alliance [alliance-neighbors] of #first
    let first-alliance-power [fighting-strength] of #first + sum [fighting-strength] of first-alliance 
    let second-alliance [alliance-neighbors] of #second
    let second-alliance-power [fighting-strength] of #second + sum [fighting-strength] of second-alliance
    
    carefully [
      if (any? states with [member? self second-alliance AND member? self first-alliance]) [
        ask states with [member? self second-alliance AND member? self first-alliance] [ ask alliance who [who] of #first [ die ]]
      ]
    ] [ print error-message print 61]
    
    let pWinningFirst 0
    let pWinningSecond 0
    carefully[
      set pWinningFirst pwinning #first #second nobody  
      set pWinningSecond pwinning #second #first nobody 
    ] [ print error-message print 62]
    
    ifelse ( pWinningFirst > pWinningSecond ) [ set winner #first set loser #second] [set winner #second set loser #first]
    ;; generate battle damage
    
    carefully [
      if ([Power > threshold-major-power] of #first AND [Power > threshold-major-power] of #second)[ 
        let counter1 count [alliance-neighbors with [Power > threshold-major-power]] of #first
        let counter2 count [alliance-neighbors with [Power > threshold-major-power]] of #second
        set-output #first #second
        set multiple-MP1 lput (1 + counter1) multiple-MP1
        set multiple-MP2 lput (1 + counter2) multiple-MP2      
      ]
      
      if ([Power > threshold-major-power] of #first AND any? [alliance-neighbors with [Power > threshold-major-power]] of #second) [ 
        let counter1 count [alliance-neighbors with [Power > threshold-major-power]] of #first
        let counter2 count [alliance-neighbors with [Power > threshold-major-power]] of #second
        let relevant-state nobody
        set relevant-state one-of [alliance-neighbors with [Power > threshold-major-power]] of #second
        set-output #first relevant-state
        set multiple-MP1 lput (1 + counter1) multiple-MP1
        set multiple-MP2 lput counter2 multiple-MP2 
      ]
      
      if (any? [alliance-neighbors  with [Power > threshold-major-power]] of #first AND [Power > threshold-major-power] of #second )[
        let counter1 count [alliance-neighbors with [Power > threshold-major-power]] of #first
        let counter2 count [alliance-neighbors with [Power > threshold-major-power]] of #second
        let relevant-state nobody
        set relevant-state one-of [alliance-neighbors with [Power > threshold-major-power]] of #first
        set-output #second relevant-state
        set multiple-MP1 lput counter1 multiple-MP1
        set multiple-MP2 lput (1 + counter2) multiple-MP2 
      ]
      
      if ( any? [alliance-neighbors  with [Power > threshold-major-power]] of #first  AND any? [alliance-neighbors with [Power > threshold-major-power]] of #second)[
        let counter1 count [alliance-neighbors with [Power > threshold-major-power]] of #first
        let counter2 count [alliance-neighbors with [Power > threshold-major-power]] of #second
        let relevant-state1 nobody
        let relevant-state2 nobody
        set relevant-state1 one-of [alliance-neighbors with [Power > threshold-major-power]] of #first
        set relevant-state2 one-of [alliance-neighbors with [Power > threshold-major-power]] of #second        
        set-output relevant-state1 relevant-state2
        set multiple-MP1 lput counter1 multiple-MP1
        set multiple-MP2 lput counter2 multiple-MP2 
      ]
      
    ] [ print error-message print 65]
    
    carefully[ 
      ask #first [
        if (in-export-from #second != nobody)[
          ask in-export-from #second [die]]
        if (out-export-to #second != nobody)[
          ask out-export-to #second [die]]]
    ] [ print error-message print 63]
    
    let actual-attritionrate 0
    carefully[  
      ask diplomaticrelation [who] of #first [who] of #second [ set actual-attritionrate actual-attrition ]    
    ] [ print error-message print 64]
    
    let new-first-alliance-power first-alliance-power - actual-attritionrate * second-alliance-power
    let new-second-alliance-power second-alliance-power - actual-attritionrate * first-alliance-power
    
    carefully [ 
      ask #first [ 
        let powershare 0
        carefully [set powershare fighting-strength / first-alliance-power] [ set powershare 1 ]
        set militarycapabilities powershare * new-first-alliance-power
      ]
      ask first-alliance [ 
        let powershare 0
        carefully [set powershare fighting-strength / first-alliance-power] [ set powershare 1 ]
        set militarycapabilities powershare * new-first-alliance-power
      ]
      
      ask #second [
        let powershare 0
        carefully [set powershare fighting-strength / second-alliance-power] [ set powershare 1 ]
        set militarycapabilities powershare * new-second-alliance-power]
      
      ask second-alliance [
        let powershare 0
        carefully [set powershare fighting-strength / second-alliance-power] [ set powershare 1 ]
        set militarycapabilities powershare * new-second-alliance-power]]
    [ print error-message print 42 ]
    
    ;; call structural change to distribute spoils
    carefully [structural-change winner loser "war"] [ print error-message print 41 ]
    
    if ( is-state? #first = true AND is-state? #second = true) [ask diplomaticrelation [who] of #first [who] of #second[ set decision-first 0 set decision-second 0 set type-of-last-conflict "armedconflict" set conflict false ]]
  ]
  
end 

to structural-change [ #winner #loser #type ] ;; update landscape according to the actions. If a war was fought and won, or bargaining process was done, may field different types of transfers of resources. 
                                              ;; the percentage of provinces that changes ownership is an input
  let total-spoilsize 0
  let total-provinces count patches with [my-state = #loser]
  let allies (list [alliance-neighbors] of #loser)
  let first-alliance-power [fighting-strength] of #winner
  let second-alliance-power [fighting-strength] of #loser
  
  let actual-reparations-factor 0
  ask diplomaticrelation [who] of #winner [who] of #loser [set actual-reparations-factor actual-reparations ] 
  
  if ( empty? allies = false) [
    foreach allies [ set total-provinces total-provinces + length [my-provinces] of ?]
    let second-alliance [alliance-neighbors] of #loser
    set second-alliance-power [fighting-strength] of #loser + sum [fighting-strength] of second-alliance]
  if (any? [alliance-neighbors] of #winner ) [
    let first-alliance [alliance-neighbors] of #winner
    set first-alliance-power first-alliance-power + sum [fighting-strength] of first-alliance]
  
  if (#type = "war") [ 
    set total-spoilsize round (actual-reparations-factor * total-provinces)]
  if (#type = "submit") [
    set total-spoilsize round ((actual-reparations-factor * (1 - give-in-compensation)) * total-provinces)]
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
    
  if (length victors = 1 AND length losers = 1)[
    repeat total-spoilsize [
      ifelse (any? patches with [ my-state = #loser AND capital? = false and any? neighbors4 with [my-state = #winner]] )
      [ let potentials patches with [ my-state = #loser AND capital? = false and any? neighbors4 with [my-state = #winner]]
        let nearest min-one-of potentials [ distance #winner ]
        ask nearest
        [ set my-state #winner
          set pcolor ([color] of my-state)        
        ]]    
      [ ifelse (any? patches with [ my-state = #loser AND capital? = false] )[
        let potentials patches with [ my-state = #loser AND capital? = false AND any? neighbors4 with [my-state != #loser ]]
        let nearest min-one-of potentials [ distance #winner ]
        ask nearest 
        [ set my-state #winner
          set pcolor ([color] of my-state)
        ]]
      [  
        ask patches with [my-state = #loser] [
          set capital? false 
          set my-state #winner 
          set pcolor [color] of my-state] 
        ask #loser [die]
      ]
      ]]]  
  
  if (length victors > 1 AND length losers > 1)[
    foreach victors [
      let powershare 0
      carefully [set powershare [fighting-strength] of ? / first-alliance-power] [ set powershare 1 ]
      let state-at-hand ?
      let spoilsize 0
      ifelse ( ? = last victors ) [ set spoilsize counter-spoilsize ] [ set spoilsize round (total-spoilsize *  powershare)]
      set counter-spoilsize (counter-spoilsize - spoilsize)
      
      foreach losers [
        if ( ? != nobody ) [
          let powershare-loser 0
          carefully [set powershare-loser [fighting-strength] of ? / second-alliance-power] [ set powershare-loser 1 ]
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
                ]]
            
              [ if ( any? states with [self = ?] AND any? states with [self = state-at-hand] ) [
                ifelse (any? patches with [ my-state = ? AND capital? = false] )[
                  let potentials patches with [ my-state = ? AND capital? = false AND any? neighbors4 with [my-state != ? ]]
                  let nearest min-one-of potentials [ distance state-at-hand ]
                  ask nearest 
                  [ set my-state state-at-hand
                    set pcolor ([color] of my-state) 
                  ]]           
                [ 
                  ask patches with [my-state = ?] [
                    set capital? false 
                    set my-state state-at-hand
                    set pcolor [color] of my-state] 
                  ask ? [die]
                  stop 
                ]]]]
        ]] 
    ]]
end

to change-traderelations
  ;; evaluate current trade relations. Are you losing money on any of these trades? if so, are any of these relationships with friendly nations, then do nothing, hostile nations, can you live without them?
  ask states [
    let amount-resources 0
    let updated-list []
    carefully [ set amount-resources length resource-allocation ] [ set amount-resources 0]
    carefully [
      if ( amount-resources < 5 )[ ;; not all resources are present within territory of the state
        let missing-list [1 2 3 4 5]
        let all-resources []
        ifelse (any? in-export-neighbors) [set tradingpartners [other-end] of my-in-exports
          foreach tradingpartners [
            set all-resources lput [resource-allocation] of ? all-resources]]
        [set tradingpartners []]
        
        if ( all-resources != []) [ 
          set all-resources flatten all-resources 
          set all-resources remove-duplicates all-resources
          foreach all-resources [ 
            set missing-list remove ? missing-list ]]
        if (amount-resources != 0) [
          foreach resource-allocation [ 
            set missing-list remove ? missing-list ]]
        let amount-missing 0
        carefully [ set amount-missing length missing-list ] [ set amount-missing 0]
        if (missing-list = 0) [set amount-missing 0]
        
        if ( amount-missing > 0 )[
          foreach missing-list [
            if (? != 0)[
              if ( any? states with [ member? ? resource-allocation ]) [ 
                let potentials [who] of states with [ member? ? resource-allocation ] 
                let amount 0
                carefully [ set amount length potentials] [ set amount 0]
                ifelse (amount = 1 ) [ ;; you have no choice but to forge a trade relationship with this state
                  create-export-to state item 0 potentials [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume show-link] ;;hide-link] 
                create-export-from state item 0 potentials [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume show-link] ;;hide-link]
                set Invaluable-partners lput item 0 potentials Invaluable-partners
                ] 
                [ let choice nobody
                  let choice-utility -10000000
                  foreach potentials [
                    let otherstate one-of states with [who = ?]
                    let attitude-aspect [attitude] of diplomaticrelation who [who] of otherstate
                    let distance-aspect distance otherstate
                    let cost distance-aspect * cost-per-distance + cost-of-new-trade
                    let utility attitude-aspect - cost
                    if ( utility > choice-utility ) [
                      set choice otherstate
                      set choice-utility utility]       
                  ]
                  create-export-to choice [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume hide-link] 
                  create-export-from choice [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume hide-link]
                ]]
              set updated-list lput ? updated-list
              
            ]]]
        
        ;;set missing-list (map - missing-list updated-list)
        if ( missing-list != [] AND missing-list != 0) [ 
          foreach updated-list [ 
            carefully [ set missing-list remove ? missing-list] []
          ]]
        
        if ( missing-list != [] AND missing-list != 0) [ 
          show missing-list
          set states-missing-resources states-missing-resources + 1 ]
      ]] [ print error-message print 5 stop ]
    
    
    let unprofitable-trades []
    set tradingpartners [other-end] of my-in-exports
    carefully [
      if (tradingpartners != 0 AND tradingpartners != []) [
        foreach tradingpartners [ 
          let exportshare 0 
          let importshare 0
          if (in-export-from ? = true)[
            set importshare [tradevolume] of in-export-from ?]
          if ( out-export-to ? = true)[
            set exportshare [tradevolume] of out-export-to ?]
          if ( importshare > exportshare ) [ set unprofitable-trades lput ? unprofitable-trades ]
        ]]
    ] [ print error-message print 6 stop ]
    
    carefully [
      ifelse (any? my-DiplomaticRelations with [attitude < 5]) [
        let hostile-links my-DiplomaticRelations with [attitude < 5]
        set hostile-states [other-end] of hostile-links ]
      [ set hostile-states []]
    ] [ print error-message print 7 stop ]
    
    carefully [
      foreach friendly-states [ 
        set unprofitable-trades remove ? unprofitable-trades ] ;; just the hostile nations are left now
    ] [ print error-message print 8 stop ]
    
    carefully [
      if (empty? Invaluable-partners = false AND Invaluable-partners != 0) [
        foreach Invaluable-partners [
          set unprofitable-trades remove ? unprofitable-trades ]]
      if ( empty? unprofitable-trades = false ) [ 
        foreach unprofitable-trades [
          
          if (empty? Invaluable-partners = false AND Invaluable-partners != 0) [
            if ( member? ? Invaluable-partners) [ set trade-severed trade-severed + 1 ]]
          ask export [who] of self [who] of ? [ die ]
          ask export [who] of ? [who] of self [ die ]
        ]
      ]
    ] [ print error-message print 9 stop ]
    carefully [
      foreach friendly-states [ 
        if (? != nobody) [
          let trade-distance distance ?
          if ( member? ? tradingpartners = false ) [ 
            create-export-to ? [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume hide-link] 
          create-export-from ? [set tradevolume random-normal mean-initial-trade-volume SD-initial-trade-volume hide-link]
          ask diplomaticrelation [who] of ? who [ set attitude attitude * (1 + attitude-trade-increase) ]
          ]]]
      set tradingpartners [other-end] of my-in-exports
    ] [ print error-message print 10 stop ]
  ]
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
    if ( time-of-decision = ticks) [ ;; this is just for updating one's own attitude
      if (any? [alliance-neighbors ] of end1) [
        let state-of-interest [who] of end1  
        ask [alliance-neighbors ] of end1 [
          ask diplomaticrelation who state-of-interest [set attitude attitude * (1 + attitude-increase-alliance)]
        ]        
      ]
      if (any? [alliance-neighbors ] of end2) [
        let state-of-interest [who] of end2 
        ask [alliance-neighbors ] of end2 [
          ask diplomaticrelation who state-of-interest [set attitude attitude * (1 + attitude-increase-alliance)]
        ]]
      
      if (type-of-last-conflict = "armedconflict") [set attitude attitude * (1 - attitude-decrease-war)]
      if (type-of-last-conflict = "bargaining") [set attitude attitude *  (1 - attitude-decrease-bargain)]
      if (type-of-last-conflict = "submitted") [set attitude attitude * (1 - attitude-decrease-submitted)]
      if (type-of-last-conflict = "friendly") [set attitude attitude * (1 - attitude-decrease-friendly)]
    ]
    if (attitude > 10) [ set attitude 10 ]    
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; To-report Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to set-output [ #first #second ]
  carefully [
    if ( #first != nobody AND #second != nobody AND (diplomaticrelation [who] of #first [who] of #second) != nobody AND ticks > memory-length) [
      set major-power-war-counter major-power-war-counter + 1
      
      set Inflection-point-end1 lput [inflectionpoint-category] of #first Inflection-point-end1
      set Inflection-point-end2 lput [inflectionpoint-category] of #second Inflection-point-end2
      set FPR-end1 lput [FPR-satisfaction] of #first FPR-end1
      set FPR-end2 lput [FPR-satisfaction] of #second FPR-end2
      set Power-end1 lput [Power] of #first Power-end1
      set Power-end2 lput [Power] of #second Power-end2
      let target (diplomaticrelation [who] of #first [who] of #second)
      set Interdependence-end1end2 lput [Interdependence-magnitude] of target Interdependence-end1end2
      set Conflict-level-end1end2 lput [Conflict-level] of target Conflict-level-end1end2
      
      ;;nw:set-context states diplomaticrelations
      ;;ask #first [
        ;;let centrality1 nw:eigenvector-centrality
        ;;let weighted-att1 nw:weighted-closeness-centrality "attitude"
        ;;let weighted-id1 nw:weighted-closeness-centrality "ideology-similarity"
        ;;set polarisation lput centrality1 polarisation
        ;;set polarisation3 lput weighted-att1 polarisation3
        ;;set polarisation5 lput weighted-id1 polarisation5
      ;;]
      
      ;;ask #second [
      ;;  let centrality2 nw:eigenvector-centrality
      ;;  let weighted-att2 nw:weighted-closeness-centrality "attitude"
      ;;  let weighted-id2 nw:weighted-closeness-centrality "ideology-similarity"        
      ;;  set polarisation2 lput centrality2 polarisation2
      ;;  set polarisation4 lput weighted-att2 polarisation4
      ;;  set polarisation6 lput weighted-id2 polarisation6
     ;; ]
    ]] [ print error-message print 200]
end

to produce-final-output
  if ( ticks = 500) [
    
    ;;Output-Inflection-point-end1
    ;; Output-Inflection-point-end2
  ;;   Output-FPR-end1
 ;;    Output-FPR-end2
 ;;  ;;   Output-Power-end1
 ;;    Output-Power-end2
  ;;   Output-Interdependence-end1end2
 ;;    Output-Conflict-level-end1end2
 ;;    Output-polarity
 ;;    Output-power-transition
 ;;    Output-polarisation
    ;;set Inflection-point-end1 array:from-list Inflection-point-end1
    ;;set Inflection-point-end2 array:from-list Inflection-point-end2
    ;;set FPR-end1 array:from-list FPR-end1
    ;;set FPR-end2 array:from-list FPR-end2
    ;;set Power-end1 array:from-list Power-end1
    ;;set Power-end2 array:from-list Power-end2
    ;;set Interdependence-end1end2 array:from-list Interdependence-end1end2
    ;;set Conflict-level-end1end2 array:from-list Conflict-level-end1end2
  ]
end

to show-DiplomaticRelations  
  ask DiplomaticRelations [ show-link]
end

to show-tradenetwork
  ask Exports [ show-link]      
end 

to-report interdependence [ #self #victim]
  carefully [
    let exportshare 0 
    let importshare 0
    let extra-dependence 0
    
    ;;if ( member? #self [Invaluable-partners] of #victim) [ set extra-dependence -1 ]
    if ( member? #victim [Invaluable-partners] of #self) [ set extra-dependence 1 ]
    
    
    ;; (([GDP-E+I] of #self + [GDP-E+I] of #victim ) != 0) AND
    ask #self [  
      if ( out-export-to #victim != nobody ) [
        set exportshare [tradevolume] of out-export-to #victim
        set importshare [tradevolume] of in-export-from #victim]]
      
      let reporter 0
      let total-gdps [GDP] of #self + [GDP] of #victim
      
      carefully [ set reporter ((exportshare + importshare) / total-gdps)] [ set reporter 0]
      report extra-dependence + reporter
    ][ report 0 ]
end

to-report set-power 
  let critical-mass 0
  let economic-strength 0
  carefully [
    set critical-mass ( (population /  total-population) + (count-provinces / total-area) ) * current-amount-of-states
    set economic-strength (GDP / total-GDP) * current-amount-of-states ]
  [ set critical-mass 1 / current-amount-of-states
    set economic-strength 1 / current-amount-of-states]
  let military-strength 0
  carefully [set military-strength (fighting-strength / total-Militarycapabilities) * current-amount-of-states][ set military-strength 0 ]  
  report (critical-mass + economic-strength + military-strength) / 4
end

to-report rankinglist
  report sort-on [rank] states    
end

to-report flatten [#lstlst] ;; method that helps reduce list of lists to a single list
  report reduce sentence #lstlst
end


to-report pWinning [ #self #victim #potentialally]
  if (#self = nobody) [report 0]
  if (#victim = nobody) [report 1]
  
  let learning-effect [length conflict-memory] of diplomaticrelation [who] of #self [who] of #victim
  let percentage-hostile-states 0
  carefully [ set percentage-hostile-states ([length hostile-states] of #self) / [length friendly-states] of #self ] [ set percentage-hostile-states 0 ]
  let SD-perception-other 0
  let SD-perception-self SD-perception
  carefully [set SD-perception-other(SD-perception * (1 / learning-effect) * percentage-hostile-states)] [ set SD-perception-other SD-perception]
  
  let d 0
  ask #victim [ set d distance #self ] 
  let victim-loss-of-strength-gradient  1 / ( 1 + (d / [technological-advancement] of #victim)) ^ distance-slope
  let self-loss-of-strength-gradient  1 / ( 1 + (d / [technological-advancement] of #self)) ^ distance-slope
  let victim-power [fighting-strength * victim-loss-of-strength-gradient * random-normal mean-Perception SD-perception-other] of #victim 
  
  let victim-alliance-power 0
  if (any? [alliance-neighbors] of #victim) [
    let victim-alliance [alliance-neighbors] of #victim
    ask victim-alliance [
      ask #victim [ set d distance myself ] 
      let alliance-loss-of-strength-gradient  1 / ( 1 + (d / technological-advancement)) ^ distance-slope
      set victim-alliance-power victim-alliance-power + alliance-loss-of-strength-gradient * fighting-strength * random-normal mean-Perception SD-perception-other
    ]
  ]
  
  let self-power [fighting-strength * self-loss-of-strength-gradient * random-normal mean-Perception SD-perception-self] of #self 
  let self-alliance-power 0
  if (any? [alliance-neighbors] of #self) [
    let self-alliance [alliance-neighbors] of #self
    ask self-alliance [
      ask #self [ set d distance myself ] 
      let alliance-loss-of-strength-gradient  1 / ( 1 + (d / technological-advancement)) ^ distance-slope
      set self-alliance-power self-alliance-power + alliance-loss-of-strength-gradient * fighting-strength * random-normal mean-Perception SD-perception-other
    ]
  ]
  
  if ( #potentialally != nobody ) 
  [ 
    ask #self [ set d distance #potentialally ]
    let alliance-loss-of-strength-gradient  1 / ( 1 + (d / [technological-advancement] of #potentialally)) ^ distance-slope
    set victim-alliance-power victim-alliance-power + alliance-loss-of-strength-gradient * [fighting-strength * random-normal mean-Perception SD-perception-other] of #potentialally
  ]
  
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
  let percentage-hostile-states 0  
  carefully [ set percentage-hostile-states ([length hostile-states] of #self) / [length friendly-states] of #self ] [ set percentage-hostile-states 0 ]
  let SD-perception-local 0
  carefully [set SD-perception-local(SD-perception * percentage-hostile-states)] [ set SD-perception-local SD-perception]
  
  let enemy-power 0
  let own-power [power] of #self * random-normal mean-Perception SD-perception-local
  if ( own-power < 0) [ set own-power 0]
  let friendly-power own-power
  if ( hostile-states != 0 ) [
    foreach hostile-states [
      if ( ? != nobody)[
        let extra [power] of ? * random-normal mean-Perception SD-perception-local
        if ( extra < 0) [ set extra 0]
        set enemy-power enemy-power + extra]
    ]]
  if ( friendly-states != 0 ) [
    foreach friendly-states [
      if ( ? != nobody)[
        let extra [power] of ? * random-normal mean-Perception SD-perception-local
        if ( extra < 0) [ set extra 0] 
        set friendly-power friendly-power + extra]
    ]]
  let initial-sense 0
  ifelse (enemy-power != 0) [set initial-sense (friendly-power / enemy-power)] [set initial-sense 3]
  
  ifelse (#typeofchange = "nothing") [
    report initial-sense ]
  [ let military-strength 0
    let count-provinces2 0
    let population2 0
    let gdp2 0
    let target-relation diplomaticrelation [who] of #self [who] of #target
    let actual-reparations-factor 0
    let actual-attrition-rate 0
    ask target-relation [set actual-reparations-factor actual-reparations set actual-attrition-rate actual-attrition]
    ifelse (#typeofchange = "fight") [      
      set population2 population + actual-reparations-factor * [population] of #target
      set count-provinces2 count patches with [ my-state = #self ] + actual-reparations-factor * count patches with [ my-state = #target ]
      set GDP2 GDP + actual-reparations-factor * [GDP] of #target
      carefully [set military-strength ((fighting-strength - [fighting-strength] of #target * actual-attrition-rate) / total-Militarycapabilities)][set military-strength 0 ]
    ]
    [if (#typeofchange = "submit") [
      let reparations actual-reparations-factor * (1 - give-in-compensation)
      set population2 population + reparations * [population] of #target
      set count-provinces2 count patches with [ my-state = #self ] + reparations * count patches with [ my-state = #target ]
      set GDP2 GDP + reparations * [GDP] of #target
      carefully [set military-strength (fighting-strength / total-Militarycapabilities)][set military-strength 0 ]
    ]
    let critical-mass 0 
    let economic-strength 0
    carefully [
      set critical-mass ( (population2 /  total-population) + (count-provinces2 / total-area) ) * current-amount-of-states
      set economic-strength (GDP2 / total-GDP) * current-amount-of-states ]
    [ set critical-mass 1 / current-amount-of-states
      set economic-strength 1 / current-amount-of-states]   
    
    set own-power (critical-mass + economic-strength + military-strength) / 4
    ]
    set friendly-power friendly-power - [power * random-normal mean-Perception SD-perception-local ] of #self + own-power
    ifelse (enemy-power != 0) [ report friendly-power / enemy-power] [report 3]] ;;ifelse (friendly-power / enemy-power > 3) [report 3] 
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; Environment Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to create-conflict ;; stochasticly create conflicts among states, with a randomised chance of a conflict for each relation, no matter alliances and attitudes
  if (any? states AND any? diplomaticrelations) [  
    let amount count DiplomaticRelations
    let amount-states count states
    let sum-rank sum [rank] of states
    let repeater 1 + round ( random-pAttack * amount)
    let repeater2 round (count diplomaticrelations * interdependence-pAttack)
    
    while [repeater > 0] [
      let a nobody
      let b nobody
      carefully [
        if (any? states )[
          ask states [ 
            if (random 1000 <= (( amount-states - rank ) / sum-rank) * 1000) [ 
              set a who] 
            if (random 1000 <= (( amount-states - rank ) / sum-rank) * 1000) [ 
              set b who] 
          ]
          ifelse ( a != b AND A != nobody AND B != nobody AND diplomaticrelation a b != nobody) [ if ([conflict] of diplomaticrelation a b = false) [ if( a = state 1 OR b = state 1) [ set amount-of-conflicts2 amount-of-conflicts2 + 1] set repeater repeater - 1 ask diplomaticrelation a b [set conflict true set time-of-last-conflict ticks set source-of-last-conflict
            "normal" set conflict-level 1]]]
          [set repeater repeater - 1]  
        ]] [ print 101 print error-message ]]
    
    carefully [
    ask diplomaticrelations [
      if (end1 != nobody AND end2 != nobody)[
        set interdependence-magnitude abs (interdependence end1 end2)
      ]]] [ print 102 print error-message ] 
    
    carefully [
    if (coercion_on = 1)[
      repeat repeater2 [
        let value 0
        if (any? diplomaticrelations with [conflict = false ]) [set value max [interdependence-magnitude] of diplomaticrelations with [conflict = false ]]
        if (any? diplomaticrelations with [conflict = false AND interdependence-magnitude = value]) [
          ask one-of diplomaticrelations with [interdependence-magnitude = value AND conflict = false] [ if( end1 = state 1 OR end2 = state 1) [ set amount-of-conflicts2 amount-of-conflicts2 + 1]set conflict true set time-of-last-conflict ticks set source-of-last-conflict "Asymmetric trade" set conflict-level 1 ]
        ]]]] [ print 103 print error-message ]
    
    carefully [
      let warmongers states with [ FPR-satisfaction > threshold-dissatisfaction AND major-power? = true]
      repeat count warmongers [
        if ( any? warmongers = true) [
          ask one-of warmongers [ 
            if ( any? my-diplomaticrelations with [ conflict = false]) [
              ask one-of my-diplomaticrelations with [ conflict = false] [ if( end1 = state 1 OR end2 = state 1) [ set amount-of-conflicts2 amount-of-conflicts2 + 1]set conflict true set time-of-last-conflict ticks set source-of-last-conflict "dissatisfaction" set conflict-level 1]]
            set warmongers warmongers with [self != myself] ]
        ]]] [ print 104 print error-message ]]
end

to conflictmemory
  ask diplomaticrelations [
    if (ticks = time-of-decision)[
      set conflict-memory lput (list time-of-last-conflict source-of-last-conflict type-of-last-conflict) conflict-memory] 
    let comparison ticks - memory-length
    if (empty? conflict-memory = false AND first (first conflict-memory) <= comparison) [set conflict-memory remove (first conflict-memory) conflict-memory]
  ]
end

to determine-similarity
  let difference (map - [ideology] of end1 [ideology] of end2)
  let sum-difference 0
  foreach difference [ ifelse (? < 0)  [set sum-difference sum-difference + ( -1 * ?)] [set sum-difference sum-difference + ?]]
  set ideology-similarity sum-difference  
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
    if (rank = 1 AND major-power? = true) [ set Hegemon self]
    if ( old-hegemon != Hegemon ) [set power-transition lput ticks power-transition]
  ]
  
  if ( power-transition != 0) [set power-transition remove-duplicates power-transition]
End

to-report request-alliance [ #self #enemy ]
  ifelse (#self != nobody AND #enemy != nobody AND #self != #enemy) [
    let potentials []
    carefully [
    if (hostile-states != 0 AND friendly-states != 0 AND empty? hostile-states = false AND empty? friendly-states = false ) [
      if (any? states with [member? #enemy hostile-states AND member? #self friendly-states]) [
        set potentials [who] of states with [member? #enemy hostile-states AND member? #self friendly-states]]]] [ set potentials []]
    carefully [
    foreach potentials [
      ask states with [who = ?] [
        let powershare 0
        
        carefully [ set powershare power / (power + [power] of #self)] [ set powershare 0.5 ]
        
        let target-relation nobody
        carefully [set target-relation diplomaticrelation [who] of #self [who] of #enemy] [ set target-relation nobody]
        let actual-reparations-factor 0
        let actual-attrition-rate 0
        ask target-relation [set actual-reparations-factor actual-reparations set actual-attrition-rate actual-attrition]
        
        let chance-winning pwinning self #enemy #self
        let expected-spoils (actual-reparations-factor * count [my-provinces] of #enemy) * powershare
        let expected-losses (actual-reparations-factor * (count my-provinces + count [my-provinces] of #self )) * powershare
        let military-losses actual-attrition-rate * [fighting-strength] of #enemy 
        let loss-of-trade-direct interdependence self #enemy
        ifelse ( chance-winning * expected-spoils - expected-losses * (1 - chance-winning) - military-losses - loss-of-trade-direct < 0 ) 
        [ set potentials remove ? potentials]   
        [ set potentials remove ? potentials
          set potentials lput self potentials]
      ]]] [ set potentials []]
    report potentials]
  [report nobody]
end

to foreign-policy-role  
  if (ticks > memory-length) [
    ask states [ 
      let expected first Power-memory
      let growth (1 + mean Power-growth-memory) ^ memory-length      
      
      set Epower expected * growth
      set FPR-satisfaction (Epower - power) ;;/ power
      if ( FPR-satisfaction > 10) [ set FPR-satisfaction 10 ]
    ]]
end

to-report actual-reparations
  let actual-reparations-factor 0  
  if (conflict-level = 1) [
    set actual-reparations-factor reparations-1
  ]
  if (conflict-level = 2) [
    set actual-reparations-factor reparations-2
  ]
  if (conflict-level = 3) [
    set actual-reparations-factor reparations-3
  ]
  if (conflict-level = 4) [
    set actual-reparations-factor reparations-4
  ]
  if (conflict-level = 5) [
    set actual-reparations-factor reparations-5
  ]
  report actual-reparations-factor
end 

to-report actual-attrition
  let actual-attrition-rate 0        
  if (conflict-level = 1) [
    set actual-attrition-rate attrition-1
  ]
  if (conflict-level = 2) [
    set actual-attrition-rate attrition-2
  ]
  if (conflict-level = 3) [
    set actual-attrition-rate attrition-3
  ]
  if (conflict-level = 4) [
    set actual-attrition-rate attrition-4
  ]
  if (conflict-level = 5) [
    set actual-attrition-rate attrition-5
  ]
  report actual-attrition-rate
end

to test 
  ask state 1 [ create-alliance-with state 3 ]
  ask state 2 [ create-alliance-with state 4 ]
  wage-war state 1 state 2   
end

to test-pwinning

end

to test-setup
  carefully [
    Set def-patches-water count patches with [water = true]
    Set should-patches-water water-percentage * count patches
    Set min-GDPpercapita min [GDPpercapita] of states
    Set max-GDPpercapita max [GDPpercapita] of states
    Set amount-capitals count patches with [capital? = true]
    ask states [ set count-provinces (count patches with [my-state = self])]
    set min-state min[count-provinces] of states
    set max-state max[count-provinces] of states
    set unassigned-patches count patches with [ water = false AND my-state = nobody ]
    set min-patch-population min[patch-population] of patches with [ water = false]
    set max-patch-population max[patch-population] of patches with [ water = false]
    set min-patch-GDPperCapita min[patch-GDPperCapita] of patches with [ water = false]
    set max-patch-GDPperCapita max[patch-GDPperCapita] of patches with [ water = false]
    set min-GDPpercapita-growth min[GDPpercapita-growth] of patches with [ water = false]
    set max-GDPpercapita-growth max[GDPpercapita-growth] of patches with [ water = false]
    set min-Population-growth min[Population-growth] of patches with [ water = false]
    set max-Population-growth max[Population-growth] of patches with [ water = false]
    set min-economic-size min[economic-size] of patches with [ water = false]
    set max-economic-size max[economic-size] of patches with [ water = false]
    set should-patches-resources count patches * likelihoodofresourcespresent
    set def-patches-resources count patches with [resource-present? = true]
    ;;set resource-type ((random 5) + 1) ;; assign type of resources 1 - 5  
    set max-GDP max[GDP] of states
    set min-GDP min[GDP] of states
    set max-Population max[Population] of states
    set min-Population min[Population] of states
    set max-MilitaryCapabilities max[MilitaryCapabilities] of states
    set min-MilitaryCapabilities min[MilitaryCapabilities] of states
    set max-MilitarySpending max[MilitarySpending] of states
    set min-MilitarySpending min[MilitarySpending] of states  
    set min-tradepartners min[count out-export-neighbors] of states
    set max-tradepartners max[count out-export-neighbors] of states  
    set min-DiplomaticRelations min[count DiplomaticRelation-neighbors] of states
    set max-DiplomaticRelations max[count DiplomaticRelation-neighbors] of states 
    set min-friendly-states min[length friendly-states] of states
    set max-friendly-states max[length friendly-states] of states
  ]
  [stop]
end

to test-decide
  ask diplomaticrelations with [ conflict = true ] [    
    
    if (decision-first = "escalate") [set count-1 count-1 + 1]
    if (decision-first = "mobilise & fight") [set count-2 count-2 + 1]
    if (decision-first = "alliance") [set count-3 count-3 + 1]
    if (decision-first = "militarycapabilities") [set count-4 count-4 + 1]
    if (decision-first = "submit") [set count-5 count-5 + 1]
    if (decision-first = "nothing") [set count-6 count-6 + 1]
    if (decision-first = "de-escalate") [set count-7 count-7 + 1]
    
    if (decision-second = "escalate") [set count-1 count-1 + 1]
    if (decision-second = "mobilise & fight") [set count-2 count-2 + 1]
    if (decision-second = "alliance") [set count-3 count-3 + 1]
    if (decision-second = "militarycapabilities") [set count-4 count-4 + 1]
    if (decision-second = "submit") [set count-5 count-5 + 1]
    if (decision-second = "nothing") [set count-6 count-6 + 1]
    if (decision-second = "de-escalate") [set count-7 count-7 + 1]    
    
    if ( decision-first != 0 AND decision-second = 0) [set count-8 count-8 + 1]
    if ( decision-first = 0 AND decision-second != 0) [set count-9 count-9 + 1]
  ] 
end

to test-inflectionpoint
  if ( state 1 != nobody) [
    ask state 1 [
      set inflection-state1 inflectionpoint-category
      set FPR-satisfaction-state1 FPR-satisfaction
      set power-1 Power
      set amount-of-conflicts1 count my-diplomaticrelations with [conflict = true]
      
      let counter2 mean [interdependence-magnitude]  of my-diplomaticrelations
      set interdependence-1 counter2]
  ]  
end

to print-initials
  print memory-length   
  print increased-mil-spending   
  print attrition-1   
  print reparations-2   
  print give-in-compensation   
  print reparations-4   
  print uw5  
  print amount_of_ideology_change   
  print pWinning-factor   
  print cost-per-distance   
  print attrition-4   
  print Length_of_culture_list   
  print attitude-decrease-war   
  print Max-initial-patch-population   
  print threshold-escalate   
  print SD-GDP-growth   
  print SD-military-spending   
  print mean-military-spending   
  print threshold-deescalate   
  print SD-initial-trade-volume   
  print interdependence-pAttack   
  print SD-tradevolume-growth   
  print mean-population-growth   
  print coercion_on   
  print attrition-3   
  print attitude-decrease-submitted   
  print SD-perception   
  print attitude-trade-increase   
  print reparations-5   
  print likelihoodofresourcespresent   
  print cost-of-new-trade   
  print uw3   
  print attrition-2   
  print uw2   
  print uw4   
  print Threshold-major-power   
  print SD-initial-military-capabilities   
  print attitude-increase-alliance   
  print worldsize   
  print threshold-dissatisfaction   
  print attrition-5   
  print inflection-point-deviation-zero   
  print threshold-counter   
  print SD-population-growth   
  print attitude-decrease-friendly   
  print mean-initial-military-capabilities   
  print amount-of-states  
  print uw1  
  print attitude-decrease-bargain   
  print Max-initial-GDPperCapita   
  print mean-initial-trade-volume   
  print mean-GDP-growth   
  print random-pAttack   
  print mean-Perception   
  print reparations-1   
  print reparations-3   
  print distance-slope   
  print population-GDP-factor   
  print mean-tradevolume-growth   
  print water-percentage       
end

to write-conflict-data
  file-open "conflict-output.txt"
  file-print (word [power] of end1 "," major-power-war-counter "," )
  file-print "\r"
  file-close
end
@#$#@#$#@
GRAPHICS-WINDOW
170
10
713
574
20
20
13.0
1
10
1
1
1
0
1
1
1
-20
20
-20
20
1
1
1
ticks
30.0

BUTTON
10
10
65
43
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
10
150
160
210
amount-of-states
25
1
0
Number

BUTTON
70
10
125
43
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
10
45
77
78
go 500
repeat 500 [go]
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
10
800
160
860
mean-population-growth
1.001
1
0
Number

INPUTBOX
10
860
160
920
mean-GDP-growth
1.001
1
0
Number

INPUTBOX
160
800
310
860
SD-population-growth
0.0010
1
0
Number

INPUTBOX
160
860
310
920
SD-GDP-growth
0.0010
1
0
Number

INPUTBOX
710
1175
860
1235
likelihoodofresourcespresent
0.1
1
0
Number

INPUTBOX
560
1175
710
1235
random-pAttack
0.01
1
0
Number

INPUTBOX
160
1160
310
1220
SD-perception
0.1
1
0
Number

BUTTON
10
300
160
350
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
10
375
160
425
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

INPUTBOX
10
1040
160
1100
Max-initial-patch-population
10
1
0
Number

INPUTBOX
160
1040
310
1100
Max-initial-GDPperCapita
1
1
0
Number

INPUTBOX
10
920
160
980
mean-initial-military-capabilities
100
1
0
Number

INPUTBOX
160
920
310
980
SD-initial-military-capabilities
50
1
0
Number

INPUTBOX
10
980
160
1040
mean-initial-trade-volume
10
1
0
Number

INPUTBOX
160
980
310
1040
SD-initial-trade-volume
4
1
0
Number

INPUTBOX
10
1160
160
1220
mean-Perception
1
1
0
Number

BUTTON
70
45
125
78
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
10
1100
160
1160
mean-tradevolume-growth
1
1
0
Number

INPUTBOX
160
1100
310
1160
SD-tradevolume-growth
0.1
1
0
Number

INPUTBOX
507
1397
657
1457
give-in-compensation
0.5
1
0
Number

BUTTON
10
100
160
133
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

INPUTBOX
10
1220
160
1280
mean-military-spending
0.01
1
0
Number

INPUTBOX
160
1220
310
1280
SD-military-spending
0.0010
1
0
Number

INPUTBOX
1100
920
1250
980
Threshold-major-power
3
1
0
Number

INPUTBOX
900
800
1050
860
attitude-decrease-war
0.75
1
0
Number

INPUTBOX
900
860
1050
920
attitude-decrease-bargain
0.3
1
0
Number

INPUTBOX
900
920
1050
980
attitude-decrease-submitted
0.1
1
0
Number

INPUTBOX
900
980
1050
1040
attitude-decrease-friendly
0.2
1
0
Number

INPUTBOX
357
1337
507
1397
increased-mil-spending
0.25
1
0
Number

INPUTBOX
560
1235
710
1295
interdependence-pAttack
0.01
1
0
Number

INPUTBOX
357
1397
507
1457
cost-of-new-trade
0
1
0
Number

INPUTBOX
357
1457
507
1517
cost-per-distance
0
1
0
Number

INPUTBOX
1100
860
1250
920
threshold-counter
5
1
0
Number

MONITOR
175
585
272
630
Amount of wars
war-counter
17
1
11

INPUTBOX
900
1040
1050
1100
attitude-increase-alliance
0.5
1
0
Number

MONITOR
270
585
382
630
Major power wars
major-power-war-counter
17
1
11

INPUTBOX
900
1100
1050
1160
attitude-trade-increase
0.1
1
0
Number

INPUTBOX
1100
800
1250
860
threshold-dissatisfaction
4
1
0
Number

INPUTBOX
360
800
510
860
uw1
5
1
0
Number

INPUTBOX
360
860
510
920
uw2
5
1
0
Number

INPUTBOX
360
920
510
980
uw3
2
1
0
Number

INPUTBOX
360
980
510
1040
uw4
2
1
0
Number

INPUTBOX
360
1040
510
1100
uw5
2
1
0
Number

INPUTBOX
710
1235
860
1295
water-percentage
0.1
1
0
Number

INPUTBOX
807
1397
957
1457
pWinning-factor
0.62
1
0
Number

CHOOSER
10
220
160
265
worldsize
worldsize
10 20 30 50 70 100
1

INPUTBOX
507
1457
657
1517
distance-slope
0.4
1
0
Number

INPUTBOX
657
1337
807
1397
memory-length
10
1
0
Number

INPUTBOX
807
1457
957
1517
coercion_on
1
1
0
Number

MONITOR
375
585
492
630
Amount of conflicts
amount-conflicts
17
1
11

INPUTBOX
807
1337
957
1397
inflection-point-deviation-zero
0.01
1
0
Number

INPUTBOX
657
1397
807
1457
Length_of_culture_list
10
1
0
Number

INPUTBOX
657
1457
807
1517
amount_of_ideology_change
0.2
1
0
Number

INPUTBOX
1100
980
1250
1040
threshold-deescalate
0.8
1
0
Number

INPUTBOX
1100
1040
1250
1100
threshold-escalate
2.5
1
0
Number

INPUTBOX
560
800
710
860
reparations-1
0.05
1
0
Number

INPUTBOX
560
860
710
920
reparations-2
0.1
1
0
Number

INPUTBOX
560
920
710
980
reparations-3
0.2
1
0
Number

INPUTBOX
710
800
860
860
attrition-1
0.05
1
0
Number

INPUTBOX
710
860
860
920
attrition-2
0.1
1
0
Number

INPUTBOX
710
920
860
980
attrition-3
0.2
1
0
Number

INPUTBOX
507
1337
657
1397
population-GDP-factor
0.1
1
0
Number

INPUTBOX
555
985
707
1045
reparations-4
0.4
1
0
Number

INPUTBOX
555
1050
707
1110
reparations-5
0.7
1
0
Number

INPUTBOX
710
985
862
1045
attrition-4
0.6
1
0
Number

INPUTBOX
715
1050
867
1110
attrition-5
0.7
1
0
Number

INPUTBOX
1100
1100
1252
1160
FPR-impact
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
1
@#$#@#$#@
