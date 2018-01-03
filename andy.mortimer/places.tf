; $Id: places.tf,v 1.1 1996/11/20 15:01:15 asm21 Exp $

;; /placeinf <placenum>/<name>
;;	Displays the value of the given places option in the current room
;; /placeinf <placenum>/<name>=<value>
;;	Sets the named option to value, which can include spaces.

; (for /think)
/require info.tf

/def -i placeinf = \
  /if (%0 !/ "*/*") \
    /echo % Malformed argument.%; \
  /else \
    /if (%0 =/ "*=*") \
      /let args=$[substr(%0, 0, strchr(%0, "="))]%; \
    /else \
      /let args=%0%; \
    /endif%; \
    /let num=$[substr(args, 0, strchr(args, "/"))]%; \
    /let opt=$[substr(args, strchr(args, "/") + 1)]%; \
    /if (strchr(%0, "=") != -1) \
      /eval update %{num}/%{opt}=$[substr(%0, strchr(%0, "=") + 1)]%; \
    /else \
      /think %{num}/%{opt} = \[placeinfo(num(here), %{num}, %{opt})\]%; \
    /endif%; \
  /endif

;/def -i placeinf = \
;  /if (%3 =~ "") \
;    /think [PLACEINFO(num(here), %1, %2)]%; \
;  /else \
;    update %1/%2=%-2%; \
;  /endif
