
; packages/autolog.tf
;   This will automatically log all input from the current world,
;   and all keyboard input, to a date-specific file.
;   (e.g. 2004-10-14.txt, 2004-10-15.txt and so on.)
;   If you don't like the date format, you can modify the pattern in
;   ftime.
;
;   Before you load this in .tfrc, define LOGDIR to whichever directory
;   you want to keep your logs in, e.g.
;
;     /def -i LOGDIR = ~vashti/keep/discworld/archive

/def -i -F -hCONNECT hook_connect_log = \
  /log -i ${LOGDIR}/$[ftime("%Y-%m-%d.txt", time())] %; \
  /log -w ${LOGDIR}/$[ftime("%Y-%m-%d.txt", time())]

