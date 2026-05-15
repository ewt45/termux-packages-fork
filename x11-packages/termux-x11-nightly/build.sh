TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-x11
TERMUX_PKG_DESCRIPTION="Termux X11 add-on."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Twaik Yont @twaik"
TERMUX_PKG_VERSION=99.00.00
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ewt45/termux-x11-fork/archive/ff8002a15ea5b40c8516e41f618c4cf3d1aeb99b.tar.gz
TERMUX_PKG_SHA256=c1fccfcc15c69301ece9f5e61299a0474a520bc1108dc6ad47e6e307290da89c
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="xkeyboard-config"
# We provide a termux-x11-xfce4 service script, so let's suggest xfce4
TERMUX_PKG_SUGGESTS="xfce4"
TERMUX_PKG_BREAKS="termux-x11"
TERMUX_PKG_REPLACES="termux-x11"
TERMUX_PKG_PROVIDES="termux-x11"

termux_step_make() {
	:
}

termux_step_make_install() {
	# Downloading full JDK to compile 7kb apk seems excessive, let's download a prebuilt.
	local LOADER_URL="https://github.com/ewt45/termux-x11-fork/releases/download/aar-250203/termux-x11-nightly-99.00.00-any.pkg.tar.xz"
	install -t "$TERMUX_PREFIX/bin" -m 755 termux-x11 termux-x11-preference
	mkdir -p "$TERMUX_PREFIX/libexec/termux-x11"
	wget -qO- "$LOADER_URL" | tar -OJxf - --wildcards "*loader.apk" > "$TERMUX_PREFIX/libexec/termux-x11/loader.apk"
}

termux_step_post_make_install() {
	# Setup termux-services scripts
	mkdir -p "$TERMUX_PREFIX/var/service/tx11/log"
	ln -sf "$TERMUX_PREFIX/share/termux-services/svlogger" "$TERMUX_PREFIX/var/service/tx11/log/run"
	sed -e "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" \
		-e "s%@TERMUX_HOME@%$TERMUX_ANDROID_HOME%g" \
		"$TERMUX_PKG_BUILDER_DIR/sv/tx11.run.in" > "$TERMUX_PREFIX/var/service/tx11/run"
	chmod 700 "$TERMUX_PREFIX/var/service/tx11/run"
	touch "$TERMUX_PREFIX/var/service/tx11/down"

	mkdir -p "$TERMUX_PREFIX/var/service/tx11-xfce4/log"
	ln -sf "$TERMUX_PREFIX/share/termux-services/svlogger" "$TERMUX_PREFIX/var/service/tx11-xfce4/log/run"
	sed "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" \
		"$TERMUX_PKG_BUILDER_DIR/sv/tx11-xfce4.run.in" > "$TERMUX_PREFIX/var/service/tx11-xfce4/run"
	chmod 700 "$TERMUX_PREFIX/var/service/tx11-xfce4/run"
	touch "$TERMUX_PREFIX/var/service/tx11-xfce4/down"
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
		#!${TERMUX_PREFIX}/bin/sh
		chmod -w $TERMUX_PREFIX/libexec/termux-x11/loader.apk
	EOF

	if [[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]]; then
		echo "post_install" > postupg
	fi
}
