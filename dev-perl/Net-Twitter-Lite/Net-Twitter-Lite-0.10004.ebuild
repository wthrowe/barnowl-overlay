# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=MMIMS
inherit perl-module

DESCRIPTION="A perl interface to the Twitter API"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="dev-perl/Crypt-SSLeay
		 dev-perl/HTTP-Message
		 dev-perl/JSON
		 dev-perl/JSON-Any
		 dev-perl/Net-OAuth
		 dev-perl/URI"
