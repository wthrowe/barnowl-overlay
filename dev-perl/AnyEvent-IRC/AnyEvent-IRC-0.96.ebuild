# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=ELMEX
inherit perl-module

DESCRIPTION="An event based IRC protocol client API"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="dev-perl/AnyEvent
		 dev-perl/common-sense
		 dev-perl/Object-Event"
