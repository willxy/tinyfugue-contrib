; $Id: sepchat.tf,v 1.1 1996/11/20 15:01:15 asm21 Exp $

/~loaded sepchat.tf

;;; ========== Introduction
;;; This file provides a mechanism for separating the `chat channels' from the
;;; actual goings on in a world. It creates a new (local) world called c<world>
;;; and sends all the chat-lines to this world. It also redirects any input
;;; to this world back to the chat channel on the other world.

;;; ========== Setup

;;; A chat world will be opened automatically for any world where
;;; c<world>_trig is defined. For this to work, you should define it
;;; as a regular expression, with the text of the chat as the second
;;; parameter.  You should also define the variable %{<world>_ccomm}
;;; to actually be the chat command, using the positional parameters
;;; to include the actual chat text. Note that, to include a dollar 
;;; sign, you need to quote it with a backslash.

;;; ========== Example
;;; (for instance, you could put this in your .tfrc)
;;;
;;;	/require sepchat.tf
;;;	/set SC_ccomm=st %*
;;;	/set cSC_trig=^(<Seacraft>)(.*)\$

;;; ========== Commands

;;; /tc
;;;          Toggle between chat worlds and actual worlds

/def -i tc = \
  /if (substr(${world_name}, 0, 1) =~ "c") \
    /eval /fg -s $[substr(${world_name}, 1)]%; \
  /else \
    /eval /fg -s c${world_name}%; \
  /endif

;;; ========== New world-type for separated chat
;; override default hook
/def -i -hCONNECT -p99 -T"sepchat" = \
  /eval /echo %% Opened separated chat world ${world_name}.

/def -iF -hLOGIN -t"sepchat"
/def -iF -hDISCONNECT -T"sepchat" = \
  /eval /echo %% Chat world ${world_name} closed.

;; send hook --- redirect to the parent world, using %{<world>_ccomm} as a
;; template.
/def -i -hSEND -T"sepchat" -p9999 -ag sepchat_send = \
  /if /eval /eval /test "%%%{$$[strcat(substr("${world_name}", 1), "_ccomm")]}" !~ ""%; \
  /then \
    /let parms=%*%; \
    /if (strchr(strcat(":;", char(34)), substr(parms, 0, 1)) != -1) \
      /eval /eval /send -w$[substr(${world_name}, 1)] - %%{$[strcat(substr(${world_name}, 1), "_ccomm")]}%; \
    /else \
      /echo % Command sent to non-chat world.%; \
      /eval /send -w$[substr(${world_name}, 1)] - %*%; \
    /endif%; \
  /else \
    /echo % No chat command has been defined!%; \
  /endif

;; connect hook --- check for the presence of the c<world>_trig variable, and
;;                  if it exists, open a chat world and set a disconnect hook
;;		    for this world.
/def -iF -hCONNECT sepchat_openhook = \
  /if /eval /test "%%{c${world_name}_trig}" !~ ""%; /then \
    /echo % Chat trigger exists --- creating chat world.%; \
    /eval \
      /def -iFw"${world_name}" -hDISCONNECT -1 ${world_name}_scdishook = /schat_rem ${world_name}%%; \
      /schat_add ${world_name}%; \
  /endif 

;;; ========== Helpers

;;; /schat_add <world>

/def -i schat_add = \
  /if /eval /eval /test "%%{c%1_trig}" =~ ""%; /then \
    /echo %% Trigger c%1_trig not defined!%; \
  /else \
    /eval /eval /def -i -ag -p1 -mregexp -F -t"%%{c%1_trig}" -w"%1" %1_chatcomm = /send -wc%1 %%%%P2%; \
    /eval /addworld -T"sepchat" c%1 ${world_character} dummy localhost echo%; \
    /connect c%1%; \
;; squelch the `% Trigger in world blah.' message
    /def -i -ag -hBACKGROUND -w"%1"%; \
  /endif

;;; /schat_rem <world>
;;; assumes that a chat-world has been setup for <world>

/def -i schat_rem = /dc c%1%; /undef %1_chatcomm%; /unworld c%1
