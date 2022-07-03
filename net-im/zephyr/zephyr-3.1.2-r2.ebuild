# Copyright 1999-2022 Gentoo Authors
# Copyright 2022 William Throwe
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="The Project Athena instant messaging system"
HOMEPAGE="https://github.com/zephyr-im"
SRC_URI="https://github.com/zephyr-im/zephyr/archive/release/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="HPND"
KEYWORDS="~amd64 ~x86"
IUSE="ares X"

RDEPEND="ares? ( net-dns/c-ares )
		 app-crypt/mit-krb5
		 X? ( x11-libs/libX11 )
		 sys-libs/ncurses"
DEPEND="${RDEPEND}
		sys-devel/bison"

S="${WORKDIR}/${PN}-release-${PV}"

# tests require a running zhm daemon
RESTRICT="test"

src_prepare() {
	sed -i /AC_CHECK_LIB/s/curses/tinfo/g configure.ac || die
	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		--without-krb4 \
		--with-krb5 \
		--without-regex \
		$(use_with ares cares) \
		--without-hesiod \
		$(use_with X x)
}

src_compile() {
	emake DEBUG= || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	dodoc OPERATING USING || die

	newinitd "${FILESDIR}"/zhm.rc zhm
	newconfd "${FILESDIR}"/zhm.confd zhm

	keepdir /etc/zephyr/acl
}

pkg_postinst() {
	elog "zephyr clients will not work without the zhm daemon running."
	elog "You likely want to add zhm to the default runlevel."
}
