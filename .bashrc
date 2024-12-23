alias yt="yt-dlp -f \"bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b\""
alias pass="~/.local/bin/password_manager.sh"

# I hate doing cd ~ so yis cd ... better
function cd() {
	case $1 in
		'...' ) command cd ~ ;;
		*  ) command cd "$@" ;;
	esac
}
