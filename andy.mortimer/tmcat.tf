;;; (c) 1996 AS Mortimer
;;; $Id: tmcat.tf,v 1.2 1996/11/22 14:26:51 asm21 Exp $

;;; /tmcat <first line>
;;;	works just like the /cat command, except it changes whitespace
;;; characters etc to the TinyMUSH substitutions as follows:
;;;    %b	space character (otherwise, they get squashed by the
;;;		interpreter)
;;;    %r	carriage return. Has the obvious effect. :)
;;;    %t	tab character. I have no idea how useful this is, or even if
;;;		it'll work or not, but I thought I'd include it anyway, just
;;;		in case. It probably hasn't been tested, though ...
;;;    %%	literal percent.
;;; In addition, you can specify a first line, which does not have a %r
;;; appended. This is so you can do something like
;;;    /tmcat @emit
;;; and then paste in some text from another window, say.
;;;
;;; The last line has no %r appended; include an extra blank line if you want
;;; the last line to be %r-terminated.
;;;
;;; This is a (heavily :) modified version of the original /cat command, so I
;;; hope this is allowed ...

/~loaded tmcat.tf

/def tmcat = \
    /echo -e %% Entering TinyMUSH cat mode.  Type "." to end.%; \
    /let line=%; \
    /let all=%; \
    /test all:=strcat({0}, " ")%; \
    /let pc=\%%; \
    /let ch=%; \
    /while ((line:=read()) !~ ".") \
        /if (line =/ "/quit") \
            /echo -e %% Type "." to end /cat.%; \
        /endif%; \
	/let lineb=%; \
	/while ((ch := strchr(line, %%)) != -1) \
	    /test lineb := strcat(substr(line, 0, ch), pc, pc)%; \
	    /test line  := substr(line, ch+1)%; \
	/done%; \
	/test line := strcat(lineb, line)%; \
	/while ((ch := strchr(line, " ")) != -1) \
	    /test line := \
	        strcat(substr(line, 0, ch), pc, "b", substr(line, ch+1))%; \
	/done%; \
	/while ((ch := strchr(line, char(9))) != -1) \
	    /test line := \
	        strcat(substr(line, 0, ch), pc, "t", substr(line, ch+1))%; \
	/done%; \
        /test all := \
            strcat(all, line, pc, "r")%; \
    /done%; \
    /if (substr(all, -(strlen(pc)+1)) =~ strcat(pc, "r")) \
        /test all := substr(all, 0, -(strlen(pc)+1))%; \
    /endif%; \
    /recordline -i %all%; \
    /eval -s0 %all
