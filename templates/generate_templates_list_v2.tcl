#!/bin/tclsh

# Template autogeneration for Plumed 2.  This file will generate (on
# stdout) "templates_list_v2_autogen.tcl" file.  The "unsubst" string
# contains a proc which returns a list, which defines the CURATED
# Templates menu to be used for Plumed 2. Right-hand sides can be
# specified manually (here), or contain %%XXXX placeholders that are
# expanded with the corresponding "plumed gentemplate" command.

# This script assumes that all of the actions have been expanded in
# templates_temp/* and templates_full/* . This is done by
# generate_templates.sh .



set unsubst {
package provide plumed 1.901
namespace eval ::Plumed {}

proc ::Plumed::templates_list_v2 { } {
    return {  
	"Group definition"		"grp:   GROUP ATOMS=[chain A and name CA]"
	"Center of mass"		"com:   COM   ATOMS=[chain A and name CA]"
	"Ghost atom"			"%%GHOST"
	- -
	"Distance"			"%%DISTANCE"
	"Angle"				"%%ANGLE"
	"Torsion"			"%%TORSION"
        "Radius of gyration"		"%%GYRATION"
	"Electric dipole"		"%%DIPOLE"
	"Coordination"			"%%COORDINATION"
	"Contact map"			"CONTACTMAP ATOMS1=1,2 ATOMS2=3,4 ... SWITCH=(RATIONAL R_0=1.5)"
	- -
	"RMSD from reference structure" "%%RMSD"
	"Amount of \u03b1-helical structure"        
	                                "%%ALPHARMSD"
        "Amount of parallel-\u03b2 structure"       
	                                "%%PARABETARMSD"
	"Amount of antiparallel-\u03b2 structure"   
	                                "%%ANTIBETARMSD"
	- -
	"Distances"                     "DISTANCES ATOMS1=3,5 ATOMS2=1,2 MIN={BETA=0.1}"
	"Coordination number"		"%%COORDINATIONNUMBER"
	- -
	"Path RMSD"			"%%PATHMSD"
	"Polynomial CV function"	"%%COMBINE"
	"Piecewise function"		"%%PIECEWISE"
	"Sort CV vector"		"%%SORT"
	"Distance in CV space"		"%%TARGET"
	- -
	"Restraint"			"%%RESTRAINT"
        "Moving restraint"		"%%MOVINGRESTRAINT"
	"Metadynamics"			"%%METAD"
	"External"			"%%EXTERNAL"
	"Adiabatic bias"		"%%ABMD"
	"Lower wall (allow higher)"	"%%LOWER_WALLS"
	"Upper wall (allow lower)"	"%%UPPER_WALLS"
	- -
	"Switch to VMD units"           "UNITS  LENGTH=A  ENERGY=kcal/mol  TIME=fs"
    }
}
}

#	"Contact map"			"%%CONTACTMAP"
#	"Distances"			"%%DISTANCES"


#        "Energy"              "%%ENERGY"
#	"Box volume"          "%%VOLUME"
#	"Density"             "%%DENSITY"
#	- -


# Replace all the %%'s
while {[regexp {%%([A-Z_]+)} $unsubst pkw kw]} {
    set fc [open templates_temp/$kw]
    set templ [string trim [gets $fc]]
    close $fc
#    puts stderr [format "%20s --> %s" $kw $templ]
    set unsubst [regsub $pkw $unsubst $templ]
}

# ----------------------------------------
# Part 1: the menu

puts "# AUTOGENERATED! DO NOT EDIT! on [exec date]"
puts "$unsubst"

# ----------------------------------------
# Part 2: popup to insert "short" template

# Generate keyword-help hashes for ALL keywords
puts "namespace eval ::Plumed {"
puts "  variable template_keyword_hash"
puts "  array set template_keyword_hash {"
foreach fkw [glob templates_temp/*] {
    set kw [file tail $fkw]
    set fc [open $fkw]
    set templ [string trim [gets $fc]]
    close $fc
    # Hack to remove spaces in <some selection>
    set templ [string map { " selection>" _selection> } $templ]
    puts "  {$kw} {$templ}"
}
puts "  }"
puts "}"


# ----------------------------------------
# Part 3: popup to insert full template keywords

puts "namespace eval ::Plumed {"
puts "  variable template_full_hash"
puts "  array set template_full_hash {"
foreach fkw [glob templates_full/*] {
    set kw [file tail $fkw]
    set fc [open $fkw]
    set templ [string trim [gets $fc]]
    close $fc
    # Hack to remove spaces in <some selection>
    set templ [string map { " selection>" _selection> } $templ]
    puts "  {$kw} {$templ}"
}
puts "  }"
puts "}"


