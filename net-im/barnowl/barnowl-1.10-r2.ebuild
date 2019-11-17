# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A curses-based IM client"
HOMEPAGE="https://barnowl.mit.edu/"
SRC_URI="https://barnowl.mit.edu/dist/${P}-src.tgz"

SLOT="0"
LICENSE="Sleepycat LGPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+zephyr irc jabber twitter wordwrap"

COMMON_DEPEND="dev-lang/perl:=
			   dev-libs/openssl:0=
			   dev-libs/glib:2
			   sys-libs/ncurses:0=[unicode]
			   dev-perl/AnyEvent
			   dev-perl/Class-Accessor
			   dev-perl/glib-perl
			   dev-perl/PAR
			   zephyr? ( net-im/zephyr )"
DEPEND="${COMMON_DEPEND}
		virtual/pkgconfig
		app-arch/zip
		dev-perl/Module-Install
		dev-perl/ExtUtils-Depends
		dev-util/glib-utils"
RDEPEND="${COMMON_DEPEND}
		 jabber? ( dev-perl/Net-DNS
				   dev-perl/Authen-SASL
				   dev-perl/IO-Socket-SSL )
		 twitter? ( dev-perl/HTML-Parser
					dev-perl/Net-Twitter-Lite )
		 irc? ( dev-perl/AnyEvent-IRC )
		 wordwrap? ( dev-perl/Text-Autoformat )"
		 # facebook? ( dev-perl/AnyEvent-HTTP
		 # 			 dev-perl/Any-Moose
		 # 			 dev-perl/DateTime
		 # 			 dev-perl/DateTime-Format-Strptime
		 # 			 dev-perl/JSON
		 # 			 dev-perl/MIME-Base64-URLSafe
		 # 			 dev-perl/Ouch
		 # 			 dev-perl/URI
		 # 			 dev-perl/URI-Encode )"

# The package contains modified budled versions of the following perl modules:
# Facebook::Graph (not in portage)
# Net::Jabber (dev-perl/Net-Jabber)
# Net::XMPP (dev-perl/Net-XMPP)
# XML::Stream (dev-perl/XML-Stream)
# I think the package will correctly pick up its bundled versions, but I
# haven't tested because I don't use any of the modules using them.

src_prepare() {
	use jabber || \
		sed -i -e '/^MODULES =/s/Jabber//'   perl/modules/Makefile.am
	use irc || \
		sed -i -e '/^MODULES =/s/IRC//'      perl/modules/Makefile.am
	use wordwrap || \
		sed -i -e '/^MODULES =/s/WordWrap//' perl/modules/Makefile.am
	use twitter || \
		sed -i -e '/^MODULES =/s/Twitter//'  perl/modules/Makefile.am
	# Facbook module is currently broken.
	#use facebook ||
	sed -i -e '/^MODULES =/s/Facebook//' perl/modules/Makefile.am

	eapply_user

	eautoreconf
}

src_configure() {
	econf --docdir="/usr/share/doc/${PF}" \
		--without-stack-protector \
		--without-krb4 \
		$(use_with zephyr)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	dodoc AUTHORS ChangeLog || die
}
