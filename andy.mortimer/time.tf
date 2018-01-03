; $Id: time.tf,v 1.1 1996/11/20 15:01:15 asm21 Exp $

/~loaded time.tf

/require pairlist.tf

;; These commands enable you to keep track of the timezones people are living
;; in, and hence what time it is for them. The commands are:

;; /ltime [<identifier> [<format>]]
;;          Tells you the time in the timezone specified by <indentifier>.
;;	    If <identifier> is a person's name (or the beginning thereof),
;;	    you get the time in the zone where they live. Otherwise, if it
;;	    is the name of a zone, you are told the time there. Finally, if
;;	    it is a number, it is taken as a difference from GMT, and this
;;	    time is displayed. If <identifier> is not included, `me' is
;;	    assumed.
;;	    <format> is the way to display the date, and defaults to the value
;;	    of %{time_format} (see /time). If <identifier> is a person or a 
;;	    timezone, and <format> is not present, then a prettified format 
;;	    based on %{time_format} is used to display the time. If 
;;	    <identifier> is a number, it is displayed as %{time_format}.

;; /mtime
;;	    Tells you the local time in the current world, assuming it has been
;;	    set (as a person called w<world>).

;; /addtzone <zone> <time-difference-with-GMT>
;;          Adds a timezone to the list.

;; /listtzones
;;          Lists the defined timezones.

;; /addtperson <name> <timezone>
;;          Adds a person to the list. Note that you *cannot* simply use a time
;;	    difference, you *must* use a timezone.

;; /listtpeople
;;          Lists the people in the list

;; ========== Setup of Variables

;; if the user hasn't already defined these variables (probable!), then give
;; them reasonable defaults.

; where I live -- set in local.tf?
/eval /set tzlocal %{tzlocal-GMT}

; list of people and zones. Add to this using /addtperson (in .tfrc?)
/eval /eval /set tzpeople=%%{tzpeople-me %{tzlocal}}

; list of defined timezones. If you want to modify this permanently, I suggest
; you do it here!
/eval /set tzlist=%{tzlist-GMT 0 EST -5 ET -5 PST -8 Universal 0 BST 1 GMT-12 -12 GMT-11 -11 GMT-10 -10 GMT-9 -9 GMT-8 -8 GMT-7 -7 GMT-6 -6 GMT-5 -5 GMT-4 -4 GMT-3 -3 GMT-2 -2 GMT-1 -1 GMT+1 1 GMT+2 2 GMT+3 3 GMT+4 4 GMT+5 5 GMT+6 6 GMT+7 7 GMT+8 8 GMT+9 9 GMT+10 10 GMT+11 11 GMT+12 12 GMT0 0 GMT1 1 GMT2 2 GMT3 3 GMT4 4 GMT5 5 GMT6 6 GMT7 7 GMT8 8 GMT9 9 GMT10 10 GMT11 11 GMT12 12}

;; ========== Entry Points

/def -i ltime= \
  /if (%1 =~ "") \
    /dtime %{tzlocal} %%% Local time is %{time_format}.%; \
  /else \
  /let prsn=$(/getfullkeyname -i tzpeople %{1-me})%; \
  /let tz=$(/getpair %{prsn} tzpeople)%; \
  /if (tz =~ "ERR") \
; we have an error somewhere.
;   first, see if we have a timezone rather than a person.
    /let tzt=$(/getpair -i %1 tzlist)%; \
    /if (tzt =~ "ERR") \
;     then, if we still have an error, see if it's a number
      /if (%1 != 0 | %1 =~ "0") \
        /dtime %*%; \
      /else \
        /echo % Cannot find person.%; \
      /endif%; \
    /else \
      /ztime %*%; \
    /endif%; \
  /else \
    /shift%; \
    /let fmt=%{*-%%% Local time for %{prsn} is %{time_format-%H:%M}.}%; \
    /ztime %{tz} %{fmt}%; \
  /endif%; \
  /endif

/def -i addtperson=/addpair tzpeople %*
/def -i listtpeople = \
  /echo % People in known timezones:%; \
  /quote -decho -S %      `/listpairs tzpeople

/def -i addtzone=/addpair tzlist %*
/def -i listtzones = \
  /eval /echo $(/echo % Defined timezones:%; /foreachpair tzlist /echo %%{key})
; /quote -decho -S %      `/listpairs tzlist

/def -i mtime=/eval /ltime w${world_name} %%%% MUSH time in world ${world_name} is %%{time_format-%H:%M}.

;; ========== Other helper functions

;; Prints the time in another timezone, specified by it's difference from
;; local time
;;
;; call as /dtime [<difference> [<format>]]
;;
;; where <difference> is the time difference in hours (negative for times
;; before the local, positive for those after) and <format> is the strftime
;; format (see /time for more details). If you don't specify a format, the
;; format given in %{time_format} is used.

/def -i dtime= \
  /let diff=%{1-0}%; \
  /shift%; \
  /eval /echo $[ftime(%{*-%{time_format-%%H:%%M}}, time() + %{diff}*60*60)]

;; Prints the time in a specified timezone
;; /ztime [<zone> [<format>]]

/def -i ztime= \
  /let tz=$(/getfullkeyname -i tzlist %{1-%{tzlocal}})%; \
  /let tzt=$(/getpair %{tz}        tzlist)%; \
  /let tzl=$(/getpair %{tzlocal}   tzlist)%; \
  /if (tzt =~ "ERR" | tzl =~ "ERR") \
    /echo % Error in timezone lookup.%; \
  /else \
    /shift%; \
    /let fmt=%{*-%%% Local time in zone %{tz} is %{time_format-%H:%M}.}%; \
    /dtime $[tzt - tzl] %{fmt}%; \
  /endif
