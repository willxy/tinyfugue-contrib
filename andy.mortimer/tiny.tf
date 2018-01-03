; $Id: tiny.tf,v 1.2 1996/11/20 18:41:55 asm21 Exp asm21 $

;;; by Andy Mortimer

/~loaded tiny.tf

;; Implement some fancy highlights etc for TinyMUSH worlds. Assumes them to have a world type of tiny.mush or a subtype
;; thereof.

;; All macros defined herein have the prefix `tiny_'

;;; ========== redefine hilite_page so it does all the TinyMUSH ones
;;; and also hilites when you page somebody else.

; note that the hilite for From afar, has priority three so it doesn'y
; conflict with some of the other hilites below.

; note also that these are NOT tiny.mush specific

/edit -i hilite_page	= \
  /def -Fip2ah -mglob -t'{*} pages from *[,:] *' ~hilite_page1%;\
  /def -Fip2ah -mglob -t'You sense that {*} is looking for you in *' ~hilite_page2%;\
  /def -Fip2ah -mglob -t'The message was: *' ~hilite_page3%;\
  /def -Fip2ah -mglob -t'{*} pages[,:] *' ~hilite_page4%;\
  /def -Fip2ah -mglob -t'In a page-pose*' ~hilite_page5%;\
  /def -Fip3ah -mglob -t'From afar,*' ~hilite_page6%;\
  /def -Fip2ah -mglob -t'Long distance to*' ~hilite_page7%;\
  /def -Fip2ah -mglob -t'You paged*' ~hilite_page8

;;; ========== Do cool things with help etc
;; automatically get all pages of help text
/def -T(tiny\.mush(\..*)?) -i -ag -mregexp -t'^{ \'([@A-Za-z0-9_ ]+)\' for more }' tiny_helpmore=%{P1}

;;; ========== Some hilites for various TinyMUSH (and generic!) things

; dbrefs and flags
/def -T(tiny\.mush(\..*)?) -i -p1 -P0Cred -mregexp -F -t'#[0-9]+' tiny_dbrefnum
/def -T(tiny\.mush(\..*)?) -i -p1 -P0BCred -mregexp -F -t'#-1' tiny_dbreferr
/def -T(tiny\.mush(\..*)?) -i -p1 -P1Cblue -mregexp -F -t'#[0-9]+([A-Za-z\$+&@]+( \[[^]]+\])?)' tiny_dbrefflag

; attributes in `examine;' other headings, esp in help
/def -T(tiny\.mush(\..*)?) -i -p1 -P1Cwhite -mregexp -F -t'^([ ]*[^;()# ]+)(\\(#[0-9]+\\))?:.*' tiny_heads

; meta-syntactic variables in help etc
/def -T(tiny\.mush(\..*)?) -i -p1 -P0Cyellow -mregexp -F -t'<[A-Za-z0-9-]+>' tiny_vars

; @-commands
/def -T(tiny\.mush(\..*)?) -i -p1 -P0Cwhite -mregexp -F -t'@[A-Za-z_]+' tiny_atcomm
; functions
/def -T(tiny\.mush(\..*)?) -i -p1 -P1Cwhite -mregexp -F -t'([A-Za-z_/]+)\\([^#]' tiny_func

;; major headings in the help file
; note that we need to test for these being the /first/ word on the line, so we can't glob. :(
; Topic:/Function:/Command:/Flag:
/def -T(tiny\.mush(\..*)?) -i -p1 -aB -mregexp -F -t'^[ ]*([Cc]ommand|[Ff]unction|[Tt]opic|[Ff]lag):' tiny_head1
; Config Parameter (wizard)
/def -T(tiny\.mush(\..*)?) -i -p1 -aB -mregexp -F -t'^[ ]*([Cc]onfig [Pp]arameter):' tiny_head2
; `see also:' or `see:'
;/def -T(tiny\.mush(\..*)?) -i -p1 -aB -mregexp -F -t'^[ ]*[Ss]ee( [Aa]lso)?:' tiny_seealso

;; for 'look' etc
/def -T(tiny\.mush(\..*)?) -i -p1 -P1B -F -t'^(.*)\\(#[0-9]+R.*\\)' tiny_room=/eval /set _room_${world_name}=%P1
/def -T{tiny.mush|tiny.mush.*} -i -p1 -aB -mglob -F -t'{Obvious exits:}*' tiny_exits
/def -T{tiny.mush|tiny.mush.*} -i -p1 -aB -mglob -F -t'{Contents:}*' tiny_contents

;; %-substitutions
; names, prepositions, etc
/def -T(tiny\.mush(\..*)?) -i -p1 -P0Cgreen -mregexp -F -t'%[SsOoPpAaNn]' tiny_pc1
; special characters
/def -T(tiny\.mush(\..*)?) -i -p1 -P0Cblue -mregexp -F -t'%[rtb%]' tiny_pc2
; registers
/def -T(tiny\.mush(\..*)?) -i -p1 -P0Cyellow -mregexp -F -t'%([0-9]|v[a-z]|q[0-9])' tiny_pc3
; stack registers
/def -T(tiny\.mush(\..*)?) -i -p1 -P0B -mregexp -F -t'%[0-9]' tiny_pc4
; misc (dbrefs, last command)
/def -T(tiny\.mush(\..*)?) -i -p1 -P0Ccyan -mregexp -F -t'%[#l!c]' tiny_pc5

; lines, on mail messages etc
/def -T(tiny\.mush(\..*)?) -i -p1 -P0Cwhite -mregexp -F -t'---(-)*|___(_)*' tiny_lines

; Any text ended by a `>' and a space --- esp. PernMUSH +watches
/def -T(tiny\.mush(\..*)?) -i -p1 -P0Cred -mregexp -F -t'^[A-Za-z0-9# _-]*>[ 	]' tiny_watches

; `From xxxx, blah' but not including `From afar'
/def -T{tiny.mush|tiny.mush.*} -i -p2 -mglob -t'From afar,*' tiny_fromovr
/def -T(tiny\.mush(\..*)?) -i -p1 -P1Cred -mregexp -F -t'^(From [^,]*),' tiny_from

; some random-but-important text
/def -T(tiny\.mush(\..*)?) -i -p1 -P0BCwhite -mregexp -F -t'\\*UNLOCKED\\*' tiny_unlocked

; when we change to a tiny world, print the name of the current room, if known.
/if (usetinyworldform =~ "yes") \
  /def -ag -hWORLD -T{tiny.mush|tiny.mush.*} -mglob tiny_roomworld=\
	/eval /echo -a%{tinyworldattr} -- ---- World ${world_name} (%%{_room_${world_name}}) ----%; \
/endif

; automatically expand flags given after dbrefs, if %tinyflags=on, or use uppercase (%tinyflags=uc) or lowercase
; (%tinyflags=lc)

; NB This is probably rather hacky; improvements welcome!

/if (tinyflags =~ "") \
  /echo % Flag expansion turned on for tiny.mush worlds. Use /set tinyflags=off to remove.%;\
  /echo % Setting it to something (`off', `on', `uc' or `lc') before loading tiny.tf will supress this message.%;\
  /set tinyflags=on%;\
/endif

/set tinyflagdefs=AAbode BBuilder CChown_OK DDark EExit FFloating GGoing HHaven IInherit JJump_OK KKey LLink_OK MMonitor \
                  NNoSpoof OOpaque PPlayer QQuiet RRoom SSticky TTrace UUnfindable VVisual WWizard XStop YParent_OK ZZone \
		  aAudible cConnected dDestroy_OK eEnter_OK hHalted iImmortal lLight mMyopic pPuppet qTerse rRobot sSafe \
		  tTransparent vVerbose xSlave zControl_OK \
		  $Commands +Has_Startup &Has_Forwardlist @Has_Listen

/def -i -T(tiny\.mush(\..*)?) -p99 -mregexp -t'(#[0-9]+)([A-Za-z$+&@]+)' -F tiny_expandflags = \
  /if (tolower(tinyflags) =~ "on" | tolower(tinyflags) =~ "lc" | tolower(tinyflags) =~ "uc") \
    /let bef=%{PL}%{P1}%; \
    /let flags=%{P2}%; \
    /let after=%{PR}%; \
    /let dollar=$$%; \
    /let defs= \
      $(/for i 0 strlen\(flags\)-1 \
        /let fn=$$[substr\(flags,i,1\)]%%; \
;       some of the characters have special meanings inside regexps
        /if \( fn =~ dollar \) /let fn=$$[strcat\("\\\\",dollar\)]%%; /endif%%; \
        /if \( fn =~ "+" \) /let fn=\\\\+%%; /endif%%; \
        /test regmatch\(strcat\("\(^| \)",fn,'\([A-Za-z0-9_]*\)'\),tinyflagdefs\)%%; \
        /echo %%{P2-??}%%;)%; \
    /let defs= [$[substr(defs,1)]]%; \
    /if (tolower(tinyflags) =~ "lc") /let defs=$[tolower(defs)]%; /endif%; \
    /if (tolower(tinyflags) =~ "uc") /let defs=$[toupper(defs)]%; /endif%; \
    /substitute %{bef}%{flags}%{defs}%{after}%; \
  /endif
