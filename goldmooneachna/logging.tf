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

/def -Fp100 -h'connect' connect_log = \
  /log -w ${LOGDIR}/$[ftime("%Y-%m-%d", time())]_${world_name}.log %;\
  /eval /echo -ag -w${world_name} \
%========================================================================== %;\
  /eval /echo -ag -w${world_name} \
%=            Log for world *** ${world_name} ***, started $(/time %%c) %;\
  /eval /echo -ag -w${world_name} \
%==========================================================================

; Lets /dc function like 'QUIT' to trigger the disconnect (needed to close the log) 
; written by 'Brack <slayer at kaiwan dot com>'

/def -F -1ag -h'conflict' gagconflict
/def -Fiq dc = /if /@dc %*%; /then /trigger -hdisconnect %*%; /endif

; This lets you return to the special logging after shutting it off with /log off.
; Note, if the original special log was during the previous calendar 'day', then, 
; /relog will start a new log!

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
