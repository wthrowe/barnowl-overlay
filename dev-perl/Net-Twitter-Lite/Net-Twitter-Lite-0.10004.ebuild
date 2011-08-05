# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=MMIMS
inherit perl-module

DESCRIPTION="Net::Twitter::Lite - A perl interface to the Twitter API"

LICENSE="|| ( Artistic GPL-1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/Crypt-SSLeay
		 dev-perl/HTTP-Message
		 dev-perl/JSON
		 dev-perl/JSON-Any
		 dev-perl/Net-OAuth
		 dev-perl/URI"
