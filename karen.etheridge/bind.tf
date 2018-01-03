
; use this to return to old up/down behaviour (with dokey_up)
;/require -q updown.tf

/loaded bind.tf

; full instead of half page.
;/def dokey_pgdn = /dokey_page
;/def dokey_pgup = /dokey_pageback
/def key_pgdn = /dokey_page
/def key_pgup = /dokey_pageback

; for easy scrolling in windows.
/def -i -b'^F' = /key_pgdn
/def -i -b'^B' = /key_pgup

; when input window is empty, use arrows to scroll up/down and switch worlds
/def -i key_up = \
  /if (kblen()) \
    /@test kbgoto(kbpoint() - wrapsize * (kbnum?:1)) %;\
  /else \
    /dokey lineback %;\
  /endif

/def -i key_down = \
  /if (kblen()) \
    /@test kbgoto(kbpoint() + wrapsize * (kbnum?:1)) %;\
  /else \
    /dokey line %;\
  /endif

/def -i key_left = \
  /if (kblen()) \
    /dokey left %;\
  /else \
    /bind_esc_y %;\
  /endif

/def -i key_right = \
  /if (kblen()) \
    /dokey right %;\
  /else \
    /to_active_or_prev_world %;\
  /endif



; new kbpush
/def -i key_esc_down = /kb_push_new

; Jump to bottom of read lines
/def -i -b'^[G' bind_esc_bigg = /test morescroll(moresize("l") - moresize("ln"))

; Marvin wants a way of searching forward/backwards for a string.
; esc-/, esc-? - take the kb and scroll upwards to the previous match
; kbhead kbpoint kbtail


; Go to previous world.
/def -i -b'^[y' bind_esc_y=\
  /while (prev_worlds !~ "") \
    /if /fg -s $(/dequeue prev_worlds) %; /then /return 1%; /endif%;\
  /done

; Speech shortcuts.
;/def -i -B'F2' bind_f2=\
/def -i key_f2=\
  "(automatic binding) Sorry, my hands are hurting.  I will provide more \
  information later.
/: "

;/def -i -B'F4' bind_f4=\
/def -i key_f4=\
  "(automatic binding) Please elaborate, be more specific, etc.
/: "


/def -i key_f10=\
  spoof ## says, "HAW HAW HAW"


; redraw screen
;/def -i -b'^[r' bind_esc_r=/recall -q -g /$[(lines() - (visual ? isize+1 : 0))]

; Evaluate what's in the input buffer
/def -i -b'^[^J' bind_esc_lf=/sub full %; /dokey newline %; /sub off
/def -i -b'^[^M' bind_esc_cr=/bind_esc_lf

; Evaluate what's in the input buffer, and return the result to there.
/def -i -b'^[g' bind_esc_g=\
  /let x=$[strcat(kbhead(),kbtail())] %;\
  /recordline -i /eval /grab $$(%x) %;\
  /grab $(/eval %x)

; Cause input string to be echoed with a prefix.
/def -i -b'^[l' bind_esc_l=\
  /set kprefix=%; /test kprefix := "Input: " %;\
  /test recordline(strcat("-w ", kprefix,  kbhead(), kbtail())) %;\
  /set kecho=on %; /dokey newline %; /set kecho=off


;;; REMOVED!
; swap esc-j and esc-J.
; /def -i -b'^[j' newflush=/dokey selflush %; /recall /10
;/def -i -b'^[J' newselflush=/dokey flush %; /recall /10


; unquell, send, quell again.
/def -i -b'^[q^J' bind_esc_q_lf=\
  /def -1 -w${world_name} -aGg -t'Flag reset.' %;\
  /def -1 -w${world_name} -aGg -t'Flag set.' %;\
  @set me = !Q %; /dokey newline %; @set me = Q

/def -i -b'^[q^M' bind_esc_q_cr=/bind_esc_q_lf

; fake spoof (change name, pose, change back)
/def -i -b'^[e^J' bind_esc_e_lf=\
  /let x=$[strcat(kbhead(),kbtail())] %;\
  /let x=$(/car %x) :$(/cdr %x) %;\
  /fake %x %;\
  /recordline -i /fake %x %;\
  /test grab("")

/def -i -b'^[e^M' bind_esc_e_cr=/bind_esc_e_lf

/def -i -b'^[k^J' bind_esc_k_lf=\
  /let x=$[strcat(kbhead(),kbtail())] %;\
  /let x=$(/car %x) kill $(/cdr %x)=100 %;\
  /fake %x %;\
  /recordline -i /fake %x %;\
  /test grab("")

/def -i -b'^[k^M' bind_esc_k_cr=/bind_esc_k_lf

;/def -i -b'^[w' bind_esc_w=\
;  /if (active_worlds !~ "") \
;    /let world=$(/car %active_worlds) %;\
;    /if (nactive(world) > 100) \
;      /echo % Dequeuing %{world}: $[nactive(world)] \
;        lines waiting. %;\
;    /else \
;      /to_active_or_prev_world %;\
;    /endif %;\
;  /else \
;    /to_active_or_prev_world %;\
;  /endif

; Skip worlds with >100 lines but keep in %active_worlds.
; deprecated in tf5 - we don't care if we fg heavy-scrollback worlds.
;/def -i -b'^[w' bind_esc_w=\
;  /let i=0 %; /let num=$(/length %active_worlds) %;\
;  /while (++i <= num) \
;    /let world=$(/nth %i %active_worlds) %;\
;    /if (nactive(world) < 100) \
;      /fg %world %;\
;      /return 1 %;\
;    /endif %; /done %;\
;  /let i=0 %; /let num=$(/length %prev_worlds) %;\
;  /while (++i <= num) \
;    /let world=$(/nth %i %prev_worlds) %;\
;    /if (nactive(world) < 100) \
;      /if /fg -s %world %; /then /return 1 %; /endif %;\
;    /endif %; /done




; Control characters
/def -b'^S'=/echo You give storm some hot loving!



