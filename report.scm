(import (rnrs (6)))
(import (math evidence))

; The probabilities of seeing the hypotheses and the pieces of evidence
(define probabilities
  '#(
    #(0.64 0.05 0.95 0.95)
    #(0.16 1.0  0.5  0.5)
    #(0.16 0.05 0.5  0.2)
    #(0.04 0.05 0.2 0.2)))

#|
  1. to prevent other Asian countries from switching to communist governments
    a. specific attention is given to Cambodia, Laos, Indonesia, and the Phillipines
      i. the only instances in which I could observe anything approaching a "domino" effect occurs when the armies of one communist country invades another in support of an embattled insurgency. Think the march of the Red army across eastern Europe in 1944-1945, China's intervention in North Korea, etc. In each of these cases, the country in question had the logistical transport resources needed to support an expeditionary army. North Vietnam lacked this capability. So, it's hard to see how such a domino effect could have developed.
    b. ironically, the only countries that Vietnam had the logistical ability to invade was cambodia and Laos. Indeed Vietname invaded Cambodia after the U.S. withdrawal, however their invasion was against another "communist" regime and was ostensibly launched in order to stop the Khmer Rouge from genocidally mass murdering ethnic Vietnamese communities (and generally disrupting the mass murders unfolding in the country). This was one of the few instances of a communist country invading another to overthrow a regime - certainly not what the "domino" theory would predict. And again, in 1979, the Vietnamese and the Chinese (two communist countries) fought each other. The Communist vietnamese government fought more communist countries than "capitalist" ones after its unification.
  2. to "protect" the south vietnamese from communist "tyranny"
    a. while the war was followed by forced disappearances, reprisal murders, and a loss of political freedoms (see, for example the mass murders during the battle for Hue), its hard for me to see how waging and exceptionally violent and brutal war across south vietnam failed to inflict greater suffering. The war killed between 966,000–3,010,000 vietnamese.(Obermeyer, Ziad; Murray, Christopher J L; Gakidou, Emmanuela (23 April 2008). "Fifty years of violent war deaths from Vietnam to Bosnia: analysis of data from the world health survey programme". British Medical Journal. 336 (7659): 1482–1486. doi:10.1136/bmj.a137. PMC 2440905. PMID 18566045.)
    b. what's more "In its aftermath, under Lê Duẩn's administration, there were no mass executions of South Vietnamese who had collaborated with the US or the defunct South Vietnamese government, confounding Western fears,[159] but up to 300,000 South Vietnamese were sent to reeducation camps, where many endured torture, starvation, and disease while being forced to perform hard labour."(Wikipedia: Vietnam)
    c. (this was not knowable at the time of the vietnam war) communism didn't work. Vietnam transitioned away from communism peacefully. If the United States had not intervened, the vietnamese people would have ultimately abandoned communisim anyway:
      "At the Sixth National Congress of the Communist Party of Vietnam (CPV) in December 1986, reformist politicians replaced the "old guard" government with new leadership.[167][168] The reformers were led by 71-year-old Nguyễn Văn Linh, who became the party's new general secretary.[167] He and the reformers implemented a series of free-market reforms known as Đổi Mới ("Renovation") that carefully managed the transition from a planned economy to a "socialist-oriented market economy".[169][170] Although the authority of the state remained unchallenged under Đổi Mới, the government encouraged private ownership of farms and factories, economic deregulation, and foreign investment, while maintaining control over strategic industries.[170][171] Subsequently, Vietnam's economy achieved strong growth in agricultural and industrial production, construction, exports, and foreign investment, although these reforms also resulted in a rise in income inequality and gender disparities.[172][173][174]"
    d. lastly, the "democratic" leaders such as Ngô Đình Diệm that the US engaged in disappearances, violently suppressed dissent, and used mass violence and intimidation. 
  3. it seems clear from internal policy papers and classified discussions that the primary interest in Vietnam for the United States derived from its relationship to the policy of communist containment in Asia. To date, I have not found a single policy paper, presidential minutes meeting, or classified leak mentioning any interest in Vietnam for economic reasons. However, many laypeople still believe the United States sought to gain economically from Vietnam. So, perhaps it's worth pointing out, that before and during the war, the United States had neglible trade relations with Vietnam. Indeed, only after the war and the collapse of the soviet union has the united states and Vietnam developed marginal trade relations based on textiles.  

  Given the flawed assumptions and logical contradictions in these goals, it seems to me that the United States's should not have intervened in Vietnam. However, some of these errors might not have been knowable at the time.

  To achieve these primary goals, the United States appeared to have adopted the following "secondary/instrumental" goals (Westmoreland's strategy)
  1. to shield the south vietnames government from being overrun by north vietnamese army units and from being toppled by the viet cong insurgency
  2. to provide training and support (money, transportation, and supporting fires) to the ARVN so that it would acquire the capabilities needed to sustain the fight indepedently
  3. to draw down to an auxiliary supporting role to sustain the ARVN against the north.

  For these goals to be achieved, the following would have to have been possible. 

  H0 - the south vietnamese government could
    1. be stable
    2. garner more than 50% approval from the populace
    3. maintain enough elite and mass support to sustain an indefinite attritional conflict with the north
    and therefore be able to sustain an indefinite attritional conflict with the north
  H1 - the south vietnamese army (ARVN) could
    1. grow to sufficient size to provide coverage across south vietname against the viet cong
    2. have the mobility needed to mass and counter incursions by the north vietnames army
    3. have sufficient effectiveness and firepower to defeat and thereby deter north vietnames incursions
  H2. - the american military and political system could
    1. maintain a sense that the war in vietnam was progressing towards a successful conclusion
      a. it seems that countries give up when they feel that they are either stuck in an endless attritional conflict with no prospect of success or are pending imminent defeat.
    2. limit casualties to a level that the american public would accept for at least 5 years


  We can then assess the evidence available for each of these goals and assess whether or not they were feasible.

  H0
    E1 - In 1956, Viet Cong assassinated 450 South Vietnamese officials 
    E2 - In 1963, Buddhists erupted in protest against Ngô Đình Diệm
    E3 - In 1963, Ngô Đình Diệm was assassinated in a coup
    E4 - From 1963 to 1965, over a dozen military governments suceded each other in South Vietnam
    E5 - General Nguyễn Văn Thiệu assumed control using fraudulent elections in 1967 and 1971. 
  H1
    E1 - Following the Paris Peace Accords of 27 January 1973, all American combat troops were withdrawn by 29 March 1973. North Vietnam captured a province in December of 1974 and seized Saigon in April 1975.
    E2 - ARVN operational level command was fragmented.
    E3 - the ARVN airforce was ineffective at providing reconnaisance, air lift, and tactical air support
    E4 - the ARVN conscript infantry lacked training and mobility and were reliant on US. artilery, airsupport, transportation, and logistics  
  H2
    E1 - The Tet offensive undercut faith in authority estimates and claims
    E2 - Leaks revealing pessimistic assessments by RAND and other analysts undercut trust in authority assessments
    E3 - the lack of clear metrics of success strained any narratives of progress
    E4 - failed promises of a pending conclusion undercut confidence
    E5 - the draft instilled visceral fear among US citizens
    E6 - the relatively uncensored reporting on the war amplified fears of potential draftees and their parents
    E7 - leaks of atrocities such as Mai Lai and the rampant violence that always occurs in warzones undercut moralistic narratives
    E8 - 1968 to 1969 monthy US KIA were:
    498 	506 	515 	520 	536 	536 	537 	537 	538 	534 	538 	537
    542 	541 	538 	543 	540 	539 	537 	510 	510 	495 	480 	474  
|#
(define probabilities
  '#(

  )
)