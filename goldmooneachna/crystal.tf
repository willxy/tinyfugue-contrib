;;;
;;;         CrystalMUSH stuff (last updated 01-11-03)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;
;;; If you're using this file and you're *not* Gwen Morse, you'll want to
;;; either name your Singer world 'ss', OR, edit the file and replace all
;;; instances of -w'ss' to be -w'<Singer worldname>' for your singer character.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Minor handy triggers/highlites

;handy sled highlights (green/red/yellow)
/def -i -F -w'ss' -p2 -abBCgreen -t'*the {scanner|autopilot} light shows green*' scanner_green

/def -i -F -w'ss' -p2 -aBCyellow -t'* You see no traces of a paintmark*' scanner_yellow
/def -i -F -w'ss' -p2 -aBCred -t'A red light flashes on the console *' scanner_red
/def -i -w'ss' -p10 -aBCyellow -t'You sense this vein is almost empty.' hl_claim

;;; Shepherd Macro
;;; '/shep <name>' <name=name of Sheep> :)
/def shep = \
/send @pemit %#=Don't forget to +mail Lydander and Samira about the Shepherd contract. %;\
/send :says with only the slightest hint of the native Taal'en trill, "Rrecording on." After a slight pause, she continues "Ssudia Chok'toth. Entering shepherd contract with [name(num(*%*))] in accordance with Section 53, paragraphs 1-5. Singer [name(num(*%*))] is aware of the fact that [subj(num(*%*))] is entitled to nothing that may be cut under Singer Chok'toth's direction and guidance. Singer [name(num(*%*))] is entitled to remain at Singer Chok'toth's claim or claims for at least two working days. " %;\
/send :says "Singer [name(num(*%*))] will never attempt to return to said claims under Section 49, paragraphs 7, 9, and 14. I, Ssudia Chok'toth, affirm and avow to provide instruction for at least two days to this singer, as specified, above and beyond any bonus I may receive." She takes a breath and then motions %* to her side, "[name(num(*%*))], do you also affirm and avow, under strict penalties imposed by the Heptite Guild that you will adhere to the strictures of the relevant sections and paragraphs cited herein?" %;\

; Start Autopilot flying
/def -F -w'ss' -t'Course set.  To invoke, do a *' autopilot_on = \
   /send -w autopilot on

; recharge lamp (in Equipment room)
/def -F -w'ss' lamp = \
     /send display lamps %;\
     /send +buy vendor=2 %;\
     /send recharge lamp %;\

; scanner quickies
; '/scanner on' or '/scanner off'
/def -F -w'ss' scanner = \
      /if ({*}=~"off")\
         /send stabilizer off %;\
         /send erase scan map %;\
         /send deactivate scan map %;\
      /elseif ({*}=~"on")\
         /send erase scan map %;\
         /send activate scan map %;\
      /else \
      /endif

; Fill Radiant Tub
/def -F -w'ss' -t'Ssudia Suite -- Amethyst Level*' fill_tub = \
   /send -w fill bath with fluid
/def -F -w'ss' -t'You may enter the peach bath now.' enter_tub = \
   /send -w enter bath

;;; Grab a special order chit as it comes out.
/def -F -w'ss' -t'You hear a low clattering in the terminal*' order_chit = \
   /send -w'ss' take chit %;\

/def -F -w'ss' -aBCred -t'You hear the clattering of the terminal*' order_chit2 = \
   /send -w'ss' take chit %;\

;;; Type '/pack <identifier>' where <identifier> is a way to identify the crystal 
;;; (dbref, shape, size, color, etc), and you will manually "get" it and "pack" it 
;;; (if you have a carton).

/def -i -F -w'ss' pack = \
/send -w'ss' get %* %;\
/send -w'ss' give carton=%*

;;; Speeds up unpack commands
;;; usage: "/unpack <carton #>"

/def -i -F -w'ss' unpack = \
/send -w'ss' drop carton %* - Ssudia %;\
/send -w'ss' unpack carton %* - Ssudia %;\

;;; CrystalMUSH auto-pack crystals 
;;; (after cutting a crystal, you automatically "get" it and "pack" it if you have a carton)

/def -w'ss' -F -mregexp -t"^The crystal is ([A-Za-z]+( [A-Za-z]+)?) in size and is" pack2 = \
   /send -w'ss' get %{P1} %;\
   /send -w'ss' give carton=%{P1}

;;; Handy little macro that unloads a sled for you and unpacks each carton in Cargo Storage.
/def -i -F -w'ss' unload = \
    /quote -w'ss' -5 `/unload_string %;\
/def -F unload_string = \
/send out %;\
/send processing %;\
/send drop carton %;\
/send unpack carton %;\
/send out %;\
/send enter ssudia's sled

;;; Handy little macro that sends <name> carton to Cargo storage while in front of a CS Conveyer.
;;; '/cargo <carton name>'
/def -F -w'ss' cargo = \
/send -w'ss' send %* to cargo conveyor %;\

;;; CrystalMUSH auto-remove carton
;;; By Gwen Morse (goldmooneachna at yahoo dot com)
;;; This looks to see if you're dropping a carton into your sled. If so, it will remove the
;;; next carton by number and have you pick it up. Very handy when emptying claims. Less handy if
;;; you don't WANT another carton :).

/def -w'ss' -F -mregexp -t"^Carton ([0-9]) - Ssudia is loaded in to the sled." carton_loaded = \
  /set carton_count=$[{P1}+1] %;\
  /if (carton_count<=8) \
  /send -w'ss' remove carton %;\
  /send -w'ss' take carton %{carton_count} %;\
  /else \
  /endif

;;; CrystalMUSH Vein emits
;;; Written by Gwen Morse (goldmooneachna at yahoo dot com)
;;; matches based on specific leading strings and highlights/beeps to show there's a vein in the room.
;;; Also calls 'vein stats' so that you can know if you spotted the vein, or, found another Singer's discard.
;;; (I always want to know this because I keep track of all claims and whether I set the color)

/def -i -F -T'tiny.cm' -p55 -abBCmagenta -mregexp -E'!regmatch("(glint|Flickers|flicker|glimmer|flash|gleam) of (light|crystal) (blue|green|rose|amethyst|black|white|yellow|that)", {*})' \
  -t"(glint|Flickers|flicker|glimmer|flash|gleam) of (light|crystal)" cm_vein = \
      /send vein stats

/def -i -F -T'tiny.cm' -p55 -abBCmagenta -mregexp -t"(this must be the place|there is a vein close by|the symbiont pinches right behind|sweet pull of crystal|hair on your arm stands straight up)" cm_vein2 = \
   /send vein stats

/def -i -F -T'tiny.cm' -p55 -abBCmagenta -mregexp -t"(something about this spot|symbiont is telling you that crystal|Pleasant shivers go up and down your spine|Crystal must be near)" cm_vein3 = \
   /send vein stats

/def -i -F -T'tiny.cm' -p55 -abBCmagenta -mregexp -t"(musical vibration rings with your footsteps|crystal song sings softly in your ear)" cm_vein4 = \
   /send vein stats

;;; For that claim with the limestone rocks (Tai'achi or whatever the Singer's name was)
;;; '/knock'
/def -w'ss' -F knock = \
knock %; knock %; knock %;\
count %; count %; count %; count %; count %;\
knock %; knock %; knock %;\

; CrystalMUSH Cutter Overheat emits
/def -i -F -T'tiny.cm' -p55 -abBCyellow -mregexp -t"^(You smell something beginning to overheat|The cutter abruptly powers down|The cutter housing feels warm to the touch|The cutter emits a low whine during the cut)" cm_overheat

; CrystalMUSH Cutter Powerdown emits
/def -i -F -T'tiny.cm' -p55 -abBCred -mregexp -t"^(The cutter's tone seems uncertain, like it's running low on power|The cutter groans and fails to hold the note)" cm_powerdown

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Flying Script Find Unstaked Claims! (VERY VERY VERY useful)
;;;
;;; based on a basic SimpleMU trigger written by Kahlyla at CM (turn the sled at every "F* *E" point).  
;;; Adapted to tf by Gwen Morse using fall-thru triggers and reacting to configured options via FLYSET.
;;;
;;; Start out on any row by flying the sled in an east or west direction.
;;; When it comes across the "F" row on the East side of the map, it will automatically shift the sled 
;;; down by 1 rank and start flying east.
;;;
;;; This automates overflying the entire flying grid once the sled has been started. It can
;;; be stopped at will by stopping the sled and/or undefining the macro.
;;; 
;;; If you fly over a claim that isn't staked, it will do one of the configured options, 
;;; including stopping the sled (so you can search) or adding those coordinates to the "location"
;;; list in the sled (if you have autopilot installed) and the date the coordinates were added, 
;;; ignoring the location, etc. The location list option allows you to return at will to check if 
;;; the location is still unclaimed and then circle to find the landing zone at another time.
;;;
;;; CAUTION: This script will treat JPF/White Sands/the Met Station as regular unstaked claims.


;;; Set this to have it default to 'stop the sled at unstaked claims'. 
;;; You may want to choose your own default

/set FLYSET=stop

;;; The autofly macro

/def -qFp50 -w'ss' -t'Loc: F* * *E Heading: *' ss_autofly = \
      /send heading 24 %;\
      /send speed 10 %;\
      /def -qFp54 -n1 -w'ss' -t'Loc: F* * *E Heading: *' ss_autofly2 = \
           /send heading 0 %;\
      /def -qp52 -n1 -w'ss' -t'Loc: F* * *E Heading: *' ss_autofly3 = \
           /send speed 26 %;\

/def -F -w'ss' -p10 -t'*You see no traces of a paintmark.' ss_autofly_notrace = \
      /if ({FLYSET}=~"add") \
           /send add location here=LZ needed $[ftime("%m/%d/%Y", time())] %;\
      /elseif ({FLYSET}=~"stop") /send stop %;\
      /elseif ({FLYSET}=~"off") /set NULL=null %;\
      /endif

;;; Configuration macro for the autofly. ("/fly" will list quick help)

/def -iq -w'ss' fly = \
  /if ({*}=~"undef") \
    /undef ss_autofly %;\
    /undef ss_autofly2 %;\
    /undef ss_autofly3 %;\
    /_echo TFRC: /fly has forced the autofly macro to completely undefine (will not trigger on the "F" East rows). %;\
    /set FLYSET=off %;\
  /elseif ({*}=~"off") \
    /set FLYSET=off %;\
    /_echo TFRC: /fly has forced the autofly macro to stop watching for unstaked claims (but, it still triggers on the "F" East rows). %;\
  /elseif ({*}=~"stop") \
    /set FLYSET=stop %;\
    /_echo TFRC: /fly will force the autofly macro to stop the sled at unstaked claims. %;\
  /elseif ({*}=~"add") \
    /set FLYSET=add %;\
    /_echo TFRC: /fly will force the autofly macro to add unstaked claims to your location list and continue flying. %;\
  /elseif ({*}=~"redef") \
    /_echo TFRC: /fly has forced the autofly macro to redefine with the default setting of searching and stopping at unstaked claims. %;\
    /set FLYSET=stop %;\
            /def -qFp50 -w'ss' -t'Loc: F* * *E Heading: *' ss_autofly =\
                   /send heading 24 %%;\
                   /send speed 10 %%;\
            /def -qFp54 -n1 -w'ss' -t'Loc: F* * *E Heading: *' ss_autofly2 =\
                   /send heading 0 %%;\
            /def -qp52 -n1 -w'ss' -t'Loc: F* * *E Heading: *' ss_autofly3 =\
                   /send speed 26 %%;\
    /_echo %;\
  /else \
    /_echo %;\
    /set FLYSET %;\
    /_echo %;\
    /_echo TFRC: Try '/fly undef' to completely undefine the autofly macro. %;\
    /_echo TFRC: Try '/fly redef' to redefine after undefining the autofly macro. %;\
    /_echo TFRC: Try '/fly off' to shut off the autofly macro watching for unstaked claims (but, it still triggers on the "F" East rows). %;\
    /_echo TFRC: Try '/fly add' to cause the autofly macro to add unstaked claims to your location list. %;\
    /_echo TFRC: Try '/fly stop' when you would like the autofly macro to stop the sled at unstaked claims. %;\
    /_echo %;\
  /endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Headings (to fly in a particular direction)
;;;
;;; Using Keypad for directions (type keypad # and then 'enter')
;;;
;;; Original author lost, but, grabbed off a site with Battletech or
;;; other 'mech-type' macros.

;;;;;;;;;;;;;;;;;;;;;
;;  Keypad macros  ;;
;;  NW    N     NE ;;
;;   \    |    /   ;;
;;    7---8---9    ;;
;;    |   |   |    ;;
;;W-- 4---5---6 --E;;
;;    |   |   |    ;;
;;    1---2---3    ;;
;;   /    |    \   ;;
;;  SW    S     SW ;;
;;                 ;;
;;    5 to stop    ;;
;;;;;;;;;;;;;;;;;;;;;

/def -w'ss' -i -mregexp -h'SEND ^1$' cm_head_sw = heading 20
/def -w'ss' -i -mregexp -h'SEND ^2$' cm_head_s  = heading 24
/def -w'ss' -i -mregexp -h'SEND ^3$' cm_head_se = heading 28
/def -w'ss' -i -mregexp -h'SEND ^4$' cm_head_w  = heading 16
/def -w'ss' -i -mregexp -h'SEND ^5$' cm_head_5  = stop
/def -w'ss' -i -mregexp -h'SEND ^6$' cm_head_e  = heading 0
/def -w'ss' -i -mregexp -h'SEND ^7$' cm_head_nw = heading 12
/def -w'ss' -i -mregexp -h'SEND ^8$' cm_head_n  = heading 8
/def -w'ss' -i -mregexp -h'SEND ^9$' cm_head_ne = heading 4

;;; The remaining flight macros are mine (Gwen Morse)

/def -F -w'ss' -p7 e = \
   /send heading 0

/def -F -w'ss' -p7 n = \
   /send heading 8

/def -F -w'ss' -p7 w = \
   /send heading 16

/def -F -w'ss' -p7 s = \
   /send heading 24

/def -F -w'ss' -p7 ne = \
   /send heading 4

/def -F -w'ss' -p7 nw = \
   /send heading 12

/def -F -w'ss' -p7 sw = \
   /send heading 20

/def -F -w'ss' -p7 se = \
   /send heading 28

;;; Stop (to stop the sled)

/def -F -w'ss' -p7 stop = \
   /send stop

;;; Move (to start flying again)

/def -F -w'ss' -p7 speed = \
   /if ({#} > 0) \
      /send speed %* %;\
   /else \
      /send speed 1 %;\
   /endif

;;; Level (to level the nose of the sled)

/def -F -w'ss' -p7 level = \
   /send level

;;; Cut Macro (this cut macro is still a "work in progress")
;;; by Gwen Morse (goldmooneachna at yahoo dot com)
;;; The evential goal is to be able to cut groupings.
;;; DOES NOT WORK YET!!!

;;; Needs the Virtual Array and /note macros below!
;;; I repeat: DOES NOT WORK YET!!!

/set size=vs
/set shape=rec

/def cut = \
    /quote -w${world_name} -10 `/%{1} %;\

/def five-chord =\
/note do %;\
/echo -w'ss' cut %{shape} size=%{size} %;\
/note mi %;\
/echo -w'ss' cut %{shape} size=%{size} %;\
/note la %;\
/echo -w'ss' cut %{shape} size=%{size} %;\
/note dx %;\
/echo -w'ss' cut %{shape} size=%{size} %;\
/note ti %;\
/echo -w'ss' cut %{shape} size=%{size} %;\


;;; The following Virtual array is needed to make later macros function
;;; Please do not remove unless you don't want to automate cutting in claims.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Virtual Array 
;;;
;;; Originally submitted to the Tinyfugue mailing list by Galvin <kairo at mediaone dot net>
;;; Modfied by Michael Hunger <mh14 at inf.tu-dresden dot de>
;;; Possibly modified by other members of the Tinyfugue mailing list.
;;;
;;; NOTES FROM GALVIN:
;;;
;;; You may store anything to be abbreviated in these lists, e.g. weapons,
;;; friends, npcs, scores etc.
;;;
;;; If you use text not containing other characters than letters, numbers and _
;;; you may also use this as an simple key-value hash list
;;; e.g. /set_array weapon s1 sword_with_a_very_long_id
;;;
;;; /def wield = /get_array weapon %1%;wield %?
;;;
;;; Usage:
;;; instead of: wield sword_with_a_very_long_id
;;; just use: /wield s1
;;;
;;; Some Examples:
;;; /test put_array('test_array', 1, 367382)
;;; /test put_array('test_array', 2, 'a string')
;;; /test echo(get_array('test_array', 1))
;;; /test echo(get_array('test_array', 2))
;;; 
;;; You should see 367382 and a string echoed to your screen.
;;; 
;;; Passing an array to a function
;;; 
;;; /def function_array = \
;;; /test array1 := get_array({*}, 1) %;\
;;; /test array2 := get_array({*}, 2) %;\
;;; /test echo(strcat(array1, ':', array2))
;;; 
;;; /test function_array('test_array')
;;; 
;;; What I wrote here was just some stuff off the top of my head real quick.  Hope it helps.
;;; Oh and /listarray is a real good debuging tool, I use this as well. SO /listarray test_array should return:
;;; test_array[1]:=367382
;;; test_array[2]:=a string
;;; test_array[3]:=
;;;
;;; /listarray only lists up till a blank entry, I thought about using entry 0 as the # of elements but decided that some people may want to start arrays from 0 and not 1.
;;;
;;; Some get_array_count examples:
;
; /test put_array('halloween', 1, 'skeleton')
; /test put_array('halloween', 2, 'owls')
; /test put_array('halloween, 3, 'boo!')
; 
; /test echo(get_array_count('halloween', 1))
; returns 3
; /test echo(get_array_count('halloween', 2))
; returns 2
; 
; /test put_2array('double', 1, 1 , 'hmm')
; /test put_2array('double, 1, 2, 'burp!')
; /test put_2array('double, 1, 3, 'damn')
; /test echo(get_2array_count('double', 1, 1) 

;------------------------------------------------------------------------
;Get array / get 2array : A virtual array function to similate a real array
;usage:
;get_array("Array name here", I) & get_2array("array name", I, I2)
;example get_array("Dir_Array", 43) returns the 43rd element from "Dir_Stack"
;
;------------------------------------------------------------------------
/def get_array = \
 /return _%1_array_%2

/def get_2array = \
 /return _%1_array_%2_%3

;------------------------------------------------------------------------
;PUT array / put 2array: A virtual array function to similate a real array
;usage:
;put_array("Array name here", I, st) & put_2array("array name", I, I2, st)
;example put_array("Dir_Array", 43, "sw") puts "sw" at element 43 in
;"Dir_Array"
;------------------------------------------------------------------------
/def put_array = \
 /IF (strlen({3}) > 0) \
   /set _%1_array_%2=%3%;\
 /ELSE \
   /unset _%1_array_%2%;\
 /ENDIF%;\

/def put_2array = \
 /IF (strlen({4}) > 0) \
   /set _%1_array_%2_%3=%4%;\
 /ELSE \
   /unset _%1_array_%2_%3%;\
 /ENDIF%;\

;------------------------------------------------------------------------
;PURGE array : Purges a virtual array made by get_array & put_array
;usage:
;purge_array("Array name here")
;example purge_array("Dir_Array"), deletes the whole array from memory
;NOTE: Purge array starts from element 0
;NOTE: this can also purge double dimensioned arrays too.
;------------------------------------------------------------------------
/def purge_array = \
 /quote -S /unset `/listvar -s _%1_array_*

;--------------------------------------------------------------------------
;listarray / list2array
;USAGE:
;/listarray array_name <num> & /list2array array_name <num> <num2>
;Will list the whole array of array_name starting from element <num>
;/list2array only lists the second dimension from <start>
;--------------------------------------------------------------------------
/def listarray = \
 /test LA_Count := %2 - 1%;\
 /test LA_Element := " "%;\
 /while (strlen(LA_Element) > 0) \
   /test ++LA_Count%;\
   /test LA_Element := get_array({1}, LA_Count)%;\
   /test echo(strcat({1}, "[", LA_Count, "]:=", LA_Element))%;\
 /DONE

/def list2array = \
 /test LA2_Count := -1%;\
 /test LA2_Element := " "%;\
 /while (LA2_Count < 255) \
   /test ++LA2_Count%;\
   /test LA2_Element := get_2array({1}, {2}, LA2_Count)%;\
   /IF (strlen(LA2_Element) > 0) \
     /test echo(strcat({1}, "[", {2}, "][", LA2_Count, "]:=", LA2_Element))%;\
   /ENDIF%;\
 /DONE
;--------------------------------------------------------------------------
;GET array count / GET 2array count
; Written by: Ian Leisk who may actually be "Galvin", but, may not (kairo at attbi dot com)!
;usage:
;get_array_count("Array name here", start)
;get_2array_count("Array name here", index, start)
;
;NOTE:
;These will count the number of elements starting at "start" till the first
;empty element.
;Get_array2_count will count the number of elements starting at index
;from "start"
;--------------------------------------------------------------------------

/def get_array_count = \
  /test GA_Name := {1} %;\
  /test GA_Count := {2} - 1 %;\
  /test GA_Element := " " %;\
  /while (strlen(GA_Element) > 0) \
    /test ++GA_Count %;\
    /test GA_Element := get_array(GA_Name, GA_Count) %;\
  /DONE %;\
  /return GA_Count - 1

/def get_2array_count = \
  /test GA2_Name := {1} %;\
  /test GA2_Index := {2} %;\
  /test GA2_Count := {3} -1 %;\
  /test GA2_Element := " " %;\
  /while (strlen(GA2_Element) > 0) \
     /test ++GA2_Count %;\
     /test GA2_Element := get_2array(GA2_Name, GA2_Index, GA2_Count) %;\
  /DONE %;\
  /return GA2_Count - 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Automated Cutter Note package (assembled by Gwen Morse) 
;;;
;;; How this works...
;;; Needs: the Array Lists of Octave Scales (below)
;;; Also Needs: the VEINSCALE global variable macro (below)
;;; Also Needs: The Virtual Array macro package by Galvin, and Michael Hunger (above)

;;; Type '/note <note>' (where <note> is do, re, mi, fa, la, so, ti, dx).
;;; This will set the cutter to the appropriate note, based on the scale of the vein
;;; you're presently in. This saves "book-keeping" in that you don't have to keep track
;;; of these settings for each octave scale. 
;;; If you want to set it manually to a specific note, /note will still accept the standard
;;; A-G [sharp/flat] options as well.

;;; /note by Phil.Pennock (Phil Pennock at globnix dot org) and Gwen Morse 
;;; (goldmooneachna at yahoo dot com). Debugging help from David Moore.
;;; You can use the existing array macros unmodified if you use the scale name as
;;; the name of the array.

/def -w'ss' note = \
  /if ({*} =/ "{do|re|mi|fa|la|so|ti|dx}") \
       /get_array %{VEINSCALE} %1 %;\
       /let note=%? %;\
       /_echo %;/send -w'ss' pose tunes a "%1" note. %;\
       /send -w'ss' set cutter to %{note} %;\
       /send -w'ss' sing %{note} %;\
  /else \
       /send -w'ss' set cutter to %* %;\
       /send -w'ss' sing %* %;\
  /endif

;;; Array list of octave scales
;;; Written by Gwen Morse (goldmooneachna at yahoo dot com)
;;; Only one octave scale for each note is provided. I only wanted to have one for each. 
;;; Some are major, some are minor (I chose based on my personal preference). This means that
;;; the scales may not be (as) useful if you're trying to maximize cuts between multiple veins of the same shade/color.
;;; But, it really can't be beat if you're just considering each vein separately.

/put_array A do A
/put_array A re B
/put_array A mi C
/put_array A fa D
/put_array A so E
/put_array A la F
/put_array A ti G
/put_array A dx A

/put_array B do B
/put_array B re Cs
/put_array B mi D
/put_array B fa E
/put_array B so Fs
/put_array B la G
/put_array B ti A
/put_array B dx B

/put_array C do C
/put_array C re D
/put_array C mi E
/put_array C fa F
/put_array C so G
/put_array C la A
/put_array C ti B
/put_array C dx C

/put_array D do D
/put_array D re E
/put_array D mi F
/put_array D fa G
/put_array D so A
/put_array D la As
/put_array D ti C
/put_array D dx D

/put_array E do E
/put_array E re Fs
/put_array E mi G
/put_array E fa A
/put_array E so B
/put_array E la C
/put_array E ti D
/put_array E dx E

/put_array F do F
/put_array F re G
/put_array F mi A
/put_array F fa As
/put_array F so C
/put_array F la D
/put_array F ti E
/put_array F dx F

/put_array G do G
/put_array G re A
/put_array G mi B
/put_array G fa C
/put_array G so D
/put_array G la E
/put_array G ti Fs
/put_array G dx G

/put_array As do As
/put_array As re C
/put_array As mi D
/put_array As fa Ds
/put_array As so F
/put_array As la G
/put_array As ti A
/put_array As dx As

/put_array Bs do C
/put_array Bs re D
/put_array Bs mi E
/put_array Bs fa F
/put_array Bs so G
/put_array Bs la A
/put_array Bs ti B
/put_array Bs dx C

/put_array Cs do Cs
/put_array Cs re Ds
/put_array Cs mi E
/put_array Cs fa Fs
/put_array Cs so Gs
/put_array Cs la A
/put_array Cs ti B
/put_array Cs dx Cs

/put_array Ds do Ds
/put_array Ds re F
/put_array Ds mi G
/put_array Ds fa Gs
/put_array Ds so As
/put_array Ds la C
/put_array Ds ti D
/put_array Ds dx Ds

/put_array Es do F
/put_array Es re G
/put_array Es mi A
/put_array Es fa As
/put_array Es so C
/put_array Es la D
/put_array Es ti E
/put_array Es dx F

/put_array Fs do Fs
/put_array Fs re Gs
/put_array Fs mi A
/put_array Fs fa B
/put_array Fs so Cs
/put_array Fs la D
/put_array Fs ti E
/put_array Fs dx Fs

/put_array Gs do Gs
/put_array Gs re As
/put_array Gs mi C
/put_array Gs fa Cs
/put_array Gs so Ds
/put_array Gs la F
/put_array Gs ti G
/put_array Gs dx Gs

/put_array Ab do Af
/put_array Ab re Bf
/put_array Ab mi C
/put_array Ab fa Df
/put_array Ab so Ef
/put_array Ab la F
/put_array Ab ti G
/put_array Ab dx Af

/put_array Bb do Bf
/put_array Bb re C
/put_array Bb mi D
/put_array Bb fa Ef
/put_array Bb so F
/put_array Bb la G
/put_array Bb ti A
/put_array Bb dx Bf

/put_array Cb do B
/put_array Cb re Df
/put_array Cb mi D
/put_array Cb fa E
/put_array Cb so Gf
/put_array Cb la G
/put_array Cb ti A
/put_array Cb dx B

/put_array Db do Df
/put_array Db re Ef
/put_array Db mi E
/put_array Db fa Gf
/put_array Db so Af
/put_array Db la A
/put_array Db ti B
/put_array Db dx Df

/put_array Eb do Ef
/put_array Eb re F
/put_array Eb mi G
/put_array Eb fa Af
/put_array Eb so Bf
/put_array Eb la C
/put_array Eb ti D
/put_array Eb dx Ef

/put_array Fb do E
/put_array Fb re Gf
/put_array Fb mi G
/put_array Fb fa A
/put_array Fb so B
/put_array Fb la C
/put_array Fb ti D
/put_array Fb dx E

/put_array Gb do Gf
/put_array Gb re Af
/put_array Gb mi A
/put_array Gb fa B
/put_array Gb so Df
/put_array Gb la D
/put_array Gb ti E
/put_array Gb dx Gf

; VEINSCALE Global Variable Macro

;;; Written by Gwen Morse (goldmooneachna at yahoo dot com)

;;; This works with the octave array code above. Grabs the scale of the vein that you've last 'looked' at.
;;; This sets the scale of the vein in the global {VEINSCALE} variable.

/def -w'ss' -F -mregexp -t"The vein subtly sings to you in a scale of ([A-Za-z]+( [A-Za-z]+)?)." vein_scale = \
  /if ({P1}=~"A flat") \
    /set VEINSCALE=Ab %;\
  /elseif ({P1}=~"B flat") \
    /set VEINSCALE=Bb %;\
  /elseif ({P1}=~"C flat") \
    /set VEINSCALE=Cb %;\
  /elseif ({P1}=~"D flat") \
    /set VEINSCALE=Db %;\
  /elseif ({P1}=~"E flat") \
    /set VEINSCALE=Eb %;\
  /elseif ({P1}=~"F flat") \
    /set VEINSCALE=Fb %;\
  /elseif ({P1}=~"G flat") \
    /set VEINSCALE=Gb %;\
  /elseif ({P1}=~"A sharp") \
    /set VEINSCALE=As %;\
  /elseif ({P1}=~"B sharp") \
    /set VEINSCALE=Bs %;\
  /elseif ({P1}=~"C sharp") \
    /set VEINSCALE=Cs %;\
  /elseif ({P1}=~"D sharp") \
    /set VEINSCALE=Ds %;\
  /elseif ({P1}=~"E sharp") \
    /set VEINSCALE=Es %;\
  /elseif ({P1}=~"F sharp") \
    /set VEINSCALE=Fs %;\
  /elseif ({P1}=~"G sharp") \
    /set VEINSCALE=Gs %;\
  /else \
    /set VEINSCALE=%P1 %;\
/endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
