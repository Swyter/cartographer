from header_common import *
from header_parties import *
from ID_troops import *
from ID_factions import *
from ID_party_templates import *
from ID_map_icons import *

####################################################################################################################
#  Each party record contains the following fields:
#  1) Party id: used for referencing parties in other files.
#     The prefix p_ is automatically added before each party id.
#  2) Party name.
#  3) Party flags. See header_parties.py for a list of available flags
#  4) Menu. ID of the menu to use when this party is met. The value 0 uses the default party encounter system.
#  5) Party-template. ID of the party template this party belongs to. Use pt_none as the default value.
#  6) Faction.
#  7) Personality. See header_parties.py for an explanation of personality flags.
#  8) Ai-behavior
#  9) Ai-target party
# 10) Initial coordinates.
# 11) List of stacks. Each stack record is a triple that contains the following fields:
#   11.1) Troop-id. 
#   11.2) Number of troops in this stack. 
#   11.3) Member flags. Use pmf_is_prisoner to note that this member is a prisoner.
# 12) Party direction in degrees [optional]
####################################################################################################################

no_menu = 0
#pf_town = pf_is_static|pf_always_visible|pf_hide_defenders|pf_show_faction
pf_town = pf_is_static|pf_always_visible|pf_show_faction|pf_label_large
pf_castle = pf_is_static|pf_always_visible|pf_show_faction|pf_label_small	#pf_label_medium
pf_village = pf_is_static|pf_always_visible|pf_hide_defenders|pf_label_small #chief cambiado

#sample_party = [(trp_briton_knight,1,0), (trp_swadian_peasant,10,0), (trp_briton_level2_landed,1,0), (trp_briton_horseman, 1, 0), (trp_briton_level1_landed, 1, 0), (trp_briton_level0_landed,1,0)]

# NEW TOWNS:

parties = [
  ("main_party","Main Party",icon_player|pf_limit_members, no_menu, pt_none,fac_player_faction,0,ai_bhvr_hold,0,(32.08,-69.56),[(trp_player,1,0)]),
  ("temp_party","{!}temp_party",pf_disabled, no_menu, pt_none, fac_commoners,0,ai_bhvr_hold,0,(0,0),[]),
  ("camp_bandits","{!}camp_bandits",pf_disabled, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(1,1),[(trp_temp_troop,3,0)]),
#parties before this point are hardwired. Their order should not be changed.
  
  ("temp_party_2","{!}temp_party_2",pf_disabled, no_menu, pt_none, fac_commoners,0,ai_bhvr_hold,0,(0,0),[]),
#Used for calculating casulties.
  ("temp_casualties","{!}casualties",pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("temp_casualties_2","{!}casualties",pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("temp_casualties_3","{!}casualties",pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("temp_wounded","{!}enemies_wounded",pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("temp_killed", "{!}enemies_killed", pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("main_party_backup","{!}_",  pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("encountered_party_backup","{!}_",  pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
#  ("ally_party_backup","_",  pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("collective_friends_backup","{!}_",  pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("player_casualties","{!}_",  pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("enemy_casualties","{!}_",  pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("ally_casualties","{!}_",  pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),

  ("collective_enemy","{!}collective_enemy",pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  #TODO: remove this and move all to collective ally
  ("collective_ally","{!}collective_ally",pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
  ("collective_friends","{!}collective_ally",pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),
   
  ("total_enemy_casualties","{!}_",  pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]), #ganimet hesaplari icin #new:
  ("routed_enemies","{!}routed_enemies",pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]), #new:  

#  ("village_reinforcements","village_reinforcements",pf_is_static|pf_disabled, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(1,1),[]),

###chief sea battles
##("burning_buildings","If you see me, report the fire bug.",  pf_disabled|icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(0, -50),[], 170),
## ("ship_colisions","If you see me, report the colision bug.",  pf_disabled|icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(0, -50),[], 170),
###chief acaba
###############################################################  
  ("zendar","Zendar",pf_disabled|icon_fort1|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(52.35,-52.72),[]),

  ("town_1","Cantwaraburh",	icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		170,(74.20,-249.1),[],170), #done                
  ("town_2","Cippanhamm",	icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(-15.80,-181.91),[],260), #done         
  ("town_3","Eidynburh",	icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		320,(48,92.1),[],320), #no                     
  ("town_4","Ribe",			icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 		70,(228,-142),[],70), #done                     
  ("town_5","Tunsberg",		icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		190,(263.05,89.05),[],190), #done                    
  ("town_6","Dun_Breatann",	icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		45,(7.42464,107.568),[],45), #done               
  ("town_7","Dubh_Linn",	icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		270,(-78, -3),[],270), #done              
  ("town_8","Cirren_Ceaster",  icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	170,(-4.34,-168.61),[],170), #done               
  ("town_9","Caer_Dyf",		icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		110,(-56.5,-161.5),[],110), #done                             
  ("town_10","Jorvik",		icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		310,(55.57,-43.05),[],310), #done                   
  ("town_11","Dorestad",	icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		310,(197.906,-253.064),[],310), #done                 
  ("town_12","Lundenwic",	icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		155,(40,-212.3),[],155), #done                    
  ("town_13","Ynys_Mon",	icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		105,(-41.2,-43.9),[],105), #done                
  ("town_14","Dunwic",		icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		245,(104.2,-200),[], 245), #done                     
  ("town_15","Scuin",   	icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		0,(30.44,123.26),[],0), #done               
  ("town_16","Witan_Ceaster",  icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	135,(6.25,-225.71),[],135), #done                #c(0.01, 225.17)
  ("town_17","Bosvenegh",  	icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		255,(-98.2,-187.32),[],255), #done               
  ("town_18","Ceall_Cainnigh",  icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	135,(-130.47,-34.25),[],135), #done              
  ("town_19","Cell_Rigmonaid",  icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 	183,(64.5,95.9),[], 183), #done                     
  ("town_20","Rath_Celtair",icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 		340,(-40.5,38.5),[], 340), #done          
  ("town_21","Maistiu",  	icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		80,(-100.14,-19.55),[],80), #no                      
  ("town_22","Caer_Meguaidd", icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	290,(-20.97,-92.59),[],290), #done             
  ("town_23","Tomtun",  	icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		90,(21.7,-100.88),[],90), #Done                       
  ("town_24","Caiseal",   	icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		290,(-151.93,-6.29),[],290), #done                      #c(152.27, 6.43)
  ("town_25","Aileach",   	icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		50,(-68,118.2),[],50), #done               #c(66.63, -115)
  ("town_26","Brycheiniog",	icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		125,(-47.36,-146.76),[],125), #no                   
  ("town_27","Bebbanburh",	icon_town_port|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 		257,(80,13.86),[],257), #done          #
  ("town_28","Cruaghan",	icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		90,(-135.17,77.67),[],90), #done                    #
  ("town_29","Temair",	icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,			155,(-100.85,8.64),[],155), #done                     #coords (105.23, -28.11)

  #  ("town_8","Grantebrycge", icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-94.72,101.41),[],175), #done
  #  ("town_10","Eoferwic",   icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-55.57,43.05),[],310), #done     
  #  ("town_24","Linnuis",   icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-73.16,63.25),[],155), #done
#  ("town_25","Caer_Peris",   icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(12.50,98.58),[],240), #no
#  ("town_28","Llys_Pengwern",   icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-24.63,79.82),[],80), #done
#  ("town_29","Din_Bych",     icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(18.99,112.58),[],290), #no
  
  #  ("town5","Caer_Luit_Coyt",  icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-28.82,68.84),[],135), #Done
#  ("town_34","Monid Crobh",   icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-26.75,-108.91),[],240), #done
#  ("town_35","Dun_Iasgach",   icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(92.37,113.04),[],170), #no
#  ("town_38","Caer_Wenddoleu",   icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-25.03,-4.36),[],90), #done
#  ("town_39","Dun_Taruo",   icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-39.09,-160.99),[],90), #done
#  ("town_40","Clochair", icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(69.25,17.81),[],45), #done
#  ("town_42","Din_Cado",  icon_town_walled|pf_town, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-16.63,127.78),[],90), #done

#   Castles-villages       
#  Northumbria
  ("castle_1","Caer_Ligualid",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	50,(27.95,20.65),[],50),                #coords (-31.87, -26.05)
  ("castle_2","Mame_Ceaster",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	75,(26.84,-40.93),[],75),                  #coords (-28.14, 50.11)
  ("castle_3","Donne_Ceaster",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	100,(45.49,-67.09),[],100),               #coords (-50.83, 70.62)
  ("castle_4","Middelsburh",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		180,(69.89,-16.3),[],180),                   #coords (-77.66, 21.86)
  ("castle_5","Denisesburna",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	45,(55.22,13.01),[],45),                   #
  ("castle_6","Ad Gefrin",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		80,(58.00,58.23),[],80),                    #
  ("castle_7","Din_Baer",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		45,(70.3,74.7),[],45),                       #coords (-84.01, -70.65)
  ("castle_8","Wicstun",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,			30,(77.29,-70.55),[],30),                       #
#Mercia
  ("castle_9","Snotingaham",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		15,(27.27,-126.24),[],15),                   #coords (-26.08, 133.14)
  ("castle_10","Lincylene",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		110,(70.01,-122.18),[],110),                  #coords (-78.8, 133.07)
  ("castle_11","Ham_Tune",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		75,(35.48,-169.02),[],75),                    #coords (-25.14, 172.53)
  ("castle_12","Hreapandun",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		95,(30.54,-84.94),[],95),                   #coords (-16.03, 116.55)
  ("castle_13","Oxenaforda",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		115,(21.25,-176.85),[],115),                 #coords (-18.43, 189.26)
  ("castle_14","Colne_Ceaster",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	90,(67.2,-211.49),[],90),                #coords (-71.17, 239.95)
  ("castle_15","Gegnesburh",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		235,(61.25,-97.24),[],235),                  #coords (-73.84, 104.38)
  ("castle_16","Stanford",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		45,(53.68,-153.23),[],45),                    #coords (-67.27, 172.74)
#east engla
  ("castle_17","Norwic",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,			15,(98.49,-169.11),[],15),                      #coords (-110.05, 193.17)
  ("castle_18","Haegelisdun",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	300,(82.73,-182.57),[],300),                #coords (-77.99, 211.52)
  ("castle_19","Rendlaesburh",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	280,(82.07,-211.14),[],280),                #coords (-96.61, 230.48)
  ("castle_20","Grantebrycge",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	260,(60.90,-178.34),[],260),               #coords (-60.9, 194.09)
#wessex
  ("castle_21","Hrofae_Ceaster",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 180,(43.9183,-228.496),[],180),              #
  ("castle_22","Dornwara_Ceaster",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,260,(-45.09,-210.96),[],260),            #coords (41.24, 249.78)
  ("castle_23","Searoburh",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		80,(-32.21,-204.58),[],80),                    #coords (11.85, 235.07)
  ("castle_24","Dorce_Ceaster",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	240,(17.15,-196.72),[],240),              #coords (-15.81, 215.28)
  ("castle_25","Wiltun",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,			260,(-43.74,-193.8),[],260),                       #coords (26.82, 223.22)
  ("castle_26","Ham_Tun",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(-11.44,-223.97),[],260),                     #coords (1.43, 263.84)
  ("castle_27","Badon",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,			260,(-28.93,-175.92),[],260),                       #coords (24.77, 204.86)
  ("castle_28","Escan_Ceaster",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	60,(-80.13,-204.77),[],60),                #coords (65.93, 226.06)
#Corniu
  ("castle_29","Towan_Blystra",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	60,(-125.81,-196.74),[],60),               #
  ("castle_30","Din_Tagell",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(-112.98,-184.8),[],260),                  #coords (103.69, 194.31)
#Alt Clut
  ("castle_31","Cathures",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(21.55,97.59),[],260),                   #
  ("castle_32","Cuil_nam",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(14.84,56.68),[],260),                   #coords (-18.39, -64.24)
  ("castle_33","Caer_Caradawg",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	80,(35.48,82.90),[],80),               #
  ("castle_34","Gobhann",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(7.21,74.61),[],260),                     #coords (-6.81, -84.15)
#Alban
  ("castle_35","Dun_Duim",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(39.89,135.05),[],260),                  #coords (-43.22, -151.04)
  ("castle_36","Dun_Foither",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	260,(93.37,121.64),[],260),               #coords (-115.32, -158.96)
  ("castle_37","Dun_Taruo",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(93.64,178.18),[],260),                 #coords (-95.52, -200.46)
  ("castle_38","Dun_Averte",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(-6.62,109.24),[],260),                  #
  ("castle_39","Dun_Onlaigh",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	280,(4,152.7),[],280),                #
  ("castle_40","Art_Muirchol",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	260,(12.3,182.00),[],260),                #
#Gwynedd
  ("castle_41","Din_Bych",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		90,(-82.88,-119.87),[],90),                     #coords (80.79, 127.87)
  ("castle_42","Dinas Bran",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		120,(-8.33,-84.45),[],120),                 #
  ("castle_43","Din_Arth",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(-6.33,-58.63),[],260),                      #coords (8.59, 65.03)
  ("castle_44","Din_Erth",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(-39.87,-89.89),[],260),                     #coords (46.82, 115.67)
  ("castle_45","Caer_Seniont",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	80,(-37.85,-60.74),[],80),                  #coords (44.03, 66.55)
  ("castle_46","Caer_Sws",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(-26.96,-112.05),[],260),                     #coords (45.72, 130.27)
#Brycheiniog
#Glywyssing
  ("castle_47","Meigen_Cil_Ceincoed",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,240,(-45.93,-164.45),[],240),         
  ("castle_48","Caer_Went",icon_fort2|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(-30.42,-151.47),[],260),                    
#Denmark
  ("castle_49","Skyfa",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,			315,(247.11,-72.43),[],315),                      #coords (-277.83, 49.18)
  ("castle_50","Vebjorg",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(274.417,-50.4479),[],260),                    #
  ("castle_51","Huhelstath",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 	60,(249.626,-183.222),[],60),                    #coords (-262.16, 159.21)
  ("castle_52","Heidabyr",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 		20,(262.713,-202.548),[],20),                   #coords (-258.24, 192.75)
#Norwey
  ("castle_53","Skiringssalr",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	45,(230.59,94),[],45),                  #coords (-272.42, -99.14)
  ("castle_54","Hordaland",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		90,(214.64,214.77),[],90),                 #
  ("castle_55","Agdir",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,			135,(214.88,112.24),[],135),
  ("castle_56","Rogaland",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		90,(203.67,163.5),[],90),                   #
#Kingdom of Isles
  ("castle_57","Caer_Reghed",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	1,(-2.99,47.27),[],1),                   #coords (3.44, -49.04)
  ("castle_58","Dun_Baitte",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		90,(71.06,197.47),[],90),                 #coords (-82.04, -228.24)
  ("castle_59","Ynys_Manaw",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		15,(-17.04,12.87),[],15),                   #coords (20.11, -13.25)
  ("castle_60","Bjarnaroy",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(31.18,267.13),[],260),                 #
  ("castle_61","Orkneyjar",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		260,(135.99,261.1),[],260),                 #coords (-138.82, -279.88)
  ("castle_62","Veisafjordr",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	280,(-114.75,-58),[],280),                    #coords (127.54, 65.28)
#Frisia
  ("castle_63","Kennemer",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 		45,(188,-235.4),[],45),                   #coords (-220.59, 257)
  ("castle_64","Vles_Inge",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 		215,(165.69,-260.98),[],215),                 #coords (-184.3, 293.63)
#Uladh
  ("castle_65","Dun_Sebuirge",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 	10,(-43.37,101.9),[],10),                #coords (73.35, -122.43)
  ("castle_66","Magh_Rath",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		45,(-48.01,69.13),[],45),                    #coords (54.52, -80.81)
  ("castle_67","Magh_Cobha",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		45,(-57.36,42.97),[],45),                   #coords (70.37, -56.45)
  ("castle_68","Druim_Mor",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		45,(-46.3,49.12),[],45),                     #coords (50.87, -49.32)
#Aileach / Ui Neill north
  ("castle_69","Rath_Clochair",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	90,(-100.75,86.86),[],90),               #coords (109.52, -95.31)
  ("castle_70","Fir_Fearnmhaigh",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,90,(-84.49,47.04),[],90),              #coords (94.26, -52.24)
  ("castle_71","Ard_Macha",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		90,(-68.12,53.47),[],90),                    #coords (72.61, -76.76)
  ("castle_72","Mag_Dumai",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		45,(-68.23,71.09),[],45),                    #coords (83.85, -78.02)
#Ui Neill South / Meath
  ("castle_73","Ath_Mor",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		80,(-130.11,27),[],80),                        #coords (131.26, -32.99)
  ("castle_74","Ard_Eachadha",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	80,(-78.53,25.29),[],80),                 #
  ("castle_75","Ard_Breacain",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	80,(-80.87,9.27),[],80),                 #coords (100.05, -10.23)
  ("castle_76","Lagore_Crannoc",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	80,(-115.5,12),[],80),                  #coords (118.49, -1.27)
#Connachta
  ("castle_77","Cathair_Chomain",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,80,(-161.99,34.12),[],80),             #coords (183.39, -32.72)
  ("castle_78","Luighne_Connacht",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,80,(-137.68,100.31),[],80),           #coords (152.01, -110.81)
  ("castle_79","Fiachrach_Aidne",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,80,(-153.84,49.8),[],80),              #coords (186.69, -68.42)
  ("castle_80","Ath_Berchna",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	80,(-132.18,58.24),[],80),                 #coords (144.84, -82.05)
#Mumain
  ("castle_81","Grian_Airbh",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	80,(-150.67,16.65),[],80),                 #coords (163.94, -11.84)
  ("castle_82","Les_Mor",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		80,(-142.61,-45.15),[],80),                      #coords (162.72, 46.16)
  ("castle_83","Ciarraighe_Luachra",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,80,(-184.95,7.24),[],80),           #coords (211.52, -6.36)
  ("castle_84","Muscraighe",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		80,(-165.92,-50.20),[],80),                   #coords (193.16, 50.2)
  ("castle_85","Dun_Na_Mbarc",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	80,(-202.18,-35.21),[],80),                 #coords (205.5, 26.02)
#Laigin
  ("castle_86","Cell_Dara",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		80,(-106.75,-4.85),[],80),                     #coords (119, 7)
  ("castle_87","Liamhain",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		80,(-94.14,-9.71),[],80),                       #coords (93.62, 14.59)
  ("castle_88","Dun Bolg",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,		80,(-112.79,-24.53),[],80),                     #coords (111.77, 42.29)
  ("castle_89","Ros_Mhic_Treoin",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,80,(-113.39,-46.33),[],80),              #coords (130.7, 57.92)
#Osrige
  ("castle_90","Mairg_Laigen",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,	80,(-127.8,-22.93),[],80),                  #coords (141.23, 17.73)
#Ui Neill Aileach TARA HILL
#  ("castle_91","Tara",icon_fort1|pf_castle, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(103.49,-3.96),[],80),                         #coords (102.22, -26.36)


#Villages are special scenes.  
#northumbria
  ("village_1","Ligualid_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(17.4549,4.53717),[],100),             #
  ("village_2","Mame_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(17.0586,-31.6989),[],110),                #
  ("village_3","Donne_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(53.6156,-76.3319),[],120),                #coords (-8.48, 57.35)
  ("village_4","Middels_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(83.6725,-32.2016),[],130),             #c(-69.89, 19.3)
  ("village_5","Denises_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(45.1003,44.5727),[],170),
  ("village_6","Ad_Gefrin_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(79.6139,57.534),[],100),          #c(-61, -58.23)
  ("village_7","Baer_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(42.2875,72.2028),[],110),               #c(-73.3, -74.7)
  ("village_8","Wics_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(92.8228,-63.6574),[],120),
#Mercia
  ("village_9","Snotingaham_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(23.2812,-143.003),[],130),
  ("village_10","Lincylene_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(80.0943,-102.567),[],170),         #c(-70.01, 125.18)
  ("village_11","Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(36.8432,-154.837),[],45),
  ("village_12","Hreapan_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(31.3599,-71.1302),[],110),
  ("village_13","Oxena_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(16.9501,-164.51),[],120),
  ("village_14","Colne_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(67.5992,-224.081),[],130),
  ("village_15","Gegnes_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(54.8675,-115.068),[],90),
  ("village_16","Stan_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(72.8937,-147.405),[],170),
#East Engla
  ("village_17","Nor_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(91.079,-146.423),[],35),
  ("village_18","Haegelis_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(77.1782,-163.037),[],180),
  ("village_19","Rendlaesham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(77.4068,-194.17),[],170),
  ("village_20","Grante_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(64.7053,-194.295),[],170),
#Wessex
  ("village_21","Hrofae_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(29.7495,-243.104),[],100),
  ("village_22","Dornwara_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-41.2668,-224.739),[],110),
  ("village_23","Searo_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-24.3151,-223.316),[],120),
  ("village_24","Dorce_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-0.773833,-192.456),[],130),
  ("village_25","Wil_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-66.3398,-204.004),[],170),
  ("village_26","Ham_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-6.29549,-210.624),[],170),                #c(14.44, 223.97)
  ("village_27","Badon_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-38.1762,-184.28),[],170),              #c(28.93, 178.92)
  ("village_28","Escan_Ham",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-86.2759,-217.291),[],170),
#Corniu
  ("village_29","Tref_Towan",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-132.893,-207.111),[],170),
  ("village_30","Tref_Tagell",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-109.755,-199.918),[],170),
#Alt Clut
  ("village_31","Tref_Cathures",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(33.2272,108.101),[],100),
  ("village_32","Tref_Cuil",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(7.72747,46.0087),[],110),              #c(-14.84, -59.68)
  ("village_33","Tref_Caradawg",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(31.4654,73.7026),[],120),         #c(-38.48, -82.9)
  ("village_34","Tref_Gob",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(25.7031,65.2674),[],130),
#Alban
  ("village_35","Bal_Duim",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(64.2713,145.446),[],170),
  ("village_36","Bal_Foither",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(112.381,143.615),[],80),            #c(-96.37, -121.64)
  ("village_37","Bal_Tauro",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(120.284,165.089),[],90),
  ("village_38","Bal_Averte",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-19.6853,95.6177),[],170),
  ("village_39","Bal_Onlaigh",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(26.8592,159.297),[],45),
  ("village_40","Bal_Muirchol",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(18.811,210.537),[],170),
#Gwynedd
  ("village_41","Tref_Bych",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-65.7373,-105.313),[],100),                #c(85.88, 119.87)
  ("village_42","Tref_Bran",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(6.31047,-78.2526),[],110),
  ("village_43","Tref_Arth",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(16.3987,-59.4645),[],120),                #c(9.33, 58.63)
  ("village_44","Tref_Erth",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-43.3383,-102.872),[],130),               #c(42.87, 89.89)
  ("village_45","Tref_Seniont",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-25.5082,-66.9855),[],170),             #c(37.85, 63.74)
  ("village_46","Tref_Sws",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-20.7288,-126.022),[],260),               #c(29.96, 112.05)
#Brycheiniog
#Glywyssing
  ("village_47","Tref_Ceincoed",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-30.0746,-164.4),[],90),           #c(45.93, 167.45)
  ("village_48","Tref_Went",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-17.1736,-142.211),[],180),
#Denmark
  ("village_49","Skyfa_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(254.962,-91.7596),[],10),
  ("village_50","Vebjorg_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(248.356,-43.2114),[],240),            #c(-259.63, 49.82)
  ("village_51","Huhelstath_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(236,-168.3),[],100),            #c(-229.8, 174.89)
  ("village_52","Heida_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(241.483,-200.11),[],110),
#Norwey
  ("village_53","Skiringssalr_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(218.59,101.741),[],120),
  ("village_54","Horda_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(209.706,194.353),[],130),               #c(-214.67, -214.77)
  ("village_55","Agdir_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(218.645,137.113),[],170),
  ("village_56","Rogaland_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(224.058,169.238),[],170),
#Kingdom of Isles
  ("village_57","Tref_Reghed",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-11.3177,64.5843),[],90),
  ("village_58","Bal_Baitte",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(78.1,217.7),[],170),
  ("village_59","Tref_Manaw",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-15.21,16.87),[],170),
  ("village_60","Bjarnaroy_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-2.87609,246.643),[],170),         #c(-34.18, -267.13)
  ("village_61","Orkneyjar_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(121.29,246.798),[],90),            #c(-135.99, -264.1)
  ("village_62","Veisa_By",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-108.921,-51.219),[],80),                #c(117.75, 58)
#Frisia
  ("village_63","Kennemer_Terp",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(179.754,-249.133),[],100),
  ("village_64","Vles_Inge_Terp",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(163.56,-270.925),[],100),
#Uladh
  ("village_65","Bal_Sebuirge",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-55.7124,91.8532),[],100),           #c(46.37, -101.9)
  ("village_66","Bal_Magh",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-43.9427,80.1401),[],100),
  ("village_67","Bal_Magh_Cobha",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-68.6736,41.913),[],100),
  ("village_68","Bal_Mor_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-44.131,60.3935),[],100),                 #c(49.3, -49.12)
#Aileach / Ui Neill north
  ("village_69","Bal_Clochair",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-76.427,90.8875),[],45),            #c(103.75, -86.86)
  ("village_70","Bal_Fearnmhaigh",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-103.718,58.752),[],100),
  ("village_71","Bal_Macha",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-62.4633,64.9163),[],240),
  ("village_72","Bal_Dumai",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-90.8242,69.3885),[],260),
#Ui Neill South / Meath
  ("village_73","Bal_Mor_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-118.115,45.0392),[],55),
  ("village_74","Bal_Eachadha",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-93.0759,39.1312),[],15),
  ("village_75","Bal_Breacain",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-94.4952,11.7913),[],10),
  ("village_76","Bal_Crannoc",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-107.79,34.7604),[],35),            #c(118.5, -12)
#Connachta
  ("village_77","Bal_Chomain",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-187.738,23.4392),[],160),           #c(161.99, -37.12)
  ("village_78","Bal_Luighne",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-153.893,111.609),[],180),
  ("village_79","Bal_Fiachrach_Aidne",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-168.24,70.1624),[],0),     #c(156.84, -49.8)
  ("village_80","Bal_Berchna",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-144.82,37.0321),[],40),
#Mumain
  ("village_81","Bal_Grian_Airbh",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-167.516,14.4463),[],20),        #c(150.67, -19.65)
  ("village_82","Bal_Les_Mor",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-148.521,-29.3121),[],90),             #c(145.61, 45.15)
  ("village_83","Bal_Ciarraighe_Luachra",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-195.53,-2.01987),[],55),
  ("village_84","Bal_Muscraighe",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-181.322,-39.5914),[],180),         #c(165.92, 53.2)
  ("village_85","Bal_Na_Mbarc",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-179.254,-21.5658),[],10),            #c(208.5, 34.09)
#Laigin
  ("village_86","Bal_Dara",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-110.845,-12.5992),[],35),                 #c(106.75, 7.85)
  ("village_87","Bal_Liamhain",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-82.2597,-10.4442),[],160),             #c(97.14, 9.71)
  ("village_88","Bal_Bolg",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-114.956,-34.8319),[],180),               #c(115.79, 24.53)
  ("village_89","Bal_Ros_Mhic_Treoin",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-98.4953,-40.1975),[],0),      #c(116.39, 46.33)
#Osrige
  ("village_90","Bal_Mairg_Laigen",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-123.369,-8.9965),[],40),
#Ui Neill Aileach TARA HILL
  ("village_91","Bal_Tara",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-101.75,1.16),[],20),                #c(104.49, -6.96)


  ("village_92","Cantwara_Ham_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(59.7325,-243.232),[],45),           #c(-69.35, 253.1) 
  ("village_93","Cantwara_Ham_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(56.5539,-260.188),[],55),           #c(-71.1, 249.1) 

  ("village_94","Cippan_Ham_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(6.38585,-184.414),[],15),              #c(15.8, 185.91)
  ("village_95","Cippan_Ham_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-22.3221,-188.889),[],10),              #c(19.8, 181.91)

  ("village_96","Eidyn_Ham_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(63.0707,81.0652),[],90),
  ("village_97","Eidyn_Ham_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(33.3328,97.3125),[],90),              #c(-40.75, -85.11)
  
  ("village_98","Ribe_By_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(230.231,-110.984),[],180),
  ("village_99","Ribe_By_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(245.502,-144.887),[],0),                #c(-237.24, 143.28)

  ("village_100","Tuns_By_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(270.837,100.816),[],20),              #c(-265.02, -99.52)
  ("village_101","Tuns_By_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(247.475,94.4952),[],80),              #c(-269.02, -95.52)

  ("village_102","Tref_Breatann_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(17.1521,89.149),[],55),            #c(-12.48, -110.01)
  ("village_103","Tref_Breatann_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(5.9,116.4),[],15),         #c(-16.48, -106.01)

  ("village_104","Dubh_Linn_By_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-78.3535,5.45916),[],10),             #c(84.48, 6.73)
  ("village_105","Dubh_Linn_By_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-90.9358,1.013),[],35),             #c(88.48, 2.73)
##
  ("village_106","Tref_Dyf_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-40.508,-155.603),[],160),               #c(53.97, 164.55)
  ("village_107","Tref_Dyf_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-57.1084,-153.14),[],180),              #c(57.97, 160.55)

  ("village_108","Eofer_Ham_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(76.837,-46.7006),[],0),                #c(-55.57, 47.05)
  ("village_109","Eofer_Ham_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(60.2449,-56.6963),[],45),              #c(-59.57, 43.05)

  ("village_110","Dore_Hem_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(211.594,-238.485),[],20),
  ("village_111","Dore_Hem_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(187.01,-260.428),[],60),

  ("village_112","Lunden_Ham_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(48.447,-198.463),[],55),            #c(-37.89, 210.74)
  ("village_113","Lunden_Ham_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(34.1324,-202.713),[],15),            #c(-41.89, 206.74)

  ("village_114","Tref_Mon_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-22.4416,-53.7553),[],10),                 #c(37.17, 46.99)
  ("village_115","Tref_Mon_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-36.016,-36.0531),[],35),                #c(41.17, 42.99)

  ("village_116","Dun_Ham_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(111.058,-176.877),[],160),
  ("village_117","Dun_Ham_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(91.7081,-195.384),[],180),              #c(-102.17, 199.51)

  ("village_118","Bal_Scuin_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(54.0271,127.373),[],0),             #c(-30.44, -127.26)
  ("village_119","Bal_Scuin_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(8.02343,134.798),[],40),            #c(-34.44, -123.26)
#
  ("village_120","Witan_Ham_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(27.8343,-216.849),[],20),              #c(0.01, 229.17) 
  ("village_121","Witan_Ham_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(8.99877,-236.999),[],60),              #c(4.01, 225.17) 

  ("village_122","Tref_Bosvenegh_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-81.2504,-183.498),[],55),
  ("village_123","Tref_Bosvenegh_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-93.2533,-175.675),[],15),

  ("village_124","Bal_Cainnighn_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-136.39,-30),[],10),
  ("village_125","Bal_Cainnighn_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-124.066,-42.9952),[],35),

  ("village_126","Bal_Rigmonaid_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(70.91,122.95),[],160),               #c(-7.96, -140.11)
  ("village_127","Bal_Rigmonaid_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(57.77,103.53),[],180),

  ("village_128","Bal_Celtair_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-35.75,46.65),[],0),             #c(36.94, -60.18)
  ("village_129","Bal_Celtair_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-56.7663,54.0824),[],20),            #c(40.94, -56.18)

  ("village_130","Bal_Maistiu_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-84.3619,-19.7548),[],60),             #c(100.14, 23.55)
  ("village_131","Bal_Maistiu_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-120.397,-18.4923),[],260),             #c(104.14, 19.55)

  ("village_132","Tref_Meguaidd_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-2.77583,-98.9646),[],15),           #c(20.97, 96.59)
  ("village_133","Tref_Meguaidd_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-24.3878,-79.0087),[],90),           #c(24.97, 92.59)

  ("village_134","Tom_Ham_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(34.29,-100.44),[],180),
  ("village_135","Tom_Ham_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(9.08753,-117.445),[],160),

  ("village_136","Bal_Caiseal_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-138.38,4.43),[],180),            #c(152.27, 6.47)
  ("village_137","Bal_Caiseal_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-166,0),[],180),             #c(156.27, 6.43)

  ("village_138","Bal_Aileach_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-63.9731,106.144),[],40),           #c(66.63, -108.54) 
  ("village_139","Bal_Aileach_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-105.483,110.806),[],20),           #c(70.63, -102.92) 
#
  ("village_140","Tref_Brycheiniog_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-38.9439,-133),[],60),       #c(47.36, 150.76)
  ("village_141","Tref_Brycheiniog_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-54.1004,-130.287),[],55),       #c(51.36, 146.76)

  ("village_142","Bebban_Ham_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(78.0011,32.819),[],15),
  ("village_143","Bebban_Ham_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(72.4225,4.503),[],10),             #c(-78.82, -13.98)

  ("village_144","Bal_Cruaghan_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-121.22,88.52),[],35),
  ("village_145","Bal_Cruaghan_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-154.406,80.0824),[],90),

  ("village_146","Bal_Temair_North",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-94.5681,24.5023),[],180),           #c(100.85, -12.64)
  ("village_147","Bal_Temair_South",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-112.80,4),[],45),              #c(104.85, -8.64)
  #cirrenceaster
  ("village_148","Cirren_Ham_East",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(7.67765,-175.956),[],180),
  ("village_149","Cirren_Ham_West",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-20.671,-165.569),[],45),
#village main quest
  ("village_150","Doccinga",  icon_village_a|pf_village, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(198.091,-218.998),[],45),

  ("salt_mine","Salt_Mine",icon_camp_basic|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(49.36,-9.24),[]),
##  ("iron_mine","Slieve Anierin",icon_village_a|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(70.01,22.69),[]),

  ("four_ways_inn","Four_Ways_Inn",icon_village_a|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-153.73,-337.10),[]), #hide lords in main quest
  ("test_scene","test_scene",icon_village_a|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(47.50,-20.57),[]),
##  ("test_scene","test_scene",icon_village_a|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(10.8, -19.6),[]),
  ("battlefields","battlefields",pf_disabled|icon_village_a|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(34.67,45.15),[]),
#plazas unicas chief
#ques principal
    ("frisa_beach","Friese Beach",icon_ship_on_land|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(205.894,-214.485),[]),
    ("farmland","Ulf's Farmstead",pf_disabled|icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(252.88,-76.22),[]),
    ("boar_grove","Boar Grove",pf_disabled|icon_sacred_forest|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(102.87,-183.02),[]),
    ("readingum","Readingum",pf_disabled|icon_camp_refuge|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(24.76,-211.39),[
        (trp_mercenary_arqueros, 1,2),(trp_taiga_bandit, 80,90),(trp_elite_viking, 30,40),(trp_sea_raider_leader2, 4,6),(trp_norse_standard_bearer, 3,5),(trp_todos_cuerno, 2,4),
        (trp_norse_level1_landed, 20,30),(trp_norse_level1_companion, 10,15),(trp_norse_level2_companion, 10,15),
        ]),
    ("aescesdun","Aescesdun",pf_disabled|icon_sacred_forest|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_kingdom_5,0,ai_bhvr_hold,0,(5.86,-206.64),[
        (trp_kingdom_5_lord, 1,0),(trp_knight_5_1, 1,0),(trp_knight_5_3, 1,0),(trp_knight_5_4, 1,0),(trp_knight_5_5, 1,0),(trp_knight_5_6, 1,0),(trp_knight_5_7, 1,0),(trp_knight_5_9, 1,0),(trp_knight_5_11, 1,0),
        (trp_saxon_level0_landed, 410,420),(trp_saxon_bowman, 190,200),(trp_saxon_level0_companion, 290,300),(trp_saxon_standard_bearer, 15,20),(trp_todos_cuerno, 4,6),
        (trp_saxon_level1_landed, 230,240),(trp_saxon_level2_landed, 190,200),(trp_saxon_horseman, 20,30),(trp_saxon_level3_landed, 15,20),
        (trp_saxon_level1_companion, 50,60),(trp_saxon_level2_companion, 30,40),
        ]),
###mega danish army
    ("mega_danishrmy"   ,"Great Summer Army",icon_warriors_10|pf_disabled|pf_is_static|pf_hide_defenders|pf_always_visible, no_menu, pt_none, fac_kingdom_8,0,0,0,(0, 0),[
        (trp_kingdom_8_lord, 1,0),(trp_knight_8_15, 1,0),(trp_knight_8_4, 1,0),(trp_knight_8_5, 1,0),(trp_knight_8_10, 1,0),(trp_knight_8_11, 1,0),(trp_knight_8_12, 1,0),(trp_knight_8_13, 1,0),(trp_knight_8_14, 1,0),
        (trp_norse_level0_landed, 300,310),(trp_norse_bowman, 190,200),(trp_norse_level0_companion, 250,260),(trp_norse_standard_bearer, 15,20),(trp_todos_cuerno, 4,6),
        (trp_norse_level1_landed, 180,190),(trp_norse_level2_landed, 140,150),(trp_norse_elitearcher, 50,60),(trp_norse_level3_landed, 15,20),
        (trp_norse_level1_companion, 80,90),(trp_norse_level2_companion, 50,60),
        ]),
#otras
    ("battle_stones","Stone Row",icon_sacred_forest|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-18.36,130.18),[]),
    ("farmland_special","Farmland",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(35.71,60.76),[]),
    ("roman_fort","Roman Fort",icon_camp_fortified|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-70.46,-193.20),[]),
    ("troll_bridge","The Troll's Bridge",icon_bridge_b|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(256.75,-115.72),[]),
    ("circle_mystic1","Mystic Circle",icon_sacred_forest|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-197.62,-9.95),[]),
    ("celidon_forest","Ancient_Stones",icon_sacred_forest|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-31.29,-70.48),[]),
    ("hidden_valley","Strange Ruins",icon_cave|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(47.50,-109.49),[]),
##quarries
    ("quarry1","Quarry",icon_camp_basic|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-135.46,-12.31),[]),
    ("quarry2","Quarry",icon_camp_basic|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(40.04,106.47),[]),
    ("quarry3","Quarry",icon_camp_basic|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(80.84,236.86),[]), #scotland
    ("quarry4","Quarry",icon_camp_basic|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-42.72,-115.49),[]),
###
    ("saltmine1","Salt Mine",icon_camp_basic|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(224.28,-266.37),[]), #frisa
    ("saltmine2","Salt Mine",icon_camp_basic|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(37.12,-259.59),[]), #wessex
    ("saltmine3","Salt Mine",icon_camp_basic|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(34.44,-109.36),[]), #mercia
    ("saltmine4","Salt Mine",icon_camp_basic|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(39.63,-21.49),[]), #nort
###
    ("lumbercamp1","Lumber Camp",icon_woodcutter_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(247.97,-103.64),[]), #denmark
    ("lumbercamp2","Lumber Camp",icon_woodcutter_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(210.19,130.73),[]), #norway
    ("lumbercamp3","Lumber Camp",icon_woodcutter_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(52.90,172.63),[]), #Scotland
    ("lumbercamp4","Lumber Camp",icon_woodcutter_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-106.82,47.95),[]), #Ireland
###
    ("farmsteadsp1","Farmstead",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(201.61,-272.42),[]), #frisa
    ("farmsteadsp2","Farmstead",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(259.86,-224.29),[]), #denmark
    ("farmsteadsp3","Farmstead",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(238.48,88.58),[]), #Norway
    ("farmsteadsp4","Farmstead",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(7.93,125.97),[]), #Scotland
    ("farmsteadsp5","Farmstead",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(60.39,-5.10),[]), #North
    ("farmsteadsp6","Farmstead",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-71.27,-118.85),[]), #wales
    ("farmsteadsp7","Farmstead",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-77.84,-165.71),[]), #Wessex
    ("farmsteadsp8","Farmstead",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-156.01,-24.20),[]), #Ireland
    ("farmsteadsp9","Farmstead",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-85.47,95.80),[]), #Ireland
###
    ("hadrian_wall1","Hadrian's Wall",icon_farmstead_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(54.16,33.88),[]),
    ("bjorn_camp","Bjorn's Camp",pf_disabled|icon_camp_fortified|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(38.2,-121.05),[]), #mainquest-27.27,126.24
    ("snotingaham_siege","Snotingaham under Siege",pf_disabled|icon_snotingaham_siege|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(27.27,-126.24),[],15), #no used, delete
#
    ("odin_cave","Odin's Cave",icon_cave|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(216.22,220.94),[]), #chief usa para mainquest
###battlefiends unicos

    ("stonemonumento","Monument of Stones",pf_disabled|icon_sacred_forest|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(8.26,-141.93),[]),

    ("forestbattle","Forest Battle",pf_disabled|icon_woodcutter_sp|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(218.509,-250.265),[]), #used for Thiaderd mainquest chief, no cambiar la posicion, se puede modificar scene solamente
    ("the_thing","The Assembly",pf_disabled|icon_sacred_forest|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(231.33,-135.22),[]), #the thing mainquest chief
#plazas unicas chief acaba
  
  ("dhorak_keep","Dhorak_Keep",icon_fort1|pf_disabled|pf_is_static|pf_always_visible|pf_no_label|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(340.81,-321.49),[]), #hide lords in mainquest

  ("training_ground","Training_Ground",  pf_disabled|icon_training_ground|pf_hide_defenders|pf_is_static|pf_always_visible, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-168.97,68.35),[]),

  ("training_ground_1","Training_Field",  pf_disabled|icon_training_ground|pf_hide_defenders|pf_is_static|pf_always_visible|pf_label_medium, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-95.16,31.58),[],100), 
  ("training_ground_2","Training_Village",  pf_disabled|icon_training_ground|pf_hide_defenders|pf_is_static|pf_always_visible|pf_label_medium, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-68.09,-135.65),[],100), 
  ("training_ground_3","Training_Field",  pf_disabled|icon_training_ground|pf_disabled|pf_hide_defenders|pf_is_static|pf_always_visible|pf_label_medium, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-131.76,28.41),[],100), #chief quitada
  ("training_ground_4","Training_Lake",  pf_disabled|icon_training_ground|pf_hide_defenders|pf_is_static|pf_always_visible|pf_label_medium, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(32.83,-235.41),[],100), 
  ("training_ground_5","Training_Camp",  pf_disabled|icon_training_ground|pf_hide_defenders|pf_is_static|pf_always_visible|pf_label_medium, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(42.75,151.74),[],100), 

###monasterios religion 
    ("monasterio1","Ad Candidam Casam",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(10.03,36.57),[]),
    ("monasterio2","Willibrord",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(207.177,-224.979),[]), #cerca doccinga, quest mainquest
    ("monasterio3","Dommoc",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(106.09,-190.52),[]),
    ("monasterio4","Lindisfarne",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(77.6948,8.28892),[]),
    ("monasterio5","Aporcrosan",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(32.76,216.79),[]),
    ("monasterio6","Petrus",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(81.03,142.33),[]),
    ("monasterio7","Apurnethige",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(44.79,116.4),[]),
    ("monasterio8","Llanteulyddog",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-63.55,-136.54),[]),
    ("monasterio9","Ynys_Enlli",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-48.42,-61.26),[]),
    ("monasterio10","Eveshomme",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-0.19,-121.29),[]),
    ("monasterio11","Inderawuda",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(84.51,-85.15),[]),
    ("monasterio12","Hagustaldes",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(75.61,44.63),[]),
    ("monasterio13","Briudun",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(18.64,-113.71),[]),
    ("monasterio14","Gudlac",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(83.78,-115.91),[]),
    ("monasterio15","Wochingas",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(13.03,-212.38),[]),
    ("monasterio16","Clofesho",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(20.83,-154.77),[]),
    ("monasterio17","Waerburh",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(46.52,-235.99),[]),
    ("monasterio18","Derhurst",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-19.85,-150.94),[]), 
    ("monasterio19","Ythan",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(53.64,-215.72),[]),
    ("monasterio20","Petrockstow",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-90.79,-199.71),[]), 
    ("monasterio21","Medeshamstede",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(64.29,-135.79),[]),
    ("monasterio22","Cocheham",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(26.77,-194.27),[]),
  #ireland
    ("monasterio23","Patricius",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-121.48,80.36),[]),
    ("monasterio24","Daire_Calgaich",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-64.71,91.83),[]),
    ("monasterio25","Finian",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-88.64,32.77),[]),
    ("monasterio26","Raithean",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-131.11,10.31),[]),
    ("monasterio27","Carthach",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-126.12,-51.72),[]),
    ("monasterio28","Scelic_Mhichi",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-214.34,15.09),[]),
    ("monasterio29","Gleann_Da_Loch",icon_monastery|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-88.58,-24.03),[]),
### lair begin chief
#sven lair puede ser para player tb
  #  ("sven_lair","Sven's Lair",icon_village_snow_deserted_a|pf_disabled|pf_is_static|pf_always_visible, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-245.14,156.91),[]),
#normal lair
      ("yourlair","My Refuge",icon_camp_refuge|pf_disabled|pf_is_static|pf_always_visible|pf_label_medium, no_menu, pt_none, fac_player_faction,0,ai_bhvr_hold,0,(1, 1),[]),
### lair end
###party quest
    ("thiaderd_lair","Thiaderd's Hideout",icon_camp|pf_disabled|pf_is_static|pf_always_visible|pf_label_large|pf_hide_defenders,no_menu, pt_none,fac_neutral,0,ai_bhvr_hold,0,(217.509,-249.265),[]),#chief cambiado icono
###places destroyed for player in mainquest. Plazas destruidas chief
     ("destroy1","Thiaderd's Hideout, Destroyed",icon_village_burnt_a|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(218.509,-250.265),[]),
     ("destroy2","Sven's Lair, Destroyed",icon_village_burnt_a|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(245.14,-156.91),[]),
     ("destroy3","Aescesdun Battlefield",icon_village_burnt_a|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(5.86,-206.64),[]),
###followers camp party  
  ("followers_camp","Followers Camp",pf_disabled, no_menu, pt_none, fac_commoners,0,ai_bhvr_hold,0,(0,0),[]),
###
###LG world map
  ("map_txt_laithlind","{!}1",icon_map_txt_laithlind|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(80.530000, 274.340000),[], 180),
("map_txt_alban","{!}1",icon_map_txt_alban|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(110.830000, 117.790000),[], 180),
("map_txt_altclut","{!}1",icon_map_txt_altclut|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-15.510000, 70.810000),[], 180),
("map_txt_norphymbra_1","{!}1",icon_map_txt_norphymbra_1|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(104.630000, -10.920000),[], 180),
("map_txt_norphymbra_2","{!}1",icon_map_txt_norphymbra_2|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-0.080000, -11.860000),[], 180),
("map_txt_gwynedd_1","{!}1",icon_map_txt_gwynedd_1|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-70.090000, -87.820000),[], 180),
("map_txt_gwynedd_2","{!}1",icon_map_txt_gwynedd_2|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-88.410000, -138.360000),[], 180),
("map_txt_corniu_1","{!}1",icon_map_txt_corniu_1|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,( -122.800000, -171.350000),[], 180),
("map_txt_corniu_2","{!}1",icon_map_txt_corniu_2|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-122.500000, -225.290000),[], 180),
("map_txt_wessex","{!}1",icon_map_txt_wessex|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(13.940000, -265.660000),[], 180),
("map_txt_eastengla","{!}1",icon_map_txt_eastengla|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(120.970000, -180.840000),[], 180),
("map_txt_mearce","{!}1",icon_map_txt_mearce|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(97.250000, -121.410000),[], 180),

("map_txt_aileach","{!}1",icon_map_txt_aileach|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-84.040000, 137.760000),[], 180),
 ("map_txt_connachta","{!}1",icon_map_txt_connachta|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-189.750000, 62.440000),[], 180),
("map_txt_meath","{!}1",icon_map_txt_meath|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-55.700000, 15.790000),[], 180),
("map_txt_laigin","{!}1",icon_map_txt_laigin|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-88.600000, -46.120000),[], 180),
("map_txt_mumain","{!}1",icon_map_txt_mumain|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-181.770000, -64.160000),[], 180),

("map_txt_noregr","{!}1",icon_map_txt_noregr|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(215.480000, 86.040000),[], 180),
("map_txt_danmork","{!}1",icon_map_txt_danmork|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(210, -110),[], 180),
("map_txt_frisa","{!}1",icon_map_txt_frisa|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(159.460000, -246.90000),[], 180),

####################

#  bridge_a
  ("Bridge_1","{!}1",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(201.882,-255.541),[],115),
  ("Bridge_2","{!}2",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(42.46,-139.82),[],64),
  ("Bridge_3","{!}3",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(184.306,-254.812),[],-5), 
  ("Bridge_4","{!}4",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(8.02,-195.33),[],90), #coords (112.83, -31.95)
  ("Bridge_5","{!}5",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(26.19,105.33),[],135), #coords (102.69, -69.6)
  ("Bridge_6","{!}6",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-101.99,31.98),[],120), #coords (116.54, 11.15)
  ("Bridge_7","{!}7",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-57.97,74.19),[],75), #coords (55.79, -91.77)
  ("Bridge_8","{!}8",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-62.47,96.70),[],55), #coords (75.8, -105.96)
  ("Bridge_9","{!}9",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-49.2492,42.7896),[],90), # new bridge in ireland
  ("Bridge_10","{!}10",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(68.62,40.45),[],35), #coords (-72.25, -42.85)
  ("Bridge_11","{!}11",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(57.55,-69.62),[],90),
  ("Bridge_12","{!}12",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(36.74,-163.93),[],135), #coords (-35.6, 161.58)
  ("Bridge_13","{!}13",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-24.54,-147.49),[],90), #coords (26.27, 154.76)
  ("Bridge_14","{!}14",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(62,-120.70),[],75), #coords (-145.19, 143.25)
  ("Bridge_15","{!}15",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(187.344,-246.97),[],-5),
  ("Bridge_16","{!}16",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-116.76,-25.08),[],35), 
  ("Bridge_17","{!}17",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-151.08,26.08),[],15), 

# Ferry
  ("ferry_1a","ferry station",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_label_small, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(192.821,-230.485),[],135),	#Frisia Ferry
  ("ferry_2a","ferry station",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_label_small, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(-34.1533,-50.1474),[],45),	#Ynys Mon Ferry
  ("ferry_3a","ferry station",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_label_small, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(87.1332,-141.915),[],0),	# The wash ferry
  ("ferry_4a","ferry station",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_label_small, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(-59.5044,-169.832),[],135), #Caer Dyf Ferry
  
  ("ferry_1b","ferry station",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_label_small, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(190.432,-233.639),[],135),
  ("ferry_2b","ferry station",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_label_small, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(-35.3514,-48.2534),[],45),
  ("ferry_3b","ferry station",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_label_small, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(85.2706,-135.084),[],0),
  ("ferry_4b","ferry station",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_label_small, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(-52.7444,-166.696),[],135),
  
  ("jetty_1","{!}jetty_1",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(-14.7232,7.25985),[],0),
  ("jetty_2","{!}jetty_2",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(33.9512,258.293),[],0),
  ("jetty_3","{!}jetty_3",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(140.528,256.663),[],0),
  ("jetty_4","{!}jetty_4",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(126.369,152.207),[], 90),
  ("jetty_5","{!}jetty_5",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(204.316,207.516),[], 90),
  ("jetty_6","{!}jetty_6",icon_ferry|pf_is_static|pf_always_visible|pf_hide_defenders|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold, 0,(200.314,171.968),[], 90),

#Begin Indexed Bandits
  ("wales_spawn_point"   ,"the coast",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(-49,-102),[(trp_taiga_bandit,15,0)]),
  ("fortiu_spawn_point"   ,"the coast",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(107,167),[(trp_steppe_bandit,15,0)]),
  ("sussex_spawn_point"   ,"South Seaxe",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(32,-235),[(trp_mountain_bandit,15,0)]),
  ("clyde_coast_spawn_point"  ,"the river",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(29,71),[(trp_steppe_bandit,15,0)]),
  ("limerick_spawn_point"   ,"the coast",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(-155,24),[(trp_taiga_bandit,15,0)]),
  ("norway_spawn_point"  ,"the mountains",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(241,132),[(trp_desert_bandit,15,0)]),
  ("northumbria_spawn_point"  ,"the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(65,24),[(trp_brigand,15,0)]),
  ("mierce_spawn_point"  ,"the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(44,-113),[(trp_brigand,15,0)]),
  ("crafu_spawn_point","the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(46,-57),[(trp_bandit,15,0)]),	#SSW of York
  ("alban_spawn_point","the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(25,188),[(trp_bandit,15,0)]),	#W Scotland
  ("aileach_spawn_point"   ,"the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(-72,94),[(trp_mountain_bandit,15,0)]),
  ("engla_coast_spawn_point"   ,"the coast",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(111,-158),[(trp_taiga_bandit,15,0)]),
  ("cornish_coast_spawn_point"   ,"the coast",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(-86,-197),[(trp_taiga_bandit,15,0)]),
  ("leinster_spawn_point"  ,"the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(-102,-29),[(trp_desert_bandit,15,0)]),
#sp of new bandits
  ("frisia_spawn_point"  ,"the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(203,-259),[(trp_mountain_bandit,15,0)]),
  ("denmark_spawn_point"  ,"the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(253.284,-200),[(trp_brigand,15,0)]),
#END OF LAIRED BANDITS
  ("caitness_priest_spawn_point"   ,"the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(71,222),[(trp_norse_priest,15,0)]),	#laithlind
  ("northumbria_priest_spawn_point"   ,"the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(66,14),[(trp_norse_priest,15,0)]),
  ("norway_priest_spawn_point"   ,"the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(201.22,139.82),[(trp_norse_priest,15,0)]),	#Odin's Hof
  ("denmark_priest_spawn_point"   ,"the countryside",pf_disabled|pf_is_static, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(270,-77.4),[(trp_norse_priest,15,0)]),	#Thor's Hof
#END OF LAND SPAWNS
#puesto chief spam point 3 sea pirates
  ("channel_spawn_point"   ,"the channel",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(-59,-250),[(trp_looter,15,0)]),	#English Channel
  ("bight_spawn_point"   ,"the Southern Bight",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(150,-204),[(trp_looter,15,0)]), #frankish #usamos esto cuando player back Douar
  ("irish_sea_spawn_point"   ,"the Irish Sea",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(-62,-21),[(trp_looter,15,0)]),	#S Irish Sea
  ("forth_firth_spawn_point"   ,"the Firth of Forth",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(105, 84),[(trp_looter,15,0)]),	#off Forth of Firth
  ("skagerrak_spawn_point"   ,"the Skagerrak",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(213,49),[(trp_looter,15,0)]),	#tip of Norway
  ("firth_clyde_spawn_point"   ,"the Firth of Clyde",pf_disabled|pf_is_static, no_menu, pt_none, fac_outlaws,0,ai_bhvr_hold,0,(-16,78),[(trp_looter,15,0)]),	#N Irish Sea
#END spawned parties with AI
### PHAIAK chief begin (
 ("testing_spawn_point"   ,"{!}the sea",pf_disabled|pf_is_static, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(17.6, -95),[(trp_looter,1,0)]),
 ("landing_point"   ,"landing point",icon_landing_point|pf_is_static|pf_no_label|pf_hide_defenders|pf_always_visible, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(0., 0),[]),
 ("landing_point2"   ,"{!}landing point2",icon_landing_point|pf_disabled|pf_is_static|pf_no_label|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(0., 0),[]),
 ("the_fleet"   ,"The Fleet",icon_ships_7|pf_disabled|pf_is_static|pf_is_ship|pf_hide_defenders|pf_always_visible, no_menu, pt_none, fac_neutral,0,0,0,(0., 0),[(trp_elite_viking, 2000,0)]),
 ("transporter"   ,"Transporter",icon_ships_2|pf_is_ship|pf_disabled|pf_hide_defenders|pf_always_visible, no_menu, pt_none, fac_neutral,0,0,0,(0,0),[(trp_regular_sailors, 5,0)]),
 ("troop_camp_1"   ,"Troop Quarters",icon_camp|pf_is_static|pf_disabled|pf_always_visible, no_menu, pt_none, fac_player_supporters_faction,0,0,0,(0,0),[]),
 ("troop_camp_2"   ,"Troop Quarters",icon_camp|pf_is_static|pf_disabled|pf_always_visible, no_menu, pt_none, fac_player_supporters_faction,0,0,0,(0,0),[]),
### ) PHAIAK end
 # add extra towns before this point 
  ("spawn_points_end"                  ,"{!}last_spawn_point",    pf_disabled|pf_is_static, no_menu, pt_none, fac_commoners,0,ai_bhvr_hold,0,(0., 0),[(trp_looter,15,0)]),
  ###Pagan Holy Sites
    ("paganholysites1","Odin's Hof",icon_sacred_forest|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(201.22,139.82),[]), #norwey
    ("paganholysites2","Thor's Hof",icon_sacred_forest|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(270,-77.4),[]), #denmark
###Add-ons story
    ("oldpagan_hut","Old Pagan's Hut",icon_farmstead_sp|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-147.45,107.77),[]), #hut ireland
    ("morrigan_lair","Morrigan's Lair",icon_cave|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-163.12,105.21),[]), #morrigan's lair ireland
    ("bresail_farm","Mael Bresail's Farm",icon_farmstead_sp|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-109.81,23.78),[]), #bresail's farm ireland
    ("bresail_fort","Mael Bresail's Fort",icon_camp_fortified|pf_disabled|pf_is_static|pf_always_visible|pf_hide_defenders, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-72.28,-176.54),[]), #bresail's farm ireland
### 
  ("reserved_1"                  ,"{!}last_spawn_point",    pf_disabled|pf_is_static, no_menu, pt_none, fac_commoners,0,ai_bhvr_hold,0,(0., 0),[(trp_looter,15,0)]),
  
  #VC-2898 (missing bridge)
  ("Bridge_18","{!}18",icon_bridge_a|pf_is_static|pf_always_visible|pf_no_label, no_menu, pt_none, fac_neutral,0,ai_bhvr_hold,0,(-96.5,71),[],90),

]
