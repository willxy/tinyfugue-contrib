
; Oy, what a palaver.  Since /list and /save don't want to know about
; variables in any way, shape or form, this is how we have to save out
; our status bar variables.
;
; This sets up a bunch of macros which will let you save variables to
; a file, which you can then /load to get the values back.  You'll need
; to set ACTIVE_PLAYER to the name of the character you're playing, or
; the name you want to save them under.
;
; Note that later updates to tf5 have made this unnecessary, but I still
; use this package for some things.
;
; Instructions for use:
;
; /set ACTIVE_PLAYER to be your character name (lowercase).
;
; Create a directory $HOME/.tf/variables/ .  You can then use the
; /save_status macro to write all variables with names beginning var_stat_
; or status_attr_ to a file in this directory.
;
; /save_global_status will save all variables beginning var_global_ .
; This is so that you can distinguish between variables that are character-
; dependent and ones which are not.
;
; To reload the variables, simply reload the relevant variables/ file with
; /load.  For instance, to load Bob's variables, simply /load variables/bob.tf
; Don't forget to add ~/.tf to your TFPATH.
;
; Vashti vashti@dream.org.uk 2004

/require -q textutil.tf

/set has_persistent_variables 1

/def -i save_status = \
  /eval /listvar var_stat_* %| \
  /writefile ~/.tf/variables/%{ACTIVE_PLAYER}.tf %; \
  /eval /listvar status_attr_* %| \
  /writefile -a ~/.tf/variables/%{ACTIVE_PLAYER}.tf

/def -i set_status_var = /set %{1} %{-1} %; /save_status

/def -i save_global_status = \
  /eval /listvar var_global_* %| \
  /writefile ~/.tf/variables/global.tf

/def -i set_global_status_var = /set %{1} %{-1} %; /save_global_status

