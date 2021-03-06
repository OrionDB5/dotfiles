#!/bin/sh
# vim: set noexpandtab:

PROMPT=$(cat <<-ENDPROMPT
		Lock
		Suspend
		Hibernate
		Logout
		Reboot
		Poweroff
ENDPROMPT
#	Hibernate
)

PARAMS=$(tr '\n' ' ' <<-ENDPARAMS
	-i
	-lines $(echo "$PROMPT" | wc -l)
	-width 400
	-padding 20
	-disable-history
	-no-custom
	-hide-scrollbar
	-show run
	-dmenu
	-p action
ENDPARAMS
)

case "$(echo "$PROMPT" | rofi $PARAMS | awk '{print $2}')" in
	"Poweroff")
		loginctl poweroff
		;;
	"Reboot")
		loginctl reboot
		;;
	"Logout")
		loginctl terminate-session $XDG_SESSION_ID || herbstclient quit || bspc quit
		;;
	"Hibernate")
		locker && systemctl hibernate
		;;
	"Suspend")
		locker && systemctl suspend
		;;
	"Lock")
		locker
		;;
	*)
		exit
		;;
esac
