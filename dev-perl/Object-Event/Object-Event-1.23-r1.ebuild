# Copyright 1999-2022 Gentoo Authors
# Copyright 2022 William Throwe
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ELMEX
inherit perl-module

DESCRIPTION="A class that provides an event callback interface"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="dev-perl/AnyEvent
		 dev-perl/common-sense"
