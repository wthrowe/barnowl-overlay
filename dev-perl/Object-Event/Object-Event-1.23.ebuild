# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR=ELMEX
inherit perl-module

DESCRIPTION="A class that provides an event callback interface"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="dev-perl/AnyEvent
		 dev-perl/common-sense"
