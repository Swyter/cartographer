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
  ("main'_party","Main Party",icon_player|pf_limit_members, no_menu, pt_none,fac_player_faction,0,ai_bhvr_hold,0,(32.08,-69.56),[(trp_player,1,0)]),
    ("mega_danishrmy"   ,"Great Summer Army",icon_warriors_10|pf_disabled|pf_is_static|pf_hide_defenders|pf_always_visible, no_menu, pt_none, fac_kingdom_8,0,0,0,(0, 0),[
        (trp_kingdom_8_lord, 1,0),(trp_knight_8_15, 1,0),(trp_knight_8_4, 1,0),(trp_knight_8_5, 1,0),(trp_knight_8_10, 1,0),(trp_knight_8_11, 1,0),(trp_knight_8_12, 1,0),(trp_knight_8_13, 1,0),(trp_knight_8_14, 1,0),
        (trp_norse_level0_landed, 300,310),(trp_norse_bowman, 190,200),(trp_norse_level0_companion, 250,260),(trp_norse_standard_bearer, 15,20),(trp_todos_cuerno, 4,6),
        (trp_norse_level1_landed, 180,190),(trp_norse_level2_landed, 140,150),(trp_norse_elitearcher, 50,60),(trp_norse_level3_landed, 15,20),
        (trp_norse_level1_companion, 80,90),(trp_norse_level2_companion, 50,60),
        ]),
] 
