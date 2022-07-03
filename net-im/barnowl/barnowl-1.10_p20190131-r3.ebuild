# Copyright 1999-2022 Gentoo Authors
# Copyright 2022 William Throwe
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A curses-based IM client"
HOMEPAGE="https://barnowl.mit.edu/"
#SRC_URI="https://barnowl.mit.edu/dist/${P}-src.tgz"

GIT_HASH="9a0d25d1513e92f2b0c99d89ab5fc5ae2c061151"
SRC_URI="https://github.com/barnowl/barnowl/archive/${GIT_HASH}.zip -> ${PN}-${GIT_HASH}.zip"
S="${WORKDIR}/${PN}-${GIT_HASH}"

SLOT="0"
LICENSE="Sleepycat LGPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+zephyr irc jabber wordwrap"

COMMON_DEPEND="dev-lang/perl:=
			   dev-libs/openssl:0=
			   dev-libs/glib:2
			   sys-libs/ncurses:0=
			   dev-perl/AnyEvent
			   dev-perl/Class-Accessor
			   dev-perl/glib-perl
			   dev-perl/PAR
			   zephyr? ( net-im/zephyr )"
DEPEND="${COMMON_DEPEND}
		virtual/pkgconfig
		app-arch/zip
		app-arch/unzip
		dev-perl/Module-Install
		dev-perl/ExtUtils-Depends
		dev-util/glib-utils"
RDEPEND="${COMMON_DEPEND}
		 jabber? ( dev-perl/Net-DNS
				   dev-perl/Authen-SASL
				   dev-perl/IO-Socket-SSL )
		 irc? ( dev-perl/AnyEvent-IRC )
		 wordwrap? ( dev-perl/Text-Autoformat )"

# The package contains modified budled versions of the following perl modules:
# Facebook::Graph (not in portage)
# Net::Jabber (dev-perl/Net-Jabber)
# Net::XMPP (dev-perl/Net-XMPP)
# XML::Stream (dev-perl/XML-Stream)
# I think the package will correctly pick up its bundled versions, but I
# haven't tested because I don't use any of the modules using them.

src_prepare() {
	eapply "${FILESDIR}/${PN}-1.10-tinfo.patch"

	use jabber || \
		sed -i -e '/^MODULES =/s/Jabber//'   perl/modules/Makefile.am
	use irc || \
		sed -i -e '/^MODULES =/s/IRC//'      perl/modules/Makefile.am
	use wordwrap || \
		sed -i -e '/^MODULES =/s/WordWrap//' perl/modules/Makefile.am
	# Twitter API is out-of-date
	sed -i -e '/^MODULES =/s/Twitter//'  perl/modules/Makefile.am
	# Facbook module is currently broken.
	sed -i -e '/^MODULES =/s/Facebook//' perl/modules/Makefile.am

	eapply_user

	eautoreconf
}

src_configure() {
	econf --docdir="/usr/share/doc/${PF}" \
		--without-stack-protector \
		$(use_with zephyr)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	dodoc AUTHORS ChangeLog || die
}
