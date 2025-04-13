TERMUX_PKG_HOMEPAGE=https://proot-me.github.io/
TERMUX_PKG_DESCRIPTION="Emulate chroot, bind mount and binfmt_misc for non-root users"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Michal Bednarski @michalbednarski"
# Just bump commit and version when needed:
_COMMIT=60485d2646c1e09105099772da4a20deda8d020d
TERMUX_PKG_VERSION=5.1.107
TERMUX_PKG_REVISION=65
TERMUX_PKG_SRCURL=https://github.com/termux/proot/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=e6942f8b94fb3840faa3a500295dd4d79147266f60404df7c026703436850737
TERMUX_PKG_AUTO_UPDATE=false
# 改为静态依赖，直接合并到二进制文件中
TERMUX_PKG_DEPENDS="libtalloc-static"
TERMUX_PKG_SUGGESTS="proot-distro"
TERMUX_PKG_BUILD_IN_SRC=true
# 我不理解，为什么官方的脚本会有问题
TERMUX_PKG_EXTRA_MAKE_ARGS="-C proot-$_COMMIT/src"

# Install loader in libexec instead of extracting it every time
# 不导出loader export PROOT_UNBUNDLE_LOADER=$TERMUX_PREFIX/libexec/proot

termux_step_pre_configure() {
	CPPFLAGS+=" -DARG_MAX=131072"
	LDFLAGS+=" -static -ltalloc" # 将依赖放入二进制文件
}
