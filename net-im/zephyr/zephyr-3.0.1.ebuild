# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

#WANT_AUTOCONF="2.5"
#WANT_AUTOMAKE="none"

#inherit autotools

SVN_REV=2642

DESCRIPTION="The Project Athena instant messaging system"
HOMEPAGE="http://zephyr.1ts.org/"
SRC_URI="http://zephyr.1ts.org/export/${SVN_REV}/distribution/${P}.tar.gz"

SLOT="0"
LICENSE="HPND"
KEYWORDS="~amd64 ~x86"
IUSE="ares +hesiod kerberos X"

RDEPEND="ares? ( net-dns/c-ares )
		 hesiod? ( net-dns/hesiod )
		 kerberos? ( app-crypt/mit-krb5 )
		 X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}"

# tests require a running zhm daemon
RESTRICT="test"

src_configure() {
	econf \
		--without-krb4 \
		--without-regex \
		$(use_with ares cares) \
		$(use_with hesiod) \
		$(use_with kerberos krb5) \
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
	if ! use hesiod ; then
		elog
		elog "You have built ${PN} with the hesiod use flag disabled."
		elog "zhm will not be able to automatically determine zephyr servers."
		elog "You should specify your zephyr servers in /etc/conf.d/zhm"
	fi
}
