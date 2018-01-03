; startup definition file

; please do not remove the next line, it enables the additional
; Windows Specific Functionality for the GUI tools (only installed
; by the Windows Enhanced Build installer)

/require winlib.tf

; general
/set isize=3
/visual on
/redef on

; worlds

; Please make all of your manual edit changes below this line as tf-config
; will overwrite any changes above here.
; ----------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;       TFRC file for Gwen Morse, last modified: 06/30/03         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Updated so all macros work under 4s1 and 5a11.
 
;;; Definitions that must come 'first'

/def -Fag -hREDEF gag_redef
/def -Fag -h'conflict' gag_conflict
/def -hload -Fag gag_load

;;; Enter the directories where you keep your tf files.
;;; Home directory if-else help from "Sizer" <sizer at san dot rr dot com>
;;; The if-else check is to see 'which' machine I am running TF on.
;;; I do this because I use TF on multiple machines and OS-es.
;;; That way, I can use one tfrc file on multiple machines.
;;;
;;; I make use of the "STATUS" definition in later macros to determine
;;; "which" machine I'm on.

/if (HOME=~"/home/goldmoon")\
    /cd /home/goldmoon %;\
    /set HOME=/home/goldmoon %;\
    /def LOGDIR=/win/My Documents/Tinyfugue/logs %;\
    /def LOCALLIBDIR=/win/My Documents/Tinyfugue/ %;\
    /def LOGFILE=/win/My Documents/Tinyfugue/tiny.log %;\
    /def DECDIR=/win/My Documents/Tinyfugue/decompile %;\
    /set status=linbook %;\
/elseif (HOME=~"/home/morsej")\
    /cd /home/morsej%;\
    /set HOME=/home/morsej %;\
    /def LOGDIR=/home/morsej/tf-logs %;\
    /def LOCALLIBDIR=/home/morsej/locallib %;\
    /def LOGFILE=/home/morsej/logs/tiny.log %;\
    /def DECDIR=/home/morsej/tf-dec %;\
    /set status=work %;\
/else \
    /cd /cygdrive/e/MUSH/Tf/%;\
    /def LOGDIR=/cygdrive/e/My Documents/Tinyfugue/logs %;\
    /def LOCALLIBDIR=/cygdrive/e/MUSH/Tf/locallib %;\
    /def LOGFILE=/cygdrive/e/MUSH/Tf/logs/tiny.log %;\
    /set status=winbook %;\
    /set DECDIR=/cygdrive/e/My Documents/Tinyfugue/decompile %;\
/endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; loading lib programs I like
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/require world-q.tf
/require spc-page.tf
/require kbstack.tf
/require complete.tf
/require textutil.tf

/def -F spelling=\
  /if ({status}=~"winbook") \
    /require complete.tf %;\
    /else \
    /require spell.tf %;\
  /endif
/spelling

;; More space-page broken in 5a11.
;; As a short-term workaround you could try redefining pager like so:
/def -i pager = \
    /dokey page%; \
    /if (moresize() == 0) \
        /purge -ib" "%; \
    /endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; setting TF system defaults I like
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; /set TZ=EST5EDT
/set maildelay=0
/set oldslash=off
/set redef=on
/set isize=5
/set more=on
/set cleardone=on
/set quiet=on
/set visual=on
/set wrapspace=2
/set insert=on
/set histsize=25000
/set ptime=0
/def -f host_def = \
 /quote /set hostname=!hostname
/host_def

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Special Logging Macros
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Put together from definitions by Andrew Mortimer and members of the 
; Tinyfugue mailing list

; When I connect to a world, it starts logging (-w) to the file 
; 'date_worldname.log', where date is in the format Year-Month-Day. For
; example: 1997-12-02_<world>.log. It also writes the time the log starts in the file.
; This format keeps logs in date order in the directory.

;;; This version doesn't include the multi-machine 'status' check:
;; /def -Fp100 -h'connect' connect_log = \
;;   /log -w ${LOGDIR}/$[ftime("%Y-%m-%d", time())]_${world_name}.log %;\
;;   /eval /echo -ag -w${world_name} \
;; %========================================================================== %;\
;;   /eval /echo -ag -w${world_name} \
;; %=            Log for world *** ${world_name} ***, started $(/time %%c) %;\
;;   /eval /echo -ag -w${world_name} \
;; %==========================================================================

;;; This version includes the multi-machine 'status' check:

/def -Fp100 -h'connect' connect_log = \
/if ({status}=~"work") \
  /log -w ${LOGDIR}/$[ftime("%Y-%m-%d", time())]w_${world_name}.log %;\
  /eval /echo -ag -w${world_name} \
%============================================================================== %;\
  /eval /echo -ag -w${world_name} \
%=            Log for world *** ${world_name} ***, started $(/time %%c) %;\
  /eval /echo -ag -w${world_name} \
%============================================================================== %;\
/elseif ({status}=~"linbook") \
  /log -w ${LOGDIR}/$[ftime("%Y-%m-%d", time())]_${world_name}.log %;\
  /eval /echo -ag -w${world_name} \
%============================================================================== %;\
  /eval /echo -ag -w${world_name} \
%=            Log for world *** ${world_name} ***, started $(/time %%c) %;\
  /eval /echo -ag -w${world_name} \
%============================================================================== %;\
/elseif ({status}=~"winbook") \
  /log -w ${LOGDIR}/$[ftime("%Y-%m-%d", time())]_${world_name}.log %;\
  /eval /echo -ag -w${world_name} \
%============================================================================== %;\
  /eval /echo -ag -w${world_name} \
%=            Log for world *** ${world_name} ***, started $(/time %%c) %;\
  /eval /echo -ag -w${world_name} \
%============================================================================== %;\
/else \
  /log -w ${LOGDIR}/$[ftime("%Y-%m-%d", time())]b_${world_name}.log %;\
  /eval /echo -ag -w${world_name} \
%============================================================================== %;\
  /eval /echo -ag -w${world_name} \
%=            Log for world *** ${world_name} ***, started $(/time %%c) %;\
  /eval /echo -ag -w${world_name} \
%============================================================================== %;\
/endif

; Lets /dc function like 'QUIT' to trigger the disconnect (needed to close the log) 
; written by 'Brack <slayer at kaiwan dot com>'

/def -F -1ag -h'conflict' gagconflict
/def -Fiq dc = /if /@dc %*%; /then /trigger -hdisconnect %*%; /endif

; This lets you return to the special logging after shutting it off with /log off.
; Note, if the original special log was during the previous calendar 'day', then, 
; /relog will start a new log!
;
; Syntax: '/relog'

/def -i -q relog = /connect_log

;This is the disconnect function, noting the time the log ended and closing the file.

/def -Fp100 -h'disconnect' disconnect_log = \
  /eval /echo -ag -w${world_name} \
%============================================================================== %;\
  /eval /echo -ag -w${world_name} \
%=            Log for world *** ${world_name} ***, ended $(/time %%c) %;\
  /eval /echo -ag -w${world_name} \
%============================================================================== %;\
  /log -w${world_name} off

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  World.tf file info
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; <snippage - get your own worldlist!>

;;;;;;;;;;;;;;;;;;;;;;
;; Sneaky world system
;; Pretend you have multiple computers you play from, and you have a character
;; (or characters) that you only want to be able to play from a specific account.
;; (Stealth RP!)
;; You can use a modified form of the below macro (coupled with the {status} macro
;; shown earlier) to only add world(s) when you're on the 'correct' account.

/def -F tsc=\
  /if ({status}=~"winbox") \
    /addworld -T"tiny.mush" tsc palemoon.com 9990 %;\
    /else \
  /endif
/tsc
;;;;;;;;;;;;;;;;;;;;
;;
;;

/addworld -T"tiny" NOWHERE nowhere guest guest localhost 9999
;;

;;;;;; IRC "Worlds"

/addworld -T"irc.irc" teambg        irc.teambg.net                  6667
/addworld -T"irc.irc" fwp           irc.gamesnet.net                6667

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; hilite.tf file info
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Make pages, multipages, and whispers stand out
;;; Gwen: I like to make my pages/multipages/whispers that I send out hilighted
;;; also, not just the ones people send to me. To discriminate between them, 
;;; I use the non-bold form of the color I use for the incoming communication 
;;; of the same type. This mostly helps me visually seperate any remote 
;;; conversation from action in my location.

;bold cyan color pages
/def -i -p2 -aBCcyan -t'* pages[,:] *' hl_page1
/def -i -p4 -aBCcyan -t'You sense that * is looking for you in *' hl_page2
/def -i -p4 -aBCcyan -t'From afar, *' hl_page3
/def -i -p2 -aCcyan -t'Long distance to *' hl_page4
/def -i -p2 -aCcyan -t'You paged *' hl_page5

;bold green multi-pages
/def -i -p3 -aBCgreen -t'* pages (*) *' hl_mpage1
/def -i -p5 -aBCgreen -mregexp -t"(multipages|multi-pages)" hl_mpage2
/def -i -p5 -aCgreen -mregexp -t"(multipage|multi-page)" hl_mpage3
/def -i -p6 -aBCgreen -t'(To: *)' hl_mpage4
/def -i -p4 -aCgreen -t'(To: *) Long Distance, *' hl_mpage5
/def -i -p5 -aCgreen -t'(To: *) * pages: *' hl_mpage6

;bold blue color whispers
/def -i -p2 -aBCblue -t'* whispers[,:] *' hl_whisper1
/def -i -p3 -aBCblue -t'You sense *' hl_whisper2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Full-line highlights (odds and ends)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;When someone triggers a character @adesc (bold magenta)
/def -p5 -aBCmagenta -t'* looked at *.' hl_adesc
/def -p5 -aBCmagenta -t'* is looking at *.' hl_adesc2

;hilite Activity in bg worlds
/def -p2 -F -hACTIVITY -aBCwhite hl_activity

;<OOC> Code
/def -p4 -aBCyellow -t'<OOC> *' hl_ooc

;+watch code
/def -i -p5 -aBCgreen -t'<Watch> *' hl_watch

;MUX 'game' messages
/def -i -p5 -F -aBCgreen -t'GAME:*' hl_watch2

;+finger pemits
/def -i -p5 -F -aBCgreen -t'* +fingered you.' hl_finger

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; "Partial" highlights of importance
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;Channels
;Any '[ ]' or '>'
/def -i -p9 -P0BCred -F -t'\\[*\\]' tiny_sh1
/def -i -p8 -P0BCred -mregexp -F -t"^\\[.*\\]" tiny_sh2
/def -i -p8 -P0BCred -mregexp -F -t"^[A-Za-z0-9 _-]*>" tiny_sh3
/def -i -p7 -P0BCred -mregexp -F -t"^<.*> " tiny_sh4

; Warnings
/def -i -p3 -F -P1xBCred -t'(ALERT>)' par_alert
/def -i -p1 -P0BCred -F -t'^[^ ]+ >>' night_chan

; Table-talk conversation partially in white
/def -i -p7 -P0xBCwhite -t'^(At|In) (your|the) [^,:]*[,:]' par_place1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Gag lines
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Gags

/def -i -p3 -ag -mregexp -t"^You own a (floating|disconnected) room" floating_gag

/def -i -p3 -ag -t"*Saving your work*" savework_gag

/def -i -p3 -ag -t"START LOG NOW*" startlog_gag

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Odds and Ends (doesn't fit anywhere else)

;; What time people connect
/def -i -p10 -F -t'* has connected.' contime_trig = \
   /send -w @pemit me=\[time()\]
   
/def -i -p10 -F -t'* has disconnected.' discontime_trig = \
   /send -w @pemit me=\[time()\]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Auto-idler 

/def idler=\
   /if (world_info()!~"") \
      /send -W @@ %;\
      /repeat -0:6:00 1 /idler %;\
   /endif%;\

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;----------------------------------------------------------------------
;;; TF stuff, by Tiercel/JBB, batzel at cceb.med.upenn.edu
;;;----------------------------------------------------------------------
;;; MUSHcode escaper. If you've typed a long line of code (or grabbed
;;; it with /fuguedit), you don't want to have to go through by hand to
;;; escape out all those characters MUSH will eat. Instead, with this
;;; loaded, just hit esc-e, and it escapes all the odd characters in
;;; what you've just typed (or /redit'd).
;;; RATING: **** (Very useful for heavy coders or for teaching people code)

/def -ib'^[e' = /test kbgoto(kblen() + 1) %;\
  /grab $(/escape %%[]{}\ $[kbhead()])

/def -i -F eschelp = %;/echo%;/echo *** Tiercel's MUSHcode Escaper Help %;\
   /echo If you've typed a long line of code (or grabbed it with Fuguedit), %;\
   /echo you don't want to have to go through by hand to escape out all those %;\
   /echo characters MUSH will eat. Instead, with this loaded, just hit esc-e, %;\
   /echo and it escapes all the odd characters in the command line. %;\
   /echo %;/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Status Field update
;;;
;;; Status_field default
;;; @more:8:Br :1 @world :1 @read:6 :1 @active:11 :1 @log:5 :1 @mail:6 :1 insert:6 :1 @clock:5
;;;   
;;; and the corresponding format variables are: 
;;;
;;;   /set status_int_more \
;;;        moresize() == 0 ? "" : \
;;;        moresize() > 9999 ? "MuchMore" : \
;;;        pad("More", 4, moresize(), 4)
;;;   /set status_int_world   ${world_name}
;;;   /set status_int_read    nread() ? "(Read)" : ""
;;;   /set status_int_active  nactive() ? pad("(Active:",0,nactive(),2,")") : ""
;;;   /set status_int_log     nlog() ? "(Log)" : ""
;;;   /set status_int_mail \
;;;        !nmail() ? "" : \
;;;        nmail()==1 ? "(Mail)" : \
;;;        pad("Mail", 0, nmail(), 2)
;;;   /set status_var_insert  insert ? "" : "(Over)"
;;;   /set status_int_clock   ftime("%I:%M", time())   
;;;
;;; /set status_fields @more:8:Br :1 @world :1 @read:6 :1 @active:11 :1 @log:5 :1 insert:6 :1 @clock:12
;;; /set status_int_clock ftime("%I:%M %m/%d", time())
;;;
;;; My changes (Gwen Morse)
;;; 1) removed the @mail configuration (since I use Windoze)
;;; 2) reset the clock to show date in dd/mm format along with time.
;;; 3) updated status line to include Australia TZ information (based on help below)
;;;
;;; From: Craig Marsden (TF mailing list)
;;;
;;; Not very pleasant but this line displays the time in the UK (me), AT
;;; (time on the game) and MC is the timezone of a good friend of mine
;;; (Canada).
;;; The number is in seconds so its (hours from your timezone to another) * 60 * 60
;;; This may be incorrect 2 weeks out of 52, as different regions treat DST differently.
;;;
;;; (Gwen Note: Australia +15 hrs=+54000 || Australia +14 hours=+50400 || +16 hours +57600)
;;;
;;; /set status_int_clock strcat(ftime("%H:%M", time()), "__AT:", ftime("%H:%M", time()-18000), "__MC:", ftime("%H:%M", time()-14400))
;;; /def setstatus = /set status_fields = @more:8 "_Wd:":4 @world:5 "_UK:":4 @clock:25 @read:6 @active:11  @log:5  @mail:6 insert:6
;;;
;;; /set status_int_clock strcat(ftime("%I:%M%p", time()), " SW: ", ftime("%I:%M%p", time()+21600), " OZ: ", ftime("%I:%M%p", time()+54000))
;;; /set status_int_clock strcat(ftime("%I:%M%p", time()), " OZ: ", ftime("%I:%M%p", time()+57600))
;;; /set status_fields @more:8:Br :1 "Wd:":3 @world:5 :1 @read:6 :1 @active:11 :1 @log:5 :1 "_NY: ":5 @clock:32

;;; 5.0 update: New way to modify status field. The below code will give errors, but, does function. Look
;;; into updating it to work seamlessly.

/set status_int_clock strcat(ftime("%I:%M%p", time()), " _ OZ: ", ftime("%I:%M%p", time()+50400))
/set status_fields @more:8:Br :1 "Wd:":3 @world:5 :1 @read:6 :1 @active:11 :1 @log:5 :1 "_NY: ":5 @clock:21

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; IDE Highlighting
;;;
;;; I'm sure most of you have worked on a IDE that uses syntax highlighting if you're into 
;;; any sort of coding at all, you all know how useful it can be. Of course, MUSHes didn't 
;;; have that -- till now. If you paste the following into your .tfrc (for tinyfugue
;;; users; others probably will have to modify this code) and then do line joins if 
;;; necessary, you'll get some form of syntax highlighting. 
;;; Author: Kamikaze: http://www.imsa.edu/~kamikaze/

/def -p10 hilight_cmd = /def -PBCwhite -F -t"%1"
/def -p10 hilight_cmd2 = /def -PBCwhite -F -t"%1"
/def -p10 hilight_cmd3 = /def -PBCwhite -F -t"%1"
/def -p10 hilight_cmd4 = /def -PBCwhite -F -t"%1"
/def -p10 -F -PBCyellow -t'(\{|\})'
/def -p10 -F -PBCred -t'(\[|\])'
/def -p10 -F -PBCgreen -t'(\(|\))'
/def -p10 -F -PBCblue -t'(=|;|/|\%0|\%1|\%2|\%3|\%4|\%5|\%6|\%7|\%8|\%9|\%#|\%@|\%N)'
/def -p10 -F -PBCmagenta -t'(\%r|\%b|\%t|\%s|\%p|\%o|\%!|\%l)'
/def -p10 -F -PBCcyan -t'(\%q0|\%q1|\%q2|\%q3|\%q4|\%q5|\%q6|\%q7|\%q8|\%q9|\%Q0|\%Q1|\%Q2|\%Q3|\%Q4|\%Q5|\%Q6|\%Q7|\%Q8|\%Q9)'
/def -p10 -F -PBCmagenta -t'(,)'
/hilight_cmd (@@|@allhalt|@allquota|@atrchown|@atrlock|@attribute|@boot|@cemit|@channel|@chat|@chown)
/hilight_cmd (@chownall|@chzone|@chzoneall|@clock|@clone|@command|@config|@cpattr|@create|@dbck)
/hilight_cmd (@decompile|@destroy|@dig|@disable|@doing|@dolist|@drain|@dump|@edit|@elock|@emit|@enable)
/hilight_cmd (@entrances|@eunlock|@find|@firstexit|@fixdb|@force|@function|@gedit|@grep|@halt|@hide|@kick)
/hilight_cmd2 (@link|@listmotd|@list|@lock|@log|@mail|@map|@motd|@mvattr|@name|@newpassword|@notify|@nuke)
/hilight_cmd2 (@oemit|@open|@parent|@password|@pcreate|@pemit/list|@pemit|@poll|@poor|@power|@ps|@purge|@quota)
/hilight_cmd2 (@recycle|@rejectmotd|@remit|@restart|@rwall|@rwallemit|@rwallpose|@scan|@search|@select)
/hilight_cmd3 (@shutdown|@sitelock|@squota|@stats|@sweep|@switch|@tel|@teleport|@toad|@trigger|@ulock|@unlock)
/hilight_cmd3 (@undestroy|@unlink|@unlock|@unrecycle|@uptime|@uunlock|@verb|@version|@wait|@wall|@wallemit)
/hilight_cmd3 (@wallpose|@warnings|@wcheck|@wipe|@wizemit|@wizmotd|@wizpose|@wizwall|@zemit|@desc|@dol)
/hilight_cmd4 (@sel|@fo|@no|@listen|@lemit|@femit|@fpose|@fsay|@mudwho|@alias|@last|@robot|@readcache)
/hilight_cmd4 (@setq|@set)

; Hilite various Tiny-MUSH specific settings (dbrefs, flags, @'s, etc)
; written by Andrew Mortimer

/def -i -p1 -P0BCred -mregexp -F -t'#[0-9]+' tiny_dbrefnum
/def -i -p1 -P0BCred -mregexp -F -t'#-1' tiny_dbreferr
/def -i -p1 -P1BCred -mregexp -F -t'#[0-9]+([A-Za-z\$+&@]+( \[[^]]+\])?)' tiny_dbrefflag
/def -i -p1 -P0Cwhite -mregexp -F -t'@[A-Za-z_]+' tiny_atcomm
/def -i -p1 -P1Cwhite -mregexp -F -t'^([ ]*[^;()# ]+)(\\(#[0-9]+\\))?:.*' tiny_heads

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; defining Improved Fugue Edit command
;;;
;;; FROM: http://www.chaoticmux.org/~kareila/TF/
;;;
;;; FugueEdit macro (ed obj/attr)
;;; Probably the most common tf macro out there is one that will grab the text of 
;;; an attribute into the input buffer for editing. The incarnation I was given required
;;; some softcode to implement, and the only tf-side code you had to define was the 
;;; gag-trigger that got the input. This worked, but I was annoyed that I had to
;;; port this piece of softcode to every game I was on. So I recoded it to be 
;;; defined entirely within tf. It uses the usual syntax: "/ed <obj>/<attr>".
;;;
;;; FugueEdit macro (ed obj/attr) coded by Kareila@ChaoticMUX
;;;  based on mushcode that originated with van@TinyTIM
;;;  and has mutated several times since then.
;;; Thanks to Gwen Morse for the incentive to make improvements.  :)
;;;
;;; Gwen: works -- very nice! And, look, I get credit for "inspiring" improvements!


; edmarker can be anything you like - no spaces allowed.

/set edmarker TFEdit

/eval /def -p100 -ag -t'%{edmarker} > *' edtrig = /grab %%-2

/def ed = \
	/if (regmatch('/',{*})) \
		/let edobj %PL %; \
		/let edattr %PR %; \
		/def -n1 -t#* -q -ag tempedtrig = \
			@pemit me = switch(%%*, \
			#-1, I don't see that here., \
			#-2, I don't know which one you mean!, \
			%{edmarker} > &%{edattr} %{edobj} = \
			[get(%%*/%{edattr})]) %; \
		/send @pemit me = locate(me, %{edobj}, *) %; \
	/else /echo %% %{edmarker}: ed argument must be of form <obj>/<attr> %; \
	/endif
/def -h"send ed *" edhook = /ed %-1

/def ng = \
	/if (regmatch('/',{*})) \
		/echo %% %{edmarker}: ng argument must be a valid object name %; \
	/else \
		/def -n1 -t#* -q -ag tempngtrig = \
			@pemit me = switch(%%*, \
			#-1, I don't see that here., \
			#-2, I don't know which one you mean!, \
			%{edmarker} > @name %* = [translate(fullname(%%*))]) %; \
		/send @pemit me = locate(me, %*, *) %; \
	/endif
/def -h"send ng *" nghook = /ng %-1

/def lock = \
	/if (regmatch('/',{*})) \
		/let edobj %PL %; \
		/let edattr %PR %; \
		/def -n1 -t#* -q -ag templocktrig = \
			@pemit me = switch(%%*, \
			#-1, I don't see that here., \
			#-2, I don't know which one you mean!, \
			%{edmarker} > @lock/%{edattr} %{edobj} = \
			[lock(%%*/%{edattr})]) %; \
		/send @pemit me = locate(me, %{edobj}, *) %; \
	/else \
		/def -n1 -t#* -q -ag templocktrig = \
			@pemit me = switch(%%*, \
			#-1, I don't see that here., \
			#-2, I don't know which one you mean!, \
			%{edmarker} > @lock %* = [lock(%%*)]) %; \
		/send @pemit me = locate(me, %*, *) %; \
	/endif
/def -h"send lock *" lockhook = /lock %-1

/def edhelp = \
	/echo -p @{h}ed <obj>/<attr>:@{n} \
		edits the given attribute on the given object. %; \
	/echo -p @{h}ng <obj>:@{n} \
		grabs the name of the given object for editing. %; \
	/echo -p @{h}lock <obj>[/<type>]:@{n} \
		edits the given lock (default lock if no type given).
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FROM: http://www.chaoticmux.org/~kareila/TF/
;;; Macro for quickly cloning a copy of an object to a different mush
;;; without the need to log a @decompile.  http://www.amtgard.com/~marvin/
;;; This is a useful macro I got from Pedersen's web page, which unfortunately 
;;; appears to have bitten the proverbial dust since I snarfed it. It defines a macro,
;;; /clone, that can be used to quickly reproduce an object between worlds you 
;;; are connected to, with no intermediate logfile. 
;;;

/def clone = \
    /def -t&* -p100 -q -ag -w%1 cloneitampertrig = /send -w%2 \%* %; \
    /def -t@* -p100 -q -ag -w%1 cloneitattrig = /send -w%2 \%* %; \
    /def -tCLONEDONE -p10 -q -ag -w%1 cloneitdone = /purge cloneit* %; \
    /def -tCLONEDONE -p1000 -n1 -q -ag -w%1 cloneitgagfirst %; \
    /send -w%1 OUTPUTSUFFIX CLONEDONE %; \
    /send -w%1 @decompile %3 %; \
    /send -w%1 OUTPUTSUFFIX %; \
    /send -w%1 @pemit \%#=Object is now sent.

/def clonehelp = /echo -p @{u}Syntax:@{n} /clone <worldfrom> <worldto> <object>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FROM: http://www.chaoticmux.org/~kareila/TF/
;;; TF multidescer coded by Kareila@ChaoticMUX, May 2003
;;; 
;;; Syntax: /showdescs, /listdescs, /showdesc <desc>, /setdesc [<obj>=]<desc>
;;; 
;;; To add a desc: /set desc_<descname> <description> (see examples below)
;;;
;;; World specific adjustment and @dolist list support by Gwen Morse.

; Descriptions start here (descs "have" to come before the commands)

/set desc_testa %r[space(5)]the first short and boring test description
/set desc_testb the second short and boring test description
/set desc_testc This is a really long and boring test description.  The \
	real purpose of this description is to demonstrate how descriptions that \
	are broken across multiple lines need to be continued with backslashes \
	in order for the file to parse correctly.  The extra spaces at the \
	beginnings of lines are parsed out by TF.

; Commands are defined here

/def helpdescs = \
    /echo  %; \
    /echo Syntax: /showdescs, /listdescs, /showdesc <desc>, /setdesc [<obj>=]<desc>

/def showdescs = /showdescs_ $(/listvar -mglob -s desc_${world_name}_*)

/def showdescs_ = \
	/while ({#}) \
		/test regmatch('^desc_${world_name}_',{1}) %; \
		/showdesc %PR %; /shift %; \
	/done

/def listdescs = /listdescs_ $(/listvar -mglob -s desc_${world_name}_*)

/def listdescs_ = \
	/while ({#}) \
		/test regmatch('^desc_${world_name}_',{1}) %; \
		/set listdescs_temp %{listdescs_temp} %PR %; /shift %; \
	/done %; \
	/echo Available descriptions: %{listdescs_temp} %; /unset listdescs_temp

/def showdesc = \
	/if ($(/eval /echo %%desc_${world_name}_%*) =~ '') \
		/echo %% showdesc: No such description "%*". %;\
	/else \
		/eval /echo -p @{h}%*:@{n} %%desc_${world_name}_%* %; \
	/endif

/def setdesc = \
	/if (regmatch('=',{*})) \
		/if ($(/eval /echo %%desc_${world_name}_%PR) =~ '') \
			/echo %% setdesc: No such description "%PR". %; \
		/else \
			/echo %% Setting description "%PR" on object "%PL". %; \
			/eval /send @desc %PL = %%desc_${world_name}_%PR %; \
			/eval /send @dolist [num(%PL)] = %%desc_list_${world_name}_%PR %; \
		/endif %; \
	/elseif ($(/eval /echo %%desc_${world_name}_%*) =~ '') \
		/echo %% setdesc: No such description "%*". %; \
	/else \
		/echo %% Setting description "%*". %; \
		/eval /send @desc me = %%desc_${world_name}_%* %; \
    /eval /send @dolist [num(me)] = %%desc_list_${world_name}_%* %; \
	/endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FROM: http://www.chaoticmux.org/~kareila/TF/
;;; Cool shell-like hacks to grab previous commands from input history.
;;; Inputs beginning with ! echo and execute the last matching command.
;;; If ` is pressed, it grabs the last matching command for editing.
;;; Kareila  02/03/1999

/def -p1000 -mregexp -h'SEND ^!(.*)$' resend = \
	/let matchtxt=$(/recall -i /1 %P1*) %; \
	/if (strlen(matchtxt)) \
		/echo %% %matchtxt %; \
		/send %matchtxt %; \
	/else \
		/beep 1 %; \
	/endif

/def -b'`' reedit = \
	/if (regmatch('^!', (kbhead()))) \
		/let matchtxt=$(/recall -i /1 $[substr((kbhead()),1)]*) %; \
		/if (strlen(matchtxt)) \
			/grab %matchtxt %; \
		/else \
			/beep 1 %; \
		/endif %; \
	/else \
		/@test input("`") %; \
	/endif
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MUSH/MUX data-base cloning
; Based on a count script by Michael Hunger (mh14 at inf dot tu-dresden dot de)
; Expanded to clone by Gwen Morse (goldmooneachna at yahoo dot com)
; Used OUTPREFIX examples provided by Kareila at chaoticMUX
;
; Handy little macro to @dec items incrementally in a database, one item at a time.
; Requires Wiz powers (or, will only @dec dbrefs you actually own).
;
; type: /dbc <number> 
; where <number> is the *last* number in the database you want to log.
; @stats will tell you last # in database.
;
; Macro tells you the number and name of each item being cloned, and then 
; @decompiles it to a log. Starts with #0


/def -w -q -F dbc = \
;;; if a parameter was given
        /if ({#} > 0) %;\
           /log -w${world_name} off %;\
           /more off %;\
           /idler %;\
;;; set variables (grabs from number entered)
           /set counter= -1 %;\
           /set end_counter=%1 %;\
        /endif%;\
;;; if end reached end log
        /if (counter==end_counter) %;\
           /more on %;\
           /relog %;\
        /endif%;\
;;; if end not reached call itself in 2 (-2) seconds
        /if (++counter<=end_counter)%;\
				    /send @pemit me = DBC> Now working with object #%counter, name: [edit(name(#%counter),\%b,_)] %; \
				    /def -q -ag -n1 -p1000 -t'DBC> Decompile done!' dbc_hide %; \
				    /send @decompile #%counter %; \
				    /send OUTPUTSUFFIX DBC> Decompile done! %; \
            /send OUTPUTSUFFIX %; \
            /repeat -w -2 1 /dbc%;\
        /endif%;\

;;; Alternate @stats check to automagically tell /dbc what the ending # should be.
;;; Gwen: The check will set DBSTATS, but, it's not integrated with /dbc, yet.
   
/def -w -F -p100 -mregexp -t"^The universe contains ([0-9]+) objects" dbstats_set = \
    /set DBSTATS=%{P1} %;\
    
;;;;;; DBC checks needed for DBC scripts

/def -p100 -qi -t'DBC> Now working with object *' dbc_start = \
    /log -w %{DECDIR}/working/dbc_${world_name}_%{counter}_%8.log

/def -p100 -qi -t'DBC> Decompile done!' dbc_end = \
    /log -w off 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Debugging Code help (MUSH/MUX)
;;;
;;; Original Source Mux-In-A-Minute Globals code. Ported to TF by Gwen Morse
;;; Gwen: DOES NOT YET WORK -- work in progress!
;;;

/def debug=[setq(0,num(%*))][setq(1,locate(me,r(0),*))]; @switch \
     [isdbref(r(1))][controls(me,r(1))]=0?,{@pemit me=I'm sorry, but I can't see \
     {'%*'} here.},10,{@pemit me=I'm sorry, but you can't modify that object.},11,{@set \
     r(1)=VERBOSE; @set r(1)=TRACE; @pemit me=Debugging is now on for [name(r(1))].}

/def debugstop=[setq(0,num(%*))][setq(1,locate(me,r(0),*))]; @switch \
     [isdbref(r(1))][controls(me,r(1))]=0?,{@pemit me=I'm sorry, but I can't see {'%*'} \
     here.},10,{@pemit me=I'm sorry, but you can't modify that object.},11,{@set \
     r(1)=!VERBOSE; @set r(1)=!TRACE; @pemit me=Debugging is now off for [name(r(1))].}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Elrick's @doing machine
;;;
;;; This is a (very rough) translation of Eldrik's @doing machine code
;;; to TF macros. No need for a parentable object on the MUSH to run it.
;;;
;;; To Use: Put this in your .tfrc. Once loaded in, type '/dohelp' for 
;;; command list.
;;;
;;; Original code by Eldrik at AmberMUSH. Modified for TF by Rina at pobox dot com.
;;;
;;; Updated to work under tf40 by Gwen Morse (with mail list help)

;;;/def -i dorand = @fo [setq(0,extract(v(doings_list), \
;;;	add(rand(words(v(doings_list),|)),1),1,|))]me=@doing [r(0)]; \
;;;	@pemit me=@doing set: [r(0)]


/def -i dolist = @pemit me=Stored \
	@doings:[iter(lnum(words(v(doings_list),|)),\%r[add(##,1)]. \
	[extract(v(doings_list),add(##,1),1,|)])]
/def -i doset = @switch [and(lte(%*,words(v(doings_list),|)), \
	gt(%*,0))]=1,{@fo [setq(0,extract(v(doings_list),%1,1,|))]me= \
	@doing [r(0)]; @pemit me=@doing set: [r(0)]},@pemit me=That is not \
	the number of a stored @doing.
/def -i doswap = @switch and(lte(%1,words(v(doings_list),|)), \
	gt(%1,0),lte(%2,words(v(doings_list),|)),gt(%2,0))=1,{&doings_list \
	me=[setq(0,extract(v(doings_list),%1,1,|))][replace(replace( \
	v(doings_list),%1,extract(v(doings_list),%2,1,|),|),%2,r(0),|)]; \
	@pemit me=@doings swapped.},@pemit me=At least one selection is invalid.
/def -i dorand = @fo [setq(0,extract(v(doings_list), \
	add(rand(words(v(doings_list),|)),1),1,|))]me=@doing [r(0)]; \
	@pemit me=@doing set: [r(0)]
/def -i dodel = @switch [and(lte(%*,words(v(doings_list),|)), \
	gt(%*,0))]=1,{&doings_list me=[ldelete(v(doings_list),{%*},|)]; \
	@pemit me=@doing deleted.},@pemit me=That is not a number of a \
	stored @doing.
/def -i dohelp = %;/echo%;/echo @doing Machine commands:%;/echo%;/echo /dolist: List \
	stored @doings.%;/echo /doadd <text>: Add an @doing.%; \
	/echo /dodel <#>: Delete a stored @doing.%; \
	/echo /doset <#>: Set your @doing to a stored one.%; \
	/echo /dorand: Set your @doing randomly.%; \
	/echo /doswap <#> <#>: Swap one @doing with another.%; \
        /echo%;/echo Original code by Eldrik@AmberMUSH. Modified for TF \
	by Rina@pobox dot com. Updated by Gwen Morse.
/def -i doadd = @switch gt(strlen(%*),40)=1,@pemit me={@doing is too long \
	-- not saved. ([strlen(%*)] chars, 40 max)},{@switch words( \
	v(doings_list),|)=0,&doings_list me={%*},{&doings_list me=[edit( \
	v(doings_list),$$,|{%*})]};@pemit me=@doing added.}

;;; Gwen: Call 'dorand' on each world when I connect to it!

/def -Fp5 -h'connect' connect_doing = /repeat -w${world_name} -1 1 /dorand

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $Id: ignore.tf,v 1.1 1996/11/24 20:22:57 dmoore Exp $
; v1.0 - created May 31, 1996
; *** Requires tf3.5a18 or later to use. ***
; (May work with earlier versions.)
;
; dmoore at ucsd.edu
;
; You first say '/ignore_pair WORLD1 WORLD2', (with your two world names),
; to tell it that these two worlds go together.  Then you can use
; '/ignore_toggle' from inside either of those worlds to switch which is
; ignored.  And you can use '/ignore_off' to turn it off.  It won't start
; ignoring until the first time you use '/ignore_toggle'.  This way you
; can stick the '/ignore_pair W1 W2' command in your world file.
;
; You can also just say '/ignore_auto WORLD1 WORLD2' which will
; automatically keep the frontmost world in a pair showing text, and the
; background one hiding it.
;
; Both /ignore_toggle and /ignore_off can be given a world name.
;
;; Example lines in your world file:
;
;	/addworld bob BOB xxx localhost echo
;	/addworld fred FRED xxx localhost echo
;	/ignore_pair bob fred
;
;; Then after you've connected to bob and fred and gotten started:
;
;	/ignore_toggle bob
; --> now you won't see anything on world bob anymore.
;
;	/ignore_toggle
; --> now you won't see anything on world fred anymore.
;
;	/ignore_off bob
; --> now you see everyone on both bob and fred.
;
;; Example lines in your world file:
;
;	/addworld aa BOB xxx localhost echo
;	/addworld bb FRED xxx localhost echo
;	/ignore_auto aa bb

;;; This sets the priority level of the gags.

/set ignore_priority=0

;;; FIX FIX FIX: if Ken adds a /fg flush option, then you could
;;; easily use /advise on fg to check if the destination is a pair'd one,
;;; and add the flush arg to the /fg subcall.


/def -i ignore_auto =\
    /if /!ignore_pair %1 %2%;/then /break%;/endif%;\
    /if (!ismacro("ignore__world_hook")) \
	/def -i -F -h'WORLD' ignore__world_hook = \
	    /let ignore_which=\$[tolower({1})]%%;\
	    /let ignore_other=%%;\
	    /if (ignore__find_pair()) \
		/ignore__show \%{ignore_which}%%;\
		/ignore__hide \%{ignore_other}%%;\
	    /endif%;\
    /endif

/def -i ignore_pair =\
    /if ({#} != 2) \
	/echo \% /ignore_pair requires two world names.%;\
	/test 0%;\
	/break%;\
    /endif%;\
    /let first=$[tolower({1})]%;\
    /let second=$[tolower({2})]%;\
    /set ignore_pairs=%{ignore_pairs} [%{first} %{second}]%;\
    /test 1

/def -i ignore_toggle =\
    /if ({#} > 1) \
	/echo \% /ignore_toggle requires one world name.%;\
	/break%;\
    /endif%;\
    /let ignore_which=$[tolower({1-${world_name}})]%;\
    /let ignore_other=%;\
    /if (!ignore__find_pair()) \
	/echo \% No match found for world %{ignore_which}.%;\
	/break%;\
    /endif%;\
    /if ({#}) \
	/ignore__show %{ignore_other}%;\
	/ignore__hide %{ignore_which}%;\
    /elseif /test (ignore_hidden =/ "*{%{ignore_which}}*")%;/then \
	/ignore__show %{ignore_which}%;\
	/ignore__hide %{ignore_other}%;\
    /else \
	/ignore__show %{ignore_other}%;\
	/ignore__hide %{ignore_which}%;\
    /endif
	

/def -i ignore_off =\
    /if ({#} > 1) \
	/echo \% /ignore_off requires one world name.%;\
	/break%;\
    /endif%;\
    /let ignore_which=$[tolower({1-${world_name}})]%;\
    /let ignore_other=%;\
    /if (!ignore__find_pair()) \
	/echo \% No match found for world %{ignore_which}.%;\
	/break%;\
    /endif%;\
    /ignore__show %{ignore_which}%;\
    /ignore__show %{ignore_other}


/def -i ignore__find_pair =\
    /: First try to find a match like [WHICH *]%;\
    /test regmatch("\\[%{ignore_which} ([^ ]*)\\]", ignore_pairs)%;\
    /test ignore_other := "%P1"%;\
    /if (ignore_other =~ "") \
	/: Didn't find it, now try a match like [* WHICH]%;\
	/test regmatch("\\[([^ ]*) %{ignore_which}\\]", ignore_pairs)%;\
	/test ignore_other := "%P1"%;\
    /endif%;\
    /test (ignore_other !~ "")

/require lisp.tf

/def -i ignore__show =\
    /set ignore_hidden=$(/remove %1 %{ignore_hidden})%;\
    /if /ismacro ignore__gag_%1%;/then \
	/undef ignore__gag_%1%;\
    /endif

/def -i ignore__hide =\
    /set ignore_hidden=%{ignore_hidden} %1%;\
    /def -i -p%{ignore_priority} -w%1 -ag -t'*' ignore__gag_%1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Gwen: Note -- completely untested!
;;;
;;; Player purges
;;;
;;; From: http://www.pennmush.org/~alansz/guide/guide-single.html (Javelin's Guide for PennMUSH)
;;;
;;; After a while, you may want to remove old players and their objects 
;;; from your game. I typically use tinyfugue macros, rather than MUSHcode 
;;; to do this. First, I define a macro /nuke <player>, which nukes a player 
;;; and everything they own, providing they're not currently connected: 

/def nuke = @switch hasflag(pmatch(%1),connected)=1,{think %1 is connected!}, {@dol lsearch(%1,none,none)=@nuke ##} 

;;; The connected check prevents you from accidentally nuking yourself.

;;; Then, I define a player purge macro like this: 

/def ppurge = @dol lsearch(all,type,player)=@switch [and(not(orflags(##,Wr)),lt(convtime(xget(##,last)),sub(convtime(time()),2419200)))]=1, {think /nuke [name(##)] ## [lstats(##)]}

;;; This macro searches the db for all players and lists those who aren't admin 
;;; and whose last connection was longer than 28 days ago.

;;; Actually doing a purge, then, requires these steps: 

;;; 1./log purge, to start logging output to a file called 'purge' 
;;; 2./ppurge, to list players who are candidates for purging 
;;; 3./log off, to stop logging 
;;; 4./sh vi purge, to edit the purge file and see who'll be purged. 
;;;   Delete lines in the file for players who you don't want to see purged. 
;;;   What's left will be a list of /nuke lines which will purge the players you want purged. 
;;; 5./quote 'purge, to load the commands in the purge file and do the actual purging. 
;;; 6./sh rm purge, to remove the purge file.
;;;
;;; [ Rhyanna notes that the tinyfugue purge macros which I discuss are incomplete. 
;;; /nuke may leave rooms with more than 3 exits, and the lsearch() may fail to get all
;;; the players due to buffer length problems. - Javelin ]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; If you want to know how long your tf has been running stick the following 
;;; line someplace early in your .tfrc, and then stick the macro below anywhere you like. 
;;;
;;; FROM: http://oj.egbt.org/dmoore/tf/#hints

;; Set the tf startup time in .tfrc, only once.
/test tf_start_time := (tf_start_time | time())

/def tf_time = \
    /let seconds=$[time() - tf_start_time] %;\
    /echo % Your tf has been running for \
      $[seconds/86400] days $[mod(seconds/3600,24)] hours \
      $[mod(seconds/60,60)] mins $[mod(seconds,60)] secs. \

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; /recall_file
;
; Michael Hunger wrote a recall file once:
;
; Usage:
; /recall_file filename recall arguments
;
; eg: /recall_file say.log 1000 *You said:*

/def recall_file = \
   /def recall_write = /test tfwrite(recall_handle,{*})%; \
   /test recall_handle:=tfopen(strcat("recall_",{1},".log"),"w")%; \
   /quote -S /recall_write `/recall %{-1}%;\
   /test tfclose(recall_handle)%;

/def recallhelp = \
   /echo %;\
   /echo Syntax: /recall_file <filename> <recall> <arguments> %;\
   /echo Example: /recall_file say.log 1000 *You said:* %;\

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; /Fix
; By Gwen Morse (goldmooneachna at yahoo dot com)
; 
; This is to send a coding fix based on a specific file that I always
; have in my home directory.
;

/def -w fix = \
   /quote -w 'fix.txt %;\


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TF Scrollback
;;;
;;; >I really like tinyfugue, however I haven't been able to find a way to scroll
;;; >up in the non-typed lines. Something like pressing page-up, which would
;;; >scroll the top window (in visual mode) up. (shift-pageup works in most
;;; >terminal emus, but I don't want the bottom lines for input to scroll away).
;;; > 
;;; >Does this exist and have I missed it, or can it be implemented?
;;;
;;; Some time ago I wrote a macro to get PgUp and PgDown working correctly. 
;;; Don't wonder at the strange names - they are a wild mixture between english and
;;; german. ;-)
;;;
;;; Stephan Lichtenhagen (stephan at lichtenhagen dot de)
;;;
;;; Modified by Gwen Morse to only recall 'World' information, not TF commands.
;;; 'Breaks' sometimes in that it doesn't always calculate the correct amount of screen
;;; size to recall, nor does it properly handle '/more on' and '/more off'.

/set LastLine 0
/def -b'^[[5~' Hist_back=\
        /let Zeilen $[lines() - (visual =~ 'on' ? isize+5 : 5)]%;\
        /if (!LastLine | (time() - Hist_Time > 120)) \
                /test regmatch('([0-9]+): ', $$(/recall -q -w -ag #1))%;\
                /set LastLine %P1%;\
                /let Hist_Anzeigen 1%;\
        /else \
                /if (LastLine <= Zeilen) \
                        /beep 1%;\
                /else \
                        /set LastLine $[FirstLine - 1]%;\
                        /let Hist_Anzeigen 1%;\
                /endif%;\
        /endif%;\
        /set FirstLine $[LastLine > Zeilen ? LastLine - Zeilen : 1]%;\
        /set Hist_Time $[time()]%;\
        /if (Hist_Anzeigen) \
                /if ((more =~ 'on') & (!moresize())) \
                        /set more off%;\
                        /set more on%;\
                /endif%;\
                /recall -q -w -ag %{FirstLine}-%{LastLine}%;\
        /endif
/def -b'^[[6~' Hist_vor=\
        /let Zeilen $[lines() - (visual =~ 'on' ? isize+5 : 5)]%;\
        /test regmatch('([0-9]+): ', $$(/recall -q -w -ag #1))%;\
        /let BottomLine %P1%;\
        /if (!LastLine | (time() - Hist_Time > 120)) \
                /set LastLine %BottomLine%;\
                /beep 1%;\
        /else \
                /if (LastLine == BottomLine) \
                        /beep 1%;\
                        /set LastLine %BottomLine%;\
                /else \
                        /set LastLine $[LastLine + Zeilen < BottomLine ? \
                                LastLine + Zeilen + 1 : BottomLine]%;\
                        /let Hist_Anzeigen 1%;\
                /endif%;\
        /endif%;\
        /set Hist_Time $[time()]%;\
        /set FirstLine $[LastLine > Zeilen ? LastLine - Zeilen : 1]%;\
        /if (Hist_Anzeigen) \
                /if ((more =~ 'on') & (!moresize())) \
                        /set more off%;\
                        /set more on%;\
                /endif%;\
                /recall -q -w -ag %{FirstLine}-%{LastLine}%;\
        /endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; trigger.tf file info
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; /prayers
;;; Lists prayers and their subject descriptions so I can quickly recall which one to use.
;;; From the TF mailing list, provided by:  Martin Nieten nieten at math dot uni dash bonn dot de.
;;; list prayers in scattered order

/def prayers = \
    /echo %;\
    /def prayers_help = \
        /while ({#}) \
	    /let tmp=%%1%%;\
	    /test tmp:=%%tmp%%;\
	    /echo $$[substr({1},0,strstr({1},"_"))] %%tmp%%;\
	    /shift%%;\
	/done%%;\
	/undef prayers_help%;\
    /prayers_help $(/listvar -s -mregexp prayer[0-9]+_desc)

;;; Jamra's Mage Prayers/Spells

/def pray = \
/if ({status}=~"linux") \
    /quote -w${world_name} -30 pose `/%{1} %;\
/else \
    /quote -w${world_name} -10 pose `/%{1} %;\
/endif

/set prayer1_desc Baby Blessing
/def prayer1 = \
/echo chants in a sing-song tone reminiscent of storytelling. "Wisdom of serpent be thine, Wisdom of raven be thine, Wisdom of valiant eagle."  %;\
/echo continues "Voice of swan be thine, Voice of honey be thine, Voice of the Son of the stars." %;\
/echo finishes "Bounty of sea be thine, Bounty of land be thine, Bounty of the Creator of all."

/set prayer2_desc Plants and garden growth with water
/def prayer2 = \
/echo chants in a sing-song tone reminiscent of storytelling "Water is one substance which supports all life. The other lifeblood is the Grace bestowed by the One, the Prime Essence." %;\
/echo continues "The practice of praying over food and water is followed by those who understand that it will instill them with some fragment of Grace." %;\
/echo finishes "In acknowledgement of that, so do I now pray that the Messenger of the greenery growing in this place will benefit from the pure water I pour to nourish the roots...."

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
;;; Changing clothes on Individual Worlds
;
; Using the Virtual Array package, I can randomize teeshirt messages sent when I connect to
; any particular world I'm playing on (assuming I have the messages pre-configured into
; an array for that world).
;
; This useage is keyed to logging in specific worlds (the array varies by world-name).
; It could easily be modified to work on ANY connected world.
;
; Sample code: 
;
; /test put_array('gis_tee', 0, '&teeshirt me="Actresses Do It Dramatically."')
; /test put_array('gis_tee', 1, '&teeshirt me="\'I\'m the Chosen One. And, I CHOOSE to go shopping!\' -- Buffy the Vampire Slayer."')
; /test put_array('gis_tee', 2, '&teeshirt me="Yes, there *is* muscle under all this curve."')

/def -p3 -F -1 -w -h"CONNECT" tee_connect_hook = \
        /test tee_value_r := get_array_count('${world_name}_tee', 0) %;\
        /test tee_value := send(get_array('${world_name}_tee',rand(0,tee_value_r)))

;I count from 0 since you had rand 0 in there, if not then count from 1 in get array count.

;;; If I don't like the tee desc I ended up with, I can call it again with '/retee'

/def -i -F -w -q retee = \
        /test tee_value := send(get_array('${world_name}_tee',rand(0,get_array_count('${world_name}_tee',0))))

/test put_array('halloween', 1, 'skeleton')
/test put_array('halloween', 2, 'owls')
/test put_array('halloween', 3, 'boo!')


/def -p3 -F -1 -w -h"CONNECT" quote_connect_hook = \
        /test tee_quote := send(get_array('${world_name}_quote', rand(1,5)))

/def -p3 -F -1 -w'galli' requote = \
        /test tee_quote := send(get_array('galli_quote', rand(1,5)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 
;;; TF-IRC
;;; 
;;; A bunch of TinyFugue scripts to let you IRC using the TinyFugue MUD
;;; client.
;;; 
;;; 
;;; INSTALLING
;;; ==========
;;;    
;;;    1.  Create a directory named .tf in your home directory.
;;; 
;;;    2.  Copy 'irc', 'irc.watch' and 'irc.dcc' to that directory.
;;; 
;;;    3.  Add a line like this to your .tfrc to load them into TF:
;;;          /load -q ~/.tf/irc
;;; 
;;;    4.  Define your IRC worlds like this in your .tfrc:
;;;          /addworld -T"irc" efnet         efnet.telstra.net.au 6667
;;;          /addworld -T"irc" oznet         aussie.oz.org        6667
;;;          /addworld -T"irc" undernet      us.undernet.org      6667
;;;        You can define as many IRC worlds as you like, as long as you
;;;        set them all to type "irc".
;;; 
;;;    5.  At the top of the file 'irc' there are a bunch of variables
;;;        you can define, like your IRC nickname, realname, etc.
;;; 
;;; 
;;; BUGS
;;; ====
;;; I don't think dcc works at the moment.  The watch stuff definately
;;; doesn't work.  I'm getting there!  This is just a minor project.
;;; 
;;; 
;;; OTHER STUFF
;;; ===========
;;; 
;;; I can be contact at <gossamer@tertius.net.au>.
;;; 
;;; Much of my code is available on the web, look for the latest
;;; release of things at:
;;;    http://www.tertius.net.au/~gossamer/code/
;;; 
;;; 
;;; LEGAL STUFF
;;; ===========
;;; 
;;; Copyright (c) 1998 Bek Oberin. All rights reserved. 
;;; 
;;; This package is free software; you can redistribute it and/or modify
;;; it under the same terms as Perl itself.

;;; Small syntax fixes by Gwen Morse

; TF-IRC
; IRC handler for TinyFugue.
;
; Last updated by gossamer on Thu Sep 17 18:53:15 EST 1998
; Last updated by Josh Howard on Mon Apr 21 18:21:19 2003


;
; Requires tf 4.0a1 or above
;

;
; User Config
;

; Nickname
/set irc_nick Eachna

; Username (bit before the @ in the domain)
/set irc_user GwenMorse

; Realname
/set irc_name Gwen Morse

; Signoff comment
/set irc_signoff I'm outta here.

; What's returned when somebody asks for your version/finger/userinfo
; via CTCP
/set finger_msg Butt-kicking for Goodness.
/set userinfo_msg http://www.geocities.com/goldmooneachna/index.html

; Don't change these ones
/set version_msg TF-IRC:v0.02:IRC via TinyFugue/Win32
/set clientinfo_msg CTCP commands supported - ACTION CLIENTINFO FINGER PING USERINFO VERSION - Client is still under development

; mud or irc
/set irc_display_mode mud

; use colours?
/set irc_colours on

;
; END User Config
; Anything you change below here is YOUR problem
;
/require lisp.tf
/require pcmd.tf

/set away_set 0

/if (irc_display_mode =~ "mud") \
   /set irc_server_prefix [Server] %;\
   /set irc_whois_prefix [Whois] %;\
   /set irc_error_prefix Error: %;\
/else \
   /set irc_server_prefix *** %;\
   /set irc_whois_prefix *** %;\
   /set irc_error_prefix *** %;\
/endif


; Debug trendy thing - comment out if you aren't debugging, it shows
;                      all the server messages before processing ...
;                      It's AWFULLY spammy though
;/def -T"irc.irc" -p999 -F -mregexp -t"^(.*)$" debug_echo = /echo -w [DEBUG] %P1


;
; Colours
;

/if (irc_colours =~ "on") \
   /if (irc_display_mode =~ "mud") \
      /def -p100 -T"irc.irc" -F -aCgreen -mregexp -t'^[^ ]* (pages):' IRCmsg%;\
      /def -p100 -T"irc.irc" -F -PCgreen -mregexp -t'^From [^,]*,' IRCotherchan %;\
      /def -p100 -T"irc.irc" -F -PCblue -mregexp -t'^\\[[^ ]+\\]' IRCbox %;\
      /def -p100 -T"irc.irc" -F -PBCred -mregexp -t'^Error: .*$' IRCerror %;\
      /def -p100 -T"irc.irc" -F -PCcyan -mregexp -t'has left.*$' IRCleft %;\
      /def -p100 -T"irc.irc" -F -PCcyan -mregexp -t'has disconnected.*$' IRCdisconn %;\
      /def -p100 -T"irc.irc" -F -PCcyan -mregexp -t'has joined.*$' IRCjoin %;\
      /def -p100 -T"irc.irc" -F -PCcyan -mregexp -t'Users [^:]*:' IRCcontents %;\
   /else \
      /def -p100 -T"irc.irc" -F -PCgreen -mregexp -t'>' IRCoutmsg %;\
      /def -p100 -T"irc.irc" -F -PCgreen -mregexp -t'<' IRCinmsg %;\
      /def -p100 -T"irc.irc" -F -PCblue -mregexp -t'^\\*\\*\\*' IRCbox %;\
   /endif %;\
/endif

;
; User-entered commands
;

; /join
/def -T"irc.irc" join = \
   /if ({*} !~ "") \
      /send -w JOIN :%*%; \
      /eval /set channel_${world_name} %%*%; \
      /eval /set irc_channel %%{channel_${world_name}} %;\
   /else \
      /echo -w -p %%{irc_error_prefix} No channel specified to join!%; \
   /endif

; /part or /hop
/def -T"irc.irc" hop = \
   /part

/def -T"irc.irc" part = \
   /if ({*} !~ "") \
      /send -w PART :%*%; \
   /else \
      /eval /send -w PART :%%{channel_${world_name}}%; \
      /eval /set channel_${world_name}=%;\
      /eval /set irc_channel %%{channel_${world_name}} %;\
   /endif

; /kick
/def -T"irc.irc" kick = \
   /eval /send -w KICK %%{channel_${world_name}} %%1 :%%-1

; /op
/def -T"irc.irc" op = \
   /eval /send -w MODE %%{channel_${world_name}} +o %%*

; /who
/def -T"irc.irc" who = \
   /eval /send -w WHO %%{channel_${world_name}}

; /whois
/def -T"irc.irc" whois = \
   /send -w WHOIS %1 %1

; /list
/def -T"irc.irc" irclist = \
   /send -w LIST %1 %1

; /away
/def -T"irc.irc" away = \
   /if ({*} !~ "") \
      /set away_msg=%* \[$[ftime(abeTZY,time())]\]%; \
      /send -w AWAY :%{away_msg}%; \
      /set away_set 1%; \
      /set away_at $[time()]%; \
   /else \
      /send -w AWAY%; \
      /set away_set 0%; \
      /unset away_msg%; \
      /unset away_at%; \
   /endif

; /ctcp commands
/def -T"irc.irc" ctcp = \
   /send -w PRIVMSG %{1} :%{-1}

/def -T"irc.irc" ctcpr = \
   /send -w NOTICE %{1} :%{-1}

; /msg and /amsg (action msg)
/def -T"irc.irc" msg = \
   /send -w PRIVMSG %{1} :%{-1}%;\
   /if (irc_display_mode =~ "mud") \
      /echo -w -p @{Cgreen}You page@{n} %{1} with "%{-1}"%;\
   /else \
      /echo -w -p @{Cgreen}>>%{1}>>@{n} %{-1}%;\
   /endif

; pageish version of msg
/def -p1  -T"irc.irc" -h'SEND ^\+who$' alias_who2= \
   /eval /send -w NAMES %%{channel_${world_name}}

/def -p1  -T"irc.irc" -h'SEND ^WHO$' alias_who= \
   /eval /send -w WHO %%{channel_${world_name}}

/def -p1  -T"irc.irc" -h'SEND ^\+finger (.*)$' alias_finger= \
   /eval /send -w WHOIS %P1 %P1

/def -p1  -T"irc.irc" -h'SEND ^p(age)? ([^=]*)=([^:].*)$' alias_msg= \
   /msg %P2 %P3

/def -T"irc.irc" amsg = \
   /ctcp %{1} ACTION %{-1}%;\
   /if (irc_display_mode =~ "mud") \
      /echo -w -p @{Cgreen}Long distance to@{n} %{1}: @{BCyellow}%{irc_nick}@{n} %{-1}%;\
   /else \
      /echo -w -p @{Cgreen}*>>%{1}>>@{n} %{irc_nick} %{-1}%;\
   /endif

; pageish version of amsg
/def -p1  -T"irc.irc" -h'SEND ^p(age)? ([^=]*)=:(.*)$' alias_amsg= \
   /amsg %P2 %P3

; /ping
/def -T"irc.irc" ping = \
   /ctcp %{1} PING $[time()]

; /nick
/def -T"irc.irc" nick = \
   /send -w NICK :%*%;\
   /set irc_nick %*

; /topic
/def -T"irc.irc" topic = \
   /if ({*} !~ "") \
      /eval /send -w TOPIC %%{channel_${world_name}} :%%*%; \
   /else \
      /eval /send -w TOPIC %%{channel_${world_name}}%; \
   /endif

; /q
/def  -T"irc.irc" q = \
   /send -w QUIT :%{irc_signoff}

; /ver
/def -T"irc.irc" ver = \
   /ctcp %* VERSION

; /finger
/def -T"irc.irc" finger = \
   /ctcp %* FINGER


;
; Server messages - things we ignore
;
/def -q -ag -p999  -T"irc.irc" -F -mregexp -t'^:.+ (315|318|321|323|329|366|369|376|403)' ~ignores

; ctcp sounds
/def -q -ag -p520  -T"irc.irc" -F -mregexp -t'^.+ PRIVMSG .+:SOUND .+'


;
; Server messages - things we just display
;
/def -q -p599  -T"irc.irc" -F -mregexp -t'^:.+ (001|002|003|004|250|251|255|265|266|305|306|368|372|375|377|378|472|257) .+ : ?-? ?(.*)$' ~numbers = \
   /substitute %{irc_server_prefix} %P2

/def -q -p599  -T"irc.irc" -F -mregexp -t'^:.+ (401|402) [^ ]+ ([^ ]+) :?(.+)$' ~numbers3 = \
   /substitute %{irc_server_prefix} %P2: %P3

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ (252|253|254)+ [^ ]+ ([^ ]+) :(.+)$' ~head1= \
   /substitute %{irc_server_prefix} %P2 %P3

/def -q -p518  -T"irc.irc" -F -mregexp -t'^NOTICE [^ ]+ :(.*)$' ~notice= \
   /substitute %{irc_server_prefix} %P1

/def -q -p518  -T"irc.irc" -F -mregexp -t'^NOTICE [^ ]+ :(.*)$' ~notice= \
   /substitute %{irc_server_prefix} %P1

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:([^!]+)![^ ]+ NOTICE [^ ]+ :VERSION (.*)' ~version_reply= \
   /substitute %{irc_server_prefix} Version from %P1: %P2

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 322 [^ ]+ (#[^ ]+) ([^ ]+) :(.*)$' ~list= \
   /substitute %{irc_server_prefix} %P2 %P1 (%P3)

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 301 [^ ]+ ([^ ]+) :(.*)$' ~away = \
   /substitute %{irc_server_prefix} Away message from %P1: %P2

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 433 \* ([^ ]+) :Nickname is already in use.' ~badnick =\
   /substitute %{irc_error_prefix} Nickname %P1 already in use!

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 367 .+ .+ (.*) (.*) (.*)$' ~bans = \
   /substitute %{irc_server_prefix} Ban: %P1 by %P2 at $[ftime(%c,{P3})]

; somebody joins channel
/def -q -p518  -T"irc.irc" \
   -F -mregexp -t'^:([^!]*)!([^ ]*) JOIN [^:]*:(([^.]|[.])*)$' ~join = \
   /substitute  %P1 (%P2) has joined %P3.%; \
   /if ({P1} =~ {irc_nick}) \
      /eval /set channel_${world_name} %P3%; \
      /eval /set irc_channel %P3 %;\
   /endif

; channel names list
/def -q -p599 -F  -T"irc.irc" \
   -F -mregexp -t'^:[^ ]+[ ]+353(([ ]|[^ ])+)[ ]+([^ ]+)[ ]+[^:]*:(([ ]|[^ ])*)' ~names = \
   /if (irc_display_mode =~ "mud") \
      /substitute Users on %P3: %P4 %;\
   /else \
      /substitute %{irc_server_prefix} Users on %P3: %P4 %;\
   /endif

/def -q -p518  -T"irc.irc" \
   -F -mregexp -t'^:([^!]*)!([^ ]*) QUIT [^:]*:(([^.]|[.])*)$' ~quit = \
   /substitute %P1 has disconnected: %P3

; somebody leaves channel
/def -q -p518  -T"irc.irc" \
   -F -mregexp -t'^:([^!]*)!([^ ]*) PART (([^.]|[.])*)$' ~part = \
   /substitute %P1 has left %P3.%;\
   /if ({P1} =~ {irc_nick}) \
      /eval /set channel_${world_name}%; \
      /eval /set irc_channel %%{channel_${world_name}}%;\
   /endif

/def -q -p518  -T"irc.irc" \
   -F -mregexp -t'^:([^!]+)![^ ]+ KICK (#[^ ]+) ([^ :]+) :(.*)$' ~kicked = \
   /substitute %{irc_server_prefix} %P3 kicked from %P2 by %P1: %P4%;\
   /if ({P3} =~ {irc_nick}) \
      /eval /set channel_${world_name}%; \
      /eval /set irc_channel %%{channel_${world_name}}%;\
   /endif

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 352 [^ ]+ (#[^ ]+) ([^ ]+) ([^ ]+) [^ ]+ ([^ ]+) ([^ ]+) :[^ ]+ (.*)$' ~ircwho = \
   /substitute %P1 $[pad({P4}, -9)] $[pad({P5}, -4)] %P2@%P3 (%P6)

/def -q -p518  -T"irc.irc" \
   -F -mregexp -t'^:.+ 311 [^ ]+ ([^ ]+) ([^ ]+) ([^ ]+) .+ :(.+)$' ~iwhois = \
   /substitute %{irc_whois_prefix} %P1 is %P2@%P3 (%P4)

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 319 [^ ]+ [^ ]+ :(.*)$' ~iwhois2 = \
   /substitute %{irc_whois_prefix} on channels: %P1

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 312 [^ ]+ [^ ]+ ([^ ]+) :(.+)$' ~iwhois3 = \
   /substitute %{irc_whois_prefix} on irc via server %P1 (%P2)

/def -q -p518  -T"irc.irc" \
   -F -mregexp -t'^:.+ 317 [^ ]+ [^ ]+ ([^ ]+) :seconds idle$' ~iwhois4 = \
   /substitute %{irc_whois_prefix} $[{P1} / 60] mins, $[mod({P1},60)] secs idle.

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 313 [^ ]+ [^ ]+ :(.*)$' ~iwhois5 = \
   /substitute %{irc_whois_prefix} IRC Operator.

/def -q -p518  -T"irc.irc" \
   -F -mregexp -t'^:.+ 421 [^ ]+ ([^ ]+) :Unknown command$' ~badcommand = \
   /substitute %{irc_error_prefix} Unknown command '%P1'.

/def -q -p518  -T"irc.irc" \
   -F -mregexp -t'^:.+ 441 [^ ]+ ([^ ]+) ([^ ]+) :isn\'t on that channel$' ~nothere = \
   /substitute %{irc_error_prefix} %P1 isn't on channel %P2.

/def -q -p518  -T"irc.irc" \
   -F -mregexp -t'^:.+ 401 [^ ]+ ([^ ]+) :is not on IRC' ~noton = \
   /substitute %{irc_error_prefix} %P1 isn't on IRC.

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 317 [^ ]+ [^ ]+ ([^ ]+) ([^ ]+) :seconds idle, signon time' ~iwhois6 = \
   /substitute %{irc_whois_prefix} $[{P1} / 60] mins, $[mod({P1},60)] secs idle. Signon at: $[ftime({c},{P2})]

; Speech to channel
/def -q -p518  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* PRIVMSG (#[^ ]+) :(([^.]|[.])*)$' ~message = \
   /if /test tolower({P2}) =~ {channel_${world_name}} %; /then \
      /if (irc_display_mode =~ "mud") \
         /substitute %P1 says, "%P3"%; \
      /else \
         /substitute \<%P1\> %P3%; \
      /endif %;\
   /else \
      /if (irc_display_mode =~ "mud") \
         /substitute From %P2, %P1 says, "%P3"%; \
      /else \
         /substitute \<%P1:%P2\> %P3%; \
      /endif %;\
   /endif

; /me to channel
/def -q -p519  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* PRIVMSG (#[^ ]+) :ACTION (([^.]|[.])*)$' ~caction = \
   /if /test tolower({P2}) =~ {channel_${world_name}} %; /then \
      /if (irc_display_mode =~ "mud") \
         /substitute %P1 %P3%; \
      /else \
         /substitute * %P1 %P3%; \
      /endif %;\
   /else \
      /if (irc_display_mode =~ "mud") \
         /substitute From %P2, %P1 %P3%; \
      /else \
         /substitute * %P1:%P2 %P3%; \
      /endif %;\
   /endif

; self mode change
/def -q -p100  -T"irc.irc" -F -mregexp -t'^:([^ ]+) MODE ([^ ]+) :(.+)$' ~selfmode = \
   /substitute %{irc_server_prefix} Mode change \"%P3\" by %P1

; channel mode change
/def -q -p100  -T"irc.irc" \
   -F -mregexp -t'^:([^!]+)(![^ ]+)? MODE (#[^ ]+) (.*)$' ~chmode = \
   /substitute %{irc_server_prefix} Mode change \"%P4\" on channel %P3 by %P1

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 324 [^ ]+ (#[^ ]+) (.+)$' ~modes = \
   /substitute %{irc_server_prefix} Modes on %P1: %P2

/def -q -p517  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* NOTICE [^:]*:(([^.]|[.])*)$' ~pnotice = \
   /substitute \-%P1\- %P2

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* NOTICE (#[^:]*):(([^.]|[.])*)$' ~cnotice = \
   /substitute \-%P1:%P2\- %P3

/def -q -p519  -T"irc.irc" -F -mregexp -t'^:([^!]+)![^ ]+ NOTICE [^:]*:([^ ]+) (([^.]|[.])+)$' ~creply = \
   /substitute %{irc_server_prefix} CTCP %P2 reply from %P1: %P3

; ping reply
/def -q -p520  -T"irc.irc" -F -mregexp -t'^:([^!]+)![^ ]+ NOTICE [^:]* :PING (([^.]|[.])+)$' ~preply = \
   /substitute %{irc_server_prefix} Ping reply from %P1: $[(time() - %P2) / 60] mins, $[mod(time() - %P2,60)] secs

/def -q -p100  -T"irc.irc" -F -mregexp -t'^:([^!]+)![^ ]+ NICK [^:]*:(([^.]|[.])+)$' ~nickchng = \
   /substitute %{irc_server_prefix} %P1 is now known as %P2

/def -q -p520  -T"irc.irc" -F -mregexp -t'^:([^!]+)![^ ]+ TOPIC ([^ ]+) :(([^.]|[.])+)$' ~topic3 = \
   /substitute %{irc_server_prefix} %P1 set the topic on %P2 to: %P3

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 332 .+ (#[^ :]+) :(([^.]|[.])+)$' ~topic = \
   /substitute %{irc_server_prefix} Topic for %P1: %P2

/def -q -p518  -T"irc.irc" -F -mregexp -t'^:.+ 333 .+ #[^ ]+ ([^ ]+) (.+)$' ~topic2 = \
   /substitute %{irc_server_prefix} Last set by %P1 at: $[ftime({c},{P2})]


;
; Server things we reply to
;

 
; server pings
;;/def -q -ag -p518  -T"irc.irc" -F -F -mregexp -t'^PING :(([ ]|[^ ])+)$' ~ping = \
;;   /send -w PONG %P1
/def -T"irc.irc" -p999 -F -mregexp -t'^PING (.*)'=/send PONG %{P1} 

/def -q -ag -p518  -T"irc.irc" -F -F -mregexp -t'^PING :(([ ]|[^ ])+)$' ~ping = \
   /send -w PONG %P1
 
; ctcp request
 /def -q -p519  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* PRIVMSG [^:]*:VERSION$' ~cversion = \

/def -q -p519  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* PRIVMSG [^:]*:TIME$' ~ctime = \
   /substitute [TFIRC] %P1 has requested your TIME.%;\
   /ctcpr %P1 TIME $[ftime(%c,time())]

/def -q -p519  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* PRIVMSG [^:]*:FINGER$' ~cfinger = \
   /substitute [TFIRC] %P1 has requested your FINGER.%;\
   /ctcpr %P1 FINGER %{finger_msg}

/def -q -p519  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* PRIVMSG [^:]*:USERINFO$' ~cuserinfo = \
   /substitute [TFIRC] %P1 has requested your USERINFO.%;\
   /ctcpr %P1 USERINFO %{version_msg}

/def -q -p519  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* PRIVMSG [^:]*:CLIENTINFO' ~cclientinto = \
   /substitute [TFIRC] %P1 has requested your CLENTINFO.%;\
   /ctcpr %P1 CLIENTINFO %{version_msg}

;/def -q -p519  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* PRIVMSG [^:]*:(VERSION|FINGER|USERINFO|CLIENTINFO)' ~cversion = \
;   /substitute [TFIRC] %P1 has requested your %P2.%;\
;   /ctcpr %P1 %P2 %{version_msg}

; /msg to us
/def -q -p517  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* PRIVMSG [^:]*:(([^.]|[.])*)$' ~pmessage = \
   /if (irc_display_mode =~ "mud") \
      /substitute %P1 pages: %P2%;\
   /else \
      /substitute <<%P1<< %P2 %; \
   /endif%;\
   /if ({away_set}) \
      /~away_idle%; \
      /send -w NOTICE %P1 :Away: %{away_msg} \[%{away_from}\]%; \
      /substitute $[ftime("[%H:%M:%S]",time())] Away message sent to %P1.%; \
   /endif

; /amsg to us
/def -q -p518  -T"irc.irc" -F -mregexp -t'^:([^!]*)[^ ]* PRIVMSG [^:]*:ACTION (([^.]|[.])*)$' ~paction = \
   /if (irc_display_mode =~ "mud") \
      /substitute From afar, %P1 %P2%;\
   /else \
      /substitute *<<%P1 %P2 %; \
   /endif
;   /if (%{away_set}) \
;      /~away_idle%; \
;      /send -w NOTICE %P1 :Away: %{away_msg} \[%{away_from}\]%; \
;      /substitute $[ftime("[%H:%M:%S]",time())] Away message sent to %P1.%; \
;   /endif

; update /away info
/def ~away_idle = \
   /if ((time() - %{away_at}) > 3600)%; \
      /set away_from=$[(time() - %{away_at}) / 3600]h$[mod((time() - %{away_at}),3600) / 60]m%; \
   /else \
      /set away_from=$[(time() - %{away_at}) / 60]m%; \
   /endif

; pings from ordinary mortals
/def -q -p520  -T"irc.irc" -F -mregexp -t'^:([^!]+)![^ ]+ PRIVMSG [^:]* :PING (.+)$' ~cping = \
   /send -w NOTICE %P1 :PING %P2 %;\
   /substitute %{irc_server_prefix} %P1 pinged you.


;
; Hooks
;

; /say and ""
/def -T"irc.irc" say = \
   /if /test {channel_${world_name}} !~ ""%;  /then \
      /eval /send -w PRIVMSG %%{channel_${world_name}} :%%*%; \
      /if (irc_display_mode =~ "mud") \
         /echo -w -p @{BCyellow}You@{n} say, "%*"%; \
      /else \
         /echo -w -p @{BCyellow}<%{irc_nick}>@{n} %*%; \
      /endif %;\
   /else \
      /echo -w -p %{irc_error_prefix} You're not on a channel!%; \
   /endif

; " version of say
/def -p1  -T"irc.irc" -h'SEND ^\"(.*)' alias_say= \
   /say %P1

; /me and :
/def -T"irc.irc" me = \
   /if /test {channel_${world_name}} !~ ""%;  /then \
      /eval /ctcp %%{channel_${world_name}} ACTION %*%;\
      /if (irc_display_mode =~ "mud") \
         /echo -w -p @{BCyellow}%{irc_nick}@{n} %*%; \
      /else \
         /echo -w -p @{Cgreen}* @{BCyellow}%{irc_nick}@{n} %*%; \
      /endif %;\
   /else \
      /echo -w -p  %{irc_error_prefix} You're not on a channel!%; \
   /endif

; : version of /me
/def -p1 -T"irc.irc" -h'SEND ^\:([^ ].*)' alias_action= \
   /me %P1

/def -T"irc.irc" -F -hWORLD -p999 IRCworld_hook = \
   /set lp=0

; Send connect stuff when we connect
/def -T"irc.irc" -hCONNECT -p999 ~irc_login_hook = \
   /send -w PASS foobar%; \
   /send -w NICK %{irc_nick}%; \
   /send -w USER %{irc_user} foo foo :%{irc_name}%; \
   /send -w MODE %{irc_nick} +i%; \
   /if (away_set) \
      /send -w AWAY :%{away_msg}%; \
   /endif%;\
   /world %1

; Unset channel when we disconnect
/def -T"irc.irc" -hDISCONNECT -p999 ~irc_logout_hook = \
   /unwatch -a%;\
   /kill %{watch_pid}%;\
   /eval /set channel_${world_name}=

;
; DCC Chat Stuff
;
/def chat = \
   /addworld -T"irc.dcc" dcc_%1 %2 %3 %;\
   /world dcc_%1

/def -q -p1 -mglob -T"irc.dcc" -t'*' ~dcc_filter =\
   /substitute $[substr(${world_name}, 4)] says, "%*"

/def -q -p2 -ag -mregexp -T"irc.dcc" -t'ACTION (.*)' ~dcc_filter2 =\
   /echo -w $[substr(${world_name}, 4)] %-1

/def ~reset_chat_alias =\
   /send -w %* %;\
   /def -p1 -F -1 -T"irc.dcc" -h'SEND ^\"(.*)' alias_dcc_say= \
      /echo -w -p @{BCyellow}You@{n} say "%%P1"%%; \
      /~reset_chat_alias %%P1

/def -p1 -F -1 -T"irc.dcc" -h'SEND ^\"(.*)' alias_dcc_say= \
   /echo -w -p @{BCyellow}You@{n} say "%P1"%; \
   /~reset_chat_alias %P1

/def -p1 -F -1 -T"irc.dcc" -h'SEND ^\:(.*)' alias_dcc_act= \
   /echo -w -p @{BCyellow}%{irc_nick}@{n} %P1%; \
   /send -w ACTION %P1

;
; Watch stuff
;

; Usage:
; /watch <player>        Tells you when <player> logs on to the mud.
; /watch                Tells you who you are still watching for.
; /unwatch <player>        Stops looking for <player>.
; /unwatch -a                Stops looking for everyone.

/def watch = \
    /let watch_list=/eval %{watch_list_${world_name}}%;\
    /let watch_glob=/eval %{watch_glob_${world_name}}%;\
    /let watch_pid=/eval %{watch_pid_${world_name}}%;\
    /let who=$[tolower(%1)]%;\
    /if (who =~ "") \
        /echo \% You are watching for: %{watch_list}%;\
        /break%;\
    /endif%;\
    /if (who =/ watch_glob) \
        /echo \% You are already watching for that person!%;\
        /break%;\
    /endif%;\
    /if (watch_pid =~ "") \
        /repeat -60 1 /_watch%;\
        /set watch_pid=%?%;\
    /endif%;\
    /set watch_list=%{who} %{watch_list}%;\
    /set watch_glob={%{watch_list}}%;\
    /eval /let %{watch_list_${world_name}} = %{watch_list}%;\
    /eval /let %{watch_glob_${world_name}} = %{watch_glob}%;\
    /eval /let %{watch_pid_${world_name}} = %{watch_pid}

/def unwatch =\
    /let who=$[tolower({1})]%;\
    /let watch_list=/eval %{watch_list_${world_name}}%;\
    /let watch_glob=/eval %{watch_glob_${world_name}}%;\
    /let watch_pid=/eval %{watch_pid_${world_name}}%;\
    /if (who =~ "") \
        /echo \% Use /unwatch <name> or /unwatch -a for all.%;\
        /break%;\
    /endif%;\
    /if ((who !~ "-a") & (who !/ watch_glob)) \
        /echo \% You already weren't watching for that person!%;\
        /break%;\
    /endif%;\
    /if (who =~ "-a") \
        /set watch_list=%;\
    /else \
        /set watch_list=$(/remove %{who} %{watch_list})%;\
    /endif%;\
    /set watch_glob={%{watch_list}}%;\
    /if ((watch_list =~ "") & (watch_pid !~ "")) \
        /kill %{watch_pid}%;\
        /unset watch_pid%;\
    /endif%;\
    /eval /let %{watch_list_${world_name}} = %{watch_list}%;\
    /eval /let %{watch_glob_${world_name}} = %{watch_glob}%;\
    /eval /let %{watch_pid_${world_name}} = %{watch_pid}

/def _watch_check =\
    /let watch_list=/eval %{watch_list_${world_name}}%;\
    /let watch_glob=/eval %{watch_glob_${world_name}}%;\
    /let watch_pid=/eval %{watch_pid_${world_name}}%;\
  /if (strstr(%{watch_ison_new}, %{*}) != -1) \
      /if (strstr(%{watch_ison}, %{*}) != -1)%;\
      /else \
          /substitute [Watch] %{1} has connected to IRC.%;\
      /endif%;\
  /else \
      /if (strstr(%{watch_ison}, %{*}) != -1) \
          /substitute [Watch] %{1} has disconnected from IRC.%;\
      /endif%;\
  /endif%;\
    /eval /let %{watch_list_${world_name}} = %{watch_list}%;\
    /eval /let %{watch_glob_${world_name}} = %{watch_glob}%;\
    /eval /let %{watch_pid_${world_name}} = %{watch_pid}

/def -q -p100 -ag -mregexp -T'irc' -t'^:.+ 303 [^ ]+ :(.*)$' _do_watch =\
    /let watch_list=/eval %{watch_list_${world_name}}%;\
    /let watch_glob=/eval %{watch_glob_${world_name}}%;\
    /let watch_pid=/eval %{watch_pid_${world_name}}%;\
  /set watch_ison_new=$[tolower(%{P1})]%;\
  /mapcar /_watch_check %{watch_list}%;\
  /set watch_ison=%{watch_ison_new}%;\
    /eval /let %{watch_list_${world_name}} = %{watch_list}%;\
    /eval /let %{watch_glob_${world_name}} = %{watch_glob}%;\
    /eval /let %{watch_pid_${world_name}} = %{watch_pid}

/def _watch =\
    /let watch_list=/eval %{watch_list_${world_name}}%;\
    /let watch_glob=/eval %{watch_glob_${world_name}}%;\
    /let watch_pid=/eval %{watch_pid_${world_name}}%;\
    /unset watch_pid%;\
        /if (watch_list !~ "") \
            /repeat -60 1 /_watch%;\
            /set watch_pid=%?%;\
        /endif%;\
    /send -T"irc.irc" -w${world_name} ison :%{watch_list}%;\
    /eval /let %{watch_list_${world_name}} = %{watch_list}%;\
    /eval /let %{watch_glob_${world_name}} = %{watch_glob}%;\
    /eval /let %{watch_pid_${world_name}} = %{watch_pid}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
