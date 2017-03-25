# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools eutils

#GIT_TAG=
#GIT_HASH=

DESCRIPTION="A curses-based IM client"
HOMEPAGE="http://barnowl.mit.edu/"
if [ -n "${GIT_TAG}" ] ; then
	SRC_URI="https://github.com/barnowl/barnowl/tarball/${PN}-${GIT_TAG}
			   -> ${P}-git.tar.gz"
else
	SRC_URI="http://barnowl.mit.edu/dist/${P}-src.tgz"
fi

SLOT="0"
LICENSE="Sleepycat LGPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+zephyr facebook irc jabber twitter wordwrap"

COMMON_DEPEND="dev-lang/perl
			   dev-libs/openssl
			   dev-libs/glib
			   sys-libs/ncurses[unicode]
			   dev-perl/PAR
			   dev-perl/Class-Accessor
			   dev-perl/AnyEvent
			   dev-perl/glib-perl
			   dev-perl/Module-Install
			   zephyr? ( net-im/zephyr )"
DEPEND="${COMMON_DEPEND}
		virtual/pkgconfig
		app-arch/zip"
RDEPEND="${COMMON_DEPEND}
		 jabber? ( dev-perl/Net-DNS
				   dev-perl/Authen-SASL
				   dev-perl/IO-Socket-SSL )
		 twitter? ( dev-perl/HTML-Parser
					dev-perl/Net-Twitter-Lite )
		 irc? ( dev-perl/AnyEvent-IRC )
		 wordwrap? ( dev-perl/Text-Autoformat )
		 facebook? ( dev-perl/AnyEvent-HTTP
					 dev-perl/Any-Moose
					 dev-perl/DateTime
					 dev-perl/DateTime-Format-Strptime
					 dev-perl/JSON
					 dev-perl/MIME-Base64-URLSafe
					 dev-perl/Ouch
					 dev-perl/URI
					 dev-perl/URI-Encode )"

# The package contains modified budled versions of the following perl modules:
# Facebook::Graph (not in portage)
# Net::Jabber (dev-perl/Net-Jabber)
# Net::XMPP (dev-perl/Net-XMPP)
# XML::Stream (dev-perl/XML-Stream)
# I think the package will correctly pick up its bundled versions, but I
# haven't tested because I don't use any of the modules using them.

if [ -n "${GIT_HASH}" ] ; then
	S="${WORKDIR}/barnowl-barnowl-${GIT_HASH}"
else
	S="${WORKDIR}/${P}-src"
fi

src_prepare() {
	# Unbundle unforked libraries.  Upstream has decided bundling them was a
	# bad idea anyway and is removing the bundled copies in the next version.
	rm -r perl/modules/Facebook/lib/AnyEvent || die
	rm perl/modules/Facebook/lib/Ouch.pm || die
	rm -r perl/modules/Facebook/lib/URI || die
	# and 5 copies of Module::Install
	epatch "${FILESDIR}/${P}-system-Module-Install.patch" # only use of eutils
	find . -name inc | xargs rm -r || die

	use jabber || \
		sed -i -e '/^MODULES =/s/Jabber//'   perl/modules/Makefile.am
	use irc || \
		sed -i -e '/^MODULES =/s/IRC//'      perl/modules/Makefile.am
	use wordwrap || \
		sed -i -e '/^MODULES =/s/WordWrap//' perl/modules/Makefile.am
	use twitter || \
		sed -i -e '/^MODULES =/s/Twitter//'  perl/modules/Makefile.am
	use facebook || \
		sed -i -e '/^MODULES =/s/Facebook//' perl/modules/Makefile.am
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
