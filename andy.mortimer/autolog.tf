; $Id: autolog.tf,v 1.2 1996/12/01 21:30:00 asm21 Exp $

;;; Automatically logs every world you open to a file called <world>.cur in the
;;; dirctory specified by %{LOGDIR}, which must not have a trailing backslash,
;;; or ~/logs if not specified.  (you must create this directory!). When you
;;; disconnect from a world, it will do two things:
;;;
;;; (a) If you have requested it, it will append the log to a `master file'
;;;     <world> in the above directory.
;;; (b) It will move the old <world.cur> file to <world>.old, overwriting
;;;	the previous <world>.old.

;;; Note that a shell command is used to rename files. This command is the value
;;; of the variable `shellrencmd', or `mv' if this is not specified. Also, the
;;; shell command `cat', or the value of the variable `shelltypecmd', is used to
;;; append a file to another, using the '>>' redirection operator.

;;; You may like to bind a key to toggle on and off the saving of the
;;; logfiles, for instance with
;;;      /def -b'^[l' logthiskey=/togglesavelog

;;; if you /set autolog_display=yes, then every time you switch worlds you
;;; will be told whether the log for the world will be saved or not.
;;; Unfortunately, you are told before the --- World <name> ---, so it looks
;;; ugly, and if you switch worlds often you're going to fill up your
;;; screen. Still, it's there if you want it ... :)

/require lisp.tf

; define a status-bar flag, to show if the log for the current world is being saved
;/defflag SaveLog

; write to the logfile only --- gags the text for the screen
/def -i writelog=/echo -ag -w${world_name} %*

; write a separator line to the logfile
/def -i auto_logging_sep=/writelog ==============================================================================

/def -i getsavelog = \
  /if (strstr(strcat(" ",_savelogs," "),strcat(" ",%0," ")) == -1) \
    /echo no%; \
  /else \
    /echo yes%; \
  /endif

/def -i setsavelog = \
  /if ($(/getsavelog %0) =~ "no") \
    /set _savelogs=%{_savelogs} %0%; \
;    /setflag SaveLog%; \
    /eval /echo %% Marked log for world %0 for saving.%; \
  /endif

/def -i unsetsavelog = \
  /if ($(/getsavelog %0) =~ "yes") \
    /set _savelogs=$(/remove %0 %{_savelogs})%; \
;    /unsetflag SaveLog%; \
    /eval /echo %% Marked log for world %0 for discarding.%; \
  /endif

/def -i togglesavelog = \
  /let wn=${world_name}%; \
  /if ($(/getsavelog %{wn}) =~ "yes") \
    /unsetsavelog %{wn}%; \
  /else \
    /setsavelog %{wn}%; \
  /endif

/def -i -p1 -F -h'CONNECT' auto_logging_conn = \
  /log -w %{LOGDIR-~/logs}/${world_name}.cur%; \
  /repeat -S 2 /auto_logging_sep%; \
  /eval /writelog ===         Log for world *** ${world_name} ***, started $(/time %%c)%; \
  /auto_logging_sep%; \
  /repeat -S 3 /echo -ag -w${world_name} ===%; \
  /repeat -S 2 /auto_logging_sep

/def -i -p1 -F -h'DISCONNECT' auto_logging_dis = \
  /let wn=${world_name}%; \
  /repeat -S 2 /auto_logging_sep%; \
  /writelog ===                  Log finished $(/time %%c)%; \
  /repeat -S 2 /auto_logging_sep%; \
  /writelog%; \
  /if ($(/getsavelog %0) =~ "yes") \
    /eval /sys %{shelltypecmt-cat} %{LOGDIR-~/logs}/${world_name}.cur >> %{LOGDIR-~/logs}/${world_name}%; \
  /else \
    /eval /echo %% Warning: log for world ${world_name} not saved!%; \
  /endif%; \
  /eval /sys %{shellrencmd-mv} %{LOGDIR-~/logs}/${world_name}.cur %{LOGDIR-~/logs}/${world_name}.old

/def -i -p1 -F -h'WORLD' auto_logging_world = \
  /let wn=${world_name}%; \
  /if (autolog_display =~ "yes") \
    /if ($(/getsavelog %{wn}) =~ "yes") \
      /echo % Log for this world will be saved on exit.%; \
    /else \
      /echo % Log for this world will be discarded on exit.%; \
    /endif%; \
  /endif%; \
;  /if ($(/getsavelog %{wn}) =~ "yes") \
;    /setflag SaveLog%; \
;  /else \
;    /unsetflag SaveLog%; \
;  /endif

; (untested; should not be needed)
/def -i log_this = \
;  /echo % Marked current log for saving.%; \
  /eval /setsavelog ${world_name}
