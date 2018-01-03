; $Id: usrflag.tf,v 1.1 1996/11/20 15:01:15 asm21 Exp $
; $Log: usrflag.tf,v $
; Revision 1.1  1996/11/20 15:01:15  asm21
; Initial revision
;
; Revision 1.2  1996/05/24 19:00:24  asm21
; *** empty log message ***
;
; Revision 1.1  1996/05/24 18:01:57  asm21
; Initial revision
;

/~loaded usrflag.tf

;; This file is to support new capabilities which I have built into the
;; executable, namely to allow the user to define and use indicators which
;; appear on the status bar in visual mode.
;;
;; The commands defined in this file are:
;; /defflag [-1] <flag>
;;	Add <flag> to the list of flags, initially set to off, and make space in
;; the status bar for it. With the -1 option, the flag is initially on instead.
;; /undefflag <flag>
;;	Remove <flag> from the status bar, and from the list of flags.
;; /setflag <flag>
;;	Set <flag> to true. It will now appear on the status bar as (<flag>).
;; /unsetflag <flag>
;; /resetflag <flag>
;;	Set <flag> to false. This means it won't appear in the status bar any
;; longer, but will be replaced by a row of hypens or underscores. This is the
;; default when a flag is created.

;; What these macros actually do is to modify the variable %{usrflag}, which is
;; used by the program to determine the flags to display. It is a
;; comma-seperated list of flags, each prefixed by a character specifying
;; whether the flag is on or off. This character can be any of "+1yt" for on, or
;; "-0nf" for off; any other character will display a series of question marks
;; in place of the flag.
;;
;; for example, the following would display '_(One)_______(Three)_' in the
;; status bar:
;; /set usrflag=+One,-Two,1Three

/def -i defflag=\
  /if (%1 =~ "-1") \
    /let flag=1%{-1}%;\
  /else \
    /let flag=0%0%;\
  /endif%; \
  /if (strlen(usrflag)==0) \
    /set usrflag=%{flag}%;\
  /else \
    /if (strstr(strcat(usrflag,","),strcat(substr(%{flag},1),",")) != -1) \
      /eval /echo %% Error: flag $[substr(%{flag},1)] already exists.%;\
    /else \
      /set usrflag=%{usrflag},%{flag}%;\
    /endif%;\
  /endif

;/def undefflag=\
;  /let of=%{usrflag}%;\
;  /let nf=%;\
;  /while (of !~ "") \
;    /let cp=$[strchr(of,",")]%;\
;    /if (cp == -1) /let cp=$[strlen(of)+1]%; /endif%;\
;    /let flag=$[substr(of, 0, cp)]%;\
;    /let of=$[substr(of, cp+1)]%;\
;    /if (substr(flag,1) !~ %*)\
;      /let nf=%{nf},%{flag}%;\
;    /endif%;\
;  /done%;\
;  /set usrflag=$[substr(nf,1)]%;\
;  /set usrflag

/def -i undefflag=\
  /let nf=%;\
  /let p=$[strstr(strcat(usrflag,","),strcat(%*,","))]%;\
  /if (p != -1) \
    /if (p != 1) /let nf=$[substr(usrflag,0,p-2)],%; /endif%;\
    /let nf=%{nf}$[substr(usrflag,p+strlen(%0)+1)]%;\
    /if (substr(nf,-1) =~ ",") /let nf=$[substr(nf,0,strlen(nf)-1)]%;/endif%;\
    /set usrflag=%{nf}%;\
  /else \
    /eval /echo %% Flag %0 does not exist.%;\
  /endif

/def -i ~setflagstat=\
  /let nf=%;\
  /let p=$[strstr(strcat(usrflag,","),strcat(%{-1},","))]%;\
  /if (p != -1) \
    /if (p != 1) /let nf=$[substr(usrflag,0,p-2)],%; /endif%;\
    /let nf=%{nf}%{1}%{-1}$[substr(usrflag,p+strlen(%{-1}))]%;\
    /set usrflag=%{nf}%;\
  /else \
    /eval /echo %% Flag %{-1} does not exist.%;\
  /endif

/def -i setflag=/~setflagstat 1 %0
/def -i unsetflag=/~setflagstat 0 %0
/def -i resetflag=/unsetflag %0
