
;; histories.tf - Save and load histories
;; by Karen Etheridge, com.tcp@ether reversed, 1998.
;; based on storehist.tf by David Moore (oj@egbt.org)
;; and feedback from Ken Keys (hawkeye@tcp.com)

;; Needs at least version 4.0a9. [Jun 12 2003: Still working out the tf5 kinks.]

;; Uses the directory hist/ in the current working directory (I use
;; ~/tf/hist, and '/cd tf' in .tfrc)

;; Also relies on some externally-defined macros, commented out at file end.

;; Known problems:
;; None in tf..
;; In tf5, may have to run each /load_history command manually due to a slight
;; thing I haven't tracked down yet.  Otherwise works well in tf5.

;; Compatibility:
;; /~load_history is stripping spaces in tf4; this works in tf5.
;; (can't remember what 4.0a9 added.)

;; Revision history:
;; 2003-06-13: do not save histories for null worlds (a new concept in tf5)
;; 2003-05-28: tf5 compatibility - /~load_history checks if the world exists.
;;             (/recordline no longer accepts undefined world names.)
;;             Not perfectly working under tf5 yet though.


;                        this one's a standard TF library
/require -q lisp.tf
;                        these are all mine: the relevant functions are
;                        also included (commented out) at the bottom of the
;                        file for the benefit of others.
/require -q commands.tf
/require -q database.tf
/require -q functions.tf

/loaded histories.tf

;; In this file:
;; /save_histories - save all global, input, world histories
;; /load_histories - restore all previously saved histories
;; /save_history - save a global, input, or world history
;; /load_history - load a global, input, or world history
;; /save_tftime - saves start time of TF: run in .tfrc after setting tftime
;; /save_histories_inc - saves all incremental history changes (run via timer)
;; /save_history_inc - save one world's incremental history changes



;; /save_ and /load_histories require a connect hook (commented out at bottom
;; of file) to set %all_worlds, and a hist/ directory.

;; Warning: loading histories into TF will result in any previously-existing
;; history lines of later timestamps to be lost/unreachable by /recall.
;; Therefore, load histories before opening any worlds.
;; There is a rumour that this will be fixed in tf5.


;; Full save (in a subdirectory)
; Usage: /save_histories
/def -i save_histories=\
  /echo % Saving all histories. %;\
  /let time=$[ftime("%Y%m%d%H%M%S", time())] %;\
  /quote -S !mkdir hist/%{time} %| /test %? %;\
  /test fwrite(strcat("hist/", time, "/", time, ".tftime"), tf_start_time) %;\
  /save_tftime %;\
  /save_history -i hist/%{time}/%{time}.i.hist %;\
  /def -i save_world_histories_=\
    /save_history -w%%{1} hist/%{time}/%{time}.%%{1}.hist %;\
  /mapcar /save_world_histories_ %{all_worlds} %;\
;  /save_history -g hist/%{time}/%{time}.g.hist %;\
  /undef save_world_histories_ %;\
  /echo % Done saving all histories. %;\
  /echo % To load histories: /load_histories %{time}

; Usage: /save_history [-lig] [-w<world>] <filename>
/def -i save_history = \
  /if ({#} > 2) /echo -e %0: Too many arguments. %; /break %; /endif %;\
  /let handle=$[tfopen({L1}, "a")]%; \
  /if (handle < 0) /return 0%; /endif%; \
  /echo % Saving to %L1. %;\
  /test tfflush(handle, "off") %;\
; 20060928: added "-ag "
  /quote -S /~save_history #-ag -t'%%@ -' %{-L1} 0- %;\
  /test tfflush(handle) %;\
  /test tfclose(handle)

/def -i ~save_history = /test tfwrite(handle, {*})


; Usage: /load_histories [time of archival]
/def -i load_histories=\
  /echo % Loading all histories. %;\
  /quote -S /load_history_ !ls hist/$[{1} ? "%{1}/%{1}." : ""]*.hist %;\
  /echo % Done loading all histories.

; /load_history_ <filename>
  /def -i load_history_=\
    /let filename=%; /test filename := {1} %;\
    /test regmatch("([^.]+)\\\\.hist$$", filename) %;\
    /let world=%; /test world := {P1} %;\
    /if (regmatch("^([gi]|\\(unnamed[0-9]+\\))$$", {world})) \
      /echo % Skipping %{world}. %;\
    /elseif (world =~ "l") \
      /load_history -%{world} %filename %;\
    /else \
      /load_history -w%{world} %filename %;\
    /endif


; Usage: /load_history [-lig] [-w<world>] <filename>
/def -i load_history = \
  /if ({#} > 2) /echo -e %0: Too many arguments. %; /break %; /endif %;\
  /if (!getopts("ligw:", "")) /return 0 %; /endif %; \
  /let world=%; /test world := opt_w %;\
  /let option=%;\
  /if (world !~ "") /let option=-w%opt_w %;\
  /elseif (opt_l) /test world := 'l' %; /let option=-l %;\
  /elseif (opt_i) /test world := 'i' %; /let option=-i %;\
  /elseif (opt_g) /test world := 'g' %; /let option=-g %; /endif %;\
  /let lines=$(/hs %option) %;\
  /let lines=$(/min %lines 100000) %;\
  /if (world =~ "") /echo -e %0: Missing world specifier %; /break %; /endif %;\
;  /if (world_info(world) =~ "") \
;    /echo -e %0: Undefined world %world %; /break %; /endif %;\
  /echo % Loading %world from %1. %;\
  /~load_history %option %lines %1 %;\
  /test DB_set("hist", world, rn({option}))

; I rewrote this so as to try and preserve leading/trailing spaces,
; but tf4.0's recordline() won't play along.  tf5 should fix this.
; Usage: /~load_history <-ligw..> <num lines> <filename>
;/def ~load_history= /recordline %{1} -t%{2} -- %{-2}
;/def -i ~load_history=/quote -S /recordline %1 -t!tail -%2 %3
/def -i ~load_history=\
  /let handle=$[tfopen(strcat("tail -", {2}, " ", {3}), "p")]%; \
  /if (handle < 0) /return 0%; /endif%; \
  /let line=%;\
  /while (tfread(handle, line) >= 0) \
    /test recordline(strcat({1}, " -t", line)) %;\
  /done %;\
  /test tfclose(handle)


; Assumes this is set at startup.
/def -i save_tftime=\
  /let time=$[ftime("%Y%m%d%H%M%S", time())] %;\
  /let handle=$[tfopen("hist/.tftime", "w")]%; \
  /if (handle < 0) /return 0%; /endif%; \
  /test tfwrite(handle, tf_start_time) %; /test tfclose(handle)


; Run this via a periodic timer that is started at startup.  I run mine
; every five minutes.
/def -i save_histories_inc=\
  /save_history_inc -i hist/master.i.hist %;\
  /mapcar /save_world_histories_inc_ %{all_worlds} %;\

; Run from the above function.  I also call this from a DISCONNECT hook.
/def -i save_world_histories_inc_=\
  /save_history_inc -w%{1} hist/master.%{1}.hist


; Usage: /save_history_inc [-lig] [-w<world>] <filename>
/def -i save_history_inc = \
  /if ({#} > 2) /echo -e %0: Too many arguments. %; /break %; /endif %;\
  /if (!getopts("ligw:", "")) /return 0 %; /endif %; \
  /let world=%; /test world := opt_w %;\
  /if (world !~ "") /let option=-w%opt_w %;\
  /elseif (opt_l) /test world := 'l' %; /let option=-l %;\
  /elseif (opt_i) /test world := 'i' %; /let option=-i %;\
  /elseif (opt_g) /test world := 'g' %; /let option=-g %; /endif %;\
  /if (world =~ "") /echo -e %0: Missing world specifier %; /break %; /endif %;\
  /let line=%; /test line := DB_get("hist", world) %;\
  /if (line =~ "") /test line := 0 %; /endif %;\
  /if (line == rn(option)) /return 0%; /endif %;\
  /let handle=$[tfopen({1}, "a")]%; \
  /if (handle < 0) /return 0%; /endif%; \
  /test tfflush(handle, "off") %;\
; 20060928: added "ag"
  /quote -S /~save_history #-ag -t'%%@ -' %option $[line+1]- %;\
;  /quote -S /~save_history #-t'%%@ -' %{-L1} $[line+1]- %;\
  /test tfflush(handle) %;\
  /test tfclose(handle) %;\
  /test DB_set("hist", world, rn(option))




;;;;; Else-file macros ;;;;;

;;; To retrieve the code in vi, highlight (visual mode) and type:
;;; :s/^;;//g

;;; Use this to set %all_worlds - we use it to know which worlds we've
;;; used in this session, so we can save all their histories
;;
;;; keep track of worlds we have histories for
;;; (don't track null worlds!)
;;/def -Fq -p2 -hCONNECT hook_connect_store_world=\
;;  /if (!fmember({1}, all_worlds) & ({1} !/ "(unnamed*)") & \
;;    world_info({1}, "host") !~ "") \
;;    /set all_worlds=%all_worlds %1 %; /endif
;;


;;; Returns the index of an item in a list, or 0 if not found.
;;; (same as lmember.  see also lmemberglob, lmemberreg)
;;/def -i member=\
;;  /let word=%{1} %; /let pos=0 %;\
;;  /while (shift(), {#}) \
;;    /test ++pos %;\
;;    /if (word =~ {1}) \
;;      /result %pos %; /endif %;\
;;  /done %;\
;;  /result 0
;;
;;/def -i fmember=/result $(/member %*)
;;


;;; DB_set and DB_get left as an exercise for the reader - anything that
;;; sets and gets variables of whatever name format you like should be
;;; sufficient.  I use a library that creates "arrays" of 1 or 2 dimensions.


;;; determine latest scrollback line number
;;/def -i rn=\
;;  /let line=$(/recall -ag %1 #/1) %;\
;;  /test regmatch("^([1-9][0-9]*):", line) %;\
;;  /result {P1}
;;

;;; functional version of /histsize (tf5 should deprecate this)
;;; returns default value if world does not exist.
;;; flags: -l -i -g -w<foo>
;;/def -i hs=\
;;  /if (!getopts("ligw:", "")) /return 0 %; /endif %; \
;;  /if (opt_l)  /let output=$(/histsize -l) %;\
;;  /elseif (opt_i)  /let output=$(/histsize -i) %;\
;;  /elseif (opt_g)  /let output=$(/histsize -g) %;\
;;  /elseif (opt_w !~ "" & world_info(opt_w, "name") =~ opt_w) \
;;    /let output=$(/histsize -w%opt_w) %;\
;;  /endif %;\
;;  /if (output !~ "") \
;;    /test regmatch("^\% [^ ]+ history capacity is ([0-9]+) lines.\$", output) %;\
;;    /result {P1} %;\
;;  /else \
;;    /result histsize %;\
;;  /endif
;;

;;; Set up the periodic history save.  (Call this in .tfrc on startup.)
;;/repeat -0:05 i /save_histories_inc

;; You'll also want a DISCONNECT hook calling /save_history_inc for the world.


